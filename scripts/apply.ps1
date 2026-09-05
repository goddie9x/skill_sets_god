param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot
)

$ErrorActionPreference = "Stop"

$skillsRoot = Join-Path $SourceRoot "skills"
$targetsPath = Join-Path $SourceRoot "install/targets.json"
if (-not (Test-Path $skillsRoot)) { throw "No skills folder at $skillsRoot" }
if (-not (Test-Path $targetsPath)) { throw "Missing $targetsPath" }

$skills = Get-ChildItem $skillsRoot -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") }
if (-not $skills) { throw "No SKILL.md folders under $skillsRoot" }

function Test-TargetActive($target) {
    if ($target.always -eq $true) { return $true }
    foreach ($rel in $target.detect) {
        if ($rel -and (Test-Path (Join-Path $HOME $rel))) { return $true }
    }
    return $false
}

function Set-SkillLink([string]$Src, [string]$Dest) {
    $parent = Split-Path $Dest
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    if (Test-Path $Dest) { Remove-Item -LiteralPath $Dest -Recurse -Force }
    $null = cmd /c "mklink /J `"$Dest`" `"$Src`""
    if ($LASTEXITCODE -eq 0) { return "link" }
    Copy-Item -Recurse -Force $Src $Dest
    return "copy"
}

$spec = Get-Content -Raw $targetsPath | ConvertFrom-Json
foreach ($target in $spec.targets) {
    if (-not (Test-TargetActive $target)) {
        Write-Host "skip $($target.id) (tool not on this machine)"
        continue
    }

    foreach ($skill in $skills) {
        $dest = Join-Path $HOME (Join-Path $target.skillsDir $skill.Name)
        $mode = Set-SkillLink $skill.FullName $dest
        Write-Host "ok $($target.id) $($skill.Name) ($mode)"

        $ruleSrc = Join-Path $skill.FullName "RULE.template.mdc"
        if ($target.rulesDir -and (Test-Path $ruleSrc)) {
            $rulesDir = Join-Path $HOME $target.rulesDir
            New-Item -ItemType Directory -Force -Path $rulesDir | Out-Null
            Copy-Item -Force $ruleSrc (Join-Path $rulesDir "$($skill.Name).mdc")
            Write-Host "ok $($target.id) rule $($skill.Name)"
        }
    }
}
