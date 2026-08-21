<#
.SYNOPSIS
    Measures how reliably a skill is triggered by a set of labelled prompts.

.DESCRIPTION
    Runs every query in a queries file through an agent command, several times each,
    and reports the fraction of runs in which the skill was loaded (its trigger rate).

    A should-trigger query passes when its trigger rate is above the threshold.
    A should-not-trigger query passes when its rate is below it. Keep -Runs odd so a
    rate can never land exactly on the threshold.

    The agent command is environment-specific, so you supply it. Its contract:
      1. It reads the prompt from the AES_EVAL_QUERY environment variable.
      2. It writes the agent's transcript, including which skills were loaded, to stdout.
    Detection is a plain substring match for the skill name in that output, so the
    command must print enough for the skill name to appear when it triggers.

.PARAMETER QueriesFile
    Path to a queries JSON file, for example evals/queries/feature-tester.json.

.PARAMETER AgentCommand
    Command that invokes your agent. See the contract above and the examples in
    evals/README.md.

.PARAMETER Split
    Which labelled subset to run: train, validation, or all. Optimise against train
    only; keep validation held back so you can tell improvement from overfitting.

.PARAMETER Runs
    Runs per query. Three is a reasonable starting point. Keep it odd.

.PARAMETER Threshold
    Trigger rate above which a query counts as having triggered the skill.

.PARAMETER SkillName
    Overrides the skill name. Defaults to the "skill" field in the queries file.

.PARAMETER OutFile
    Optional path to write the full results as JSON.

.EXAMPLE
    ./run-trigger-eval.ps1 -QueriesFile ./queries/feature-tester.json `
        -AgentCommand 'cursor-agent -p $env:AES_EVAL_QUERY' -Split train
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$QueriesFile,

    [Parameter(Mandatory = $true)]
    [string]$AgentCommand,

    [ValidateSet('all', 'train', 'validation')]
    [string]$Split = 'all',

    [int]$Runs = 3,

    [double]$Threshold = 0.5,

    [string]$SkillName,

    [string]$OutFile
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $QueriesFile)) {
    throw "Queries file not found: $QueriesFile"
}

$spec = Get-Content -LiteralPath $QueriesFile -Raw | ConvertFrom-Json

if (-not $SkillName) {
    $SkillName = $spec.skill
}
if (-not $SkillName) {
    throw "No skill name. Pass -SkillName, or add a 'skill' field to $QueriesFile."
}

$queries = @($spec.queries)
if ($Split -ne 'all') {
    $queries = @($queries | Where-Object { $_.split -eq $Split })
}
if ($queries.Count -eq 0) {
    throw "No queries matched split '$Split' in $QueriesFile."
}

$pattern = [regex]::Escape($SkillName)
$results = New-Object System.Collections.ArrayList

Write-Host "Skill:     $SkillName"
Write-Host "Split:     $Split ($($queries.Count) queries, $Runs runs each)"
Write-Host "Threshold: $Threshold"
Write-Host ""

$index = 0
foreach ($q in $queries) {
    $index++
    $triggers = 0

    for ($run = 1; $run -le $Runs; $run++) {
        $env:AES_EVAL_QUERY = $q.query
        $output = ''
        try {
            $output = Invoke-Expression $AgentCommand 2>&1 | Out-String
        }
        catch {
            Write-Warning "Run $run errored for query $index. Counting as no trigger. $($_.Exception.Message)"
        }
        if ($output -match $pattern) {
            $triggers++
        }
    }

    $rate = [math]::Round($triggers / $Runs, 3)
    if ($q.should_trigger) {
        $passed = $rate -gt $Threshold
    }
    else {
        $passed = $rate -lt $Threshold
    }

    if ($passed) { $mark = 'pass' } else { $mark = 'FAIL' }
    $preview = $q.query
    if ($preview.Length -gt 64) { $preview = $preview.Substring(0, 61) + '...' }
    Write-Host ("{0,-5} rate {1,-6} expect {2,-5} {3}" -f $mark, $rate, $q.should_trigger, $preview)

    [void]$results.Add([pscustomobject]@{
            query          = $q.query
            split          = $q.split
            should_trigger = [bool]$q.should_trigger
            triggers       = $triggers
            runs           = $Runs
            trigger_rate   = $rate
            passed         = $passed
        })
}

Remove-Item Env:\AES_EVAL_QUERY -ErrorAction SilentlyContinue

$passCount = @($results | Where-Object { $_.passed }).Count
$passRate = [math]::Round($passCount / $results.Count, 3)

$falseNegatives = @($results | Where-Object { $_.should_trigger -and -not $_.passed })
$falsePositives = @($results | Where-Object { -not $_.should_trigger -and -not $_.passed })

Write-Host ""
Write-Host "Pass rate:       $passCount/$($results.Count) ($passRate)"
Write-Host "Missed triggers: $($falseNegatives.Count)  (description may be too narrow)"
Write-Host "False triggers:  $($falsePositives.Count)  (description may be too broad)"

if ($OutFile) {
    $outDir = Split-Path -Parent $OutFile
    if ($outDir -and -not (Test-Path -LiteralPath $outDir)) {
        New-Item -ItemType Directory -Path $outDir -Force | Out-Null
    }
    $report = [pscustomobject]@{
        skill     = $SkillName
        split     = $Split
        runs      = $Runs
        threshold = $Threshold
        pass_rate = $passRate
        results   = $results
    }
    $report | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutFile -Encoding UTF8
    Write-Host "Wrote $OutFile"
}
