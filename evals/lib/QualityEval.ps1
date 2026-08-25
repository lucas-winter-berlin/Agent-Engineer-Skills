# Shared helpers for evals/run-quality-eval.ps1. PowerShell 5.1 compatible.

$script:KnownCheckTypes = @(
    'transcript_contains',
    'transcript_not_contains',
    'asked_or_awaiting',
    'status_in',
    'status_not_in',
    'file_exists',
    'no_file',
    'file_contains',
    'file_not_contains',
    'heading_present',
    'no_placeholder',
    'no_emoji',
    'no_extra_prd',
    'paths_unchanged',
    'git_not_default',
    'git_branch_matches',
    'git_ahead_of_main',
    'git_no_push',
    'blocked_or_names_specifier',
    'findings_has_row',
    'smell_addressed_or_reported',
    'verdict_in',
    'layer_filled',
    'layer_absent_or_not_run',
    'package_no_test_script'
)

$script:ExtraPrdNames = @(
    'concept.md',
    'prd.md',
    'clarification-log.md',
    'acceptance-criteria.md',
    'notes.md'
)

function Get-SkillRelPath {
    param([string]$SkillName)
    $known = Get-AllQualitySkillNames
    if ($known -notcontains $SkillName) { throw "Unknown skill: $SkillName" }
    return "skills/$SkillName"
}

function Get-SkillRelPathAtCommit {
    param(
        [string]$Repo,
        [string]$Commit,
        [string]$SkillName
    )
    $flat = Get-SkillRelPath $SkillName
    $nested = if ($SkillName -eq 'mvp-specifier') {
        "skills/mvp-builder/$SkillName"
    }
    else {
        "skills/feature-builder/$SkillName"
    }
    foreach ($rel in @($flat, $nested)) {
        $posix = ($rel -replace '\\', '/')
        $files = @(git -C $Repo ls-tree -r --name-only $Commit -- $posix 2>$null)
        if ($LASTEXITCODE -eq 0 -and $files.Count -gt 0) {
            return $posix
        }
    }
    return $flat
}

function Get-AllQualitySkillNames {
    return @(
        'feature-specifier',
        'feature-bug-analyst',
        'feature-developer',
        'feature-code-reviewer',
        'feature-tester',
        'feature-refactorer',
        'mvp-specifier'
    )
}

function Convert-GlobToRegex {
    param([string]$Glob)
    $g = ($Glob -replace '\\', '/')
    $g = $g -replace '\*\*/', '__GLOBSTARSLASH__'
    $g = $g -replace '\*\*', '__GLOBSTAR__'
    $escaped = [regex]::Escape($g)
    $escaped = $escaped -replace '__GLOBSTARSLASH__', '(.*/)?'
    $escaped = $escaped -replace '__GLOBSTAR__', '.*'
    $escaped = $escaped -replace '\\\*', '[^/]*'
    $escaped = $escaped -replace '\\\?', '.'
    return "^$escaped`$"
}

function Get-RelativePosix {
    param([string]$Root, [string]$FullPath)
    $rootFull = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\', '/')
    $full = $FullPath
    if ($full.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        $rel = $full.Substring($rootFull.Length).TrimStart('\', '/')
    }
    else {
        $rel = $FullPath
    }
    return ($rel -replace '\\', '/')
}

function Test-EvalRelExcluded {
    param([string]$Rel)
    $posix = ($Rel -replace '\\', '/')
    return [bool]($posix -match '^(skills|\.cursor|\.agents|\.agent|\.git)(/|$)')
}

function Resolve-EvalGlob {
    param(
        [string]$Root,
        [string]$Pattern
    )
    if (-not $Pattern) { return @() }
    $norm = $Pattern -replace '\\', '/'
    if ($norm -notmatch '[\*\?]') {
        $candidate = Join-Path $Root ($norm -replace '/', [IO.Path]::DirectorySeparatorChar)
        if (Test-Path -LiteralPath $candidate) {
            return @(Get-Item -LiteralPath $candidate)
        }
        return @()
    }
    $regex = Convert-GlobToRegex $norm
    $hits = New-Object System.Collections.ArrayList
    if (-not (Test-Path -LiteralPath $Root)) { return @() }
    Get-ChildItem -LiteralPath $Root -Recurse -Force -File -ErrorAction SilentlyContinue | ForEach-Object {
        $rel = Get-RelativePosix -Root $Root -FullPath $_.FullName
        if (Test-EvalRelExcluded $rel) { return }
        if ($rel -match $regex) {
            [void]$hits.Add($_)
        }
    }
    return @($hits)
}

function Read-TextFile {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    return [System.IO.File]::ReadAllText($Path)
}

function Test-HasEmoji {
    param([string]$Text)
    if ([string]::IsNullOrEmpty($Text)) { return $false }
    foreach ($ch in $Text.ToCharArray()) {
        $code = [int]$ch
        if ($code -ge 0xD800 -and $code -le 0xDFFF) { return $true }
        if ($code -ge 0x2600 -and $code -le 0x27BF) { return $true }
        if ($code -ge 0xFE00 -and $code -le 0xFE0F) { return $true }
        if ($code -ge 0x200D -and $code -le 0x200D) { return $true }
    }
    return $false
}

function Test-HasPlaceholder {
    param([string]$Text)
    if ([string]::IsNullOrEmpty($Text)) { return $false }
    return [bool]($Text -match '\{\{[A-Za-z0-9_| -]+}}')
}

function Get-StatusValue {
    param([string]$Text)
    if ([string]::IsNullOrEmpty($Text)) { return $null }
    $m = [regex]::Match($Text, '(?im)^-\s*Status:\s*`?([a-z0-9-]+)`?')
    if ($m.Success) { return $m.Groups[1].Value.ToLowerInvariant() }
    return $null
}

function Get-VerdictValue {
    param([string]$Text)
    if ([string]::IsNullOrEmpty($Text)) { return $null }
    $m = [regex]::Match($Text, '(?im)^##\s*Verdict\s*$\s*`?(pass|fail|not-run)`?')
    if ($m.Success) { return $m.Groups[1].Value.ToLowerInvariant() }
    $m2 = [regex]::Match($Text, '(?im)^##\s*Verdict\b[\s\S]{0,500}?\b(pass|fail|not-run)\b')
    if ($m2.Success) { return $m2.Groups[1].Value.ToLowerInvariant() }
    return $null
}

function Get-LayerRow {
    param([string]$Text, [string]$Layer)
    if ([string]::IsNullOrEmpty($Text)) { return $null }
    $escaped = [regex]::Escape($Layer)
    $m = [regex]::Match($Text, "(?im)^\|\s*$escaped\s*\|([^|]*)\|([^|]*)\|")
    if (-not $m.Success) { return $null }
    return [pscustomobject]@{
        Command = $m.Groups[1].Value.Trim()
        Result  = $m.Groups[2].Value.Trim().ToLowerInvariant()
    }
}

function New-CheckResult {
    param(
        [string]$Id,
        [string]$Text,
        [bool]$Passed,
        [string]$Evidence,
        [bool]$Must
    )
    return [pscustomobject]@{
        id       = $Id
        text     = $Text
        passed   = $Passed
        evidence = $Evidence
        must     = $Must
    }
}

function Get-CheckMust {
    param($Check)
    if ($null -eq $Check.must) { return $true }
    return [bool]$Check.must
}

function Get-CheckOptional {
    param($Check)
    if ($null -eq $Check.optional) { return $false }
    return [bool]$Check.optional
}

function Get-FirstGlobText {
    param([string]$Root, [string]$Pattern)
    $items = @(Resolve-EvalGlob -Root $Root -Pattern $Pattern)
    if ($items.Count -eq 0) { return $null }
    return (Read-TextFile $items[0].FullName)
}

function Get-PathSnapshot {
    param([string]$Root, [string[]]$Paths)
    $map = @{}
    foreach ($p in @($Paths)) {
        $full = Join-Path $Root ($p -replace '/', [IO.Path]::DirectorySeparatorChar)
        if (-not (Test-Path -LiteralPath $full)) { continue }
        $item = Get-Item -LiteralPath $full
        if ($item.PSIsContainer) {
            Get-ChildItem -LiteralPath $item.FullName -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
                $rel = Get-RelativePosix -Root $Root -FullPath $_.FullName
                if (Test-EvalRelExcluded $rel) { return }
                $map[$rel] = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
            }
        }
        else {
            $rel = Get-RelativePosix -Root $Root -FullPath $item.FullName
            if (Test-EvalRelExcluded $rel) { continue }
            $map[$rel] = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256).Hash
        }
    }
    return $map
}

function Resolve-EvalOverlayPath {
    param(
        [string]$PackRoot,
        [string]$SkillDir,
        [string]$Rel
    )
    if ([string]::IsNullOrWhiteSpace($Rel)) { return $null }
    $norm = $Rel -replace '/', [IO.Path]::DirectorySeparatorChar
    $fromSkill = Join-Path $SkillDir $norm
    if (Test-Path -LiteralPath $fromSkill) { return $fromSkill }
    $fromPack = Join-Path $PackRoot $norm
    if (Test-Path -LiteralPath $fromPack) { return $fromPack }
    return $null
}

function Test-RelUnderRoots {
    param([string]$Rel, [string[]]$Roots)
    $posix = ($Rel -replace '\\', '/')
    foreach ($root in @($Roots)) {
        $r = ($root -replace '\\', '/').TrimEnd('/')
        if ($posix -eq $r) { return $true }
        if ($posix.StartsWith($r + '/')) { return $true }
    }
    return $false
}

function Copy-DirectoryContents {
    param([string]$From, [string]$To)
    if (-not (Test-Path -LiteralPath $From)) {
        throw "Overlay not found: $From"
    }
    New-Item -ItemType Directory -Force -Path $To | Out-Null
    Get-ChildItem -LiteralPath $From -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $To -Recurse -Force
    }
}

function Copy-SkillTree {
    param([string]$From, [string]$To)
    if (Test-Path -LiteralPath $To) {
        Remove-Item -LiteralPath $To -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $To | Out-Null
    Get-ChildItem -LiteralPath $From -Force | Where-Object { $_.Name -ne 'evals' } | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $To -Recurse -Force
    }
}

function Export-SkillAtCommit {
    param(
        [string]$Repo,
        [string]$Commit,
        [string]$RelPath,
        [string]$Dest
    )
    if (Test-Path -LiteralPath $Dest) {
        Remove-Item -LiteralPath $Dest -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $Dest | Out-Null
    $posix = ($RelPath -replace '\\', '/')
    $files = @(git -C $Repo ls-tree -r --name-only $Commit -- $posix 2>$null)
    if ($LASTEXITCODE -ne 0 -or $files.Count -eq 0) {
        throw "No files at ${Commit}:$posix"
    }
    $prefix = $posix.TrimEnd('/') + '/'
    foreach ($f in $files) {
        $norm = $f -replace '\\', '/'
        if ($norm -match '/evals/') { continue }
        $relInside = $norm
        if ($relInside.StartsWith($prefix)) {
            $relInside = $relInside.Substring($prefix.Length)
        }
        elseif ($relInside -eq $posix) {
            continue
        }
        $out = Join-Path $Dest ($relInside -replace '/', [IO.Path]::DirectorySeparatorChar)
        $parent = Split-Path -Parent $out
        if ($parent -and -not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Force -Path $parent | Out-Null
        }
        $shown = & git -C $Repo show "${Commit}:$norm" 2>$null
        if ($shown -is [System.Array]) { $shown = $shown -join "`n" }
        [System.IO.File]::WriteAllText($out, [string]$shown)
    }
}

function Test-SkillTreeDirty {
    param([string]$Repo, [string]$RelPath)
    $out = git -C $Repo status --porcelain -- $RelPath 2>$null
    return -not [string]::IsNullOrWhiteSpace($out)
}

function Invoke-Git {
    param([string]$WorkDir, [string[]]$GitArgs)
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $output = & git -C $WorkDir @GitArgs 2>&1 | Out-String
    $code = $LASTEXITCODE
    $ErrorActionPreference = $prev
    return [pscustomobject]@{ ExitCode = $code; Output = $output }
}

function Initialize-EvalGitRepo {
    param([string]$WorkDir)
    $r = Invoke-Git $WorkDir @('init')
    if ($r.ExitCode -ne 0) { throw "git init failed: $($r.Output)" }
    Invoke-Git $WorkDir @('checkout', '-B', 'main') | Out-Null
    Invoke-Git $WorkDir @('add', '-A') | Out-Null
    $r = Invoke-Git $WorkDir @(
        '-c', 'user.email=aes-eval@local',
        '-c', 'user.name=AES Eval',
        '-c', 'commit.gpgsign=false',
        'commit', '-m', 'eval fixture'
    )
    if ($r.ExitCode -ne 0) { throw "git commit fixture failed: $($r.Output)" }
}

function Add-EvalGitCommit {
    param([string]$WorkDir, [string]$Message)
    Invoke-Git $WorkDir @('add', '-A') | Out-Null
    $r = Invoke-Git $WorkDir @(
        '-c', 'user.email=aes-eval@local',
        '-c', 'user.name=AES Eval',
        '-c', 'commit.gpgsign=false',
        'commit', '-m', $Message
    )
    if ($r.ExitCode -ne 0) { throw "git commit failed: $($r.Output)" }
}

function Get-GitFacts {
    param([string]$WorkDir)
    $branch = (Invoke-Git $WorkDir @('rev-parse', '--abbrev-ref', 'HEAD')).Output.Trim()
    $sha = (Invoke-Git $WorkDir @('rev-parse', 'HEAD')).Output.Trim()
    $remotes = (Invoke-Git $WorkDir @('remote')).Output.Trim()
    $ahead = 0
    $hasMain = (Invoke-Git $WorkDir @('rev-parse', '--verify', 'main')).ExitCode -eq 0
    if ($hasMain) {
        $countOut = (Invoke-Git $WorkDir @('rev-list', '--count', 'main..HEAD')).Output.Trim()
        [void][int]::TryParse($countOut, [ref]$ahead)
    }
    return [pscustomobject]@{
        branch     = $branch
        sha        = $sha
        remotes    = $remotes
        ahead_main = $ahead
        has_main   = $hasMain
    }
}

function Install-SkillIntoWorkspace {
    param(
        [string]$WorkDir,
        [string]$PackRoot,
        [string]$SkillName,
        [string]$SkillSourceDir
    )
    $rel = Get-SkillRelPath $SkillName
    $dest = Join-Path $WorkDir ($rel -replace '/', [IO.Path]::DirectorySeparatorChar)
    Copy-SkillTree -From $SkillSourceDir -To $dest
    Copy-SkillTree -From $SkillSourceDir -To (Join-Path $WorkDir ".cursor\skills\$SkillName")
    Copy-SkillTree -From $SkillSourceDir -To (Join-Path $WorkDir ".agents\skills\$SkillName")

    $rulesDir = Join-Path $WorkDir '.cursor\rules'
    New-Item -ItemType Directory -Force -Path $rulesDir | Out-Null
    Copy-Item -LiteralPath (Join-Path $PackRoot '.cursor\rules\agent-engineer-skills.mdc') -Destination $rulesDir -Force
    $agentsSrc = Join-Path $PackRoot 'AGENTS.md'
    if (Test-Path -LiteralPath $agentsSrc) {
        Copy-Item -LiteralPath $agentsSrc -Destination (Join-Path $WorkDir 'AGENTS.md') -Force
    }
}

function Get-NextIterationDir {
    param([string]$SkillWorkRoot, [int]$Iteration)
    if ($Iteration -gt 0) {
        return (Join-Path $SkillWorkRoot "iteration-$Iteration")
    }
    $n = 1
    while (Test-Path -LiteralPath (Join-Path $SkillWorkRoot "iteration-$n")) {
        $n++
    }
    return (Join-Path $SkillWorkRoot "iteration-$n")
}

function Test-QualityEvalsDocument {
    param(
        [string]$PackRoot,
        [string]$SkillName
    )
    $rel = Get-SkillRelPath $SkillName
    $skillDir = Join-Path $PackRoot ($rel -replace '/', [IO.Path]::DirectorySeparatorChar)
    $evalsPath = Join-Path $skillDir 'evals\evals.json'
    $errors = New-Object System.Collections.ArrayList
    if (-not (Test-Path -LiteralPath $evalsPath)) {
        [void]$errors.Add("Missing $evalsPath")
        return [pscustomobject]@{ Ok = $false; Errors = @($errors); Spec = $null; SkillDir = $skillDir }
    }
    $raw = Read-TextFile $evalsPath
    $spec = $raw | ConvertFrom-Json
    if ($spec.skill_name -ne $SkillName) {
        [void]$errors.Add("skill_name '$($spec.skill_name)' does not match $SkillName")
    }
    if (-not $spec.family) {
        [void]$errors.Add('family is required')
    }
    $evals = @($spec.evals)
    if ($evals.Count -lt 1) {
        [void]$errors.Add('evals array is empty')
    }
    $ids = @{}
    $names = @{}
    foreach ($ev in $evals) {
        if (-not $ev.id) { [void]$errors.Add('eval missing id') }
        elseif ($ids.ContainsKey([string]$ev.id)) { [void]$errors.Add("duplicate eval id $($ev.id)") }
        else { $ids[[string]$ev.id] = $true }
        if (-not $ev.name) { [void]$errors.Add("eval $($ev.id) missing name") }
        elseif ($names.ContainsKey([string]$ev.name)) { [void]$errors.Add("duplicate eval name $($ev.name)") }
        else { $names[[string]$ev.name] = $true }
        if (-not $ev.prompt) { [void]$errors.Add("eval $($ev.name) missing prompt") }
        if (-not $ev.expected_output) { [void]$errors.Add("eval $($ev.name) missing expected_output") }
        if (-not $ev.fixture) { [void]$errors.Add("eval $($ev.name) missing fixture") }
        else {
            $fix = Join-Path $PackRoot "evals\fixtures\$($ev.fixture)"
            if (-not (Test-Path -LiteralPath $fix)) {
                [void]$errors.Add("eval $($ev.name) fixture not found: $($ev.fixture)")
            }
        }
        foreach ($f in @($ev.files)) {
            if ([string]::IsNullOrWhiteSpace($f)) { continue }
            $p = Resolve-EvalOverlayPath -PackRoot $PackRoot -SkillDir $skillDir -Rel $f
            if (-not $p) {
                [void]$errors.Add("eval $($ev.name) files path missing: $f")
            }
        }
        foreach ($f in @($ev.branch_files)) {
            if ([string]::IsNullOrWhiteSpace($f)) { continue }
            $p = Resolve-EvalOverlayPath -PackRoot $PackRoot -SkillDir $skillDir -Rel $f
            if (-not $p) {
                [void]$errors.Add("eval $($ev.name) branch_files path missing: $f")
            }
        }
        $checks = @($ev.checks)
        if ($checks.Count -lt 1) {
            [void]$errors.Add("eval $($ev.name) has no checks")
        }
        $cids = @{}
        foreach ($c in $checks) {
            if (-not $c.id) { [void]$errors.Add("eval $($ev.name) check missing id") }
            elseif ($cids.ContainsKey([string]$c.id)) { [void]$errors.Add("eval $($ev.name) duplicate check id $($c.id)") }
            else { $cids[[string]$c.id] = $true }
            if ($script:KnownCheckTypes -notcontains $c.type) {
                [void]$errors.Add("eval $($ev.name) unknown check type '$($c.type)'")
            }
        }
    }
    return [pscustomobject]@{
        Ok       = ($errors.Count -eq 0)
        Errors   = @($errors)
        Spec     = $spec
        SkillDir = $skillDir
        EvalsPath = $evalsPath
    }
}

function Invoke-CursorAgentTurn {
    param(
        [string]$AgentExe,
        [string]$WorkDir,
        [string]$Prompt,
        [string]$ResumeId,
        [int]$TimeoutSec,
        [string]$LogPath
    )
    $promptFile = Join-Path $LogPath 'prompt-current.txt'
    [System.IO.File]::WriteAllText($promptFile, $Prompt)
    $stdoutPath = Join-Path $LogPath 'agent-stdout.txt'
    $stderrPath = Join-Path $LogPath 'agent-stderr.txt'

    $cmd = Get-Command $AgentExe -ErrorAction SilentlyContinue
    if (-not $cmd) {
        throw "Agent executable not found: $AgentExe"
    }
    $exe = $cmd.Source
    if (-not $exe) { $exe = $AgentExe }

    # Prefer node.exe + index.js. Calling cursor-agent.ps1 with -p lets PowerShell
    # eat CLI flags; the Windows installer also keeps the payload under versions/.
    $nodeExe = $null
    $indexJs = $null
    $agentDir = Split-Path -Parent $exe
    $directNode = Join-Path $agentDir 'node.exe'
    $directIndex = Join-Path $agentDir 'index.js'
    if ((Test-Path -LiteralPath $directNode) -and (Test-Path -LiteralPath $directIndex)) {
        $nodeExe = $directNode
        $indexJs = $directIndex
    }
    else {
        $versionsRoot = Join-Path $agentDir 'versions'
        if (Test-Path -LiteralPath $versionsRoot) {
            $latest = Get-ChildItem -LiteralPath $versionsRoot -Directory |
                Sort-Object Name -Descending |
                Select-Object -First 1
            if ($latest) {
                $vNode = Join-Path $latest.FullName 'node.exe'
                $vIndex = Join-Path $latest.FullName 'index.js'
                if ((Test-Path -LiteralPath $vNode) -and (Test-Path -LiteralPath $vIndex)) {
                    $nodeExe = $vNode
                    $indexJs = $vIndex
                }
            }
        }
    }

    $invokePs1 = Join-Path $LogPath 'invoke-agent.ps1'
    if ($nodeExe -and $indexJs) {
        $invokeBody = @'
$ErrorActionPreference = 'Stop'
$node = $env:AES_AGENT_NODE
$index = $env:AES_AGENT_INDEX
$ws = $env:AES_EVAL_WORKSPACE
$query = $env:AES_EVAL_QUERY
$resume = $env:AES_EVAL_RESUME
if (-not $node) { throw 'AES_AGENT_NODE is empty' }
if (-not $index) { throw 'AES_AGENT_INDEX is empty' }
$agentArgs = @(
    $index,
    '-p',
    '--force',
    '--trust',
    '--workspace', $ws,
    '--output-format', 'json'
)
if ($resume) {
    $agentArgs += @('--resume', $resume)
}
$agentArgs += @('--', $query)
& $node @agentArgs
exit $LASTEXITCODE
'@
    }
    else {
        # Fallback: cmd.exe so PowerShell does not bind -p as a script parameter.
        $invokeBody = @'
$ErrorActionPreference = 'Stop'
$exe = $env:AES_AGENT_EXE
$ws = $env:AES_EVAL_WORKSPACE
$query = $env:AES_EVAL_QUERY
$resume = $env:AES_EVAL_RESUME
if (-not $exe) { throw 'AES_AGENT_EXE is empty' }
$cmdExe = Join-Path $env:SystemRoot 'System32\cmd.exe'
$argLine = '-p --force --trust --workspace "' + $ws + '" --output-format json'
if ($resume) {
    $argLine += ' --resume "' + $resume + '"'
}
$argLine += ' -- "' + ($query -replace '"', '\"') + '"'
$psi = "/c `"`"$exe`" $argLine`""
& $cmdExe $psi
exit $LASTEXITCODE
'@
    }
    [System.IO.File]::WriteAllText($invokePs1, $invokeBody)

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Join-Path $PSHOME 'powershell.exe')
    $psi.Arguments = "-NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$invokePs1`""
    $psi.WorkingDirectory = $WorkDir
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $psi.EnvironmentVariables['AES_AGENT_EXE'] = $exe
    if ($nodeExe -and $indexJs) {
        $psi.EnvironmentVariables['AES_AGENT_NODE'] = $nodeExe
        $psi.EnvironmentVariables['AES_AGENT_INDEX'] = $indexJs
    }
    $psi.EnvironmentVariables['AES_EVAL_QUERY'] = $Prompt
    $psi.EnvironmentVariables['AES_EVAL_WORKSPACE'] = $WorkDir
    if ($ResumeId) {
        $psi.EnvironmentVariables['AES_EVAL_RESUME'] = $ResumeId
    }
    else {
        $psi.EnvironmentVariables['AES_EVAL_RESUME'] = ''
    }

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    [void]$proc.Start()
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()
    $timedOut = $false
    $waitMs = [Math]::Max(1000, $TimeoutSec * 1000)
    if (-not $proc.WaitForExit($waitMs)) {
        $timedOut = $true
        try { $proc.Kill() } catch { }
        try { $proc.WaitForExit(10000) } catch { }
    }
    $sw.Stop()
    $stdout = [string]$stdoutTask.Result
    $stderr = [string]$stderrTask.Result
    [System.IO.File]::WriteAllText($stdoutPath, $stdout)
    [System.IO.File]::WriteAllText($stderrPath, $stderr)

    $sessionId = $null
    $tokens = $null
    try {
        $parsed = $stdout | ConvertFrom-Json
        foreach ($key in @('session_id', 'sessionId', 'id')) {
            if ($parsed.PSObject.Properties.Name -contains $key -and $parsed.$key) {
                $sessionId = [string]$parsed.$key
                break
            }
        }
        if ($parsed.usage -and $parsed.usage.total_tokens) {
            $tokens = [int]$parsed.usage.total_tokens
        }
        elseif ($parsed.total_tokens) {
            $tokens = [int]$parsed.total_tokens
        }
    }
    catch {
        $sessionId = $null
    }

    return [pscustomobject]@{
        ExitCode   = $proc.ExitCode
        TimedOut   = $timedOut
        DurationMs = [int]$sw.Elapsed.TotalMilliseconds
        Stdout     = $stdout
        Stderr     = $stderr
        SessionId  = $sessionId
        Tokens     = $tokens
    }
}

function Invoke-EvalAgent {
    param(
        [string]$AgentExe,
        [string]$WorkDir,
        [string]$Prompt,
        [string[]]$Replies,
        [int]$TimeoutSec,
        [string]$RunDir
    )
    $logDir = Join-Path $RunDir 'agent-logs'
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    $parts = New-Object System.Collections.ArrayList
    $totalMs = 0
    $totalTokens = 0
    $hasTokens = $false
    $sessionId = $null
    $lastExit = 0
    $timedOut = $false

    $turn = Invoke-CursorAgentTurn -AgentExe $AgentExe -WorkDir $WorkDir -Prompt $Prompt `
        -ResumeId $null -TimeoutSec $TimeoutSec -LogPath $logDir
    [void]$parts.Add("=== turn 1 ===`n$($turn.Stdout)`n$($turn.Stderr)")
    $totalMs += $turn.DurationMs
    $lastExit = $turn.ExitCode
    $timedOut = $turn.TimedOut
    if ($null -ne $turn.Tokens) { $hasTokens = $true; $totalTokens += $turn.Tokens }
    if ($turn.SessionId) { $sessionId = $turn.SessionId }

    $n = 1
    foreach ($reply in @($Replies)) {
        if ([string]::IsNullOrWhiteSpace($reply)) { continue }
        if ($timedOut) { break }
        $n++
        $turnDir = Join-Path $logDir "turn-$n"
        New-Item -ItemType Directory -Force -Path $turnDir | Out-Null
        $resume = $sessionId
        $turn = Invoke-CursorAgentTurn -AgentExe $AgentExe -WorkDir $WorkDir -Prompt $reply `
            -ResumeId $resume -TimeoutSec $TimeoutSec -LogPath $turnDir
        if ($turn.ExitCode -ne 0 -and $resume) {
            $combined = "The operator answered:`n$reply"
            $turn = Invoke-CursorAgentTurn -AgentExe $AgentExe -WorkDir $WorkDir -Prompt $combined `
                -ResumeId $null -TimeoutSec $TimeoutSec -LogPath $turnDir
        }
        [void]$parts.Add("=== turn $n ===`n$($turn.Stdout)`n$($turn.Stderr)")
        $totalMs += $turn.DurationMs
        $lastExit = $turn.ExitCode
        if ($turn.TimedOut) { $timedOut = $true }
        if ($null -ne $turn.Tokens) { $hasTokens = $true; $totalTokens += $turn.Tokens }
        if ($turn.SessionId) { $sessionId = $turn.SessionId }
    }

    $tokenValue = $null
    if ($hasTokens) { $tokenValue = $totalTokens }
    return [pscustomobject]@{
        Transcript = ($parts -join "`n")
        DurationMs = $totalMs
        Tokens     = $tokenValue
        ExitCode   = $lastExit
        TimedOut   = $timedOut
        SessionId  = $sessionId
    }
}

function Invoke-EvalCheck {
    param(
        $Check,
        [string]$WorkDir,
        [string]$Transcript,
        $GitFacts,
        $Snapshot
    )
    $id = [string]$Check.id
    $type = [string]$Check.type
    $must = Get-CheckMust $Check
    $optional = Get-CheckOptional $Check
    $label = $type
    if ($Check.pattern) { $label = "$type $($Check.pattern)" }

    switch ($type) {
        'transcript_contains' {
            $ok = $Transcript -match $Check.pattern
            $ev = if ($ok) { 'Matched transcript' } else { 'Pattern not found in transcript' }
            return New-CheckResult $id $label $ok $ev $must
        }
        'transcript_not_contains' {
            $ok = $Transcript -notmatch $Check.pattern
            $ev = if ($ok) { 'Pattern absent from transcript' } else { 'Pattern unexpectedly present in transcript' }
            return New-CheckResult $id $label $ok $ev $must
        }
        'asked_or_awaiting' {
            if ($Transcript -match $Check.transcript_pattern) {
                return New-CheckResult $id $type $true 'Transcript contains a landmine question' $must
            }
            $specs = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.awaiting_glob)
            foreach ($s in $specs) {
                $st = Get-StatusValue (Read-TextFile $s.FullName)
                if ($st -eq 'awaiting-questions') {
                    return New-CheckResult $id $type $true "Status awaiting-questions in $($s.Name)" $must
                }
            }
            return New-CheckResult $id $type $false 'No landmine question in transcript and no awaiting-questions spec' $must
        }
        'file_exists' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            $ok = $items.Count -gt 0
            $ev = if ($ok) { "Found $($items[0].FullName)" } else { "No file matched $($Check.path)" }
            return New-CheckResult $id $label $ok $ev $must
        }
        'no_file' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            $ok = $items.Count -eq 0
            $ev = if ($ok) { "No file matched $($Check.path)" } else { "Found $($items[0].Name)" }
            return New-CheckResult $id $label $ok $ev $must
        }
        'file_contains' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                if ($optional) { return New-CheckResult $id $label $true 'Optional path missing' $must }
                return New-CheckResult $id $label $false "No file matched $($Check.path)" $must
            }
            $ok = $false
            $hit = $null
            foreach ($it in $items) {
                $text = Read-TextFile $it.FullName
                if ($text -match $Check.pattern) { $ok = $true; $hit = $it.Name; break }
            }
            $ev = if ($ok) { "Matched in $hit" } else { "Pattern not found in $($Check.path)" }
            return New-CheckResult $id $label $ok $ev $must
        }
        'file_not_contains' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            $ok = $true
            $hit = $null
            foreach ($it in $items) {
                $text = Read-TextFile $it.FullName
                if ($text -match $Check.pattern) { $ok = $false; $hit = $it.Name; break }
            }
            $ev = if ($ok) { 'Pattern absent' } else { "Pattern found in $hit" }
            return New-CheckResult $id $label $ok $ev $must
        }
        'heading_present' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                if ($optional) { return New-CheckResult $id $label $true 'Optional path missing' $must }
                return New-CheckResult $id $label $false "No file matched $($Check.path)" $must
            }
            $heading = [regex]::Escape([string]$Check.heading)
            $ok = $false
            foreach ($it in $items) {
                $text = Read-TextFile $it.FullName
                if ($text -match "(?m)^$heading(\s|$)") { $ok = $true; break }
            }
            $ev = if ($ok) { "Found $($Check.heading)" } else { "Missing heading $($Check.heading)" }
            return New-CheckResult $id $label $ok $ev $must
        }
        'status_in' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                if ($optional) { return New-CheckResult $id $type $true 'Optional path missing' $must }
                return New-CheckResult $id $type $false "No file matched $($Check.path)" $must
            }
            $values = @($Check.values | ForEach-Object { $_.ToString().ToLowerInvariant() })
            $st = Get-StatusValue (Read-TextFile $items[0].FullName)
            $ok = $values -contains $st
            $ev = "Status='$st' allowed=[$($values -join ', ')]"
            return New-CheckResult $id $type $ok $ev $must
        }
        'status_not_in' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                if ($optional) { return New-CheckResult $id $type $true 'Optional path missing' $must }
                return New-CheckResult $id $type $false "No file matched $($Check.path)" $must
            }
            $values = @($Check.values | ForEach-Object { $_.ToString().ToLowerInvariant() })
            $st = Get-StatusValue (Read-TextFile $items[0].FullName)
            $ok = $values -notcontains $st
            $ev = "Status='$st' forbidden=[$($values -join ', ')]"
            return New-CheckResult $id $type $ok $ev $must
        }
        'verdict_in' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                if ($optional) { return New-CheckResult $id $type $true 'Optional path missing' $must }
                return New-CheckResult $id $type $false "No file matched $($Check.path)" $must
            }
            $values = @($Check.values | ForEach-Object { $_.ToString().ToLowerInvariant() })
            $v = Get-VerdictValue (Read-TextFile $items[0].FullName)
            $ok = $values -contains $v
            $ev = "Verdict='$v' allowed=[$($values -join ', ')]"
            return New-CheckResult $id $type $ok $ev $must
        }
        'no_placeholder' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                if ($optional) { return New-CheckResult $id $type $true 'Optional path missing' $must }
                return New-CheckResult $id $type $false "No file matched $($Check.path)" $must
            }
            $ok = $true
            $hit = $null
            foreach ($it in $items) {
                if (Test-HasPlaceholder (Read-TextFile $it.FullName)) { $ok = $false; $hit = $it.Name; break }
            }
            $ev = if ($ok) { 'No template placeholders' } else { "Placeholder left in $hit" }
            return New-CheckResult $id $type $ok $ev $must
        }
        'no_emoji' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                if ($optional) { return New-CheckResult $id $type $true 'Optional path missing' $must }
                return New-CheckResult $id $type $true 'No matching files' $must
            }
            $ok = $true
            $hit = $null
            foreach ($it in $items) {
                if (Test-HasEmoji (Read-TextFile $it.FullName)) { $ok = $false; $hit = $it.Name; break }
            }
            $ev = if ($ok) { 'No emoji' } else { "Emoji in $hit" }
            return New-CheckResult $id $type $ok $ev $must
        }
        'no_extra_prd' {
            $hit = $null
            Get-ChildItem -LiteralPath $WorkDir -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
                $rel = Get-RelativePosix -Root $WorkDir -FullPath $_.FullName
                if (Test-EvalRelExcluded $rel) { return }
                if ($script:ExtraPrdNames -contains $_.Name.ToLowerInvariant()) {
                    $hit = $rel
                }
            }
            $ok = [string]::IsNullOrEmpty($hit)
            $ev = if ($ok) { 'No extra PRD filenames' } else { "Found $hit" }
            return New-CheckResult $id $type $ok $ev $must
        }
        'paths_unchanged' {
            $before = $Snapshot
            if ($null -eq $before) { $before = @{} }
            $after = Get-PathSnapshot -Root $WorkDir -Paths @($Check.paths)
            $changed = New-Object System.Collections.ArrayList
            foreach ($k in $before.Keys) {
                if (-not (Test-RelUnderRoots -Rel $k -Roots @($Check.paths))) { continue }
                if (-not $after.ContainsKey($k)) { [void]$changed.Add("removed $k") }
                elseif ($after[$k] -ne $before[$k]) { [void]$changed.Add("changed $k") }
            }
            foreach ($k in $after.Keys) {
                if (-not $before.ContainsKey($k)) { [void]$changed.Add("added $k") }
            }
            $ok = $changed.Count -eq 0
            $ev = if ($ok) { 'Listed paths unchanged' } else { ($changed -join '; ') }
            return New-CheckResult $id $type $ok $ev $must
        }
        'git_not_default' {
            $b = [string]$GitFacts.branch
            $ok = ($b -ne 'main' -and $b -ne 'master')
            return New-CheckResult $id $type $ok "branch=$b" $must
        }
        'git_branch_matches' {
            $b = [string]$GitFacts.branch
            $ok = $b -match $Check.pattern
            return New-CheckResult $id $type $ok "branch=$b pattern=$($Check.pattern)" $must
        }
        'git_ahead_of_main' {
            $ok = [int]$GitFacts.ahead_main -ge 1
            return New-CheckResult $id $type $ok "ahead_main=$($GitFacts.ahead_main)" $must
        }
        'git_no_push' {
            $ok = [string]::IsNullOrWhiteSpace([string]$GitFacts.remotes)
            $ev = if ($ok) { 'No git remotes' } else { "remotes=$($GitFacts.remotes)" }
            return New-CheckResult $id $type $ok $ev $must
        }
        'blocked_or_names_specifier' {
            $ok = $false
            $ev = ''
            if ($Transcript -match 'feature-specifier') {
                $ok = $true; $ev = 'Transcript names feature-specifier'
            }
            if ($Transcript -match 'blocked-need-concept') {
                $ok = $true; $ev = 'Transcript has blocked-need-concept'
            }
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern '**/what-was-implemented.md')
            foreach ($it in $items) {
                $st = Get-StatusValue (Read-TextFile $it.FullName)
                if ($st -eq 'blocked-need-concept' -or $st -eq 'blocked-need-ask') {
                    $ok = $true
                    $ev = "Write-up Status=$st"
                }
            }
            if (-not $ok) { $ev = 'Did not stop for missing spec' }
            return New-CheckResult $id $type $ok $ev $must
        }
        'findings_has_row' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                return New-CheckResult $id $type $false 'Write-up missing' $must
            }
            $text = Read-TextFile $items[0].FullName
            $ok = $false
            $in = $false
            foreach ($line in ($text -split '\r?\n')) {
                if ($line -match '^##\s*Findings\s*$') { $in = $true; continue }
                if ($in -and $line -match '^##\s') { break }
                if ($in -and $line -match '^\|' -and $line -notmatch '^\|\s*ID\s*\|' -and $line -notmatch '^\|\s*-+') {
                    $ok = $true
                    break
                }
            }
            $ev = if ($ok) { 'Findings table has a data row' } else { 'Findings table has no data row' }
            return New-CheckResult $id $type $ok $ev $must
        }
        'smell_addressed_or_reported' {
            $smellPath = Join-Path $WorkDir ($Check.smell_path -replace '/', '\')
            $fixed = $true
            if (Test-Path -LiteralPath $smellPath) {
                $src = Read-TextFile $smellPath
                $fixed = $src -notmatch $Check.smell_pattern
            }
            $reported = $false
            $writeup = Get-FirstGlobText -Root $WorkDir -Pattern $Check.writeup
            if ($writeup -and $writeup -match $Check.report_pattern) { $reported = $true }
            $ok = $fixed -or $reported
            $ev = "fixed=$fixed reported=$reported"
            return New-CheckResult $id $type $ok $ev $must
        }
        'layer_filled' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                return New-CheckResult $id $type $false 'Write-up missing' $must
            }
            $row = Get-LayerRow (Read-TextFile $items[0].FullName) $Check.layer
            if ($null -eq $row) {
                return New-CheckResult $id $type $false "No $($Check.layer) row" $must
            }
            $ok = $row.Result -match '^(pass|fail|not-run)$'
            $ev = "$($Check.layer) command='$($row.Command)' result='$($row.Result)'"
            return New-CheckResult $id $type $ok $ev $must
        }
        'layer_absent_or_not_run' {
            $items = @(Resolve-EvalGlob -Root $WorkDir -Pattern $Check.path)
            if ($items.Count -eq 0) {
                return New-CheckResult $id $type $false 'Write-up missing' $must
            }
            $row = Get-LayerRow (Read-TextFile $items[0].FullName) $Check.layer
            if ($null -eq $row) {
                return New-CheckResult $id $type $false "No $($Check.layer) row" $must
            }
            $cmd = $row.Command.ToLowerInvariant()
            $absentCmd = $cmd -match 'absent|none|n/a|no test'
            $honest = $absentCmd -or $row.Result -eq 'not-run'
            $fakePass = $row.Result -eq 'pass'
            $ok = $honest -and -not $fakePass
            $ev = "$($Check.layer) command='$($row.Command)' result='$($row.Result)'"
            return New-CheckResult $id $type $ok $ev $must
        }
        'package_no_test_script' {
            $pkgPath = Join-Path $WorkDir 'package.json'
            if (-not (Test-Path -LiteralPath $pkgPath)) {
                return New-CheckResult $id $type $true 'No package.json' $must
            }
            $pkg = (Read-TextFile $pkgPath) | ConvertFrom-Json
            $ok = $true
            $hit = $null
            if ($pkg.scripts) {
                foreach ($p in $pkg.scripts.PSObject.Properties) {
                    if ($p.Name -match '^(test|test:|e2e)') {
                        $ok = $false
                        $hit = $p.Name
                        break
                    }
                }
            }
            $ev = if ($ok) { 'No test script added' } else { "Found scripts.$hit" }
            return New-CheckResult $id $type $ok $ev $must
        }
        default {
            return New-CheckResult $id $type $false "Unknown check type $type" $must
        }
    }
}

function Write-EvalOutputs {
    param([string]$WorkDir, [string]$OutputDir)
    New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
    $copy = @('agent-engineer-skills', 'src', 'public', 'package.json', 'README.md')
    foreach ($name in $copy) {
        $src = Join-Path $WorkDir $name
        if (Test-Path -LiteralPath $src) {
            Copy-Item -LiteralPath $src -Destination (Join-Path $OutputDir $name) -Recurse -Force
        }
    }
}
