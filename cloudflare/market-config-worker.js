const CONFIG_KEY = "market-config-v1";
const MAX_CONFIG_BYTES = 512 * 1024;

function corsHeaders() {
    return {
        "access-control-allow-origin": "*",
        "access-control-allow-methods": "GET,POST,OPTIONS",
        "access-control-allow-headers": "content-type,x-admin-key",
        "cache-control": "no-store"
    };
}

function jsonResponse(data, status = 200) {
    return new Response(JSON.stringify(data, null, 2), {
        status,
        headers: {
            ...corsHeaders(),
            "content-type": "application/json; charset=utf-8"
        }
    });
}

function pickArray(data, names) {
    for (const name of names) {
        if (Array.isArray(data[name])) {
            return data[name];
        }
    }
    return [];
}

function normalizeConfig(data) {
    if (!data || typeof data !== "object" || Array.isArray(data)) {
        throw new Error("config must be a JSON object");
    }

    const listing = pickArray(data, ["listing", "Listing", "listings", "Listings", "filters", "Filters"]);
    const sniper = pickArray(data, ["sniper", "Sniper", "sniperFilters", "SniperFilters", "watchlist", "Watchlist"]);

    if (listing.length === 0 && sniper.length === 0) {
        throw new Error("config must include listing or sniper array");
    }

    return {
        version: data.version || 1,
        listing,
        sniper,
        updatedAt: new Date().toISOString()
    };
}

async function readConfig(env) {
    const raw = await env.MARKET_CONFIG.get(CONFIG_KEY);
    if (!raw) {
        return jsonResponse({
            version: 1,
            listing: [],
            sniper: [],
            empty: true
        });
    }

    return new Response(raw, {
        headers: {
            ...corsHeaders(),
            "content-type": "application/json; charset=utf-8"
        }
    });
}

async function writeConfig(request, env) {
    const adminKey = request.headers.get("x-admin-key") || "";
    if (!env.ADMIN_KEY || adminKey !== env.ADMIN_KEY) {
        return jsonResponse({ ok: false, error: "unauthorized" }, 401);
    }

    const raw = await request.text();
    if (raw.length > MAX_CONFIG_BYTES) {
        return jsonResponse({ ok: false, error: "config too large" }, 413);
    }

    let parsed;
    try {
        parsed = JSON.parse(raw);
    } catch (_) {
        return jsonResponse({ ok: false, error: "invalid json" }, 400);
    }

    let config;
    try {
        config = normalizeConfig(parsed);
    } catch (err) {
        return jsonResponse({ ok: false, error: err.message || String(err) }, 400);
    }

    await env.MARKET_CONFIG.put(CONFIG_KEY, JSON.stringify(config, null, 2));

    return jsonResponse({
        ok: true,
        listing: config.listing.length,
        sniper: config.sniper.length,
        updatedAt: config.updatedAt
    });
}

export default {
    async fetch(request, env) {
        if (request.method === "OPTIONS") {
            return new Response(null, { headers: corsHeaders() });
        }

        const url = new URL(request.url);
        if (url.pathname !== "/market-config") {
            return jsonResponse({ ok: false, error: "not found" }, 404);
        }

        if (!env.MARKET_CONFIG) {
            return jsonResponse({ ok: false, error: "missing MARKET_CONFIG KV binding" }, 500);
        }

        if (request.method === "GET") {
            return readConfig(env);
        }

        if (request.method === "POST") {
            return writeConfig(request, env);
        }

        return jsonResponse({ ok: false, error: "method not allowed" }, 405);
    }
};
