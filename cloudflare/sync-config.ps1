param(
    [string] $ListingPath = "$env:TEMP\listing_filters.json",
    [string] $SniperPath = "$env:TEMP\sniper_filters.json",
    [string] $OutPath = "$env:TEMP\nomo_market_config.json",
    [string] $Url = "https://nomo-market-config.atmincosplay.workers.dev/market-config",
    [Parameter(Mandatory = $true)]
    [string] $AdminKey
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$mergeScript = Join-Path $scriptDir "merge-local-config.ps1"
$uploadScript = Join-Path $scriptDir "upload-config.ps1"

if (-not (Test-Path -LiteralPath $mergeScript)) {
    throw "Missing merge helper: $mergeScript"
}

if (-not (Test-Path -LiteralPath $uploadScript)) {
    throw "Missing upload helper: $uploadScript"
}

Write-Host "Merging local market config..."
& $mergeScript -ListingPath $ListingPath -SniperPath $SniperPath -OutPath $OutPath

Write-Host ""
Write-Host "Uploading shared market config..."
$result = & $uploadScript -ConfigPath $OutPath -Url $Url -AdminKey $AdminKey

Write-Host ""
Write-Host "Done."
$result
