param(
    [string] $ListingPath = "$env:TEMP\listing_filters.json",
    [string] $SniperPath = "$env:TEMP\sniper_filters.json",
    [string] $OutPath = "$env:TEMP\nomo_market_config.json"
)

function Read-JsonFile($path) {
    if (-not (Test-Path -LiteralPath $path)) {
        return $null
    }

    $raw = Get-Content -LiteralPath $path -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $null
    }

    return $raw | ConvertFrom-Json
}

$listingData = Read-JsonFile $ListingPath
$sniperData = Read-JsonFile $SniperPath

$listing = @()
if ($listingData -and $listingData.listing) {
    $listing = @($listingData.listing)
} elseif ($listingData -and $listingData.Filters) {
    $listing = @($listingData.Filters)
}

$sniper = @()
if ($sniperData -and $sniperData.sniper) {
    $sniper = @($sniperData.sniper)
} elseif ($sniperData -and $sniperData.Watchlist) {
    $sniper = @($sniperData.Watchlist)
}

$combined = [ordered]@{
    version = 1
    listing = $listing
    sniper = $sniper
}

$combined | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $OutPath -Encoding UTF8
Write-Host "Saved $OutPath"
Write-Host "Listing: $($listing.Count)"
Write-Host "Sniper: $($sniper.Count)"
