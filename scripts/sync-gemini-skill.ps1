param(
    [Parameter(Mandatory = $true)]
    [string]$SourceSkillDir,
    [Parameter(Mandatory = $true)]
    [string]$DestSkillDir
)

$ErrorActionPreference = "Stop"
$allowed = @(".md", ".py", ".txt", ".csv")
$skillMd = Join-Path $SourceSkillDir "SKILL.md"
if (-not (Test-Path $skillMd)) { throw "Missing SKILL.md in $SourceSkillDir" }

if (Test-Path $DestSkillDir) { Remove-Item -LiteralPath $DestSkillDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $DestSkillDir | Out-Null

function Copy-AllowedTree([string]$From, [string]$To) {
    New-Item -ItemType Directory -Force -Path $To | Out-Null
    Get-ChildItem $From -Force | ForEach-Object {
        if ($_.PSIsContainer) {
            Copy-AllowedTree $_.FullName (Join-Path $To $_.Name)
            return
        }
        if ($allowed -contains $_.Extension.ToLowerInvariant()) {
            Copy-Item -Force $_.FullName (Join-Path $To $_.Name)
        }
    }
}

Copy-Item -Force $skillMd (Join-Path $DestSkillDir "SKILL.md")

foreach ($folder in @("references", "scripts", "assets")) {
    $src = Join-Path $SourceSkillDir $folder
    if (Test-Path $src) {
        Copy-AllowedTree $src (Join-Path $DestSkillDir $folder)
    }
}
