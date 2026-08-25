<#
.SYNOPSIS
    Copy each canonical skills/<id>/ leaf (SKILL.md + assets, no evals) into
    Cursor and Antigravity discovery folders.

.DESCRIPTION
    Canonical source is skills/<id>/. Host copies are:
      .cursor/skills/<id>/
      .agents/skills/<id>/

    Does not copy evals/. Safe to re-run. PowerShell 5.1 compatible.
#>
[CmdletBinding()]
param(
    [string]$PackRoot = ''
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($PackRoot)) {
    $PackRoot = Split-Path -Parent $PSScriptRoot
}

$skillsRoot = Join-Path $PackRoot 'skills'
if (-not (Test-Path -LiteralPath $skillsRoot)) {
    throw "No skills directory at $skillsRoot"
}

function Copy-SkillLeaf {
    param(
        [string]$From,
        [string]$To
    )
    if (Test-Path -LiteralPath $To) {
        Remove-Item -LiteralPath $To -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $To | Out-Null
    Get-ChildItem -LiteralPath $From -Force | Where-Object { $_.Name -ne 'evals' } | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $To -Recurse -Force
    }
}

$ids = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md')
    } | ForEach-Object { $_.Name })

if ($ids.Count -lt 1) {
    throw "No skills/<id>/SKILL.md packages under $skillsRoot"
}

foreach ($id in $ids) {
    $from = Join-Path $skillsRoot $id
    Copy-SkillLeaf -From $from -To (Join-Path $PackRoot ".cursor\skills\$id")
    Copy-SkillLeaf -From $from -To (Join-Path $PackRoot ".agents\skills\$id")
}

Write-Output ("Synced {0} skill(s) to .cursor/skills and .agents/skills" -f $ids.Count)
