param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,
    [string]$Bundle = "basic",
    [string[]]$Skill = @()
)

$ErrorActionPreference = "Stop"

$spec = Get-Content -Raw (Join-Path $SourceRoot "install/bundles.json") | ConvertFrom-Json
$item = $spec.bundles | Where-Object { $_.id -eq $Bundle }
if (-not $item) { throw "Unknown bundle: $Bundle" }

$names = [System.Collections.Generic.List[string]]::new()
foreach ($name in @($item.skills) + @($Skill) + @("command-rights")) {
    if ($name -and -not $names.Contains($name)) { $names.Add($name) }
}

$skillsRoot = Join-Path $SourceRoot "skills"
$missing = @($names | Where-Object { -not (Test-Path (Join-Path (Join-Path $skillsRoot $_) "SKILL.md")) })
if ($missing) { throw "Unknown skill: $($missing -join ', ')" }
if (-not $names) { throw "No skills selected. Use -Bundle basic or -Skill <name>." }

foreach ($name in $names) {
    Write-Output $name
}
