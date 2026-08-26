# Runs trigger evals one skill at a time. Writes JSON after each skill so
# results are on disk even if the terminal is later killed.
# Set AES_TRIGGER_TAG to suffix result files (for example final2).
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$pack = Split-Path -Parent $here
Set-Location $pack
$tag = $env:AES_TRIGGER_TAG
$logName = 'sequential.log'
if ($tag) { $logName = "sequential-$tag.log" }
$log = Join-Path $pack "evals\results\$logName"
New-Item -ItemType Directory -Force -Path (Join-Path $pack 'evals\results') | Out-Null
if (Test-Path -LiteralPath $log) { Remove-Item -LiteralPath $log -Force }

function Write-EvalLog {
    param([string]$Message)
    $line = '{0} {1}' -f (Get-Date).ToUniversalTime().ToString('o'), $Message
    Add-Content -LiteralPath $log -Value $line -Encoding UTF8
    Write-Host $line
    [Console]::Out.Flush()
}

$skills = @(
    'feature-specifier',
    'feature-bug-analyst',
    'feature-developer',
    'feature-code-reviewer',
    'feature-refactorer',
    'feature-tester',
    'mvp-specifier'
)

$code = 0
foreach ($skill in $skills) {
    Write-EvalLog "==== START $skill ===="
    & powershell -NoProfile -File (Join-Path $here 'run-one-trigger.ps1') -Skill $skill -Split all -Runs 1
    $one = $LASTEXITCODE
    if ($one -ne 0) { $code = $one }
    $tag = $env:AES_TRIGGER_TAG
    $suffix = ''
    if ($tag) { $suffix = "-$tag" }
    $json = Join-Path $pack "evals\results\$skill-all-runs1$suffix.json"
    $summary = 'no-json'
    if (Test-Path -LiteralPath $json) {
        $doc = Get-Content -LiteralPath $json -Raw | ConvertFrom-Json
        $summary = "pass_rate=$($doc.pass_rate) file=$json"
    }
    Write-EvalLog "==== END $skill exit=$one $summary ===="
}

Write-EvalLog 'ALL TRIGGER EVALS DONE'
exit $code
