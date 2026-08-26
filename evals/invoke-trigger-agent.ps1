# Invokes cursor-agent for trigger evals. Called via run-trigger-eval.ps1 -AgentCommand.
# Reads AES_EVAL_QUERY. Uses AES_TRIGGER_WORKSPACE (required): a sandbox with all
# skills in .cursor/skills and no always-on dispatcher, so descriptions do the routing.
#
# Kills the agent after 90s so one hung query cannot stick the eval terminal.
# Do not pass cursor-agent -p as -AgentCommand: PowerShell 5.1 eats -p.
$ErrorActionPreference = 'Stop'
$query = $env:AES_EVAL_QUERY
$ws = $env:AES_TRIGGER_WORKSPACE
if (-not $query) { throw 'AES_EVAL_QUERY is empty' }
if (-not $ws) { throw 'AES_TRIGGER_WORKSPACE is empty' }

$cmd = Get-Command cursor-agent -ErrorAction Stop
$exe = $cmd.Source
if (-not $exe) { $exe = 'cursor-agent' }
$agentDir = Split-Path -Parent $exe

$node = $null
$index = $null
$directNode = Join-Path $agentDir 'node.exe'
$directIndex = Join-Path $agentDir 'index.js'
if ((Test-Path -LiteralPath $directNode) -and (Test-Path -LiteralPath $directIndex)) {
    $node = $directNode
    $index = $directIndex
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
                $node = $vNode
                $index = $vIndex
            }
        }
    }
}
if (-not $node -or -not $index) {
    throw "cursor-agent payload not found next to $exe (node.exe + index.js, or versions/)"
}

function Quote-Arg([string]$Value) {
    return '"' + ($Value -replace '"', '\"') + '"'
}

$argString = @(
    (Quote-Arg $index),
    '-p',
    '--trust',
    '--mode', 'ask',
    '--workspace', (Quote-Arg $ws),
    '--output-format', 'json',
    '--',
    (Quote-Arg $query)
) -join ' '

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $node
$psi.Arguments = $argString
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true

$proc = New-Object System.Diagnostics.Process
$proc.StartInfo = $psi
[void]$proc.Start()
$stdoutTask = $proc.StandardOutput.ReadToEndAsync()
$stderrTask = $proc.StandardError.ReadToEndAsync()
$timeoutMs = 90000
if (-not $proc.WaitForExit($timeoutMs)) {
    try { $proc.Kill() } catch { }
    Get-CimInstance Win32_Process -Filter "ParentProcessId=$($proc.Id)" -ErrorAction SilentlyContinue |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
    try { $proc.WaitForExit(5000) } catch { }
    Write-Output '{"type":"result","result":"AES_TRIGGER_TIMEOUT"}'
    exit 2
}

Write-Output ([string]$stdoutTask.Result)
Write-Output ([string]$stderrTask.Result)
exit $proc.ExitCode
