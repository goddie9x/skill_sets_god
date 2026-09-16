param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,
    [string]$Bundle = "basic",
    [string[]]$Policy = @("safe-run"),
    [string[]]$Skill = @()
)

$ErrorActionPreference = "Stop"
$env:SKILL_SETS_BUNDLE = $Bundle

$names = @(
    & (Join-Path $SourceRoot "scripts/select-skills.ps1") -SourceRoot $SourceRoot -Bundle $Bundle -Skill $Skill |
        Where-Object { $_ -is [string] -and $_.Trim() }
)
$skillsRoot = Join-Path $SourceRoot "skills"
if (-not $names) { throw "No skills selected." }

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

$spec = Get-Content -Raw (Join-Path $SourceRoot "install/targets.json") | ConvertFrom-Json
foreach ($target in $spec.targets) {
    if (-not (Test-TargetActive $target)) {
        Write-Host "skip $($target.id) (tool not on this machine)"
        continue
    }
    foreach ($name in $names) {
        $src = Join-Path $skillsRoot $name
        $dest = Join-Path $HOME (Join-Path $target.skillsDir $name)
        if ($target.packMode -eq "gemini") {
            & (Join-Path $SourceRoot "scripts/sync-gemini-skill.ps1") -SourceSkillDir $src -DestSkillDir $dest
            Write-Host "ok $($target.id) $name (gemini-pack)"
        } else {
            $mode = Set-SkillLink $src $dest
            Write-Host "ok $($target.id) $name ($mode)"
        }
        $ruleSrc = Join-Path $src "RULE.template.mdc"
        if ($target.rulesDir -and (Test-Path $ruleSrc)) {
            $rulesDir = Join-Path $HOME $target.rulesDir
            New-Item -ItemType Directory -Force -Path $rulesDir | Out-Null
            Copy-Item -Force $ruleSrc (Join-Path $rulesDir "$name.mdc")
            Write-Host "ok $($target.id) rule $name"
        }
    }
}

& (Join-Path $SourceRoot "scripts/apply-policy.ps1") -SourceRoot $SourceRoot -PolicyIds $Policy
