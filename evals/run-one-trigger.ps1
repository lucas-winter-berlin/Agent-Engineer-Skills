param(
    [Parameter(Mandatory = $true)]
    [string]$Skill,
    [ValidateSet('all', 'train', 'validation')]
    [string]$Split = 'all',
    [int]$Runs = 1
)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$pack = Split-Path -Parent $here
Set-Location $pack

$ids = @(
    'feature-specifier',
    'feature-bug-analyst',
    'feature-developer',
    'feature-code-reviewer',
    'feature-refactorer',
    'feature-tester',
    'mvp-specifier'
)
if ($ids -notcontains $Skill) {
    throw "Unknown skill '$Skill'. Expected one of: $($ids -join ', ')"
}

$ws = Join-Path $pack 'evals\workspaces\_trigger-host'
New-Item -ItemType Directory -Force -Path $ws | Out-Null
$readme = Join-Path $ws 'README.md'
if (-not (Test-Path -LiteralPath $readme)) {
    Set-Content -LiteralPath $readme -Value 'Trigger-eval host. Skills in .cursor/skills. No dispatcher.'
}
foreach ($id in $ids) {
    foreach ($hostDir in @('.cursor\skills', '.agents\skills')) {
        $to = Join-Path $ws "$hostDir\$id"
        New-Item -ItemType Directory -Force -Path $to | Out-Null
        Get-ChildItem -LiteralPath (Join-Path $pack "skills\$id") -Force |
            Where-Object { $_.Name -ne 'evals' } |
            ForEach-Object {
                Copy-Item -LiteralPath $_.FullName -Destination $to -Recurse -Force
            }
    }
}
$env:AES_TRIGGER_WORKSPACE = $ws

$invoke = Join-Path $here 'invoke-trigger-agent.ps1'
$queries = Join-Path $here "queries\$Skill.json"
$tag = $env:AES_TRIGGER_TAG
$suffix = ''
if ($tag) { $suffix = "-$tag" }
$out = Join-Path $pack "evals\results\$Skill-$Split-runs$Runs$suffix.json"
New-Item -ItemType Directory -Force -Path (Join-Path $pack 'evals\results') | Out-Null
& powershell -NoProfile -File (Join-Path $here 'run-trigger-eval.ps1') `
    -QueriesFile $queries `
    -AgentCommand "powershell -NoProfile -File `"$invoke`"" `
    -Split $Split `
    -Runs $Runs `
    -OutFile $out
exit $LASTEXITCODE
