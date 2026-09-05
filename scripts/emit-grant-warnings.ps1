param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,
    [Parameter(Mandatory = $true)]
    [string[]]$Grants
)

$ErrorActionPreference = "Stop"
$path = Join-Path $SourceRoot "install/warnings.json"
if (-not (Test-Path $path)) { return }

$map = Get-Content -Raw $path | ConvertFrom-Json
foreach ($grant in $Grants) {
    $lines = $map.$grant
    if (-not $lines) { continue }
    Write-Host ""
    foreach ($line in $lines) {
        Write-Host $line -ForegroundColor Yellow
    }
    Write-Host ""
}
