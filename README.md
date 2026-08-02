# NOMO Market

Private Roblox market script workspace.

## Files

- `NOMO MARKET SCRIPT.lua` - stable script.
- `Nomo Obsidia UI.lua` - Obsidian/full/status/noui prototype.
- `NOMO_MARKET_UI_TEST.lua` - UI test copy.

## Loader Example

```lua
getgenv().NOMO_MODE = "status" -- full, status, noui
loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()
```

## Shared Config

Shared listing/sniper config can be served from Cloudflare instead of GitHub.
See `cloudflare/README_MARKET_CONFIG.md`.

Default shared config URL:

```text
https://nomo-market-config.atmincosplay.workers.dev/market-config
```
