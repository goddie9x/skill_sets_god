param(
    [Parameter(Mandatory = $true)]
    [string]$SourceSkillDir,
    [Parameter(Mandatory = $true)]
    [string]$DestSkillDir
)

$ErrorActionPreference = "Stop"
$skillMd = Join-Path $SourceSkillDir "SKILL.md"
if (-not (Test-Path $skillMd)) { throw "Missing SKILL.md in $SourceSkillDir" }

if (Test-Path $DestSkillDir) { Remove-Item -LiteralPath $DestSkillDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $DestSkillDir | Out-Null
Copy-Item -Force $skillMd (Join-Path $DestSkillDir "SKILL.md")

$refs = Join-Path $SourceSkillDir "references"
if (Test-Path $refs) {
    Copy-Item -Recurse -Force $refs (Join-Path $DestSkillDir "references")
}

foreach ($folder in @("scripts", "assets")) {
    $src = Join-Path $SourceSkillDir $folder
    if (Test-Path $src) {
        Copy-Item -Recurse -Force $src (Join-Path $DestSkillDir $folder)
    }
}
