param(
    [string]$SourceRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$OutDir = ""
)

$ErrorActionPreference = "Stop"
if (-not $OutDir) {
    $OutDir = Join-Path $SourceRoot "dist/gemini-upload"
}

$skillsRoot = Join-Path $SourceRoot "skills"
$sync = Join-Path $SourceRoot "scripts/sync-gemini-skill.ps1"
if (Test-Path $OutDir) { Remove-Item -LiteralPath $OutDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Get-ChildItem $skillsRoot -Directory | ForEach-Object {
    if (-not (Test-Path (Join-Path $_.FullName "SKILL.md"))) { return }
    $dest = Join-Path $OutDir $_.Name
    & $sync -SourceSkillDir $_.FullName -DestSkillDir $dest
    Write-Host "ok export $($_.Name) -> $dest"
}

Write-Host ""
Write-Host "Upload ONE folder from: $OutDir"
Write-Host "Example: dist/gemini-upload/clean-programming (SKILL.md at the top of that folder)."
Write-Host "Do not upload the whole repo or the skills/ parent folder."
