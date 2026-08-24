<#
.SYNOPSIS
    Runs quality evals for one or all Agent Engineer skills.

.DESCRIPTION
    Copies a fixture, injects one skill, runs cursor-agent on each eval prompt,
    grades deterministic checks, and writes grading.json / timing.json / benchmark.json.

    Default baseline is the last committed copy of the skill (when the working tree
    is dirty) or a path/commit you pass. Compare current SKILL.md against that snapshot.

.PARAMETER Skill
    Skill id, or 'all'.

.PARAMETER ValidateOnly
    Check evals.json and overlay paths. Do not run an agent.

.PARAMETER SkipBaseline
    Run only with_skill (no old_skill comparison).

.PARAMETER BaselineCommit
    Git commit to snapshot as old_skill.

.PARAMETER BaselineDir
    Directory that already holds a skill snapshot (SKILL.md + assets).

.PARAMETER Iteration
    Workspace iteration number. Default: next unused iteration-N.

.PARAMETER EvalName
    Run only this eval name.

.PARAMETER AgentExe
    Agent executable. Default: cursor-agent.

.PARAMETER TimeoutSec
    Per-turn timeout in seconds. Default: 900.

.EXAMPLE
    ./evals/run-quality-eval.ps1 -Skill feature-specifier -ValidateOnly

.EXAMPLE
    ./evals/run-quality-eval.ps1 -Skill feature-specifier

.EXAMPLE
    ./evals/run-quality-eval.ps1 -Skill feature-developer -BaselineCommit HEAD~1
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet(
        'feature-specifier',
        'feature-developer',
        'feature-code-reviewer',
        'feature-tester',
        'mvp-specifier',
        'all'
    )]
    [string]$Skill,

    [switch]$ValidateOnly,

    [switch]$SkipBaseline,

    [string]$BaselineCommit,

    [string]$BaselineDir,

    [int]$Iteration = 0,

    [string]$EvalName,

    [string]$AgentExe = 'cursor-agent',

    [int]$TimeoutSec = 900
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'lib\QualityEval.ps1')

$PackRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

function Resolve-BaselineSkillDir {
    param(
        [string]$SkillName
    )
    if ($SkipBaseline) { return $null }
    if ($BaselineDir) {
        $resolved = (Resolve-Path -LiteralPath $BaselineDir).Path
        if (-not (Test-Path -LiteralPath (Join-Path $resolved 'SKILL.md'))) {
            throw "BaselineDir has no SKILL.md: $resolved"
        }
        return [pscustomobject]@{ Path = $resolved; Temporary = $false }
    }
    $rel = Get-SkillRelPath $SkillName
    $commit = $BaselineCommit
    if (-not $commit) {
        if (Test-SkillTreeDirty -Repo $PackRoot -RelPath $rel) {
            $commit = 'HEAD'
        }
        else {
            throw @"
Working tree for $rel is clean. Pass one of:
  -BaselineCommit HEAD~1
  -BaselineDir <snapshot>
  -SkipBaseline
"@
        }
    }
    $dest = Join-Path $env:TEMP ("aes-skill-baseline-{0}-{1}" -f $SkillName, [Guid]::NewGuid().ToString('N'))
    Export-SkillAtCommit -Repo $PackRoot -Commit $commit -RelPath $rel -Dest $dest
    return [pscustomobject]@{ Path = $dest; Temporary = $true }
}

function New-EvalWorktree {
    param(
        $Eval,
        [string]$SkillDir,
        [string]$SkillName,
        [string]$SkillSourceDir,
        [string]$DestRoot
    )
    if (Test-Path -LiteralPath $DestRoot) {
        Remove-Item -LiteralPath $DestRoot -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $DestRoot | Out-Null
    $fixture = Join-Path $PackRoot "evals\fixtures\$($Eval.fixture)"
    Copy-DirectoryContents -From $fixture -To $DestRoot
    foreach ($f in @($Eval.files)) {
        if ([string]::IsNullOrWhiteSpace($f)) { continue }
        $from = Resolve-EvalOverlayPath -PackRoot $PackRoot -SkillDir $SkillDir -Rel $f
        if (-not $from) { throw "Overlay not found: $f" }
        Copy-DirectoryContents -From $from -To $DestRoot
    }
    Initialize-EvalGitRepo -WorkDir $DestRoot
    Install-SkillIntoWorkspace -WorkDir $DestRoot -PackRoot $PackRoot -SkillName $SkillName -SkillSourceDir $SkillSourceDir
    Add-EvalGitCommit -WorkDir $DestRoot -Message 'eval skill install'
    if ($Eval.branch) {
        $sw = Invoke-Git $DestRoot @('switch', '-c', [string]$Eval.branch)
        if ($sw.ExitCode -ne 0) {
            throw "git switch -c $($Eval.branch) failed: $($sw.Output)"
        }
        foreach ($f in @($Eval.branch_files)) {
            if ([string]::IsNullOrWhiteSpace($f)) { continue }
            $from = Resolve-EvalOverlayPath -PackRoot $PackRoot -SkillDir $SkillDir -Rel $f
            if (-not $from) { throw "Overlay not found: $f" }
            Copy-DirectoryContents -From $from -To $DestRoot
        }
        Add-EvalGitCommit -WorkDir $DestRoot -Message 'eval feature overlay'
    }
}

function Invoke-OneConfiguration {
    param(
        $Eval,
        [string]$SkillDir,
        [string]$SkillName,
        [string]$SkillSourceDir,
        [string]$ConfigDir,
        [string]$ConfigName
    )
    $work = Join-Path $ConfigDir 'work'
    $outputs = Join-Path $ConfigDir 'outputs'
    New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null
    New-EvalWorktree -Eval $Eval -SkillDir $SkillDir -SkillName $SkillName -SkillSourceDir $SkillSourceDir -DestRoot $work

    $snapshotPaths = @()
    foreach ($c in @($Eval.checks)) {
        if ($c.type -eq 'paths_unchanged') {
            $snapshotPaths += @($c.paths)
        }
    }
    $snapshot = @{}
    if ($snapshotPaths.Count -gt 0) {
        $snapshot = Get-PathSnapshot -Root $work -Paths $snapshotPaths
    }

    $agent = Invoke-EvalAgent -AgentExe $AgentExe -WorkDir $work -Prompt ([string]$Eval.prompt) `
        -Replies @($Eval.replies) -TimeoutSec $TimeoutSec -RunDir $ConfigDir

    $gitFacts = Get-GitFacts -WorkDir $work
    $gitFacts | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $ConfigDir 'git.json') -Encoding UTF8
    [System.IO.File]::WriteAllText((Join-Path $ConfigDir 'transcript.txt'), [string]$agent.Transcript)

    Write-EvalOutputs -WorkDir $work -OutputDir $outputs

    $timing = [pscustomobject]@{
        total_tokens  = $agent.Tokens
        duration_ms   = $agent.DurationMs
        timed_out     = [bool]$agent.TimedOut
        agent_exit    = $agent.ExitCode
        configuration = $ConfigName
    }
    $timing | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $ConfigDir 'timing.json') -Encoding UTF8

    $results = New-Object System.Collections.ArrayList
    foreach ($c in @($Eval.checks)) {
        $one = Invoke-EvalCheck -Check $c -WorkDir $work -Transcript ([string]$agent.Transcript) -GitFacts $gitFacts -Snapshot $snapshot
        [void]$results.Add($one)
        $mark = 'pass'
        if (-not $one.passed) { $mark = 'FAIL' }
        Write-Host ("    {0,-5} {1}  {2}" -f $mark, $one.id, $one.evidence)
    }

    $passed = @($results | Where-Object { $_.passed }).Count
    $failed = @($results | Where-Object { -not $_.passed }).Count
    $total = $results.Count
    $passRate = 0
    if ($total -gt 0) { $passRate = [math]::Round($passed / $total, 4) }
    $mustFailed = @($results | Where-Object { $_.must -and -not $_.passed }).Count

    $grading = [pscustomobject]@{
        assertion_results = @($results)
        summary           = [pscustomobject]@{
            passed     = $passed
            failed     = $failed
            total      = $total
            pass_rate  = $passRate
            must_failed = $mustFailed
        }
    }
    $grading | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $ConfigDir 'grading.json') -Encoding UTF8

    return [pscustomobject]@{
        eval_id         = $Eval.id
        eval_name       = $Eval.name
        configuration   = $ConfigName
        pass_rate       = $passRate
        passed          = $passed
        failed          = $failed
        total           = $total
        must_failed     = $mustFailed
        time_seconds    = [math]::Round($agent.DurationMs / 1000.0, 2)
        tokens          = $agent.Tokens
        timed_out       = [bool]$agent.TimedOut
        grading         = $grading
    }
}

function Get-Mean {
    param([double[]]$Values)
    if ($null -eq $Values -or $Values.Count -eq 0) { return 0 }
    $sum = 0.0
    foreach ($v in $Values) { $sum += $v }
    return [math]::Round($sum / $Values.Count, 4)
}

function Get-StdDev {
    param([double[]]$Values)
    if ($null -eq $Values -or $Values.Count -lt 2) { return 0 }
    $mean = Get-Mean $Values
    $acc = 0.0
    foreach ($v in $Values) { $acc += [math]::Pow($v - $mean, 2) }
    return [math]::Round([math]::Sqrt($acc / $Values.Count), 4)
}

function Write-Benchmark {
    param(
        [string]$Path,
        [string]$SkillName,
        $Runs
    )
    $with = @($Runs | Where-Object { $_.configuration -eq 'with_skill' })
    $old = @($Runs | Where-Object { $_.configuration -eq 'old_skill' })

    function Summarize($subset) {
        if ($subset.Count -eq 0) { return $null }
        $pr = @($subset | ForEach-Object { [double]$_.pass_rate })
        $tm = @($subset | ForEach-Object { [double]$_.time_seconds })
        $tk = @($subset | Where-Object { $null -ne $_.tokens } | ForEach-Object { [double]$_.tokens })
        $tokenSummary = $null
        if ($tk.Count -gt 0) {
            $tokenSummary = [pscustomobject]@{ mean = (Get-Mean $tk); stddev = (Get-StdDev $tk) }
        }
        return [pscustomobject]@{
            pass_rate    = [pscustomobject]@{ mean = (Get-Mean $pr); stddev = (Get-StdDev $pr) }
            time_seconds = [pscustomobject]@{ mean = (Get-Mean $tm); stddev = (Get-StdDev $tm) }
            tokens       = $tokenSummary
        }
    }

    $withSum = Summarize $with
    $oldSum = Summarize $old
    $delta = $null
    if ($withSum -and $oldSum) {
        $delta = [pscustomobject]@{
            pass_rate    = [math]::Round($withSum.pass_rate.mean - $oldSum.pass_rate.mean, 4)
            time_seconds = [math]::Round($withSum.time_seconds.mean - $oldSum.time_seconds.mean, 2)
        }
    }

    $doc = [pscustomobject]@{
        metadata    = [pscustomobject]@{
            skill_name  = $SkillName
            timestamp   = (Get-Date).ToUniversalTime().ToString('o')
            evals_run   = @($with | ForEach-Object { $_.eval_name } | Select-Object -Unique)
        }
        runs        = @($Runs)
        run_summary = [pscustomobject]@{
            with_skill = $withSum
            old_skill  = $oldSum
            delta      = $delta
        }
    }
    $doc | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $Path -Encoding UTF8
    return $doc
}

function Invoke-SkillQualityEvals {
    param([string]$SkillName)
    $doc = Test-QualityEvalsDocument -PackRoot $PackRoot -SkillName $SkillName
    foreach ($err in @($doc.Errors)) {
        Write-Host "ERROR: $err"
    }
    if (-not $doc.Ok) {
        return 1
    }
    Write-Host "OK  $($doc.EvalsPath) ($($doc.Spec.evals.Count) evals)"
    if ($ValidateOnly) { return 0 }

    $currentSkillDir = $doc.SkillDir
    $baselineDirResolved = $null
    $baselineTemp = $false
    try {
        $baseline = Resolve-BaselineSkillDir -SkillName $SkillName
        if ($baseline) {
            $baselineDirResolved = $baseline.Path
            $baselineTemp = [bool]$baseline.Temporary
        }

        $wsRoot = Join-Path $PackRoot "evals\workspaces\$SkillName"
        $iterDir = Get-NextIterationDir -SkillWorkRoot $wsRoot -Iteration $Iteration
        New-Item -ItemType Directory -Force -Path $iterDir | Out-Null
        Write-Host "Workspace: $iterDir"

        $evals = @($doc.Spec.evals)
        if ($EvalName) {
            $evals = @($evals | Where-Object { $_.name -eq $EvalName })
            if ($evals.Count -eq 0) { throw "No eval named '$EvalName' for $SkillName" }
        }

        $runs = New-Object System.Collections.ArrayList
        foreach ($ev in $evals) {
            Write-Host ""
            Write-Host "Eval $($ev.id) $($ev.name)"
            $evalRoot = Join-Path $iterDir ("eval-" + $ev.name)

            Write-Host "  with_skill"
            $with = Invoke-OneConfiguration -Eval $ev -SkillDir $currentSkillDir -SkillName $SkillName `
                -SkillSourceDir $currentSkillDir -ConfigDir (Join-Path $evalRoot 'with_skill') -ConfigName 'with_skill'
            [void]$runs.Add($with)

            if ($baselineDirResolved) {
                Write-Host "  old_skill"
                $old = Invoke-OneConfiguration -Eval $ev -SkillDir $currentSkillDir -SkillName $SkillName `
                    -SkillSourceDir $baselineDirResolved -ConfigDir (Join-Path $evalRoot 'old_skill') -ConfigName 'old_skill'
                [void]$runs.Add($old)
            }
        }

        $benchPath = Join-Path $iterDir 'benchmark.json'
        $bench = Write-Benchmark -Path $benchPath -SkillName $SkillName -Runs @($runs)
        Write-Host ""
        Write-Host "Wrote $benchPath"
        if ($bench.run_summary.with_skill) {
            Write-Host ("with_skill pass_rate mean {0}" -f $bench.run_summary.with_skill.pass_rate.mean)
        }
        if ($bench.run_summary.old_skill) {
            Write-Host ("old_skill  pass_rate mean {0}" -f $bench.run_summary.old_skill.pass_rate.mean)
        }
        if ($bench.run_summary.delta) {
            Write-Host ("delta pass_rate {0}" -f $bench.run_summary.delta.pass_rate)
        }

        $mustFailed = @($runs | Where-Object { $_.configuration -eq 'with_skill' -and $_.must_failed -gt 0 }).Count
        $worse = $false
        if ($bench.run_summary.with_skill -and $bench.run_summary.old_skill) {
            if ($bench.run_summary.with_skill.pass_rate.mean -lt $bench.run_summary.old_skill.pass_rate.mean) {
                $worse = $true
            }
        }
        if ($mustFailed -gt 0) {
            Write-Host "FAIL: $mustFailed with_skill eval(s) have failed must-checks"
            return 1
        }
        if ($worse) {
            Write-Host 'FAIL: with_skill pass rate is worse than old_skill'
            return 1
        }
        return 0
    }
    finally {
        if ($baselineTemp -and $baselineDirResolved -and (Test-Path -LiteralPath $baselineDirResolved)) {
            Remove-Item -LiteralPath $baselineDirResolved -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

$names = @($Skill)
if ($Skill -eq 'all') { $names = Get-AllQualitySkillNames }

$code = 0
foreach ($n in $names) {
    Write-Host "==== $n ===="
    $one = Invoke-SkillQualityEvals -SkillName $n
    if ($one -ne 0) { $code = $one }
}
exit $code
