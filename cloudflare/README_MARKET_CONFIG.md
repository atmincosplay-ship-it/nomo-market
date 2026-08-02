# NOMO Market Shared Config

This keeps the market script on GitHub, but keeps listing/sniper prices out of the public repo.

## Shape

Use one JSON payload for every market account:

```json
{
  "version": 1,
  "listing": [],
  "sniper": []
}
```

The script accepts the current HTML/editor style keys, including `listing`, `sniper`, `Pet`, `Price`, `MaxListedPet`, `pet`, `price`, `maxKg: null`, and `priority`.

## Cloudflare Worker Setup

1. Create a Worker.
2. Create a Workers KV namespace.
3. Bind the namespace as `MARKET_CONFIG`.
4. Set a secret called `ADMIN_KEY`.
5. Deploy `market-config-worker.js`.

Example with Wrangler:

```bash
wrangler kv namespace create MARKET_CONFIG
wrangler secret put ADMIN_KEY
wrangler deploy
```

## Upload Config

Only the editor/uploader needs the admin key. Do not put the admin key inside Roblox or the market script.

One-command local sync:

```powershell
powershell -ExecutionPolicy Bypass -File .\cloudflare\sync-config.ps1 `
  -ListingPath "$env:TEMP\listing_filters.json" `
  -SniperPath "$env:TEMP\sniper_filters.json" `
  -AdminKey "YOUR_ADMIN_KEY"
```

If you still have separate `listing_filters.json` and `sniper_filters.json`, combine them first:

```powershell
powershell -ExecutionPolicy Bypass -File .\cloudflare\merge-local-config.ps1 `
  -ListingPath "$env:TEMP\listing_filters.json" `
  -SniperPath "$env:TEMP\sniper_filters.json" `
  -OutPath "$env:TEMP\nomo_market_config.json"
```

Then upload:

```bash
curl -X POST "https://YOUR-WORKER.workers.dev/market-config" \
  -H "content-type: application/json" \
  -H "x-admin-key: YOUR_ADMIN_KEY" \
  --data-binary @combined_market_config.json
```

PowerShell helper:

```powershell
powershell -ExecutionPolicy Bypass -File .\cloudflare\upload-config.ps1 `
  -ConfigPath "$env:TEMP\nomo_market_config.json" `
  -AdminKey "YOUR_ADMIN_KEY"
```

Expected response:

```json
{
  "ok": true,
  "listing": 10,
  "sniper": 20,
  "updatedAt": "2026-08-02T00:00:00.000Z"
}
```

## Read Config From Roblox

Add this before loading NOMO Market:

```lua
getgenv().NOMO_MARKET_CONFIG_URL = "https://nomo-market-config.atmincosplay.workers.dev/market-config"

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/atmincosplay-ship-it/nomo-market/main/nomo_obsidian.lua",
    true
))()
```

## Security Notes

- Public GitHub is fine for the script code.
- The Worker read URL can be read by anyone who has the URL.
- The admin key controls editing, and must never be placed in Roblox code.
- If the read URL leaks, make a new Worker route or add a read token. A read token inside Roblox still can be extracted by whoever can view the loader.
