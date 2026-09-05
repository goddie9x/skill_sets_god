param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,
    [switch]$ListOnly
)

$ErrorActionPreference = "Stop"

function Show-JsonTable([string]$Path, [string]$Key, [string]$Title) {
    $rows = (Get-Content -Raw $Path | ConvertFrom-Json).$Key
    Write-Host $Title
    foreach ($row in $rows) {
        $extra = if ($row.skills) { $row.skills -join ", " }
        elseif ($row.grants) { $row.grants -join ", " }
        else { $row.skillsDir }
        Write-Host ("  {0,-12} {1} [{2}]" -f $row.id, $row.description, $extra)
    }
}

if (-not $ListOnly) {
    Write-Host @"
Skill Sets installer

Usage:
  .\install.ps1 [-Bundle <id>] [-Policy <id>[,<id>...]] [-Skill <name>...] [-List] [-Help]
  ./install.sh [--bundle <id>] [--policy <id>[,<id>...]] [--skill <name>] [--list] [--help]

Default: -Bundle basic -Policy safe-run

Examples:
  .\install.ps1
  .\install.ps1 -Bundle basic -Policy ship
  .\install.ps1 -Policy autopilot
  .\install.ps1 -Policy safe-test
  .\install.ps1 -Bundle none -Skill clean-programming
  .\install.ps1 -List
  .\install.ps1 -Help

After the first clone:
  & "`$HOME\.skill-sets-god\install.ps1" -Bundle basic -Policy autopilot

"@
}

Show-JsonTable (Join-Path $SourceRoot "install/bundles.json") "bundles" "Bundles"
Write-Host ""
Show-JsonTable (Join-Path $SourceRoot "install/policies.json") "policies" "Policies (clusters)"
Write-Host ""
Write-Host "Skills"
Get-ChildItem (Join-Path $SourceRoot "skills") -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } |
    ForEach-Object { Write-Host "  $($_.Name)" }
Write-Host ""
Show-JsonTable (Join-Path $SourceRoot "install/targets.json") "targets" "Targets"
