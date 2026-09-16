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

    $zip = Join-Path $OutDir "$($_.Name).zip"
    if (Test-Path $zip) { Remove-Item -Force $zip }
    Compress-Archive -Path (Join-Path $dest "*") -DestinationPath $zip -Force

    $bad = Get-ChildItem $dest -Recurse -File -Force |
        Where-Object { @(".md", ".py", ".txt", ".csv") -notcontains $_.Extension.ToLowerInvariant() }
    if ($bad) {
        throw "Export still has unsupported files: $($bad.FullName -join ', ')"
    }

    Write-Host "ok export $($_.Name) -> $dest"
    Write-Host "ok zip $($_.Name) -> $zip"
}

Write-Host ""
Write-Host "Gemini web only allows .md .py .txt .csv"
Write-Host "Upload ONE skill folder OR its .zip from: $OutDir"
Write-Host "Example folder: $OutDir\clean-programming"
Write-Host "Example zip:    $OutDir\clean-programming.zip"
Write-Host "Do NOT upload skills\ from the repo root as a multi-skill parent."
