$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/goddie9x/skill_sets_god.git"
$HomeClone = Join-Path $HOME ".skill-sets-god"

function Get-LocalRepoRoot {
    if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "skills"))) {
        return $PSScriptRoot
    }
    return $null
}

function Sync-HomeClone {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "git is required. Install Git, then rerun."
    }
    if (Test-Path (Join-Path $HomeClone ".git")) {
        git -C $HomeClone pull --ff-only
        if ($LASTEXITCODE -ne 0) { throw "git pull failed in $HomeClone" }
        return
    }
    if (Test-Path $HomeClone) {
        throw "$HomeClone exists and is not a git clone"
    }
    git clone $RepoUrl $HomeClone
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
}

$local = Get-LocalRepoRoot
if ($local) {
    $source = $local
    Write-Host "using local repo $source"
} else {
    Sync-HomeClone
    $source = $HomeClone
    Write-Host "using $source"
}

& (Join-Path $source "scripts/apply.ps1") -SourceRoot $source
Write-Host "done. reopen the AI tool (new chat) to load skills."
