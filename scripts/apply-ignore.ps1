param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,
    [string]$TargetPath = (Get-Location).Path,
    [switch]$SkipProject,
    [switch]$SkipGlobal
)

$ErrorActionPreference = "Stop"

$patternFile = Join-Path $SourceRoot "install/ai-ignore.patterns"
if (-not (Test-Path $patternFile)) { throw "Missing $patternFile" }

$patterns = @(
    Get-Content $patternFile |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith("#") }
)
if (-not $patterns) { throw "No patterns in $patternFile" }

$block = ((@("# BEGIN skill-sets-god") + $patterns + @("# END skill-sets-god")) -join "`n") + "`n"

function Merge-IgnoreFile([string]$File, [string]$Body) {
    $text = ""
    if (Test-Path $File) { $text = [IO.File]::ReadAllText($File) }
    $rx = [regex]"(?s)# BEGIN skill-sets-god\r?\n.*?# END skill-sets-god\r?\n"
    $normalized = $Body.Replace("`n", "`r`n")
    if ($rx.IsMatch($text)) {
        $text = $rx.Replace($text, $normalized, 1)
    } else {
        if ($text.Length -gt 0 -and -not $text.EndsWith("`n")) { $text += "`r`n" }
        if ($text.Trim().Length -gt 0) { $text += "`r`n" }
        $text += $normalized
    }
    [IO.File]::WriteAllText($File, $text)
}

function Convert-ToGlobalGlob([string]$Pattern) {
    $raw = $Pattern.Trim()
    $isDir = $raw.EndsWith("/")
    $name = $raw.TrimEnd("/")
    if ($name.StartsWith("**/")) { return $name }
    if ($isDir) { return "**/$name/**" }
    return "**/$name"
}

if (-not $SkipProject) {
    if (-not (Test-Path $TargetPath -PathType Container)) {
        throw "Not a directory: $TargetPath"
    }
    foreach ($name in @(".cursorignore", ".geminiignore", ".antigravityignore")) {
        $file = Join-Path $TargetPath $name
        Merge-IgnoreFile $file $block
        Write-Host "ok ignore $file"
    }
}

if (-not $SkipGlobal) {
    $settings = Join-Path $env:APPDATA "Cursor\User\settings.json"
    if (-not (Test-Path $settings)) {
        Write-Host "skip cursor global (no $settings)"
        return
    }
    $json = Get-Content -Raw $settings | ConvertFrom-Json
    $globs = @($patterns | ForEach-Object { Convert-ToGlobalGlob $_ })
    $key = "cursor.general.globalCursorIgnoreList"
    $existing = @()
    if ($json.PSObject.Properties.Name -contains $key) {
        $existing = @($json.$key)
    }
    foreach ($glob in $globs) {
        if ($existing -notcontains $glob) { $existing += $glob }
    }
    if ($json.PSObject.Properties.Name -contains $key) {
        $json.$key = $existing
    } else {
        $json | Add-Member -NotePropertyName $key -NotePropertyValue $existing
    }
    $json | ConvertTo-Json -Depth 30 | Set-Content -Encoding utf8 $settings
    Write-Host "ok cursor global $settings ($($globs.Count) patterns)"
}
