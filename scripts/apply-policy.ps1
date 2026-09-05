param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,
    [Parameter(Mandatory = $true)]
    [string[]]$PolicyIds
)

$ErrorActionPreference = "Stop"

function ConvertTo-IdList([string[]]$Values) {
    return @($Values | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$PolicyIds = ConvertTo-IdList $PolicyIds
$spec = Get-Content -Raw (Join-Path $SourceRoot "install/policies.json") | ConvertFrom-Json
$unknown = @($PolicyIds | Where-Object { $id = $_; -not ($spec.policies | Where-Object { $_.id -eq $id }) })
if ($unknown) { throw "Unknown policy: $($unknown -join ', ')" }

$grants = [System.Collections.Generic.List[string]]::new()
foreach ($id in $PolicyIds) {
    $item = $spec.policies | Where-Object { $_.id -eq $id }
    foreach ($grant in $item.grants) {
        if (-not $grants.Contains($grant)) { $grants.Add($grant) }
    }
}

$configDir = Join-Path $HOME ".skill-sets-god"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null
$config = [ordered]@{
    bundle   = $env:SKILL_SETS_BUNDLE
    policies = @($PolicyIds)
    grants   = @($grants)
}
$config | ConvertTo-Json | Set-Content -Encoding utf8 (Join-Path $configDir "config.json")

$rule = @"
---
description: Installed command-rights grants for this machine.
alwaysApply: true
---

Active policies: $($PolicyIds -join ', ')
Active grants: $($grants -join ', ')

Follow the command-rights skill and [grants.md](grants.md).

$(if ($grants -contains 'safe-commands') { '- safe-commands: classify, then run safe in-project commands. Do not ask.' })
$(if ($grants -contains 'safe-tests') { '- safe-tests: read test files; run them if they look safe. Do not ask.' })
$(if ($grants -contains 'auto-review') { '- auto-review: read the diff before commit or push. Fix problems, then continue.' })
$(if ($grants -contains 'auto-commit') { '- auto-commit: commit when the task is done. No secret files.' })
$(if ($grants -contains 'auto-push') { '- auto-push: push the current branch after a successful commit. No force push.' })

Unsafe commands still need one ask. No force-push to main/master.
"@

$rulesDir = Join-Path $HOME ".cursor/rules"
New-Item -ItemType Directory -Force -Path $rulesDir | Out-Null
Set-Content -Encoding utf8 (Join-Path $rulesDir "command-rights.mdc") $rule.Trim()
Write-Host "ok policy $($PolicyIds -join ',') grants $($grants -join ',')"
& (Join-Path $SourceRoot "scripts/emit-grant-warnings.ps1") -SourceRoot $SourceRoot -Grants @($grants)
