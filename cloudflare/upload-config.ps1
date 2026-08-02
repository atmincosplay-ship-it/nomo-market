param(
    [Parameter(Mandatory = $true)]
    [string] $ConfigPath,

    [string] $Url = "https://nomo-market-config.atmincosplay.workers.dev/market-config",

    [Parameter(Mandatory = $true)]
    [string] $AdminKey
)

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    throw "Config file not found: $ConfigPath"
}

$body = Get-Content -LiteralPath $ConfigPath -Raw

function Invoke-NodeUpload {
    $node = Get-Command node.exe -ErrorAction SilentlyContinue
    if (-not $node) {
        $bundledNode = "C:\Users\nomoz\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe"
        if (Test-Path -LiteralPath $bundledNode) {
            $node = [pscustomobject]@{ Source = $bundledNode }
        }
    }

    if (-not $node) {
        throw "Upload failed and node.exe fallback was not found"
    }

    $jsTmp = Join-Path $env:TEMP ("nomo_market_upload_" + [guid]::NewGuid().ToString("N") + ".js")
    $js = @'
const fs = require("fs");
const [url, path, key] = process.argv.slice(2);
const body = fs.readFileSync(path, "utf8");

fetch(url, {
  method: "POST",
  headers: {
    "content-type": "application/json",
    "x-admin-key": key,
  },
  body,
}).then(async (response) => {
  const text = await response.text();
  if (!response.ok) {
    console.error(text);
    process.exit(1);
  }
  console.log(text);
}).catch((error) => {
  console.error(error && error.stack ? error.stack : String(error));
  process.exit(1);
});
'@

    try {
        Set-Content -LiteralPath $jsTmp -Value $js -Encoding UTF8
        $response = & $node.Source $jsTmp $Url $ConfigPath $AdminKey
        if ($LASTEXITCODE -ne 0) {
            throw "node upload failed with exit code $LASTEXITCODE"
        }
        $response | ConvertFrom-Json
    } finally {
        if (Test-Path -LiteralPath $jsTmp) {
            Remove-Item -LiteralPath $jsTmp -Force
        }
    }
}

try {
    Invoke-RestMethod `
        -Uri $Url `
        -Method Post `
        -ContentType "application/json" `
        -Headers @{ "x-admin-key" = $AdminKey } `
        -Body $body
} catch {
    Invoke-NodeUpload
    return

    $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
    if (-not $curl) {
        Invoke-NodeUpload
        return
    }

    $tmp = Join-Path $env:TEMP ("nomo_market_upload_" + [guid]::NewGuid().ToString("N") + ".json")
    try {
        Set-Content -LiteralPath $tmp -Value $body -Encoding UTF8
        $response = & $curl.Source -sS --ssl-no-revoke -X POST $Url `
            -H "content-type: application/json" `
            -H "x-admin-key: $AdminKey" `
            --data-binary "@$tmp"

        if ($LASTEXITCODE -ne 0) {
            $response = & $curl.Source -k -sS -X POST $Url `
                -H "content-type: application/json" `
                -H "x-admin-key: $AdminKey" `
                --data-binary "@$tmp"
        }

        if ($LASTEXITCODE -ne 0) {
            Add-Type -AssemblyName System.Net.Http
            $client = [System.Net.Http.HttpClient]::new()
            try {
                $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Post, $Url)
                $request.Headers.TryAddWithoutValidation("x-admin-key", $AdminKey) | Out-Null
                $request.Content = [System.Net.Http.StringContent]::new($body, [System.Text.Encoding]::UTF8, "application/json")
                $httpResponse = $client.SendAsync($request).GetAwaiter().GetResult()
                $responseText = $httpResponse.Content.ReadAsStringAsync().GetAwaiter().GetResult()
                if (-not $httpResponse.IsSuccessStatusCode) {
                    throw "HttpClient upload failed: $([int]$httpResponse.StatusCode) $responseText"
                }
                $responseText | ConvertFrom-Json
                return
            } catch {
                Invoke-NodeUpload
                return
            } finally {
                $client.Dispose()
            }
        }

        $response | ConvertFrom-Json
    } finally {
        if (Test-Path -LiteralPath $tmp) {
            Remove-Item -LiteralPath $tmp -Force
        }
    }
}
