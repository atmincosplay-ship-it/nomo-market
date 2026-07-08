--//====================================================--
--// NOMO MARKET SELLER LITE V3.0
--// Blue Rose Full UI + Exact Booth/Listings Data Core
--// Seller focused. Sniper dry-run only by default.
--//====================================================--

local VERSION = "V7.3 CONFIG COMPAT"
print("[NOMO] Booting " .. VERSION)

--//====================================================--
--// Config
--//====================================================--

getgenv().NOMO_MARKET = getgenv().NOMO_MARKET or {}

local CFG = getgenv().NOMO_MARKET

CFG.Booth = CFG.Booth or {
    AutoClaim = true,
    SmartReclaim = true,
    MaxMiddleDistance = 85,
    BoothSkin = "Auto",
    ClaimInterval = 10,
}

CFG.Seller = CFG.Seller or {
    Enabled = true,
    PreviewOnly = true,
    AutoList = false,
    ScanInterval = 0.25,
    ListCooldown = 0,
    MaxListPerMinute = 999,
    MinPetCountKeep = 0,
    SkipFavorited = true,
    SkipLocked = true,
    ListingFilterPath = "Nomo",
}

CFG.Listings = CFG.Listings or {
    RemoveCooldown = 1.2,
}

CFG.Sniper = CFG.Sniper or {
    Enabled = false,
    DryRun = true,
    ScanInterval = 0.25,
    BuyCooldown = 0,
    MaxBuyPerMinute = 999,

    -- V3.1 display/safety limits
    MaxMatchesShown = 20,      -- UI display cap
    MaxMatchesPerPet = 5,      -- prevent 70 same-pet rows
    MaxMatchesPerOwner = 0,    -- dev: disabled; per-pet cap is enough

    Watchlist = {},
}

CFG.Webhook = CFG.Webhook or {
    Enabled = false,
    Url = "",
    PetSold = true,
    SuccessfulSnipe = true,
}

CFG.Debug = CFG.Debug or false
if CFG.Booth.MaxMiddleDistance == nil or tonumber(CFG.Booth.MaxMiddleDistance) == 200 then
    CFG.Booth.MaxMiddleDistance = 85
end
CFG.Booth.ClaimInterval = CFG.Booth.ClaimInterval or 10
CFG.Booth.DataCacheSeconds = CFG.Booth.DataCacheSeconds or 0.25
CFG.Booth.ClaimVerifyAttempts = CFG.Booth.ClaimVerifyAttempts or 6
CFG.Booth.ClaimVerifyDelay = CFG.Booth.ClaimVerifyDelay or 0.35
CFG.Seller.BoothCap = 50
CFG.Seller.WeightMode = CFG.Seller.WeightMode or "Base"
CFG.Seller.ShowSkipReasons = CFG.Seller.ShowSkipReasons ~= false
CFG.Seller.RequireBoothBeforeList = CFG.Seller.RequireBoothBeforeList ~= false
CFG.Seller.ScanInterval = tonumber(CFG.Seller.ScanInterval) or 0.25
if CFG.Seller.ScanInterval > 1 then CFG.Seller.ScanInterval = 0.25 end
CFG.Seller.ListCooldown = 0
CFG.Seller.ListOnceMax = 50
CFG.Seller.AutoSmartRebuildOnStart = CFG.Seller.AutoSmartRebuildOnStart ~= false
CFG.Seller.StartupSmartRebuildDelay = CFG.Seller.StartupSmartRebuildDelay or 8
CFG.Seller.StartupSmartRebuildRetries = CFG.Seller.StartupSmartRebuildRetries or 5
CFG.Seller.StartupSmartRebuildRetryDelay = CFG.Seller.StartupSmartRebuildRetryDelay or 4
CFG.Seller.RemoteConfigEnabled = CFG.Seller.RemoteConfigEnabled ~= false
CFG.Seller.RemoteConfigSaveLocal = CFG.Seller.RemoteConfigSaveLocal ~= false
CFG.Seller.RemoteConfigURL = CFG.Seller.RemoteConfigURL or tostring((getgenv().NOMO_MARKET_CONFIG_URL or getgenv().NOMO_MARKET_FILTER_URL or ""))
CFG.Seller.RemoteConfigRefreshSeconds = CFG.Seller.RemoteConfigRefreshSeconds or 0
CFG.Seller.HighPriceWarnTokens = CFG.Seller.HighPriceWarnTokens or 1000000
CFG.Seller.VerifyAfterList = CFG.Seller.VerifyAfterList ~= false
CFG.Seller.VerifyAfterListDelay = CFG.Seller.VerifyAfterListDelay or 0.2
CFG.Seller.VerifyAfterListAttempts = CFG.Seller.VerifyAfterListAttempts or 8
CFG.Seller.PendingListCooldown = CFG.Seller.PendingListCooldown or 6
CFG.Seller.RequireExactPetName = CFG.Seller.RequireExactPetName ~= false
CFG.Seller.StrictListGuard = CFG.Seller.StrictListGuard ~= false
CFG.Seller.AdaptiveCreateWait = CFG.Seller.AdaptiveCreateWait ~= false
CFG.Seller.CreateWaitMin = math.max(5, tonumber(CFG.Seller.CreateWaitMin) or 5)
CFG.Seller.CreateWaitMax = math.max(CFG.Seller.CreateWaitMin, tonumber(CFG.Seller.CreateWaitMax) or 10)
CFG.Seller.CreateWaitBackoff = math.clamp(tonumber(CFG.Seller.CreateWaitBackoff) or 5, CFG.Seller.CreateWaitMin, CFG.Seller.CreateWaitMax)
CFG.Seller.MinPetCountKeep = 0
CFG.Seller.MaxListPerMinute = 999
CFG.Seller.MaxAutoListSession = 50
CFG.Listings.RemoveCooldown = CFG.Listings.RemoveCooldown or 1.2
CFG.Listings.RemoveAllMax = CFG.Listings.RemoveAllMax or 50
CFG.Listings.VerifyRemoveDelay = CFG.Listings.VerifyRemoveDelay or 0.45
CFG.Listings.VerifyRemoveAttempts = CFG.Listings.VerifyRemoveAttempts or 4
CFG.Sniper.RescanBeforeBuy = CFG.Sniper.RescanBeforeBuy ~= false
CFG.Sniper.SkipOwnListings = CFG.Sniper.SkipOwnListings ~= false
CFG.Sniper.RequireExactPetName = CFG.Sniper.RequireExactPetName ~= false
CFG.Sniper.AllowNoMaxPrice = CFG.Sniper.AllowNoMaxPrice == true
CFG.Sniper.MinTokensAfterBuy = CFG.Sniper.MinTokensAfterBuy or 0
CFG.Sniper.ScanInterval = tonumber(CFG.Sniper.ScanInterval) or 0.25
if CFG.Sniper.ScanInterval > 1 then CFG.Sniper.ScanInterval = 0.25 end
CFG.Sniper.BuyCooldown = 0
CFG.Sniper.WatchlistId = tostring(CFG.Sniper.WatchlistId or "1")
CFG.Sniper.WeightMode = CFG.Sniper.WeightMode or "Base"
CFG.Sniper.MaxMatchesPerOwner = 0
CFG.UI = CFG.UI or {
    CompactBoothData = true,
    FilterGameSpam = true,
}
CFG.UI.MaxDropdownRows = CFG.UI.MaxDropdownRows or 80

--//====================================================--
--// Stop old UI/loop
--//====================================================--

local STATE_KEY = "__NOMO_MARKET_V30_STATE"

local old = getgenv()[STATE_KEY]
if old and old.Stop then
    old.Stop("Reloaded")
    task.wait(0.2)
end

local CoreGui = game:GetService("CoreGui")
for _, n in ipairs({
    "NOMO_MARKET_CUSTOM_UI",
    "NOMO_MARKET_SELLER_UI",
    "NOMO_LISTING_FILTER_UI",
}) do
    local g = CoreGui:FindFirstChild(n)
    if g then g:Destroy() end
end

local State = {
    Running = true,
    CurrentTab = "Booth",
    Logs = {},
    LastSellerScanAt = 0,
    LastSniperScanAt = 0,
    LastSoldCheckAt = 0,
    LastAutoClaimAt = 0,
    LastListAt = 0,
    ListTimes = {},
    ListedThisSession = 0,
    LastBuyAt = 0,
    BuyTimes = {},
    PetList = {},
    FilterData = {Filters = {}},
    LastScan = nil,
    LastListings = {},
    LastMyListings = {},
    LastSniperMatches = {},
    BoothDataCache = nil,
    LastBoothDataAt = 0,
    PendingListUUIDs = {},
    PendingRemoveUUIDs = {},
    ManualRemoveUUIDs = {},
    KnownMyListings = {},
    KnownMyListingsReady = false,
    MissingMyListings = {},
    WebhookQueue = {},
    WebhookBusy = false,
    LastCreateWaitSignal = 0,
    CreateBlockedUntil = 0,
    NextCreateAllowedAt = 0,
    AdaptiveCreateWait = tonumber(CFG.Seller.CreateWaitBackoff) or 5,
    CreateSuccessStreak = 0,
    SelectedPetFromDropdown = false,
}

function State.Stop(reason)
    State.Running = false
    print("[NOMO V3] Stop:", reason or "manual")
end

getgenv()[STATE_KEY] = State

--//====================================================--
--// Services/modules/remotes
--//====================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local BoothRemotes = GameEvents:WaitForChild("TradeEvents"):WaitForChild("Booths")

local ClaimBooth = BoothRemotes:WaitForChild("ClaimBooth")
local CreateListing = BoothRemotes:WaitForChild("CreateListing")
local RemoveListing = BoothRemotes:WaitForChild("RemoveListing")
local BuyListing = BoothRemotes:WaitForChild("BuyListing")
local SkinEquip = GameEvents:WaitForChild("TradeBoothSkinService"):WaitForChild("Equip")
local NotificationRemote = GameEvents:FindFirstChild("Notification")

local TradeBoothsData = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("TradeBoothsData"))
local ReplicationReceiver = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ReplicationReciever"))
local BoothReceiver = ReplicationReceiver.new("Booths")

local DataService = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DataService"))

local PetUtilities
pcall(function()
    PetUtilities = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PetServices"):WaitForChild("PetUtilities"))
end)

--//====================================================--
--// Utils
--//====================================================--

local function stamp()
    local t = os.date("*t")
    return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end

local function log(...)
    local parts = {}
    for i = 1, select("#", ...) do
        table.insert(parts, tostring(select(i, ...)))
    end
    local text = stamp() .. " | " .. table.concat(parts, " ")
    print("[NOMO V3]", table.concat(parts, " "))
    table.insert(State.Logs, 1, text)
    while #State.Logs > 70 do table.remove(State.Logs) end
end

local function dlog(...)
    if CFG.Debug then log("[DEBUG]", ...) end
end

local function trim(s)
    return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function norm(s)
    s = tostring(s or ""):lower()
    s = s:gsub("%b[]", "")
    s = s:gsub("%b()", "")
    s = s:gsub("_", " ")
    s = s:gsub("%s+", " ")
    return trim(s)
end

local function toNumber(v)
    if type(v) == "number" then return v end
    if v == nil then return nil end
    local s = tostring(v):gsub(",", "."):gsub("[^%d%.%-]", "")
    return tonumber(s)
end

local function toInt(v)
    if type(v) == "number" then return math.floor(v) end
    if v == nil then return nil end
    local s = tostring(v):gsub("[^%d%-]", "")
    local n = tonumber(s)
    return n and math.floor(n) or nil
end

local function clampPrice(v)
    local n = toInt(v)
    if not n then return nil end
    if n < 1 then n = 1 end
    if n > 100000000 then n = 100000000 end
    return n
end

local function count(t)
    local n = 0
    if type(t) == "table" then for _ in pairs(t) do n += 1 end end
    return n
end

local function commaNumber(n)
    n = tonumber(n) or 0
    local s = tostring(math.floor(n))
    local left, num, right = string.match(s, "^([^%d]*%d)(%d*)(.-)$")
    if not left then return s end
    return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

local function fmtKg(n)
    n = tonumber(n)
    if not n then return "?" end
    return string.format("%.2f", n)
end

local function compactNumber(n)
    n = tonumber(n) or 0
    local abs = math.abs(n)
    if abs >= 1e12 then return string.format("%.2fT", n / 1e12):gsub("%.00", "") end
    if abs >= 1e9 then return string.format("%.2fB", n / 1e9):gsub("%.00", "") end
    if abs >= 1e6 then return string.format("%.2fM", n / 1e6):gsub("%.00", "") end
    if abs >= 1e3 then return string.format("%.1fK", n / 1e3):gsub("%.0", "") end
    return commaNumber(n)
end

local function getTokenBalance()
    local ok, data = pcall(function()
        return DataService:GetData()
    end)
    if ok and type(data) == "table" and data.TradeData and data.TradeData.Tokens ~= nil then
        return tonumber(data.TradeData.Tokens) or 0
    end
    return 0
end

local function registerCreateWait(reason)
    if not CFG.Seller.AdaptiveCreateWait then return end

    local now = os.clock()
    local minWait = tonumber(CFG.Seller.CreateWaitMin) or 5
    local maxWait = tonumber(CFG.Seller.CreateWaitMax) or 10
    local current = tonumber(State.AdaptiveCreateWait) or tonumber(CFG.Seller.CreateWaitBackoff) or 5

    current = math.clamp(current + 1, minWait, maxWait)
    State.AdaptiveCreateWait = current
    State.CreateBlockedUntil = math.max(State.CreateBlockedUntil or 0, now + current)
    State.NextCreateAllowedAt = math.max(State.NextCreateAllowedAt or 0, now + current)
    State.LastCreateWaitSignal = now
    State.CreateSuccessStreak = 0

    log("Listing server wait", tostring(reason or "signal"), "pause", string.format("%.2fs", current))
end

local function registerCreateSuccess()
    if not CFG.Seller.AdaptiveCreateWait then return end

    local now = os.clock()
    local current = math.clamp(
        tonumber(State.AdaptiveCreateWait) or tonumber(CFG.Seller.CreateWaitBackoff) or 5,
        tonumber(CFG.Seller.CreateWaitMin) or 5,
        tonumber(CFG.Seller.CreateWaitMax) or 10
    )

    State.NextCreateAllowedAt = math.max(State.NextCreateAllowedAt or 0, now + current)
    State.CreateSuccessStreak = (State.CreateSuccessStreak or 0) + 1
    if State.CreateSuccessStreak >= 3 then
        local minWait = tonumber(CFG.Seller.CreateWaitMin) or 5
        State.AdaptiveCreateWait = math.max(minWait, current - 0.25)
        State.CreateSuccessStreak = 0
    end
end

local function createWaitRemaining()
    local target = math.max(tonumber(State.CreateBlockedUntil) or 0, tonumber(State.NextCreateAllowedAt) or 0)
    local left = target - os.clock()
    if left > 0 then return left end
    return 0
end

if NotificationRemote and NotificationRemote.OnClientEvent then
    pcall(function()
        NotificationRemote.OnClientEvent:Connect(function(message)
            if type(message) ~= "string" then return end
            local text = string.lower(message)
            if text:find("please wait before trying to create another listing", 1, true) then
                registerCreateWait("game notification")
            end
        end)
    end)
end


local function installWarnFilter()
    if not CFG.UI or not CFG.UI.FilterGameSpam then return false end
    if getgenv().__NOMO_MARKET_WARN_FILTER then return true end
    if type(hookfunction) ~= "function" then return false end

    local ok, oldWarn = pcall(function()
        local original
        original = hookfunction(warn, function(...)
            local msg = ""
            for i = 1, select("#", ...) do
                msg = msg .. tostring(select(i, ...)) .. " "
            end

            if msg:find("Missing quest container id", 1, true)
                or msg:find("BeeEvent", 1, true)
                or msg:find("Eligible for Water Can Ad Services", 1, true)
                or msg:find("Eligible for Daily Deals Ad Services", 1, true)
            then
                return
            end

            return original(...)
        end)
        return original
    end)

    getgenv().__NOMO_MARKET_WARN_FILTER = ok
    return ok
end


local function ensureFolder()
    if type(makefolder) == "function" and type(isfolder) == "function" then
        if not isfolder("Nomo") then makefolder("Nomo") end
    end
end

local function readJson(path)
    if type(isfile) == "function" and type(readfile) == "function" and isfile(path) then
        local ok, raw = pcall(readfile, path)
        if ok and raw and raw ~= "" then
            local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok2 and type(data) == "table" then
                data.Filters = data.Filters or {}
                return data
            end
        end
    end
    return {Filters = {}}
end

local function saveJson(path, data)
    data.Filters = data.Filters or {}
    if type(writefile) ~= "function" then
        log("writefile unsupported")
        return false
    end
    ensureFolder()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if not ok then
        log("JSON encode failed", tostring(encoded))
        return false
    end
    writefile(path, encoded)
    return true
end

local function cleanConfigPath(path)
    path = tostring(path or ""):gsub("\\", "/"):gsub("^%s+", ""):gsub("%s+$", "")
    path = path:gsub("/+$", "")
    if path == "" then path = "Nomo" end
    return path
end

local function joinConfigPath(folder, fileName)
    folder = cleanConfigPath(folder)
    return folder .. "/" .. tostring(fileName or "")
end

local function getConfigFolder()
    local path = cleanConfigPath(CFG.Seller.ListingFilterPath or "Nomo")
    local folder = path:match("^(.*)/[^/]+%.json$")
    if folder and folder ~= "" then
        return cleanConfigPath(folder)
    end
    if path:match("%.json$") then
        return "Nomo"
    end
    return path
end

local function getFilterPath()
    local path = cleanConfigPath(CFG.Seller.ListingFilterPath or "Nomo")
    if path:match("%.json$") then
        return path
    end
    return joinConfigPath(path, "listing_filters.json")
end

State.GetSettingsPath = function()
    return joinConfigPath(getConfigFolder(), "settings.json")
end

State.LoadRuntimeSettings = function()
    local data = readJson(State.GetSettingsPath())
    if type(data.Booth) == "table" then
        if data.Booth.AutoClaim ~= nil then CFG.Booth.AutoClaim = data.Booth.AutoClaim == true end
        if data.Booth.SmartReclaim ~= nil then CFG.Booth.SmartReclaim = data.Booth.SmartReclaim == true end
    end
    if type(data.Seller) == "table" then
        if data.Seller.AutoList ~= nil then CFG.Seller.AutoList = data.Seller.AutoList == true end
        if data.Seller.PreviewOnly ~= nil then CFG.Seller.PreviewOnly = data.Seller.PreviewOnly == true end
        if type(data.Seller.ListingFilterPath) == "string" and data.Seller.ListingFilterPath ~= "" then
            CFG.Seller.ListingFilterPath = data.Seller.ListingFilterPath
        end
    end
    if type(data.Sniper) == "table" then
        if data.Sniper.Enabled ~= nil then CFG.Sniper.Enabled = data.Sniper.Enabled == true end
        if data.Sniper.DryRun ~= nil then CFG.Sniper.DryRun = data.Sniper.DryRun == true end
        if data.Sniper.RescanBeforeBuy ~= nil then CFG.Sniper.RescanBeforeBuy = data.Sniper.RescanBeforeBuy == true end
        if data.Sniper.WatchlistId ~= nil then CFG.Sniper.WatchlistId = tostring(data.Sniper.WatchlistId) end
    end
    if type(data.Webhook) == "table" then
        if data.Webhook.Enabled ~= nil then CFG.Webhook.Enabled = data.Webhook.Enabled == true end
        if type(data.Webhook.Url) == "string" then CFG.Webhook.Url = data.Webhook.Url end
        if data.Webhook.PetSold ~= nil then CFG.Webhook.PetSold = data.Webhook.PetSold == true end
        if data.Webhook.SuccessfulSnipe ~= nil then CFG.Webhook.SuccessfulSnipe = data.Webhook.SuccessfulSnipe == true end
    end
    if CFG.Seller.AutoList then
        CFG.Seller.PreviewOnly = false
    end
    return data
end

State.SaveRuntimeSettings = function()
    local data = {
        Booth = {
            AutoClaim = CFG.Booth.AutoClaim == true,
            SmartReclaim = CFG.Booth.SmartReclaim == true,
        },
        Seller = {
            AutoList = CFG.Seller.AutoList == true,
            PreviewOnly = CFG.Seller.PreviewOnly == true,
            ListingFilterPath = CFG.Seller.ListingFilterPath or "Nomo",
        },
        Sniper = {
            Enabled = CFG.Sniper.Enabled == true,
            DryRun = CFG.Sniper.DryRun == true,
            RescanBeforeBuy = CFG.Sniper.RescanBeforeBuy == true,
            WatchlistId = tostring(CFG.Sniper.WatchlistId or "1"),
        },
        Webhook = {
            Enabled = CFG.Webhook.Enabled == true,
            Url = tostring(CFG.Webhook.Url or ""),
            PetSold = CFG.Webhook.PetSold == true,
            SuccessfulSnipe = CFG.Webhook.SuccessfulSnipe == true,
        },
    }
    return saveJson(State.GetSettingsPath(), data)
end

State.LoadRuntimeSettings()

--//====================================================--
--// Pet database
--//====================================================--

local function loadGamePetList()
    local names, seen = {}, {}
    local ok, petList = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("PetRegistry"):WaitForChild("PetList"))
    end)

    if ok and type(petList) == "table" then
        for name in pairs(petList) do
            if type(name) == "string" and name ~= "" and not seen[name] then
                seen[name] = true
                table.insert(names, name)
            end
        end
    end

    table.sort(names, function(a,b) return a:lower() < b:lower() end)
    State.PetList = names
    return names
end

local function getPetList()
    if #State.PetList == 0 then loadGamePetList() end
    return State.PetList
end

local function resolveExactPetName(name)
    local target = norm(name)
    if target == "" then return nil end

    local pets = getPetList()
    if type(pets) ~= "table" or #pets == 0 then
        return tostring(name or "")
    end

    for _, petName in ipairs(pets) do
        if norm(petName) == target then
            return tostring(petName)
        end
    end

    return nil
end

local function isExactPetName(name)
    return resolveExactPetName(name) ~= nil
end

local function loadGameMutationList()
    local names, seen = {}, {}

    local function add(name)
        name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" or name == "nil" or name == "Unknown" then return end
        if not seen[name] then
            seen[name] = true
            table.insert(names, name)
        end
    end

    -- Fixed control modes first.
    add("Any")
    add("Normal")
    add("Mutated Only")

    local ok, registry = pcall(function()
        return require(
            ReplicatedStorage
                :WaitForChild("Data")
                :WaitForChild("PetRegistry")
                :WaitForChild("PetMutationRegistry")
        )
    end)

    if ok and type(registry) == "table" then
        local mutationTable = registry.PetMutationRegistry or registry.MutationRegistry or registry
        if type(mutationTable) == "table" then
            for mutName, mutData in pairs(mutationTable) do
                if type(mutName) == "string" and type(mutData) == "table" then
                    add(mutName)
                end
            end
        end
    else
        log("PetMutationRegistry load failed", tostring(registry))
        -- fallback only if API path fails
        for _, n in ipairs({"Rainbow", "Golden", "Gold", "Shiny"}) do add(n) end
    end

    table.sort(names, function(a, b)
        local rank = {
            Any = 1,
            Normal = 2,
            ["Mutated Only"] = 3,
        }
        local ra, rb = rank[a] or 99, rank[b] or 99
        if ra ~= rb then return ra < rb end
        return a:lower() < b:lower()
    end)

    State.MutationList = names
    log("PetMutationRegistry loaded", tostring(#names) .. " mutations")
    return names
end

local function getMutationList()
    if type(State.MutationList) ~= "table" or #State.MutationList == 0 then
        return loadGameMutationList()
    end
    return State.MutationList
end

--//====================================================--
--// Booth exact data core
--//====================================================--

local function fetchBoothData(force)
    local now = os.clock()
    local cacheSeconds = tonumber(CFG.Booth.DataCacheSeconds) or 0
    if not force and State.BoothDataCache and (now - (State.LastBoothDataAt or 0)) <= cacheSeconds then
        return State.BoothDataCache
    end

    local ok, data = pcall(function()
        return BoothReceiver:GetDataAsync()
    end)

    if not ok or type(data) ~= "table" then
        log("Booth GetDataAsync failed", tostring(data))
        return State.BoothDataCache
    end

    if type(data.Booths) ~= "table" or type(data.Players) ~= "table" then
        log("Bad booth data shape", type(data.Booths), type(data.Players))
        return State.BoothDataCache
    end

    State.BoothDataCache = data
    State.LastBoothDataAt = now
    getgenv().NOMO_BOOTH_DATA = data
    return data
end

local function expireMap(map)
    local now = os.clock()
    for key, untilTime in pairs(map or {}) do
        if tonumber(untilTime) and now >= untilTime then
            map[key] = nil
        end
    end
end

local function markPendingList(uuid)
    uuid = tostring(uuid or "")
    if uuid == "" then return end
    State.PendingListUUIDs[uuid] = os.clock() + (tonumber(CFG.Seller.PendingListCooldown) or 12)
end

local function clearPendingList(uuid)
    State.PendingListUUIDs[tostring(uuid or "")] = nil
end

local function markPendingRemove(listingUUID)
    listingUUID = tostring(listingUUID or "")
    if listingUUID == "" then return end
    State.PendingRemoveUUIDs[listingUUID] = os.clock() + math.max(3, (tonumber(CFG.Listings.VerifyRemoveDelay) or 0.45) * (tonumber(CFG.Listings.VerifyRemoveAttempts) or 4) + 2)
end

local function getPlayerId()
    local ok, id = pcall(function()
        return TradeBoothsData.getPlayerId(LocalPlayer)
    end)
    if ok and id ~= nil then return id end
    return LocalPlayer.UserId
end

local function getPlayerById(id)
    local ok, p = pcall(function()
        return TradeBoothsData.getPlayerById(id)
    end)
    if ok then return p end
    return nil
end

local function getBoothsFolder()
    local tw = workspace:FindFirstChild("TradeWorld")
    return tw and tw:FindFirstChild("Booths") or nil
end

local function getPos(inst)
    if not inst then return nil end
    if inst:IsA("Model") then
        local ok, cf = pcall(function() return inst:GetPivot() end)
        if ok and cf then return cf.Position end
    elseif inst:IsA("BasePart") then
        return inst.Position
    end
    return nil
end

local function center(items)
    if #items == 0 then return nil end
    local s = Vector3.new()
    for _, item in ipairs(items) do s += item.Pos end
    return s / #items
end

local function getBoothSnapshot(force)
    local data = fetchBoothData(force)
    if not data then return {} end

    local folder = getBoothsFolder()
    if not folder then return {} end

    local myId = tostring(getPlayerId())
    local items = {}

    for boothId, bd in pairs(data.Booths) do
        local id = tostring(boothId)
        local inst = folder:FindFirstChild(id)
        local pos = inst and getPos(inst)
        if pos then
            local owner = bd.Owner
            local status = "FREE"
            if owner ~= nil then
                if tostring(owner) == myId or tostring(owner) == LocalPlayer.Name then
                    status = "MINE"
                else
                    status = "TAKEN"
                end
            end
            table.insert(items, {
                Id = id,
                Instance = inst,
                Pos = pos,
                Data = bd,
                Owner = owner,
                OwnerText = owner == nil and "-" or tostring(owner),
                Status = status,
                Skin = bd.Skin or "-",
            })
        end
    end

    local c = center(items)
    for _, item in ipairs(items) do
        item.MiddleDistance = c and (Vector3.new(item.Pos.X,0,item.Pos.Z) - Vector3.new(c.X,0,c.Z)).Magnitude or 999999
    end

    table.sort(items, function(a,b)
        return (a.MiddleDistance or 999999) < (b.MiddleDistance or 999999)
    end)

    return items
end

local function findBestBooth(force)
    local maxDist = tonumber(CFG.Booth.MaxMiddleDistance) or 200
    local mine, free

    for _, item in ipairs(getBoothSnapshot(force)) do
        if (item.MiddleDistance or 999999) <= maxDist then
            if item.Status == "MINE" then
                mine = item
                break
            elseif item.Status == "FREE" and not free then
                free = item
            end
        end
    end

    return mine or free, mine and "MINE" or (free and "FREE" or "NONE")
end

local function getOwnedBoothSkins()
    local out = {}
    local seen = {}

    local ok, folder = pcall(function()
        return LocalPlayer
            :WaitForChild("PlayerGui", 5)
            :WaitForChild("ReplicatedAssets", 5)
            :WaitForChild("TradeBoothSkins", 5)
    end)

    if ok and folder then
        for _, child in ipairs(folder:GetChildren()) do
            if child and child.Name and child.Name ~= "" and not seen[child.Name] then
                seen[child.Name] = true
                table.insert(out, child.Name)
            end
        end
    end

    table.sort(out)
    return out
end

local function resolveBoothSkin()
    local wanted = tostring(CFG.Booth.BoothSkin or "Auto")
    local skins = getOwnedBoothSkins()

    if #skins > 0 then
        -- If user explicitly set a real owned skin, use it.
        if wanted ~= "" and wanted ~= "Auto" and wanted ~= "Default" then
            for _, name in ipairs(skins) do
                if name == wanted then
                    return name
                end
            end
        end

        -- Prefer Fairy when available, matching user's observed owned skin path.
        for _, name in ipairs(skins) do
            if name == "Fairy" then
                return "Fairy"
            end
        end

        -- Otherwise use first owned skin instead of Default.
        return skins[1]
    end

    return wanted ~= "" and wanted or "Default"
end

local function equipSkin()
    local skin = resolveBoothSkin()
    local ok, err = pcall(function()
        SkinEquip:FireServer(skin)
    end)
    if ok then log("Equipped skin", skin) else log("Equip skin failed", tostring(err)) end
    return ok
end

local function claimBestFreeBooth()
    local target, status = findBestBooth(true)
    if not target then
        log("No FREE/MINE booth in distance", tostring(CFG.Booth.MaxMiddleDistance))
        return false
    end

    if status == "MINE" then
        log("Already own booth", target.Id, "dist", math.floor(target.MiddleDistance or 0))
        State.LastBooth = target
        getgenv().NOMO_BOOTH_LAST_CLAIMED = target
        return true
    end

    log("Claiming FREE booth", target.Id, "dist", math.floor(target.MiddleDistance or 0))
    local ok, err = pcall(function()
        ClaimBooth:FireServer(target.Instance)
    end)
    if not ok then
        log("ClaimBooth failed", tostring(err))
        return false
    end

    task.wait(tonumber(CFG.Booth.ClaimVerifyDelay) or 0.35)
    equipSkin()

    local attempts = math.max(1, toInt(CFG.Booth.ClaimVerifyAttempts) or 6)
    for attempt = 1, attempts do
        task.wait(tonumber(CFG.Booth.ClaimVerifyDelay) or 0.35)
        for _, item in ipairs(getBoothSnapshot(true)) do
            if item.Id == target.Id then
                log("Post claim", item.Id, item.Status, "owner", item.OwnerText, "try", tostring(attempt))
                if item.Status == "MINE" then
                    State.LastBooth = item
                    getgenv().NOMO_BOOTH_LAST_CLAIMED = item
                    return true
                end
            end
        end
    end

    log("Claim not verified", target.Id)
    return false
end

local function hasOwnBooth(force)
    local target, status = findBestBooth(force)
    if status == "MINE" and target then
        State.LastBooth = target
        return true, target
    end
    return false, target
end

local function ensureBoothForListing()
    if not CFG.Seller.RequireBoothBeforeList then
        return true
    end

    local owned = hasOwnBooth(true)
    if owned then
        return true
    end

    return claimBestFreeBooth()
end

--//====================================================--
--// Listings data core
--//====================================================--

local function getAllListings(force, includePendingRemoves)
    expireMap(State.PendingRemoveUUIDs)
    expireMap(State.PendingListUUIDs)

    local data = fetchBoothData(force)
    local out = {}
    if not data then return out end

    for boothId, boothData in pairs(data.Booths) do
        local ownerId = boothData.Owner
        local pd = ownerId and data.Players[ownerId]
        if type(pd) == "table" and type(pd.Listings) == "table" and type(pd.Items) == "table" then
            for listingUUID, listing in pairs(pd.Listings) do
                listingUUID = tostring(listingUUID)
                if State.PendingRemoveUUIDs[listingUUID] and not includePendingRemoves then
                    continue
                end

                local item = pd.Items[listing.ItemId]
                if item then
                    local ownerPlayer = getPlayerById(ownerId)
                    table.insert(out, {
                        BoothId = tostring(boothId),
                        OwnerId = ownerId,
                        OwnerPlayer = ownerPlayer,
                        OwnerName = ownerPlayer and ownerPlayer.Name or tostring(ownerId),
                        ListingUUID = listingUUID,
                        ItemId = listing.ItemId,
                        ItemType = listing.ItemType,
                        Price = listing.Price,
                        Item = item,
                        PetType = item.PetType or item.Name or item.ItemName or item.SkinID or "Unknown",
                    })
                end
            end
        end
    end

    table.sort(out, function(a,b)
        return (tonumber(a.Price) or 999999999) < (tonumber(b.Price) or 999999999)
    end)

    State.LastListings = out
    return out
end

local function getMyListings(force, includePendingRemoves)
    local myId = tostring(getPlayerId())
    local out = {}
    for _, l in ipairs(getAllListings(force, includePendingRemoves)) do
        if tostring(l.OwnerId) == myId then
            table.insert(out, l)
        end
    end
    State.LastMyListings = out
    return out
end

local function findMyListingByItemAndPrice(itemId, price, force, includePendingRemoves)
    local targetId = tostring(itemId or "")
    local targetPrice = clampPrice(price)
    if targetId == "" or not targetPrice then return nil end

    for _, l in ipairs(getMyListings(force, includePendingRemoves)) do
        local listedItemId = tostring(l.ItemId or l.ItemID or l.itemId or "")
        if listedItemId == targetId and clampPrice(l.Price) == targetPrice then
            return l
        end
    end

    return nil
end

local function findMyListingByItem(itemId, force, includePendingRemoves)
    local targetId = tostring(itemId or "")
    if targetId == "" then return nil end

    for _, l in ipairs(getMyListings(force, includePendingRemoves)) do
        local listedItemId = tostring(l.ItemId or l.ItemID or l.itemId or "")
        if listedItemId == targetId then
            return l
        end
    end

    return nil
end

local function listingStillExists(listingUUID)
    listingUUID = tostring(listingUUID or "")
    if listingUUID == "" then return false end
    for _, l in ipairs(getMyListings(true, true)) do
        if tostring(l.ListingUUID) == listingUUID then
            return true
        end
    end
    return false
end

local function countMyListingsByPet()
    local counts = {}
    for _, l in ipairs(getMyListings()) do
        local key = norm(l.PetType)
        counts[key] = (counts[key] or 0) + 1
    end
    return counts
end

local function canListSession()
    local boothCap = tonumber(CFG.Seller.BoothCap) or 50
    local current = #getMyListings()
    if boothCap > 0 and current >= boothCap then
        return false, "booth full"
    end
    return true
end

local function removeListingUUID(id)
    id = trim(id)
    if id == "" then log("Remove skipped: empty id") return false end

    markPendingRemove(id)
    State.ManualRemoveUUIDs[id] = os.clock() + 45
    local ok, result = pcall(function()
        return RemoveListing:InvokeServer(id)
    end)
    if ok and result ~= false then
        local attempts = math.max(1, toInt(CFG.Listings.VerifyRemoveAttempts) or 4)
        local delay = tonumber(CFG.Listings.VerifyRemoveDelay) or 0.45

        for attempt = 1, attempts do
            task.wait(delay)
            if not listingStillExists(id) then
                State.PendingRemoveUUIDs[id] = nil
                log("RemoveListing verified", id, "try", tostring(attempt))
                return true
            end
        end

        log("RemoveListing sent, still waiting in data", id, "result", tostring(result))
        return true
    else
        State.PendingRemoveUUIDs[id] = nil
        log("RemoveListing failed", id, tostring(result))
        return false
    end
end

local function removeMyListingIndex(index)
    index = toInt(index)
    local list = getMyListings()
    local l = index and list[index]
    if not l then
        log("No my listing at index", tostring(index))
        return false
    end
    return removeListingUUID(l.ListingUUID)
end

local function removeAllMyListings(maxCount)
    maxCount = toInt(maxCount) or CFG.Listings.RemoveAllMax or 50
    local list = getMyListings()
    local done = 0

    if #list == 0 then
        log("Remove all skipped: no listings")
        return 0
    end

    log("Remove all my listings started", "count=" .. tostring(#list), "max=" .. tostring(maxCount))

    for i, l in ipairs(list) do
        if done >= maxCount then
            break
        end

        local ok = removeListingUUID(l.ListingUUID)
        if ok then
            done += 1
        end

        task.wait(tonumber(CFG.Listings.RemoveCooldown) or 1.2)
    end

    log("Remove all my listings done", done)
    return done
end

--//====================================================--
--// Seller inventory and filters
--//====================================================--

local saveFilters

local function shallowMerge(dst, srcTable)
    if type(dst) ~= "table" or type(srcTable) ~= "table" then return dst end
    for k, v in pairs(srcTable) do
        dst[k] = v
    end
    return dst
end

local function normalizeRemoteConfig(data)
    if type(data) ~= "table" then
        return nil, "not table"
    end

    local out = {}

    if type(data.Filters) == "table" then
        out.Filters = data.Filters
    elseif type(data.filters) == "table" then
        out.Filters = data.filters
    elseif type(data.ListingFilters) == "table" then
        out.Filters = data.ListingFilters
    elseif type(data[1]) == "table" then
        out.Filters = data
    else
        out.Filters = {}
    end

    if type(data.Seller) == "table" then
        out.Seller = data.Seller
    elseif type(data.seller) == "table" then
        out.Seller = data.seller
    end

    if type(data.Config) == "table" then
        out.Config = data.Config
    elseif type(data.config) == "table" then
        out.Config = data.config
    end

    return out
end

local function parseRemoteConfig(raw)
    raw = tostring(raw or "")
    raw = raw:gsub("^%s+", ""):gsub("%s+$", "")
    if raw == "" then return nil, "empty" end

    local okJson, jsonData = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if okJson and type(jsonData) == "table" then
        return normalizeRemoteConfig(jsonData)
    end

    -- Optional Lua table support for your own Pastebin config:
    -- return { Filters = {...}, Seller = {...} }
    -- or just { Filters = {...} }
    if type(loadstring) == "function" then
        local code = raw
        if not code:match("^return%s+") then
            code = "return " .. code
        end

        local fn, err = loadstring(code)
        if type(fn) == "function" then
            local okLua, luaData = pcall(fn)
            if okLua and type(luaData) == "table" then
                return normalizeRemoteConfig(luaData)
            end
        end
    end

    return nil, "parse failed"
end

local function fetchRemoteConfig()
    local url = tostring(CFG.Seller.RemoteConfigURL or "")
    if url == "" then
        return nil, "no url"
    end
    if not CFG.Seller.RemoteConfigEnabled then
        return nil, "disabled"
    end

    local ok, raw = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or type(raw) ~= "string" or raw == "" then
        return nil, "fetch failed"
    end

    local data, err = parseRemoteConfig(raw)
    if type(data) ~= "table" then
        return nil, tostring(err or "bad config")
    end

    State.LastRemoteConfigAt = os.clock()
    State.LastRemoteConfigURL = url
    return data
end

local function applyRemoteConfig(data)
    if type(data) ~= "table" then return false end

    if type(data.Seller) == "table" then
        shallowMerge(CFG.Seller, data.Seller)
        CFG.Seller.MinPetCountKeep = 0
        CFG.Seller.MaxListPerMinute = 50
        CFG.Seller.MaxAutoListSession = CFG.Seller.BoothCap or 50
    end

    if type(data.Config) == "table" then
        if type(data.Config.Seller) == "table" then
            shallowMerge(CFG.Seller, data.Config.Seller)
        end
        if type(data.Config.Listings) == "table" then
            shallowMerge(CFG.Listings, data.Config.Listings)
        end
        CFG.Seller.MinPetCountKeep = 0
        CFG.Seller.MaxListPerMinute = 50
        CFG.Seller.MaxAutoListSession = CFG.Seller.BoothCap or 50
    end

    local filters = data.Filters
    if type(filters) == "table" then
        State.FilterData = {Filters = filters}
        if CFG.Seller.RemoteConfigSaveLocal then
            saveFilters()
        end
        return true
    end

    return false
end

local function reloadFilters()
    local remoteURL = tostring(CFG.Seller.RemoteConfigURL or "")
    if CFG.Seller.RemoteConfigEnabled and remoteURL ~= "" then
        local remoteData, remoteErr = fetchRemoteConfig()
        if type(remoteData) == "table" and applyRemoteConfig(remoteData) then
            log("Remote config loaded", tostring(#(State.FilterData.Filters or {})) .. " filters")
            return State.FilterData
        else
            log("Remote config failed", tostring(remoteErr), "using local")
        end
    end

    State.FilterData = readJson(getFilterPath())
    return State.FilterData
end

State.LoadLocalFilters = function()
    State.FilterData = readJson(getFilterPath())
    return State.FilterData
end

saveFilters = function()
    return saveJson(getFilterPath(), State.FilterData)
end

local function traitWantedAny(v)
    v = norm(v or "Any")
    return v == "" or v == "---" or v == "any" or v == "all" or v == "off" or v == "none" or v == "normal"
end

local function normalizeMutationConfig(v)
    if traitWantedAny(v) then
        return "Any"
    end
    return tostring(v or "Any")
end

local function addFilter(pet, price, minW, maxW, minAge, maxAge, mutation, maxListed, variant)
    local exactPet = resolveExactPetName(pet)
    if CFG.Seller.RequireExactPetName and not exactPet then
        log("Add filter blocked", "unknown pet name:", tostring(pet), "| select from dropdown to avoid typo listing")
        return false
    end

    reloadFilters()
    State.FilterData.Filters = State.FilterData.Filters or {}
    table.insert(State.FilterData.Filters, {
        Enabled = true,
        Pet = tostring(exactPet or pet or ""),
        Price = clampPrice(price) or 1,
        MinWeight = toNumber(minW) or 0,
        MaxWeight = toNumber(maxW) or 100,
        MinLevel = toInt(minAge) or 1,
        MaxLevel = toInt(maxAge) or 100,
        Mutation = tostring(mutation or "Any"),
        Variant = tostring(variant or "Any"),
        MaxListedPet = toInt(maxListed) or 0,
    })
    local ok = saveFilters()
    log("Added filter #" .. tostring(#State.FilterData.Filters), exactPet or pet, "@" .. tostring(price), "saved=" .. tostring(ok))
    local high = tonumber(price) or 0
    if high >= (tonumber(CFG.Seller.HighPriceWarnTokens) or 1000000) and traitWantedAny(mutation) then
        log("HIGH PRICE WARNING", "Mutation is Any. Use exact Pet name for hatch types like GIANT Barn Owl / RBH.")
    end
    return ok
end

local function deleteFilter(index)
    reloadFilters()
    index = toInt(index)
    if not index or not State.FilterData.Filters[index] then
        log("Bad filter index", tostring(index))
        return false
    end
    local old = State.FilterData.Filters[index]
    table.remove(State.FilterData.Filters, index)
    local ok = saveFilters()
    log("Deleted filter #" .. tostring(index), old.Pet or "?", "saved=" .. tostring(ok))
    return ok
end

local function clearFilters()
    State.FilterData = {Filters = {}}
    local ok = saveFilters()
    log("Cleared filters saved=" .. tostring(ok))
    return ok
end

local function splitList(v)
    local out = {}
    if type(v) == "table" then
        for _, item in pairs(v) do if tostring(item) ~= "" then table.insert(out, tostring(item)) end end
    elseif type(v) == "string" then
        for item in v:gmatch("[^,|]+") do
            item = trim(item)
            if item ~= "" then table.insert(out, item) end
        end
    end
    return out
end

local function getFilters()
    reloadFilters()
    local out = {}
    for i, row in ipairs(State.FilterData.Filters or {}) do
        if type(row) == "table" and row.Enabled ~= false then
            local pet = row.Pet or row.pet or row.PetType or row.Name
            if pet and tostring(pet) ~= "" then
                local exactPet = resolveExactPetName(pet)
                if CFG.Seller.RequireExactPetName and not exactPet then
                    log("Filter skipped", "unknown pet name:", tostring(pet), "row", tostring(i))
                    continue
                end
                table.insert(out, {
                    Row = i,
                    Pet = tostring(exactPet or pet),
                    PetNorm = norm(exactPet or pet),
                    Price = clampPrice(row.Price or row.price or row.Tokens or row.tokens),
                    MinWeight = toNumber(row.MinWeight or row.minWeight or row.MinKG or row.MinBaseWeight),
                    MaxWeight = toNumber(row.MaxWeight or row.maxWeight or row.MaxKG or row.MaxBaseWeight),
                    MinLevel = toInt(row.MinLevel or row.minLevel or row.MinAge),
                    MaxLevel = toInt(row.MaxLevel or row.maxLevel or row.MaxAge),
                    Mutation = normalizeMutationConfig(row.Mutation or row.mutation or "Any"),
                    -- Hatch types like GIANT/Rainbow-hatched pets appear as different Pet names in the game API.
                    -- Keep Variant fields only for backward compatibility, but do not require them by default.
                    Variant = "Any",
                    ExcludeMutations = splitList(row.ExcludeMutations or row.ExcludedMutations or row.excludeMutations or row.excludedMutations),
                    ExcludeVariants = {},
                    MaxListedPet = toInt(row.MaxListedPet or row.maxListedPet or row.MaxListed) or 0,
                    Raw = row,
                })
            end
        end
    end
    return out
end

local function collectTextValues(v, out, depth)
    out = out or {}
    depth = depth or 0
    if depth > 2 then return out end

    if type(v) == "string" then
        v = trim(v)
        if v ~= "" and v ~= "Normal" and v ~= "None" and v ~= "Unknown" then
            out[v] = true
        end
    elseif type(v) == "table" then
        for k, val in pairs(v) do
            local key = tostring(k or "")
            if type(val) == "string" then
                collectTextValues(val, out, depth + 1)
            elseif val == true and key ~= "" then
                collectTextValues(key, out, depth + 1)
            elseif type(val) == "table" then
                collectTextValues(val, out, depth + 1)
            end
        end
    end

    return out
end

local function valuesToSortedList(map)
    local out = {}
    if type(map) == "table" then
        for v in pairs(map) do table.insert(out, tostring(v)) end
    end
    table.sort(out)
    return out
end

local function getPetTraitInfo(petData)
    local pd = petData and petData.PetData or {}

    local variant = petData and (petData.Variant or petData.HatchVariant or petData.Type or petData.PetVariant)
    variant = variant or pd.Variant or pd.HatchVariant or pd.Type or pd.PetVariant
    variant = tostring(variant or "Normal")
    if variant == "" or variant == "nil" then variant = "Normal" end

    local mutationMap = {}

    local mutationSources = {
        petData and petData.Mutation,
        petData and petData.Mutations,
        petData and petData.MutationData,
        petData and petData.AppliedMutations,
        petData and petData.ActiveMutations,
        pd.Mutation,
        pd.Mutations,
        pd.MutationData,
        pd.AppliedMutations,
        pd.ActiveMutations,
    }

    for _, src in ipairs(mutationSources) do
        collectTextValues(src, mutationMap, 0)
    end

    -- Some game data stores rainbow mutation as a boolean-like field.
    local possibleBoolKeys = {
        "Rainbow", "Gold", "Golden", "Shiny"
    }
    for _, k in ipairs(possibleBoolKeys) do
        if petData and petData[k] == true then mutationMap[k] = true end
        if pd and pd[k] == true then mutationMap[k] = true end
    end

    local mutationList = valuesToSortedList(mutationMap)
    local mutationText = (#mutationList > 0) and table.concat(mutationList, ", ") or "Normal"

    return {
        Variant = variant,
        VariantNorm = norm(variant),
        Mutations = mutationList,
        MutationText = mutationText,
    }
end

local function mutationMapFromText(mutationText, mutationList)
    local m = {}
    if type(mutationList) == "table" then
        for _, v in ipairs(mutationList) do m[norm(v)] = true end
    end
    local text = tostring(mutationText or "")
    text = text:gsub("[,/;|]+", " ")
    for word in text:gmatch("%S+") do
        local n = norm(word)
        if n ~= "" and n ~= "normal" and n ~= "none" and n ~= "unknown" then
            m[n] = true
        end
    end
    return m
end

local function filterRiskText(f)
    if type(f) ~= "table" then return "" end
    local price = tonumber(f.Price) or 0
    local highAt = tonumber(CFG.Seller.HighPriceWarnTokens) or 1000000
    if price < highAt then return "" end

    local petName = tostring(f.Pet or "")
    local mut = tostring(f.Mutation or "Any")

    if traitWantedAny(mut) then
        return "HIGH+ANY_MUT"
    end

    return "HIGH"
end

local function calculatePetWeights(petData)
    local pd = petData and petData.PetData
    if not pd then return nil, nil end

    local baseWeight = tonumber(pd.BaseWeight)
    local visualWeight = baseWeight

    if PetUtilities and type(PetUtilities.CalculateWeight) == "function" then
        local ok, w = pcall(function()
            return PetUtilities:CalculateWeight(baseWeight, pd.Level)
        end)
        if ok then visualWeight = tonumber(w) or visualWeight end
    end

    return baseWeight, visualWeight
end

local function getFilterWeight(baseWeight, visualWeight)
    if CFG.Seller.WeightMode == "Visual" then
        return visualWeight
    end
    return baseWeight
end

local function isPetFavorite(petData)
    local pd = petData and petData.PetData
    return pd and pd.IsFavorite == true
end

local function getOwnPetsFromData()
    local ok, data = pcall(function()
        return DataService:GetData()
    end)
    if not ok or type(data) ~= "table" then
        log("DataService:GetData failed", tostring(data))
        return {}
    end

    local listed = {}
    if data.TradeData and type(data.TradeData.Listings) == "table" then
        for _, l in pairs(data.TradeData.Listings) do
            if type(l) == "table" and l.ItemId then
                listed[tostring(l.ItemId)] = true
            end
        end
    end

    local out = {}
    local petInv = data.PetsData and data.PetsData.PetInventory and data.PetsData.PetInventory.Data
    if type(petInv) ~= "table" then return out end

    for uuid, petData in pairs(petInv) do
        local tradeLock = data.TradeData and data.TradeData.TradeLocks and data.TradeData.TradeLocks.Pet and data.TradeData.TradeLocks.Pet[uuid]
        local petType = petData.PetType or petData.Name or "Unknown"
        local pd = petData.PetData or {}
        local baseWeight, visualWeight = calculatePetWeights(petData)
        local traits = getPetTraitInfo(petData)
        table.insert(out, {
            UUID = tostring(uuid),
            Type = "Pet",
            Name = tostring(petType),
            NameNorm = norm(petType),
            Weight = getFilterWeight(baseWeight, visualWeight),
            BaseWeight = baseWeight,
            VisualWeight = visualWeight,
            Age = tonumber(pd.Level),
            Level = tonumber(pd.Level),
            Mutation = traits.MutationText,
            Mutations = traits.Mutations,
            Variant = traits.Variant,
            VariantNorm = traits.VariantNorm,
            Favorited = isPetFavorite(petData),
            Locked = tradeLock ~= nil,
            AlreadyListed = listed[tostring(uuid)] == true,
            Raw = petData,
        })
    end

    table.sort(out, function(a,b)
        if a.NameNorm ~= b.NameNorm then return a.NameNorm < b.NameNorm end
        return (a.Weight or 999999) < (b.Weight or 999999)
    end)

    return out
end

local function findOwnPetByUUID(uuid)
    local target = tostring(uuid or "")
    if target == "" then return nil end

    for _, pet in ipairs(getOwnPetsFromData()) do
        if tostring(pet.UUID or "") == target then
            return pet
        end
    end

    return nil
end

local function inRange(v, minV, maxV)
    if minV ~= nil and (v == nil or v < minV) then return false end
    if maxV ~= nil and (v == nil or v > maxV) then return false end
    return true
end

local function mutationAllowed(pet, f)
    local mutationMap = mutationMapFromText(pet.Mutation, pet.Mutations)

    for _, ex in ipairs(f.ExcludeMutations or {}) do
        local n = norm(ex)
        if n ~= "" and mutationMap[n] then return false end
    end

    local w = norm(f.Mutation or "Any")
    if w == "" or w == "any" or w == "all" or w == "off" then
        return true
    end

    if w == "normal" or w == "none" or w == "no mutation" or w == "clean" then
        for _ in pairs(mutationMap) do return false end
        return true
    end

    if w == "mutated only" or w == "mutated" or w == "any mutation" then
        for _ in pairs(mutationMap) do return true end
        return false
    end

    return mutationMap[w] == true
end

local function variantAllowed(pet, f)
    -- V5.3: game API treats hatch variants as separate pet names.
    -- Example: "Barn Owl" and "GIANT Barn Owl" should be filtered by Pet name,
    -- not by a Variant field. This function stays for legacy configs only.
    local raw = f and f.Raw
    if not (type(raw) == "table" and raw.LegacyVariantMatch == true) then
        return true
    end

    local have = norm(pet.Variant or "Normal")

    for _, ex in ipairs(f.ExcludeVariants or {}) do
        if have ~= "" and have == norm(ex) then return false end
    end

    local w = norm(raw.Variant or raw.variant or raw.HatchVariant or raw.hatchVariant or "Any")
    if w == "" or w == "any" or w == "all" or w == "off" then
        return true
    end

    if w == "normal" or w == "none" or w == "clean" then
        return have == "" or have == "normal" or have == "none"
    end

    return have == w
end

local function findFilter(pet, filters)
    for _, f in ipairs(filters) do
        if pet.NameNorm == f.PetNorm
            and inRange(pet.Weight, f.MinWeight, f.MaxWeight)
            and inRange(pet.Level, f.MinLevel, f.MaxLevel)
            and mutationAllowed(pet, f)
            and variantAllowed(pet, f)
        then
            return f
        end
    end
    return nil
end

local function validateListCandidate(pet, f, price)
    if not CFG.Seller.StrictListGuard then
        return true, pet
    end

    if type(pet) ~= "table" or tostring(pet.UUID or "") == "" then
        return false, nil, "missing pet uuid"
    end

    local fresh = findOwnPetByUUID(pet.UUID)
    if not fresh then
        return false, nil, "pet missing from fresh inventory"
    end

    if CFG.Seller.SkipFavorited and fresh.Favorited then
        return false, fresh, "fresh pet is favorited"
    end

    if CFG.Seller.SkipLocked and fresh.Locked then
        return false, fresh, "fresh pet is trade locked"
    end

    if fresh.AlreadyListed then
        return false, fresh, "fresh pet already listed"
    end

    if CFG.Seller.RequireExactPetName and not resolveExactPetName(fresh.Name) then
        return false, fresh, "fresh pet name not exact"
    end

    if type(f) == "table" then
        local filterPrice = clampPrice(f.Price)
        local targetPrice = clampPrice(price)
        if not targetPrice or not filterPrice or targetPrice ~= filterPrice then
            return false, fresh, "price changed before list"
        end

        local matched = findFilter(fresh, {f})
        if not matched then
            return false, fresh, "fresh pet no longer matches filter"
        end
    end

    return true, fresh
end

local function filterKey(f)
    if type(f) ~= "table" then return "?" end
    return tostring(f.Row) .. ":" .. tostring(f.Pet)
end

local function getItemTableFromListing(l)
    if type(l) ~= "table" then return {} end
    return type(l.Item) == "table" and l.Item or {}
end

local function listingToPseudoPet(l)
    local item = getItemTableFromListing(l)
    local pd = type(item.PetData) == "table" and item.PetData or item

    local baseWeight = tonumber(item.BaseWeight or item.baseWeight or item.WeightBase or pd.BaseWeight or pd.baseWeight)
    local level = tonumber(item.Level or item.Age or item.age or pd.Level or pd.Age or pd.age)
    local visualWeight = tonumber(item.DisplayWeight or item.VisualWeight or item.Weight or item.weight or pd.DisplayWeight or pd.VisualWeight or pd.Weight)

    if not visualWeight and baseWeight and PetUtilities and type(PetUtilities.CalculateWeight) == "function" then
        local ok, w = pcall(function()
            return PetUtilities:CalculateWeight(baseWeight, level)
        end)
        if ok then visualWeight = tonumber(w) or visualWeight end
    end

    local name = tostring(l.PetType or item.PetType or item.Name or item.ItemName or "Unknown")
    local traits = getPetTraitInfo({PetData = pd, Mutation = item.Mutation or item.MutationText, Mutations = item.Mutations, Variant = item.Variant or item.HatchVariant})

    return {
        UUID = tostring(l.ItemId or ""),
        Name = name,
        NameNorm = norm(name),
        Weight = getFilterWeight(baseWeight, visualWeight),
        BaseWeight = baseWeight,
        VisualWeight = visualWeight,
        Age = level,
        Level = level,
        Mutation = traits.MutationText,
        Mutations = traits.Mutations,
        Variant = traits.Variant,
        VariantNorm = traits.VariantNorm,
        Listing = l,
    }
end

State.WebhookPost = function(payload)
    if not CFG.Webhook or CFG.Webhook.Enabled ~= true then return false end
    local url = tostring(CFG.Webhook.Url or "")
    if url == "" then return false end

    table.insert(State.WebhookQueue, payload)
    if State.WebhookBusy then return true end
    State.WebhookBusy = true

    task.spawn(function()
        while #State.WebhookQueue > 0 and State.Running do
            local item = table.remove(State.WebhookQueue, 1)
            local ok, body = pcall(function()
                return HttpService:JSONEncode(item)
            end)
            if ok then
                local req = (type(request) == "function" and request)
                    or (type(http_request) == "function" and http_request)
                    or (syn and type(syn.request) == "function" and syn.request)
                    or (http and type(http.request) == "function" and http.request)
                if req then
                    local sent, err = pcall(function()
                        return req({
                            Url = url,
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = body,
                        })
                    end)
                    if not sent then log("Webhook failed", tostring(err)) end
                else
                    local sent, err = pcall(function()
                        return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
                    end)
                    if not sent then log("Webhook failed", tostring(err)) end
                end
            else
                log("Webhook JSON failed", tostring(body))
            end
            task.wait(0.4)
        end
        State.WebhookBusy = false
    end)

    return true
end

State.WebhookEmbedForListing = function(kind, l, extra)
    local pet = listingToPseudoPet(l or {})
    extra = type(extra) == "table" and extra or {}

    local titlePrefix = kind == "snipe" and "SNIPED" or "SOLD"
    local color = kind == "snipe" and 16731389 or 16766720
    local priceLabel = kind == "snipe" and "Bought For" or "Sold For"
    local userLabel = kind == "snipe" and "Seller" or "By User"
    local userValue = tostring(extra.User or l.OwnerName or "Unknown")
    if kind == "sold" then userValue = tostring(extra.User or "Unknown") end

    return {
        username = "NOMO Market",
        embeds = {{
            title = string.format("%s - %s [Age %s] [%.2f KG]", titlePrefix, tostring(pet.Name or "?"), tostring(pet.Age or "?"), tonumber(pet.VisualWeight or pet.BaseWeight) or 0),
            color = color,
            fields = {
                {name = userLabel, value = userValue, inline = false},
                {name = priceLabel, value = commaNumber(l.Price) .. " Tokens", inline = true},
                {name = "Mutation", value = tostring(pet.Mutation or "Normal"), inline = true},
                {name = "BaseWeight", value = fmtKg(pet.BaseWeight), inline = true},
                {name = "Age", value = tostring(pet.Age or "?"), inline = true},
                {name = "Token Balance", value = commaNumber(getTokenBalance()) .. " Tokens", inline = true},
                {name = "Pet Inventory", value = tostring(#getOwnPetsFromData()) .. " pets", inline = true},
                {name = "Server", value = tostring(game.PlaceId) .. ":" .. tostring(game.JobId), inline = false},
            },
            footer = {text = "NOMO " .. VERSION .. " - " .. os.date("%m/%d/%Y %I:%M %p")},
        }},
    }
end

State.SendSoldWebhook = function(l)
    if not CFG.Webhook or CFG.Webhook.Enabled ~= true or CFG.Webhook.PetSold ~= true then return false end
    return State.WebhookPost(State.WebhookEmbedForListing("sold", l, {}))
end

State.SendSnipeWebhook = function(match)
    if not CFG.Webhook or CFG.Webhook.Enabled ~= true or CFG.Webhook.SuccessfulSnipe ~= true then return false end
    if type(match) ~= "table" or type(match.Listing) ~= "table" then return false end
    return State.WebhookPost(State.WebhookEmbedForListing("snipe", match.Listing, {User = match.Listing.OwnerName}))
end

State.TrackSoldListings = function(myListings)
    local now = os.clock()
    local current = {}
    for _, l in ipairs(myListings or {}) do
        local id = tostring(l.ListingUUID or "")
        if id ~= "" then current[id] = l end
    end

    for id, expires in pairs(State.ManualRemoveUUIDs or {}) do
        if tonumber(expires) and expires < now then
            State.ManualRemoveUUIDs[id] = nil
        end
    end

    if State.KnownMyListingsReady then
        for id, oldListing in pairs(State.KnownMyListings or {}) do
            if not current[id] and not State.ManualRemoveUUIDs[id] then
                local missing = State.MissingMyListings[id]
                if missing and now - (tonumber(missing.At) or now) >= 8 then
                    State.SendSoldWebhook(missing.Listing or oldListing)
                    State.MissingMyListings[id] = nil
                    log("Webhook sold detected", tostring(oldListing.PetType), tostring(oldListing.Price), id)
                else
                    State.MissingMyListings[id] = {At = now, Listing = oldListing}
                end
            end
        end
    end

    for id in pairs(current) do
        State.MissingMyListings[id] = nil
    end

    for id, missing in pairs(State.MissingMyListings or {}) do
        if tonumber(missing.At) and now - missing.At > 45 then
            State.MissingMyListings[id] = nil
        elseif missing.Listing and not current[id] then
            current[id] = missing.Listing
        end
    end

    State.KnownMyListings = current
    State.KnownMyListingsReady = true
end

local function findFilterForListing(l, filters, requirePrice)
    local pseudo = listingToPseudoPet(l)
    local f = findFilter(pseudo, filters)
    if not f then return nil, pseudo, "no filter" end

    if requirePrice then
        local listingPrice = clampPrice(l.Price)
        local filterPrice = clampPrice(f.Price)
        if not listingPrice or not filterPrice or listingPrice ~= filterPrice then
            return nil, pseudo, "wrong price"
        end
    end

    return f, pseudo, nil
end

local function countMyGoodListingsByFilter(filters)
    filters = filters or getFilters()
    local counts = {}

    for _, l in ipairs(getMyListings()) do
        local f = findFilterForListing(l, filters, true)
        if f then
            local key = filterKey(f)
            counts[key] = (counts[key] or 0) + 1
        end
    end

    return counts
end

local function buildCandidates()
    local pets = getOwnPetsFromData()
    local filters = getFilters()
    local counts, chosenName, chosenFilter = {}, {}, {}
    local alreadyListedByFilter = countMyGoodListingsByFilter(filters)
    for _, p in ipairs(pets) do counts[p.NameNorm] = (counts[p.NameNorm] or 0) + 1 end

    local candidates, skipped = {}, {}
    for _, pet in ipairs(pets) do
        local reason, f = nil, nil
        if CFG.Seller.SkipFavorited and pet.Favorited then
            reason = "favorited"
        elseif CFG.Seller.SkipLocked and pet.Locked then
            reason = "trade locked"
        elseif pet.AlreadyListed then
            reason = "already listed"
        end

        if not reason then
            f = findFilter(pet, filters)
            if not f then reason = "no filter"
            elseif not f.Price then reason = "filter no price" end
        end

        if not reason then
            local boothCap = tonumber(CFG.Seller.BoothCap) or 50
            local currentBoothListings = #getMyListings()
            local remainingBoothSlots = math.max(0, boothCap - currentBoothListings)

            local key = filterKey(f)
            local currentListed = alreadyListedByFilter[key] or 0
            local nameChosen = chosenName[pet.NameNorm] or 0
            local filterChosen = chosenFilter[key] or 0
            local maxListed = tonumber(f.MaxListedPet) or 0

            local allowed = remainingBoothSlots
            if maxListed > 0 then
                allowed = math.min(allowed, math.max(0, maxListed - currentListed))
            end

            if remainingBoothSlots <= 0 then
                reason = "booth full"
            elseif maxListed > 0 and currentListed >= maxListed then
                reason = "filter cap reached"
            elseif nameChosen >= allowed then
                reason = "filter / booth cap"
            elseif filterChosen >= allowed then
                reason = "filter / booth cap"
            else
                chosenName[pet.NameNorm] = nameChosen + 1
                chosenFilter[key] = filterChosen + 1
                table.insert(candidates, {Pet = pet, Filter = f, TotalOwned = counts[pet.NameNorm] or 0, Allowed = allowed})
            end
        end

        if reason then table.insert(skipped, {Pet = pet, Reason = reason}) end
    end

    local scan = {Pets = pets, Filters = filters, Candidates = candidates, Skipped = skipped}
    State.LastScan = scan
    return scan
end

local function cleanupTimes(arr)
    local fresh = {}
    local now = os.clock()
    for _, t in ipairs(arr) do
        if now - t <= 60 then table.insert(fresh, t) end
    end
    return fresh
end

local function canListNow()
    State.ListTimes = cleanupTimes(State.ListTimes)
    if #State.ListTimes >= (tonumber(CFG.Seller.MaxListPerMinute) or 6) then return false, "max/min" end
    local serverWait = createWaitRemaining()
    if serverWait > 0 then
        return false, "server wait " .. string.format("%.2fs", serverWait)
    end
    if os.clock() - (State.LastListAt or 0) < (tonumber(CFG.Seller.ListCooldown) or 0) then return false, "cooldown" end
    return true
end

local function verifyListingAfterList(pet, price, f)
    if not CFG.Seller.VerifyAfterList then
        return true, "verify off"
    end

    local targetId = tostring(pet and pet.UUID or "")
    local targetPrice = clampPrice(price)
    local attempts = math.max(1, toInt(CFG.Seller.VerifyAfterListAttempts) or 4)
    local delay = tonumber(CFG.Seller.VerifyAfterListDelay) or 0.75

    for attempt = 1, attempts do
        task.wait(delay)
        local listing = findMyListingByItemAndPrice(targetId, targetPrice, true, true)
        if listing then
            if type(f) == "table" then
                local matched = findFilterForListing(listing, {f}, true)
                if not matched then
                    log("UNSAFE listing verified mismatch, removing", tostring(listing.PetType), "price", tostring(listing.Price), "uuid", tostring(listing.ListingUUID))
                    removeListingUUID(listing.ListingUUID)
                    clearPendingList(targetId)
                    return false, "verified listing failed exact filter check"
                end
            end
            clearPendingList(targetId)
            return true, listing
        end

        local wrongPrice = findMyListingByItem(targetId, true, true)
        if wrongPrice then
            log("UNSAFE listing wrong price, removing", tostring(wrongPrice.PetType), "expected", tostring(targetPrice), "got", tostring(wrongPrice.Price), "uuid", tostring(wrongPrice.ListingUUID))
            removeListingUUID(wrongPrice.ListingUUID)
            clearPendingList(targetId)
            return false, "listed at wrong price"
        end
    end

    return false, "not found in booth data"
end

local function listPet(pet, price, boothReady, f)
    if not pet or not pet.UUID then
        return false, "missing pet uuid"
    end

    local petUUID = tostring(pet.UUID)
    local guardOk, freshPet, guardWhy = validateListCandidate(pet, f, price)
    if not guardOk then
        log("Listing blocked by safety", tostring(pet.Name or petUUID), tostring(guardWhy))
        return false, guardWhy
    end
    pet = freshPet or pet

    expireMap(State.PendingListUUIDs)
    if State.PendingListUUIDs[petUUID] then
        log("Listing blocked", tostring(pet.Name or petUUID), "already pending")
        return false, "pending"
    end

    if findMyListingByItemAndPrice(petUUID, price, true, true) then
        log("Listing skipped", tostring(pet.Name or petUUID), "already listed at price", tostring(price))
        return false, "already listed"
    end

    local sessionOk, sessionWhy = canListSession()
    if not sessionOk then
        log("Listing blocked", sessionWhy)
        return false, sessionWhy
    end

    if CFG.Seller.RequireBoothBeforeList and not boothReady and not ensureBoothForListing() then
        return false, "no booth"
    end

    markPendingList(petUUID)
    local ok, result = pcall(function()
        return CreateListing:InvokeServer("Pet", petUUID, clampPrice(price))
    end)
    if ok and result ~= false then
        State.LastListAt = os.clock()
        State.ListedThisSession = (State.ListedThisSession or 0) + 1
        table.insert(State.ListTimes, os.clock())

        local verified, verifyInfo = verifyListingAfterList(pet, price, f)
        if verified then
            registerCreateSuccess()
            log("Listed OK + verified", pet.Name, "price", tostring(price), "session", tostring(State.ListedThisSession))
            return true
        else
            log("Listed sent but NOT verified", pet.Name, "price", tostring(price), tostring(verifyInfo))
            return true
        end
    end

    if ok and result == false and (os.clock() - (tonumber(State.LastCreateWaitSignal) or 0)) < 1.5 then
        registerCreateWait("CreateListing returned false")
        clearPendingList(petUUID)
        return false, "server wait"
    end

    clearPendingList(petUUID)
    log("Listing failed", pet.Name, tostring(result))
    return false, result
end

local function autoList(scan)
    if CFG.Seller.PreviewOnly or not CFG.Seller.AutoList then return end
    local boothReady = ensureBoothForListing()
    if not boothReady then
        log("AutoList blocked", "no booth")
        return
    end

    scan = scan or buildCandidates()
    local i = 1
    while i <= #scan.Candidates do
        local c = scan.Candidates[i]
        local serverWait = createWaitRemaining()
        if serverWait > 0 then
            task.wait(math.min(serverWait, 1))
            continue
        end

        local can, why = canListNow()
        if not can then dlog("list wait", why) break end
        local ok, whyList = listPet(c.Pet, c.Filter.Price, true, c.Filter)
        if ok then
            i += 1
        elseif whyList == "server wait" then
            task.wait(math.min(math.max(createWaitRemaining(), 0.15), 1))
        else
            i += 1
        end

        local waitTime = tonumber(CFG.Seller.ListCooldown) or 0
        if waitTime > 0 then task.wait(waitTime) else task.wait() end
    end
end

local function listOnce(maxCount)
    maxCount = toInt(maxCount) or CFG.Seller.ListOnceMax or 50
    local boothReady = ensureBoothForListing()
    if not boothReady then
        log("List until booth full blocked", "no booth")
        return 0
    end

    local scan = buildCandidates()
    local done = 0

    log("List until booth full started", "max=" .. tostring(maxCount), "candidates=" .. tostring(#scan.Candidates))

    local i = 1
    while i <= #scan.Candidates do
        local c = scan.Candidates[i]
        if done >= maxCount then break end

        local serverWait = createWaitRemaining()
        if serverWait > 0 then
            task.wait(math.min(serverWait, 1))
            continue
        end

        local can, why = canListNow()
        if not can then
            log("List Once paused", tostring(why))
            break
        end

        local ok, whyList = listPet(c.Pet, c.Filter.Price, true, c.Filter)
        if ok then
            done += 1
            i += 1
        elseif whyList == "server wait" then
            task.wait(math.min(math.max(createWaitRemaining(), 0.15), 1))
        else
            i += 1
        end

        local waitTime = tonumber(CFG.Seller.ListCooldown) or 0
        if waitTime > 0 then task.wait(waitTime) else task.wait() end
    end

    log("List until booth full done", done)
    return done
end

local function rebuildBooth()
    local restoreAutoList = CFG.Seller.AutoList == true
    if restoreAutoList then
        CFG.Seller.AutoList = false
        log("Rebuild Booth paused Auto List")
    end

    log("Rebuild Booth started", "remove old listings first")
    removeAllMyListings(CFG.Listings.RemoveAllMax or 50)

    task.wait(1)

    local maxCount = tonumber(CFG.Seller.BoothCap) or 50
    log("Rebuild Booth listing", "max=" .. tostring(maxCount))
    local done = listOnce(maxCount)

    log("Rebuild Booth done", "listed=" .. tostring(done), "booth=" .. tostring(#getMyListings()) .. "/" .. tostring(CFG.Seller.BoothCap or 50))
    if restoreAutoList then
        CFG.Seller.AutoList = true
        State.LastSellerScanAt = os.clock()
        log("Rebuild Booth restored Auto List")
    end
    return done
end

local function smartRebuildBooth()
    local restoreAutoList = CFG.Seller.AutoList == true
    if restoreAutoList then
        CFG.Seller.AutoList = false
        log("Smart Rebuild paused Auto List")
    end

    local filters = getFilters()
    local my = getMyListings()
    local keepCounts = {}
    local removeList = {}
    local kept = 0

    log("Smart Rebuild started", "my=" .. tostring(#my), "filters=" .. tostring(#filters))

    for _, l in ipairs(my) do
        local f, pseudo, why = findFilterForListing(l, filters, true)
        local removeReason = why

        if f then
            local key = filterKey(f)
            local cap = tonumber(f.MaxListedPet) or 0
            local current = keepCounts[key] or 0

            if cap > 0 and current >= cap then
                removeReason = "over filter cap"
            else
                keepCounts[key] = current + 1
                kept += 1
                removeReason = nil
            end
        end

        if removeReason then
            table.insert(removeList, {
                Listing = l,
                Reason = removeReason,
            })
        end
    end

    log("Smart Rebuild keep/remove", "keep=" .. tostring(kept), "remove=" .. tostring(#removeList))

    local removed = 0
    for _, r in ipairs(removeList) do
        local l = r.Listing
        log("Smart remove", tostring(l.PetType), "price", tostring(l.Price), "|", tostring(r.Reason))
        if removeListingUUID(l.ListingUUID) then
            removed += 1
        end
        task.wait(tonumber(CFG.Listings.RemoveCooldown) or 1.2)
    end

    if removed > 0 then
        task.wait(1)
    end

    local boothCap = tonumber(CFG.Seller.BoothCap) or 50
    local current = #getMyListings()
    local missing = math.max(0, boothCap - current)
    local listed = 0

    if missing > 0 then
        log("Smart Rebuild fill missing", tostring(missing), "slots")
        listed = listOnce(missing)
    else
        log("Smart Rebuild booth already full/capped")
    end

    log("Smart Rebuild done", "kept=" .. tostring(kept), "removed=" .. tostring(removed), "listed=" .. tostring(listed), "booth=" .. tostring(#getMyListings()) .. "/" .. tostring(boothCap))
    if restoreAutoList then
        CFG.Seller.AutoList = true
        State.LastSellerScanAt = os.clock()
        log("Smart Rebuild restored Auto List")
    end
    return {
        Kept = kept,
        Removed = removed,
        Listed = listed,
        Booth = #getMyListings(),
    }
end

--//====================================================--
--// Sniper data-table dry run
--//====================================================--

local function addWatch(pet, maxPrice)
    local exactPet = resolveExactPetName(pet)
    if CFG.Sniper.RequireExactPetName and not exactPet then
        log("Sniper watch blocked", "unknown pet name:", tostring(pet), "| select from dropdown")
        return false
    end

    local price = clampPrice(maxPrice)
    if (not price or price <= 0) and not CFG.Sniper.AllowNoMaxPrice then
        log("Sniper watch blocked", "max price required for safety")
        return false
    end

    CFG.Sniper.Watchlist = CFG.Sniper.Watchlist or {}
    CFG.Sniper.Watchlist[tostring(exactPet or pet)] = {
        MaxPrice = price or 0,
        MinWeight = toNumber(CFG.Sniper.MinWeight) or 0,
        MaxWeight = toNumber(CFG.Sniper.MaxWeight),
        WeightMode = CFG.Sniper.WeightMode or "Base",
        MaxMatchesPerPet = toInt(CFG.Sniper.MaxMatchesPerPet) or 5,
    }
    local ok = State.SaveSniperWatchlist()
    log("Added sniper watch", tostring(exactPet or pet), "max", tostring(price or 0), "saved=" .. tostring(ok))
    return true
end

local function clearWatch()
    CFG.Sniper.Watchlist = {}
    local ok = State.SaveSniperWatchlist()
    log("Cleared sniper watchlist", "saved=" .. tostring(ok))
end

local function getSniperFilterPath()
    return joinConfigPath(getConfigFolder(), "sniper_filters.json")
end

State.SaveSniperWatchlist = function()
    local id = tostring(CFG.Sniper.WatchlistId or "1")
    local data = readJson(getSniperFilterPath())
    data.Watchlists = type(data.Watchlists) == "table" and data.Watchlists or {}
    data.Watchlists[id] = CFG.Sniper.Watchlist or {}
    return saveJson(getSniperFilterPath(), data)
end

local function extractSniperWatchSource(data)
    if type(data) ~= "table" then
        return nil
    end

    local watchlists = data.Watchlists or data.watchlists
    if type(watchlists) == "table" then
        local id = tostring(CFG.Sniper.WatchlistId or "1")
        if type(watchlists[id]) == "table" then
            return watchlists[id]
        end
        if type(watchlists[tonumber(id)]) == "table" then
            return watchlists[tonumber(id)]
        end
    end

    if type(data.Watchlist) == "table" then
        return data.Watchlist
    end
    if type(data.watchlist) == "table" then
        return data.watchlist
    end
    if type(data.Sniper) == "table" and type(data.Sniper.Watchlist) == "table" then
        return data.Sniper.Watchlist
    end

    return nil
end

local function importSniperWatchlist(path)
    path = tostring(path or getSniperFilterPath())
    local data = readJson(path)
    local source = extractSniperWatchSource(data)
    if type(source) ~= "table" then
        log("Sniper config import failed", "no Watchlists[" .. tostring(CFG.Sniper.WatchlistId or "1") .. "]", path)
        return false
    end

    local imported, skipped = 0, 0
    local nextWatch = {}

    local function addImportedWatch(name, cfg)
        name = tostring(name or "")
        if name == "" then
            skipped += 1
            return
        end

        local exactPet = resolveExactPetName(name)
        if CFG.Sniper.RequireExactPetName and not exactPet then
            skipped += 1
            log("Sniper config skipped", "unknown pet:", name)
            return
        end

        local maxPrice = cfg
        if type(cfg) == "table" then
            maxPrice = cfg.MaxPrice or cfg.maxPrice or cfg.Price or cfg.price
        end

        local price = clampPrice(maxPrice)
        if (not price or price <= 0) and not CFG.Sniper.AllowNoMaxPrice then
            skipped += 1
            log("Sniper config skipped", tostring(exactPet or name), "bad max price")
            return
        end

        local minWeight, maxWeight, weightMode
        if type(cfg) == "table" then
            minWeight = toNumber(cfg.MinWeight or cfg.minWeight or cfg.MinKG or cfg.minKG)
            maxWeight = toNumber(cfg.MaxWeight or cfg.maxWeight or cfg.MaxKG or cfg.maxKG)
            weightMode = tostring(cfg.WeightMode or cfg.weightMode or CFG.Sniper.WeightMode or "Base")
        end
        weightMode = weightMode:gsub("%s+", "")
        if weightMode == "BaseWeight" or weightMode == "BaseKG" then weightMode = "Base" end
        if weightMode == "VisualWeight" or weightMode == "DisplayWeight" or weightMode == "VisualKG" then weightMode = "Visual" end
        if weightMode ~= "Visual" then weightMode = "Base" end

        nextWatch[tostring(exactPet or name)] = {
            MaxPrice = price or 0,
            MinWeight = minWeight or 0,
            MaxWeight = maxWeight,
            WeightMode = weightMode,
            MaxMatchesPerPet = type(cfg) == "table" and (toInt(cfg.MaxMatchesPerPet or cfg.maxMatchesPerPet or cfg.PerPet or cfg.perPet) or 5) or 5,
            Priority = type(cfg) == "table" and toInt(cfg.Priority or cfg.priority) or nil,
        }
        imported += 1
    end

    for key, cfg in pairs(source) do
        if type(key) == "number" and type(cfg) == "table" then
            addImportedWatch(cfg.Pet or cfg.pet or cfg.Name or cfg.name, cfg)
        else
            addImportedWatch(key, cfg)
        end
    end

    CFG.Sniper.Watchlist = nextWatch
    State.SaveSniperWatchlist()
    log("Sniper config imported", tostring(imported), "watch(es)", "skipped", tostring(skipped), path)
    return true
end

State.ReloadSniperConfig = function()
    CFG.Sniper.WatchlistId = tostring(CFG.Sniper.WatchlistId or "1")
    return importSniperWatchlist(getSniperFilterPath())
end

local function removeWatch(name)
    CFG.Sniper.Watchlist = CFG.Sniper.Watchlist or {}
    local target = norm(name)
    for watchName in pairs(CFG.Sniper.Watchlist) do
        if norm(watchName) == target then
            CFG.Sniper.Watchlist[watchName] = nil
            local ok = State.SaveSniperWatchlist()
            log("Removed sniper watch", tostring(watchName), "saved=" .. tostring(ok))
            return true
        end
    end
    log("Sniper watch not found", tostring(name))
    return false
end

local validateSniperMatch

local function normalizeSniperWeightMode(mode)
    mode = tostring(mode or CFG.Sniper.WeightMode or "Base"):gsub("%s+", "")
    if mode == "BaseWeight" or mode == "BaseKG" then return "Base" end
    if mode == "VisualWeight" or mode == "DisplayWeight" or mode == "VisualKG" then return "Visual" end
    if mode == "Visual" then return "Visual" end
    return "Base"
end

local function formatSniperMax(price)
    price = tonumber(price) or 0
    if price <= 0 then
        return "Any"
    end
    return tostring(price)
end

State.FormatSniperKgRange = function(mode, minKg, maxKg)
    local upper = tonumber(maxKg)
    return tostring(mode or "Base") .. " KG " .. tostring(tonumber(minKg) or 0) .. "-" .. (upper and tostring(upper) or "unli")
end

State.GetSortedSniperWatches = function()
    local out = {}
    for name, cfg in pairs(CFG.Sniper.Watchlist or {}) do
        table.insert(out, {Name = tostring(name), Config = cfg})
    end
    table.sort(out, function(a, b)
        return a.Name:lower() < b.Name:lower()
    end)
    return out
end

local function getSniperWeightForListing(l, watch)
    local pseudo = listingToPseudoPet(l)
    local mode = normalizeSniperWeightMode(type(watch) == "table" and watch.WeightMode or CFG.Sniper.WeightMode)
    if mode == "Visual" then
        return pseudo.VisualWeight or pseudo.BaseWeight, pseudo, mode
    end
    return pseudo.BaseWeight or pseudo.VisualWeight, pseudo, mode
end

local function snipeDryRun(force)
    local myId = tostring(getPlayerId())
    local watchNorm = {}

    for name, cfg in pairs(CFG.Sniper.Watchlist or {}) do
        watchNorm[norm(name)] = {
            Name = name,
            MaxPrice = tonumber(type(cfg) == "table" and cfg.MaxPrice or cfg) or 0,
            MinWeight = type(cfg) == "table" and toNumber(cfg.MinWeight or cfg.minWeight) or 0,
            MaxWeight = type(cfg) == "table" and toNumber(cfg.MaxWeight or cfg.maxWeight) or nil,
            WeightMode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode or cfg.weightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode),
            MaxMatchesPerPet = type(cfg) == "table" and (toInt(cfg.MaxMatchesPerPet or cfg.maxMatchesPerPet or cfg.PerPet or cfg.perPet) or toInt(CFG.Sniper.MaxMatchesPerPet) or 5) or (toInt(CFG.Sniper.MaxMatchesPerPet) or 5),
        }
    end

    local raw = {}

    for _, l in ipairs(getAllListings(force)) do
        local isOwnListing = tostring(l.OwnerId) == myId
        if (not CFG.Sniper.SkipOwnListings or not isOwnListing) and tostring(l.ItemType) == "Pet" then
            local w = watchNorm[norm(l.PetType)]

            if w then
                local price = tonumber(l.Price) or 999999999

                if w.MaxPrice <= 0 or price <= w.MaxPrice then
                    local match = {
                        Listing = l,
                        Watch = w,
                    }
                    local safe, why = validateSniperMatch and validateSniperMatch(match)
                    if safe then
                        table.insert(raw, match)
                    else
                        dlog("sniper scan skipped", tostring(l.PetType), tostring(why))
                    end
                end
            end
        end
    end

    table.sort(raw, function(a, b)
        local ap = tonumber(a.Listing.Price) or 999999999
        local bp = tonumber(b.Listing.Price) or 999999999

        if ap ~= bp then
            return ap < bp
        end

        local an = tostring(a.Listing.PetType)
        local bn = tostring(b.Listing.PetType)

        if an ~= bn then
            return an < bn
        end

        return tostring(a.Listing.ListingUUID) < tostring(b.Listing.ListingUUID)
    end)

    local maxShown = tonumber(CFG.Sniper.MaxMatchesShown) or 20
    local petCounts = {}
    local filtered = {}

    for _, m in ipairs(raw) do
        local petKey = norm(m.Listing.PetType)
        local maxPerPet = tonumber(m.Watch and m.Watch.MaxMatchesPerPet) or tonumber(CFG.Sniper.MaxMatchesPerPet) or 5

        petCounts[petKey] = petCounts[petKey] or 0

        local petOk = maxPerPet <= 0 or petCounts[petKey] < maxPerPet

        if petOk then
            table.insert(filtered, m)
            petCounts[petKey] += 1
        end

        if maxShown > 0 and #filtered >= maxShown then
            break
        end
    end

    State.LastSniperMatches = filtered
    State.LastSniperRawCount = #raw

    log("Sniper dry-run matches", #filtered, "shown from raw", #raw)
    return filtered
end

local function canBuyNow(price)
    State.BuyTimes = cleanupTimes(State.BuyTimes)
    if #State.BuyTimes >= (tonumber(CFG.Sniper.MaxBuyPerMinute) or 1) then
        return false, "max buys/min"
    end

    if os.clock() - (State.LastBuyAt or 0) < (tonumber(CFG.Sniper.BuyCooldown) or 8) then
        return false, "buy cooldown"
    end

    price = tonumber(price) or 0
    local minAfter = tonumber(CFG.Sniper.MinTokensAfterBuy) or 0
    if minAfter > 0 and (getTokenBalance() - price) < minAfter then
        return false, "token reserve"
    end

    return true
end

local function getCurrentSniperWatch(petType)
    local target = norm(petType)
    if target == "" then return nil end

    for name, cfg in pairs(CFG.Sniper.Watchlist or {}) do
        if norm(name) == target then
            return {
                Name = tostring(name),
                MaxPrice = tonumber(type(cfg) == "table" and cfg.MaxPrice or cfg) or 0,
            }
        end
    end

    return nil
end

validateSniperMatch = function(m)
    if type(m) ~= "table" or type(m.Listing) ~= "table" then
        return false, "bad match"
    end

    local l = m.Listing
    if tostring(l.ItemType) ~= "Pet" then
        return false, "not pet"
    end

    if CFG.Sniper.SkipOwnListings and tostring(l.OwnerId) == tostring(getPlayerId()) then
        return false, "own listing"
    end

    if not l.OwnerPlayer then
        return false, "missing owner"
    end

    if tostring(l.ListingUUID or "") == "" then
        return false, "missing listing id"
    end

    local watch = getCurrentSniperWatch(l.PetType)
    if not watch then
        return false, "not in current watchlist"
    end

    local price = clampPrice(l.Price)
    if not price then
        return false, "bad price"
    end

    if watch.MaxPrice > 0 and price > watch.MaxPrice then
        return false, "above max price"
    end

    if watch.MaxPrice <= 0 and not CFG.Sniper.AllowNoMaxPrice then
        return false, "no max price"
    end

    local weight, pseudo, weightMode = getSniperWeightForListing(l, watch)
    local minWeight = toNumber(watch.MinWeight) or 0
    local maxWeight = toNumber(watch.MaxWeight)
    if minWeight > 0 and (not weight or weight < minWeight) then
        return false, "below min kg"
    end
    if maxWeight and (not weight or weight > maxWeight) then
        return false, "above max kg"
    end

    m.SniperWeight = weight
    m.SniperWeightMode = weightMode
    m.SniperPseudo = pseudo

    return true, watch
end

local function findFreshSniperMatch(wanted)
    if not wanted or not wanted.Listing then return nil end
    local wl = wanted.Listing
    local wantedUUID = tostring(wl.ListingUUID or "")
    local wantedOwner = tostring(wl.OwnerId or "")
    local wantedPrice = clampPrice(wl.Price)

    for _, fresh in ipairs(snipeDryRun(true)) do
        local fl = fresh.Listing
        local stillSafe = validateSniperMatch(fresh)
        if stillSafe
            and tostring(fl.ListingUUID or "") == wantedUUID
            and tostring(fl.OwnerId or "") == wantedOwner
            and clampPrice(fl.Price) == wantedPrice
        then
            return fresh
        end
    end

    return nil
end

local function buyFirstMatch()
    if CFG.Sniper.DryRun ~= false then
        log("Buy blocked: Sniper DryRun true")
        return false
    end
    local m = State.LastSniperMatches[1] or snipeDryRun()[1]
    if not m then log("No match to buy") return false end

    local safeBefore, whyBefore = validateSniperMatch(m)
    if not safeBefore then
        log("Buy blocked:", tostring(whyBefore))
        return false
    end

    if CFG.Sniper.RescanBeforeBuy then
        local fresh = findFreshSniperMatch(m)
        if not fresh then
            log("Buy blocked: listing no longer matches after rescan")
            return false
        end
        m = fresh
    end

    local l = m.Listing
    local safeAfter, whyAfter = validateSniperMatch(m)
    if not safeAfter then
        log("Buy blocked:", tostring(whyAfter))
        return false
    end

    local canBuy, why = canBuyNow(l.Price)
    if not canBuy then
        log("Buy blocked:", tostring(why))
        return false
    end

    if not l.OwnerPlayer then log("No OwnerPlayer for listing") return false end
    local ok, a, b = pcall(function()
        return BuyListing:InvokeServer(l.OwnerPlayer, l.ListingUUID)
    end)
    if ok then
        State.LastBuyAt = os.clock()
        table.insert(State.BuyTimes, os.clock())
        log("Buy sent", l.PetType, l.Price, l.ListingUUID, tostring(a), tostring(b))
        if a ~= false then
            State.SendSnipeWebhook(m)
        end
        return a, b
    end
    log("Buy failed", tostring(a))
    return false
end


-- NOMO-style Hub UI V3.2 (private Obsidian-style, mini presets)
-- Single file: library + demo (Seller page) at the bottom.

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local SCALE = 0.85 -- readable size for Redfinger / 1280x720

local T = {
	BG        = Color3.fromRGB(8, 12, 22),
	Sidebar   = Color3.fromRGB(11, 16, 28),
	Card      = Color3.fromRGB(13, 19, 34),
	Card2     = Color3.fromRGB(18, 26, 44),
	Border    = Color3.fromRGB(32, 46, 78),
	Accent    = Color3.fromRGB(56, 132, 255),
	AccentSoft= Color3.fromRGB(19, 34, 62),
	Text      = Color3.fromRGB(230, 237, 248),
	Sub       = Color3.fromRGB(122, 138, 166),
	Green     = Color3.fromRGB(52, 199, 123),
	Yellow    = Color3.fromRGB(235, 190, 80),
	Red       = Color3.fromRGB(240, 85, 85),
	Toggle0   = Color3.fromRGB(45, 55, 75),
}

local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	o.Parent = parent
	return o
end
local function corner(p, r) make("UICorner", {CornerRadius = UDim.new(0, r or 8)}, p) end
local function stroke(p, c, tr) make("UIStroke", {Color = c or T.Border, Thickness = 1, Transparency = tr or 0}, p) end
local function pad(p, t, b, l, r)
	make("UIPadding", {
		PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b or t),
		PaddingLeft = UDim.new(0, l or t), PaddingRight = UDim.new(0, r or l or t),
	}, p)
end
local function vlist(p, gap)
	return make("UIListLayout", {Padding = UDim.new(0, gap or 6), SortOrder = Enum.SortOrder.LayoutOrder}, p)
end

local function clampGuiPosition(frame, pos)
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)

	-- AbsoluteSize can ignore UIScale in some executors, so multiply by SCALE.
	local sx = (frame.AbsoluteSize.X > 0 and frame.AbsoluteSize.X or 820) * (SCALE or 1)
	local sy = (frame.AbsoluteSize.Y > 0 and frame.AbsoluteSize.Y or 500) * (SCALE or 1)

	local maxX = math.max(0, vp.X - sx - 6)
	local maxY = math.max(0, vp.Y - sy - 6)

	local x = math.clamp(pos.X.Offset, 0, maxX)
	local y = math.clamp(pos.Y.Offset, 0, maxY)

	return UDim2.new(0, x, 0, y)
end


local Library = {}

local function resolveAsset(pathOrId)
	if not pathOrId or pathOrId == "" then return nil end
	if tostring(pathOrId):match("^rbxassetid://") or tostring(pathOrId):match("^http") then
		return pathOrId
	end
	if type(getcustomasset) == "function" then
		local ok, asset = pcall(getcustomasset, pathOrId)
		if ok then return asset end
	end
	return pathOrId
end

function Library:CreateWindow(cfg)
	cfg = cfg or {}
	local gui = Instance.new("ScreenGui")
	gui.Name = "NomoHub"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	-- Arceus-safe: PlayerGui first. CoreGui can trigger capability errors on some executors.
	local pg = Players.LocalPlayer:WaitForChild("PlayerGui")
	gui.Parent = pg

	local main = make("Frame", {
		Size = UDim2.fromOffset(820, 500),
		Position = UDim2.new(0, 110, 0, 58),
		BackgroundColor3 = T.BG,
		BorderSizePixel = 0,
		Active = true,
		ClipsDescendants = true,
	}, gui)
	corner(main, 12)
	stroke(main, T.Border)
	make("UIScale", {Scale = SCALE}, main)

	----------------------------------------------------------------
	-- TOP BAR
	----------------------------------------------------------------
	local top = make("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1}, main)

	local search = make("TextBox", {
		Size = UDim2.fromOffset(260, 32),
		Position = UDim2.fromOffset(196, 10),
		BackgroundColor3 = T.Card,
		Text = "",
		PlaceholderText = "  Search pets, UUIDs, users...",
		PlaceholderColor3 = T.Sub,
		TextColor3 = T.Text,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		BorderSizePixel = 0,
	}, top)
	corner(search, 8); stroke(search); pad(search, 0, 0, 8, 8)

	-- status pills (right side)
	local pillHolder = make("Frame", {
		Size = UDim2.new(1, -530, 0, 32),
		Position = UDim2.new(1, -74, 0, 10),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
	}, top)
	make("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, pillHolder)

	local function makePill(label, value, color)
		local f = make("Frame", {Size = UDim2.fromOffset(110, 32), BackgroundColor3 = T.Card, BorderSizePixel = 0}, pillHolder)
		corner(f, 8); stroke(f)
		make("TextLabel", {
			Size = UDim2.new(1, -10, 0, 12), Position = UDim2.fromOffset(10, 4),
			BackgroundTransparency = 1, Text = label, TextColor3 = T.Sub,
			Font = Enum.Font.Gotham, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
		}, f)
		local v = make("TextLabel", {
			Size = UDim2.new(1, -10, 0, 12), Position = UDim2.fromOffset(10, 16),
			BackgroundTransparency = 1, Text = value, TextColor3 = color or T.Text,
			Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
		}, f)
		return {Set = function(_, txt, col) v.Text = txt if col then v.TextColor3 = col end end}
	end

	local pills = {
		Status  = makePill("STATUS", "● Online", T.Green),
		Booth   = makePill("BOOTH", "Active", T.Green),
		Balance = makePill("BALANCE", "0¢", T.Yellow),
	}

	-- window buttons
	local function winBtn(txt, x, cb)
		local b = make("TextButton", {
			Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, x, 0, 13),
			BackgroundColor3 = T.Card, Text = txt, TextColor3 = T.Sub,
			Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0,
		}, top)
		corner(b, 6)
		b.Activated:Connect(cb)
		return b
	end
	winBtn("×", -36, function() gui:Destroy() end)

	-- Hydra/Holy-style minimize: hide full window and show compact floating button.
	local mini = make("TextButton", {
		Size = UDim2.fromOffset(cfg.MiniSize or 58, cfg.MiniSize or 58),
		-- top-center like Hydra/Holy floating button
		Position = cfg.MiniPosition or UDim2.new(0.5, -160, 0, 2),
		BackgroundColor3 = T.Card,
		Text = "",
		TextColor3 = T.Accent,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		BorderSizePixel = 0,
		Visible = false,
		Active = true,
	}, gui)
	corner(mini, cfg.MiniCorner or 14)
	stroke(mini, T.Accent, 0)
	make("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, T.AccentSoft),
			ColorSequenceKeypoint.new(1, T.Card),
		}),
		Rotation = 90,
	}, mini)

	local miniImageAsset = resolveAsset(cfg.MiniImage)
	if miniImageAsset then
		local img = make("ImageLabel", {
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.fromOffset(5, 5),
			BackgroundTransparency = 1,
			Image = miniImageAsset,
			ScaleType = Enum.ScaleType.Fit,
		}, mini)
	else
		make("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = cfg.MiniText or "NOMO",
			TextColor3 = T.Accent,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
		}, mini)
	end

	local function setMinimized(v)
		main.Visible = not v
		mini.Visible = v
	end

	winBtn("–", -66, function()
		setMinimized(true)
	end)

	mini.Activated:Connect(function()
		setMinimized(false)
	end)

	-- drag mini button
	do
		local draggingMini, dragStartMini, miniStartPos
		mini.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				draggingMini, dragStartMini, miniStartPos = true, i.Position, mini.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(i)
			if draggingMini and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - dragStartMini
				local newPos = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + d.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + d.Y)
				mini.Position = clampGuiPosition(mini, newPos)
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingMini = false end
		end)
	end

	-- drag via top bar
	do
		local dragging, dragStart, startPos
		top.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging, dragStart, startPos = true, i.Position, main.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - dragStart
				local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				main.Position = clampGuiPosition(main, newPos)
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
		end)
	end

	----------------------------------------------------------------
	-- SIDEBAR
	----------------------------------------------------------------
	local side = make("Frame", {
		Size = UDim2.new(0, 180, 1, 0),
		BackgroundColor3 = T.Sidebar,
		BorderSizePixel = 0,
	}, main)

	make("TextLabel", {
		Size = UDim2.new(1, -20, 0, 20), Position = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1, RichText = true,
		Text = ('<font color="#%s"><b>%s</b></font> <b>%s</b>'):format(T.Accent:ToHex(), cfg.TitleAccent or "NOMO", cfg.Title or "MARKET"),
		TextColor3 = T.Text, Font = Enum.Font.GothamBold, TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, side)
	make("TextLabel", {
		Size = UDim2.new(1, -20, 0, 12), Position = UDim2.fromOffset(16, 36),
		BackgroundTransparency = 1, Text = cfg.Subtitle or "SELLER LITE",
		TextColor3 = T.Accent, Font = Enum.Font.Gotham, TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, side)

	local navHolder = make("Frame", {
		Size = UDim2.new(1, -16, 1, -140), Position = UDim2.fromOffset(8, 64),
		BackgroundTransparency = 1,
	}, side)
	vlist(navHolder, 4)

	-- profile box (bottom)
	local prof = make("Frame", {
		Size = UDim2.new(1, -16, 0, 58), Position = UDim2.new(0, 8, 1, -68),
		BackgroundColor3 = T.Card, BorderSizePixel = 0,
	}, side)
	corner(prof, 8); stroke(prof)
	make("TextLabel", {
		Size = UDim2.new(1, -12, 0, 16), Position = UDim2.fromOffset(12, 8),
		BackgroundTransparency = 1, Text = Players.LocalPlayer and Players.LocalPlayer.Name or "Player",
		TextColor3 = T.Text, Font = Enum.Font.GothamBold, TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, prof)
	make("TextLabel", {
		Size = UDim2.new(1, -12, 0, 12), Position = UDim2.fromOffset(12, 23),
		BackgroundTransparency = 1, Text = cfg.PlanText or "LITE PLAN",
		TextColor3 = T.Sub, Font = Enum.Font.Gotham, TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, prof)
	make("TextLabel", {
		Size = UDim2.new(1, -12, 0, 12), Position = UDim2.fromOffset(12, 34),
		BackgroundTransparency = 1, Text = cfg.VersionText or "",
		TextColor3 = T.Accent, Font = Enum.Font.GothamBold, TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, prof)

	----------------------------------------------------------------
	-- CONTENT / PAGES
	----------------------------------------------------------------
	local content = make("Frame", {
		Size = UDim2.new(1, -196, 1, -68), Position = UDim2.fromOffset(188, 60),
		BackgroundTransparency = 1,
	}, main)

	local window = {Pills = pills, SearchBox = search}
	local pages = {}

	local function selectPage(name)
		for n, p in pairs(pages) do
			p.frame.Visible = (n == name)
			p.btn.BackgroundColor3 = (n == name) and T.AccentSoft or T.Sidebar
			p.btn.BackgroundTransparency = (n == name) and 0 or 1
			p.btn.TextColor3 = (n == name) and T.Accent or T.Sub
		end
	end
	window.SelectPage = function(_, name) selectPage(name) end

	function window:CreatePage(name)
		local btn = make("TextButton", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = T.Sidebar, BackgroundTransparency = 1,
			Text = name, TextColor3 = T.Sub,
			Font = Enum.Font.GothamMedium, TextSize = 13, BorderSizePixel = 0,
		}, navHolder)
		corner(btn, 8)
		pad(btn, 0, 0, 12, 0)
		btn.TextXAlignment = Enum.TextXAlignment.Left

		local frame = make("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
			ScrollBarThickness = 3, ScrollBarImageColor3 = T.Border,
			CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false, BorderSizePixel = 0,
		}, content)
		vlist(frame, 10)

		pages[name] = {btn = btn, frame = frame}
		btn.Activated:Connect(function() selectPage(name) end)
		if not next(pages, next(pages)) and #navHolder:GetChildren() <= 2 then selectPage(name) end

		local page = {}

		-- row = horizontal container for side-by-side sections
		function page:AddRow()
			local row = make("Frame", {
				Size = UDim2.new(1, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
			}, frame)
			make("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder,
			}, row)
			return row
		end

		local function newSection(parent, title, widthScale)
			local card = make("Frame", {
				Size = UDim2.new(widthScale or 1, widthScale and -6 or -6, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = T.Card, BorderSizePixel = 0,
			}, parent)
			corner(card, 10); stroke(card); pad(card, 12)
			vlist(card, 8)
			make("TextLabel", {
				Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
				Text = title, TextColor3 = T.Text, Font = Enum.Font.GothamBold,
				TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = -1,
			}, card)

			local sec = {Frame = card}

			local function baseRow(h)
				return make("Frame", {Size = UDim2.new(1, 0, 0, h or 30), BackgroundTransparency = 1}, card)
			end
			local function rowLabel(row, text)
				make("TextLabel", {
					Size = UDim2.new(1, -150, 1, 0), BackgroundTransparency = 1,
					Text = text, TextColor3 = T.Text, Font = Enum.Font.Gotham,
					TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
				}, row)
			end

			function sec:AddToggle(text, default, cb)
				local state = default or false
				local row = baseRow(28)
				rowLabel(row, text)
				local hit = make("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""}, row)
				local bg = make("Frame", {
					Size = UDim2.fromOffset(36, 18), Position = UDim2.new(1, -36, 0.5, -9),
					BackgroundColor3 = state and T.Accent or T.Toggle0, BorderSizePixel = 0,
				}, row)
				corner(bg, 9)
				local knob = make("Frame", {
					Size = UDim2.fromOffset(14, 14),
					Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
					BackgroundColor3 = T.Text, BorderSizePixel = 0,
				}, bg)
				corner(knob, 7)
				local function set(v)
					state = v
					-- Arceus-safe: no TweenService on executor-created UI.
					bg.BackgroundColor3 = state and T.Accent or T.Toggle0
					knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
					if cb then cb(state) end
				end
				hit.Activated:Connect(function() set(not state) end)
				return {Set = function(_, v) set(v) end, Get = function() return state end}
			end

			function sec:AddStepper(text, default, min, max, cb)
				local val = default or 0
				local row = baseRow(28)
				rowLabel(row, text)
				local box = make("TextBox", {
					Size = UDim2.fromOffset(48, 24), Position = UDim2.new(1, -76, 0.5, -12),
					BackgroundColor3 = T.Card2, Text = tostring(val), TextColor3 = T.Text,
					Font = Enum.Font.GothamMedium, TextSize = 12, BorderSizePixel = 0,
				}, row)
				corner(box, 6); stroke(box)
				local function set(v)
					v = math.clamp(v, min or -math.huge, max or math.huge)
					val = v
					box.Text = tostring(v)
					if cb then cb(v) end
				end
				local function stepBtn(txt, x, delta)
					local b = make("TextButton", {
						Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, x, 0.5, -12),
						BackgroundColor3 = T.Card2, Text = txt, TextColor3 = T.Accent,
						Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0,
					}, row)
					corner(b, 6); stroke(b)
					b.Activated:Connect(function() set(val + delta) end)
				end
				stepBtn("–", -104, -1)
				stepBtn("+", -24, 1)
				box.FocusLost:Connect(function() set(tonumber(box.Text) or val) end)
				return {Set = function(_, v) set(v) end, Get = function() return val end}
			end

			function sec:AddInput(text, default, cb)
				local row = baseRow(28)
				rowLabel(row, text)
				local box = make("TextBox", {
					Size = UDim2.fromOffset(130, 24), Position = UDim2.new(1, -130, 0.5, -12),
					BackgroundColor3 = T.Card2, Text = tostring(default or ""), TextColor3 = T.Text,
					Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false, BorderSizePixel = 0,
				}, row)
				corner(box, 6); stroke(box); pad(box, 0, 0, 6, 6)
				box.FocusLost:Connect(function() if cb then cb(box.Text) end end)
				return {Set = function(_, v) box.Text = tostring(v) end, Get = function() return box.Text end}
			end

			function sec:AddDropdown(text, options, default, cb)
                -- V5.9: all dropdowns use the same popup selector UI.
                -- This keeps small dropdowns and large API dropdowns consistent.
                return sec:AddSearchDropdown(text, options or {}, default, cb)
            end

            function sec:AddSearchDropdown(text, options, default, cb)
                options = options or {}
                local current = default or options[1] or ""

                local function nrm(s)
                    s = tostring(s or ""):lower()
                    s = s:gsub("%b[]", ""):gsub("%b()", ""):gsub("_", " "):gsub("%s+", " ")
                    return s:gsub("^%s+", ""):gsub("%s+$", "")
                end

                local holder = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 28),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                }, card)

                local row = make("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1}, holder)
                rowLabel(row, text)

                local openBtn = make("TextButton", {
                    Size = UDim2.fromOffset(130, 24),
                    Position = UDim2.new(1, -130, 0.5, -12),
                    BackgroundColor3 = T.Card2,
                    Text = tostring(current),
                    TextColor3 = T.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                }, row)
                corner(openBtn, 6); stroke(openBtn); pad(openBtn, 0, 0, 6, 6)

                local overlay = make("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(0, 0, 0),
                    BackgroundTransparency = 0.35,
                    Visible = false,
                    BorderSizePixel = 0,
                    ZIndex = 80,
                }, gui)

                local modal = make("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.fromOffset(470, 360),
                    BackgroundColor3 = T.Card,
                    BorderSizePixel = 0,
                    ZIndex = 81,
                }, overlay)
                corner(modal, 12); stroke(modal, T.Border); pad(modal, 12)

                local titleRow = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundTransparency = 1,
                    ZIndex = 81,
                }, modal)
                make("TextLabel", {
                    Size = UDim2.new(1, -88, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 81,
                }, titleRow)
                local doneBtn = make("TextButton", {
                    Size = UDim2.fromOffset(72, 26),
                    Position = UDim2.new(1, -72, 0, 1),
                    BackgroundColor3 = T.Accent,
                    Text = "Done",
                    TextColor3 = Color3.new(1,1,1),
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    BorderSizePixel = 0,
                    ZIndex = 81,
                }, titleRow)
                corner(doneBtn, 8)

                local searchBox = make("TextBox", {
                    Size = UDim2.new(1, 0, 0, 32),
                    Position = UDim2.fromOffset(0, 36),
                    BackgroundColor3 = T.Card2,
                    PlaceholderText = "Search items...",
                    PlaceholderColor3 = T.Sub,
                    Text = "",
                    TextColor3 = T.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0,
                    ZIndex = 81,
                }, modal)
                corner(searchBox, 8); stroke(searchBox); pad(searchBox, 0, 0, 10, 10)

                local listWrap = make("Frame", {
                    Size = UDim2.new(1, 0, 1, -76),
                    Position = UDim2.fromOffset(0, 76),
                    BackgroundColor3 = T.BG,
                    BorderSizePixel = 0,
                    ZIndex = 81,
                }, modal)
                corner(listWrap, 10); stroke(listWrap)

                local list = make("ScrollingFrame", {
                    Size = UDim2.new(1, -8, 1, -8),
                    Position = UDim2.fromOffset(4, 4),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 4,
                    ScrollBarImageColor3 = T.Border,
                    CanvasSize = UDim2.new(0,0,0,0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 82,
                }, listWrap)
                local listLayout = vlist(list, 2)
                pad(list, 4, 4, 4, 4)

                local function clearList()
                    for _, child in ipairs(list:GetChildren()) do
                        if child:IsA("TextButton") or child:IsA("TextLabel") then
                            child:Destroy()
                        end
                    end
                end

                local function filtered(query)
                    local q = nrm(query)
                    local start, contain = {}, {}
                    for _, opt in ipairs(options) do
                        local name = tostring(opt)
                        local nn = nrm(name)
                        if q == "" or nn:find(q, 1, true) then
                            if q ~= "" and nn:sub(1, #q) == q then
                                table.insert(start, name)
                            else
                                table.insert(contain, name)
                            end
                        end
                    end
                    table.sort(start)
                    table.sort(contain)
                    for _, v in ipairs(contain) do table.insert(start, v) end
                    return start
                end

                local function refreshButton()
                    openBtn.Text = tostring(current ~= "" and current or "Select")
                    if current == "" then openBtn.TextColor3 = T.Sub else openBtn.TextColor3 = T.Text end
                end

                local function rebuildList()
                    clearList()
                    local vals = filtered(searchBox.Text)
                    if #vals == 0 then
                        make("TextLabel", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundTransparency = 1,
                            Text = "No match",
                            TextColor3 = T.Sub,
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            ZIndex = 82,
                        }, list)
                        return
                    end

                    local maxRows = math.max(20, toInt(CFG.UI.MaxDropdownRows) or 80)
                    for i, name in ipairs(vals) do
                        if i > maxRows then
                            make("TextLabel", {
                                Size = UDim2.new(1, 0, 0, 28),
                                BackgroundTransparency = 1,
                                Text = "... +" .. tostring(#vals - maxRows) .. " more, type to narrow",
                                TextColor3 = T.Sub,
                                Font = Enum.Font.Gotham,
                                TextSize = 12,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                ZIndex = 82,
                            }, list)
                            break
                        end

                        local selected = (tostring(name) == tostring(current))
                        local b = make("TextButton", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = selected and T.AccentSoft or T.Card2,
                            Text = tostring(name),
                            TextColor3 = selected and T.Accent or T.Text,
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            BorderSizePixel = 0,
                            AutoButtonColor = false,
                            ZIndex = 82,
                        }, list)
                        corner(b, 6)
                        pad(b, 0, 0, 10, 10)
                        b.Activated:Connect(function()
                            current = tostring(name)
                            refreshButton()
                            if cb then cb(current) end
                            overlay.Visible = false
                        end)
                    end
                end

                openBtn.Activated:Connect(function()
                    overlay.Visible = true
                    searchBox.Text = ""
                    rebuildList()
                    task.defer(function()
                        pcall(function() searchBox:CaptureFocus() end)
                    end)
                end)

                doneBtn.Activated:Connect(function()
                    overlay.Visible = false
                end)

                overlay.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        local pos = UserInputService:GetMouseLocation()
                        local mpos, msize = modal.AbsolutePosition, modal.AbsoluteSize
                        if pos.X < mpos.X or pos.X > mpos.X + msize.X or pos.Y < mpos.Y or pos.Y > mpos.Y + msize.Y then
                            overlay.Visible = false
                        end
                    end
                end)

                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if overlay.Visible then rebuildList() end
                end)

                refreshButton()

                return {
                    Get = function() return current end,
                    Set = function(_, v) current = tostring(v or ""); refreshButton() end,
                    SetOptions = function(_, opts) options = opts or {}; if overlay.Visible then rebuildList() end end,
                    Open = function() overlay.Visible = true; searchBox.Text = ""; rebuildList() end,
                }
            end

			function sec:AddButton(text, cb, style)
				local filled = style ~= "outline"
				local b = make("TextButton", {
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = filled and T.Accent or T.Card,
					Text = text, TextColor3 = filled and Color3.new(1, 1, 1) or T.Accent,
					Font = Enum.Font.GothamBold, TextSize = 13, BorderSizePixel = 0,
				}, card)
				corner(b, 8)
				if not filled then stroke(b, T.Accent, 0.4) end
				b.Activated:Connect(function() if cb then cb() end end)
				return b
			end

			function sec:AddNote(text)
				make("TextLabel", {
					Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1, Text = text, TextColor3 = T.Sub,
					Font = Enum.Font.Gotham, TextSize = 11, TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				}, card)
			end

            function sec:AddLabel(text, color)
                local lbl = make("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Text = tostring(text or ""),
                    TextColor3 = color or T.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                }, card)
                return {
                    Set = function(_, value, col)
                        lbl.Text = tostring(value or "")
                        if col then lbl.TextColor3 = col end
                    end,
                    Label = lbl,
                }
            end

			-- Table: columns = {{name, widthScale}, ...}; row status = {text, color}
			function sec:AddTable(columns)
				local header = make("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1}, card)
				local x = 0.06
				for _, col in ipairs(columns) do
					make("TextLabel", {
						Size = UDim2.new(col[2], 0, 1, 0), Position = UDim2.new(x, 0, 0, 0),
						BackgroundTransparency = 1, Text = col[1], TextColor3 = T.Sub,
						Font = Enum.Font.GothamMedium, TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
					}, header)
					x += col[2]
				end
				local tbl = {}
				function tbl:AddRow(values, status)
					local r = make("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = T.Card2, BorderSizePixel = 0}, card)
					corner(r, 6)
					local checked = false
					local cb = make("TextButton", {
						Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 10, 0.5, -7),
						BackgroundColor3 = T.Card, Text = "", BorderSizePixel = 0,
					}, r)
					corner(cb, 4); stroke(cb)
					cb.Activated:Connect(function()
						checked = not checked
						cb.BackgroundColor3 = checked and T.Accent or T.Card
					end)
					local cx = 0.06
					for i, col in ipairs(columns) do
						local isStatus = (i == #columns and status)
						make("TextLabel", {
							Size = UDim2.new(col[2], -4, 1, 0), Position = UDim2.new(cx, 0, 0, 0),
							BackgroundTransparency = 1,
							Text = isStatus and ("● " .. status[1]) or tostring(values[i] or ""),
							TextColor3 = isStatus and status[2] or T.Text,
							Font = Enum.Font.Gotham, TextSize = 11,
							TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
						}, r)
						cx += col[2]
					end
					return {IsChecked = function() return checked end, Frame = r}
				end
				return tbl
			end

			function sec:AddLog(height)
				local logFrame = make("ScrollingFrame", {
					Size = UDim2.new(1, 0, 0, height or 110),
					BackgroundColor3 = T.Card2, BorderSizePixel = 0,
					ScrollBarThickness = 3, CanvasSize = UDim2.new(),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
				}, card)
				corner(logFrame, 6); pad(logFrame, 6); vlist(logFrame, 2)
				local log = {}
				function log:Add(text)
					make("TextLabel", {
						Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1,
						RichText = false,
						Text = ("%s  %s"):format(os.date("%H:%M:%S"), tostring(text or ""):gsub("<.->", "")),
						Font = Enum.Font.Code, TextSize = 11, TextColor3 = T.Sub,
						TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
					}, logFrame)
					logFrame.CanvasPosition = Vector2.new(0, 1e6)
				end
				function log:Clear()
					for _, c in ipairs(logFrame:GetChildren()) do
						if c:IsA("TextLabel") then c:Destroy() end
					end
				end
				return log
			end

			return sec
		end

	function page:AddSection(title) return newSection(frame, title) end
	function page:AddSectionInRow(row, title, widthScale) return newSection(row, title, widthScale) end

	return page
	end

    window.Gui = gui
	return window
end

--//====================================================--
--// NOMO Market V6.1 List Verify Guard
--// Uses private NOMO Hub UI V3.2
--//====================================================--

local win = Library:CreateWindow({
    TitleAccent = "NOMO",
    Title = "MARKET",
    Subtitle = "SELLER LITE",
    PlanText = "PRIVATE DATA CORE",
    VersionText = VERSION,
    MiniText = "NOMO",

    -- top, left-of-center: above Tokens / Booth
    MiniPosition = UDim2.new(0.5, -160, 0, 2),

    -- Optional later:
    -- MiniImage = "rbxassetid://YOUR_IMAGE_ID",
    -- MiniImage = "Nomo/blue_rose.png",
})

win.Pills.Status:Set("Ready", T.Green)
win.Pills.Booth:Set("Data", T.Accent)
win.Pills.Balance:Set(commaNumber(getTokenBalance()), T.Green)

local function addLines(logObj, lines)
    logObj:Clear()
    for _, line in ipairs(lines) do
        logObj:Add(line)
    end
end

local function safeLine(v)
    return tostring(v or "-")
end

local refreshSellerLog

local function refreshPills()
    local best = findBestBooth()
    local boothText = best and best.Status or "No Booth"
    win.Pills.Booth:Set(boothText, boothText == "MINE" and T.Green or (boothText == "FREE" and T.Yellow or T.Sub))
    win.Pills.Balance:Set(commaNumber(getTokenBalance()), T.Green)
end


--// BOOTH PAGE
local boothPage = win:CreatePage("Booth")
local boothRow = boothPage:AddRow()
local boothCtrl = boothPage:AddSectionInRow(boothRow, "Booth Automation", 0.48)
local boothDataSec = boothPage:AddSectionInRow(boothRow, "Booth Data", 0.52)

boothCtrl:AddToggle("Auto Claim Booth", CFG.Booth.AutoClaim, function(v)
    CFG.Booth.AutoClaim = v
    State.SaveRuntimeSettings()
    log("AutoClaim", tostring(v))
end)

boothCtrl:AddToggle("Smart Reclaim", CFG.Booth.SmartReclaim, function(v)
    CFG.Booth.SmartReclaim = v
    State.SaveRuntimeSettings()
    log("SmartReclaim", tostring(v))
end)

boothCtrl:AddToggle("Compact Booth Data", CFG.UI.CompactBoothData ~= false, function(v)
    CFG.UI.CompactBoothData = v
    log("CompactBoothData", tostring(v))
end)

local boothMaxDist = boothCtrl:AddInput("Max Middle Distance", tostring(CFG.Booth.MaxMiddleDistance), function(v)
    CFG.Booth.MaxMiddleDistance = toNumber(v) or CFG.Booth.MaxMiddleDistance
end)

local boothSkin = boothCtrl:AddInput("Booth Skin", tostring(CFG.Booth.BoothSkin or "Default"), function(v)
    CFG.Booth.BoothSkin = trim(v) ~= "" and trim(v) or "Default"
end)

local boothClaimInterval = boothCtrl:AddInput("Claim Interval", tostring(CFG.Booth.ClaimInterval or 10), function(v)
    CFG.Booth.ClaimInterval = toNumber(v) or CFG.Booth.ClaimInterval or 10
end)

local boothLog = boothDataSec:AddLog(315)

local function refreshBoothLog()
    refreshPills()
    CFG.Booth.MaxMiddleDistance = toNumber(boothMaxDist:Get()) or CFG.Booth.MaxMiddleDistance
    CFG.Booth.BoothSkin = trim(boothSkin:Get()) ~= "" and trim(boothSkin:Get()) or "Default"
    CFG.Booth.ClaimInterval = toNumber(boothClaimInterval:Get()) or CFG.Booth.ClaimInterval or 10

    local items = getBoothSnapshot()
    local target, status = findBestBooth()
    local lines = {
        "Booths: " .. tostring(#items),
        "Best: " .. tostring(target and (target.Id:sub(1, 8) .. "...") or "None") .. " / " .. tostring(status),
        "MaxDist: " .. tostring(CFG.Booth.MaxMiddleDistance),
        "Skin: " .. tostring(CFG.Booth.BoothSkin),
        "AutoClaim every: " .. tostring(CFG.Booth.ClaimInterval) .. "s",
        "------------------------------",
    }

    for i, item in ipairs(items) do
        if i > 16 then
            table.insert(lines, "... +" .. tostring(#items - 16) .. " more")
            break
        end

        local shortId = tostring(item.Id):sub(1, 8)
        local status = item.Status
        local owner = item.OwnerText

        if status == "FREE" then
            owner = "-"
        elseif status == "MINE" then
            owner = "YOU"
        else
            owner = tostring(owner):gsub("^Player_", "P_")
            if #owner > 10 then owner = owner:sub(1, 10) end
        end

        if CFG.UI and CFG.UI.CompactBoothData ~= false then
            table.insert(lines, string.format(
                "%02d. %-5s d%-3d %s",
                i,
                status,
                math.floor(item.MiddleDistance or 0),
                shortId
            ))
        else
            table.insert(lines, string.format(
                "%02d. %s | %s | owner %s | dist %d",
                i,
                item.Id,
                status,
                owner,
                math.floor(item.MiddleDistance or 0)
            ))
        end
    end

    addLines(boothLog, lines)
end

boothCtrl:AddButton("Refresh Booth Data", refreshBoothLog)
boothCtrl:AddButton("Claim Best Free", function()
    claimBestFreeBooth()
    refreshBoothLog()
end)
boothCtrl:AddButton("Equip Skin", function()
    CFG.Booth.BoothSkin = trim(boothSkin:Get()) ~= "" and trim(boothSkin:Get()) or "Default"
    equipSkin()
end, "outline")

--// SELLER PAGE
local sellerPage = win:CreatePage("Seller")
local sellerRow = sellerPage:AddRow()
local sellerCtrl = sellerPage:AddSectionInRow(sellerRow, "Runtime Controls", 0.45)
local filterSec = sellerPage:AddSectionInRow(sellerRow, "Filter Builder", 0.55)

sellerCtrl:AddToggle("Auto List", CFG.Seller.AutoList, function(v)
    CFG.Seller.AutoList = v
    CFG.Seller.PreviewOnly = not v
    State.SaveRuntimeSettings()
    log("AutoList", tostring(v))
end)

sellerCtrl:AddToggle("Preview Only", CFG.Seller.PreviewOnly, function(v)
    CFG.Seller.PreviewOnly = v
    if v then CFG.Seller.AutoList = false end
    State.SaveRuntimeSettings()
    log("PreviewOnly", tostring(v))
end)

sellerCtrl:AddToggle("Skip Favorited", CFG.Seller.SkipFavorited, function(v)
    CFG.Seller.SkipFavorited = v
end)

sellerCtrl:AddToggle("Skip Locked", CFG.Seller.SkipLocked, function(v)
    CFG.Seller.SkipLocked = v
end)

sellerCtrl:AddInput("Scan Interval", tostring(CFG.Seller.ScanInterval), function(v)
    CFG.Seller.ScanInterval = toNumber(v) or CFG.Seller.ScanInterval
end)

sellerCtrl:AddButton("LIST UNTIL BOOTH FULL", function()
    CFG.Seller.BoothCap = 50
    CFG.Seller.ListOnceMax = 50
    CFG.Seller.MaxAutoListSession = 50
    task.spawn(function()
        listOnce(50)
    end)
end)

sellerCtrl:AddButton("REMOVE ALL MY LISTINGS", function()
    task.spawn(function()
        removeAllMyListings(CFG.Listings.RemoveAllMax or 50)
        task.wait(0.6)
        refreshSellerLog(true)
    end)
end, "outline")

sellerCtrl:AddButton("REBUILD BOOTH", function()
    task.spawn(function()
        rebuildBooth()
        task.wait(0.6)
        refreshSellerLog(true)
    end)
end, "outline")

sellerCtrl:AddButton("SMART REBUILD", function()
    task.spawn(function()
        smartRebuildBooth()
        task.wait(0.6)
        refreshSellerLog(true)
    end)
end, "outline")

sellerCtrl:AddToggle("Auto Smart Rebuild On Start", CFG.Seller.AutoSmartRebuildOnStart, function(v)
    CFG.Seller.AutoSmartRebuildOnStart = v
end)

sellerCtrl:AddToggle("Remote Config", CFG.Seller.RemoteConfigEnabled, function(v)
    CFG.Seller.RemoteConfigEnabled = v
end)

sellerCtrl:AddButton("Reload Remote Config", function()
    task.spawn(function()
        reloadFilters()
        task.wait(0.2)
        refreshSellerLog(true)
    end)
end, "outline")

local sellerLog
local diagnosePetFilter

filterSec:AddDropdown("Listing Weight Mode", {"Base", "Visual"}, CFG.Seller.WeightMode or "Base", function(v)
    CFG.Seller.WeightMode = tostring(v or "Base")
    log("ListingWeightMode", CFG.Seller.WeightMode)
end)

local petInput = filterSec:AddSearchDropdown("Pet", getPetList(), "Ankylosaurus")
filterSec:AddButton("Diagnose This Pet", function()
    if sellerLog and diagnosePetFilter then
        addLines(sellerLog, diagnosePetFilter(petInput:Get()))
    end
end, "outline")
local priceInput = filterSec:AddInput("Price", "111")
local minKgInput = filterSec:AddInput("Min Base KG", "0")
local maxKgInput = filterSec:AddInput("Max Base KG", "3")
local minAgeInput = filterSec:AddInput("Min Age", "1")
local maxAgeInput = filterSec:AddInput("Max Age", "100")
local mutationInput = filterSec:AddSearchDropdown("Mutation", getMutationList(), "Any")
local variantInput = { Get = function() return "Any" end } -- hatch type is part of Pet name, e.g. GIANT Barn Owl
local maxListedInput = filterSec:AddInput("Per Filter Cap", "5")

State.OpenFilterEditPopup = function(index, managerOverlay)
    State.LoadLocalFilters()
    index = toInt(index)
    local f = index and State.FilterData.Filters and State.FilterData.Filters[index]
    if not f then
        log("Edit filter failed", "bad index", tostring(index))
        return
    end

    local overlay = make("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 100,
    }, win.Gui)
    local modal = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(420, 260),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ZIndex = 101,
    }, overlay)
    corner(modal, 10); stroke(modal); pad(modal, 12)

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "Edit Filter - " .. tostring(f.Pet or "?"),
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
    }, modal)

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.fromOffset(0, 34),
        BackgroundTransparency = 1,
        Text = string.format("Base KG %s-%s | Age %s-%s | Mutation %s",
            tostring(f.MinWeight or 0),
            tostring(f.MaxWeight or "?"),
            tostring(f.MinLevel or 1),
            tostring(f.MaxLevel or 100),
            tostring(f.Mutation or "Any")
        ),
        TextColor3 = T.Sub,
        Font = Enum.Font.Code,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        ZIndex = 102,
    }, modal)

    make("TextLabel", {
        Size = UDim2.new(0, 120, 0, 26),
        Position = UDim2.fromOffset(0, 92),
        BackgroundTransparency = 1,
        Text = "Price",
        TextColor3 = T.Sub,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
    }, modal)
    local priceBox = make("TextBox", {
        Size = UDim2.new(1, -130, 0, 26),
        Position = UDim2.fromOffset(130, 92),
        BackgroundColor3 = T.Card2,
        Text = tostring(f.Price or ""),
        TextColor3 = T.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, modal)
    corner(priceBox, 6); stroke(priceBox); pad(priceBox, 0, 0, 6, 6)

    make("TextLabel", {
        Size = UDim2.new(0, 120, 0, 26),
        Position = UDim2.fromOffset(0, 126),
        BackgroundTransparency = 1,
        Text = "Max Listing",
        TextColor3 = T.Sub,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
    }, modal)
    local maxBox = make("TextBox", {
        Size = UDim2.new(1, -130, 0, 26),
        Position = UDim2.fromOffset(130, 126),
        BackgroundColor3 = T.Card2,
        Text = tostring(f.MaxListedPet or 5),
        TextColor3 = T.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, modal)
    corner(maxBox, 6); stroke(maxBox); pad(maxBox, 0, 0, 6, 6)

    local saveBtn = make("TextButton", {
        Size = UDim2.fromOffset(130, 30),
        Position = UDim2.new(1, -272, 1, -34),
        BackgroundColor3 = T.Accent,
        Text = "Save",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, modal)
    corner(saveBtn, 7)
    local cancelBtn = make("TextButton", {
        Size = UDim2.fromOffset(130, 30),
        Position = UDim2.new(1, -134, 1, -34),
        BackgroundColor3 = T.Card2,
        Text = "Cancel",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, modal)
    corner(cancelBtn, 7); stroke(cancelBtn)

    cancelBtn.Activated:Connect(function()
        overlay:Destroy()
    end)
    saveBtn.Activated:Connect(function()
        State.LoadLocalFilters()
        local row = State.FilterData.Filters and State.FilterData.Filters[index]
        if row then
            row.Price = clampPrice(priceBox.Text) or row.Price
            row.MaxListedPet = toInt(maxBox.Text) or row.MaxListedPet or 5
            local ok = saveFilters()
            if CFG.Seller.RemoteConfigEnabled and tostring(CFG.Seller.RemoteConfigURL or "") ~= "" then
                CFG.Seller.RemoteConfigEnabled = false
                log("Remote config disabled after local filter edit")
            end
            log("Updated filter", tostring(index), tostring(row.Pet or "?"), "price", tostring(row.Price), "max", tostring(row.MaxListedPet), "saved=" .. tostring(ok), getFilterPath())
            refreshSellerLog(true)
        end
        overlay:Destroy()
        if managerOverlay then managerOverlay:Destroy() end
        State.OpenFilterManager()
    end)
end

State.OpenFilterManager = function()
    local overlay = make("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 90,
    }, win.Gui)
    local modal = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(560, 390),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ZIndex = 91,
    }, overlay)
    corner(modal, 10); stroke(modal); pad(modal, 10)

    local title = make("TextLabel", {
        Size = UDim2.new(1, -74, 0, 26),
        BackgroundTransparency = 1,
        Text = "Manage Listing Filters",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 92,
    }, modal)
    local closeBtn = make("TextButton", {
        Size = UDim2.fromOffset(64, 24),
        Position = UDim2.new(1, -64, 0, 0),
        BackgroundColor3 = T.Card2,
        Text = "Done",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 92,
    }, modal)
    corner(closeBtn, 7); stroke(closeBtn)

    local list = make("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -36),
        Position = UDim2.fromOffset(0, 34),
        BackgroundColor3 = T.Card2,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ZIndex = 92,
    }, modal)
    corner(list, 8); pad(list, 5); vlist(list, 4)

    closeBtn.Activated:Connect(function() overlay:Destroy() end)

    for i, f in ipairs(getFilters()) do
        local row = make("Frame", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T.Card,
            BorderSizePixel = 0,
            ZIndex = 93,
        }, list)
        corner(row, 7); stroke(row)
        make("TextLabel", {
            Size = UDim2.new(1, -116, 1, 0),
            Position = UDim2.fromOffset(8, 0),
            BackgroundTransparency = 1,
            Text = string.format("%02d. %s | Price %s | Base KG %s-%s | Age %s-%s | Max %s | %s",
                i,
                tostring(f.Pet or "?"),
                tostring(f.Price or "?"),
                tostring(f.MinWeight or 0),
                tostring(f.MaxWeight or "?"),
                tostring(f.MinLevel or 1),
                tostring(f.MaxLevel or 100),
                tostring(f.MaxListedPet or 5),
                tostring(f.Mutation or "Any")
            ),
            TextColor3 = T.Text,
            Font = Enum.Font.Code,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 94,
        }, row)
        local editBtn = make("TextButton", {
            Size = UDim2.fromOffset(50, 24),
            Position = UDim2.new(1, -104, 0.5, -12),
            BackgroundColor3 = T.Card2,
            Text = "Edit",
            TextColor3 = T.Accent,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            BorderSizePixel = 0,
            ZIndex = 94,
        }, row)
        corner(editBtn, 6); stroke(editBtn)
        local delBtn = make("TextButton", {
            Size = UDim2.fromOffset(36, 24),
            Position = UDim2.new(1, -44, 0.5, -12),
            BackgroundColor3 = Color3.fromRGB(255, 72, 86),
            Text = "X",
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            BorderSizePixel = 0,
            ZIndex = 94,
        }, row)
        corner(delBtn, 6)

        editBtn.Activated:Connect(function()
            State.OpenFilterEditPopup(f.Row or i, overlay)
        end)
        delBtn.Activated:Connect(function()
            deleteFilter(f.Row or i)
            refreshSellerLog(true)
            overlay:Destroy()
            State.OpenFilterManager()
        end)
    end
end

local logRow = sellerPage:AddRow()
local filterLogSec = sellerPage:AddSectionInRow(logRow, "Active Filters / Candidates", 1)
sellerLog = filterLogSec:AddLog(210)

diagnosePetFilter = function(petName)
    petName = tostring(petName or "")
    local target = norm(petName)
    local pets = getInventoryPets()
    local myCounts = countMyListingsByPet()
    local scan = buildCandidates()

    local lines = {
        "Diagnose: " .. petName,
        "Listing Weight Mode: " .. tostring(CFG.Seller.WeightMode or "Base"),
        "Already in booth: " .. tostring(myCounts[target] or 0),
        "------------------------------",
        "Owned matching name:",
    }

    local found = 0
    for _, p in ipairs(pets) do
        if target == "" or p.NameNorm == target then
            found += 1
            local flags = ""
            if p.Locked then flags ..= " LOCKED" end
            if p.Favorite then flags ..= " FAV" end
            if p.AlreadyListed then flags ..= " LISTED" end

            table.insert(lines, string.format(
                "%02d. Base %.2f | Visual %.2f | Age %s%s",
                found,
                tonumber(p.BaseWeight or p.Weight) or 0,
                tonumber(p.VisualWeight or p.Weight) or 0,
                tostring(p.Age or "?"),
                flags
            ))
        end
    end

    local cand, skipped = 0, 0
    for _, c in ipairs(scan.Candidates or {}) do
        if c.Pet and c.Pet.NameNorm == target then cand += 1 end
    end
    for _, s in ipairs(scan.Skipped or {}) do
        if s.Pet and s.Pet.NameNorm == target then skipped += 1 end
    end

    table.insert(lines, "------------------------------")
    table.insert(lines, "Candidates: " .. tostring(cand))
    table.insert(lines, "Skipped: " .. tostring(skipped))
    table.insert(lines, "Skipped detail:")

    local shown = 0
    for _, s in ipairs(scan.Skipped or {}) do
        if s.Pet and s.Pet.NameNorm == target then
            shown += 1
            if shown > 14 then
                table.insert(lines, "... +" .. tostring(skipped - 14) .. " more")
                break
            end
            local p = s.Pet or {}
            table.insert(lines, string.format(
                "%02d. Base %.2f | Visual %.2f | Age %s | %s",
                shown,
                tonumber(p.BaseWeight or p.Weight) or 0,
                tonumber(p.VisualWeight or p.Weight) or 0,
                tostring(p.Age or "?"),
                tostring(s.Reason or "?")
            ))
        end
    end

    return lines
end

refreshSellerLog = function(showCandidates)
    local filters = getFilters()
    local myListings = getMyListings()
    local lines = {
        "Filters: " .. tostring(#filters),
        "Booth listings: " .. tostring(#myListings) .. " / " .. tostring(CFG.Seller.BoothCap or 50),
        "Listed this run: " .. tostring(State.ListedThisSession or 0),
        "Listing weight mode: " .. tostring(CFG.Seller.WeightMode or "Base") .. " KG",
        "Per filter cap: enabled",
        "Auto smart rebuild: " .. tostring(CFG.Seller.AutoSmartRebuildOnStart),
        "Remote config: " .. tostring(CFG.Seller.RemoteConfigEnabled) .. " | " .. tostring((CFG.Seller.RemoteConfigURL ~= "" and "URL set") or "no URL"),
        "Verify after list: " .. tostring(CFG.Seller.VerifyAfterList),
        "------------------------------",
    }

    for i, f in ipairs(filters) do
        if i > 10 then
            table.insert(lines, "... +" .. tostring(#filters - 10) .. " more filters")
            break
        end
        table.insert(lines, string.format(
            "%02d. %s | Price %s | Base KG %s-%s | Age %s-%s | Mut %s | Max %s",
            i,
            f.Pet,
            tostring(f.Price),
            fmtKg(f.MinWeight),
            fmtKg(f.MaxWeight),
            tostring(f.MinLevel),
            tostring(f.MaxLevel),
            tostring(f.Mutation or "Any"),
            tostring(f.MaxListedPet or 5)
        ))
    end

    if showCandidates then
        local scan = buildCandidates()
        table.insert(lines, "------------------------------")
        table.insert(lines, string.format(
            "Pets %d | Candidates %d | Skipped %d",
            #scan.Pets,
            #scan.Candidates,
            #scan.Skipped
        ))

        for i, c in ipairs(scan.Candidates) do
            if i > 12 then
                table.insert(lines, "... +" .. tostring(#scan.Candidates - 12) .. " more candidates")
                break
            end
            table.insert(lines, string.format(
                "%02d. %s | Base %s | Visual %s | Age %s | Mut %s | price %s %s",
                i,
                c.Pet.Name,
                fmtKg(c.Pet.BaseWeight),
                fmtKg(c.Pet.VisualWeight),
                tostring(c.Pet.Age or "?"),
                tostring(c.Pet.Mutation or "Normal"),
                tostring(c.Filter.Price),
                filterRiskText(c.Filter)
            ))
        end

        if CFG.Seller.ShowSkipReasons and #scan.Skipped > 0 then
            table.insert(lines, "------------------------------")
            table.insert(lines, "Skipped sample:")
            for i, s in ipairs(scan.Skipped) do
                if i > 8 then
                    table.insert(lines, "... +" .. tostring(#scan.Skipped - 8) .. " more skipped")
                    break
                end
                local p = s.Pet or {}
                table.insert(lines, string.format(
                    "%02d. %s | Base %s | Visual %s | Age %s | Mut %s | %s",
                    i,
                    tostring(p.Name or "?"),
                    fmtKg(p.BaseWeight or p.Weight),
                    fmtKg(p.VisualWeight or p.Weight),
                    tostring(p.Age or "?"),
                    tostring(p.Mutation or "Normal"),
                    tostring(s.Reason or "?")
                ))
            end
        end
    end

    addLines(sellerLog, lines)
end

filterSec:AddButton("+ Add Filter", function()
    addFilter(
        petInput:Get(),
        priceInput:Get(),
        minKgInput:Get(),
        maxKgInput:Get(),
        minAgeInput:Get(),
        maxAgeInput:Get(),
        mutationInput:Get(),
        maxListedInput:Get(),
        variantInput:Get()
    )
    refreshSellerLog(true)
end)

filterSec:AddButton("Preview Candidates", function()
    refreshSellerLog(true)
end, "outline")

local delFilterInput = filterLogSec:AddInput("Remove Filter #", "1")
filterLogSec:AddButton("Manage Filters", function()
    State.OpenFilterManager()
end)

filterLogSec:AddButton("Remove Selected Filter", function()
    deleteFilter(delFilterInput:Get())
    refreshSellerLog(true)
end, "outline")

filterLogSec:AddButton("Clear All Filters", function()
    clearFilters()
    refreshSellerLog(false)
end, "outline")

--// LISTINGS PAGE
local listingsPage = win:CreatePage("Listings")
local listingRow = listingsPage:AddRow()
local myListingSec = listingsPage:AddSectionInRow(listingRow, "My Listings", 1)
local allListingSec = listingsPage:AddSection("Market Listings Sample")

local myListingList = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 0, 280),
    BackgroundColor3 = T.BG,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = T.Border,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, myListingSec.Frame)
corner(myListingList, 8); stroke(myListingList); pad(myListingList, 6, 6, 6, 6); vlist(myListingList, 4)

local marketLog = allListingSec:AddLog(125)

local function clearListingRows()
    for _, child in ipairs(myListingList:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function makeListingRow(i, l)
    local row = make("Frame", {
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundColor3 = T.Card2,
        BorderSizePixel = 0,
    }, myListingList)
    corner(row, 7)

    local xBtn = make("TextButton", {
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(0, 6, 0.5, -12),
        BackgroundColor3 = T.Red,
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, row)
    corner(xBtn, 6)

    local info = make("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.fromOffset(36, 0),
        BackgroundTransparency = 1,
        Text = string.format(
            "%02d. %s | %s | %s | id %s",
            i,
            tostring(l.PetType or "?"),
            tostring(l.ItemType or "?"),
            commaNumber(l.Price),
            tostring(l.ListingUUID or ""):sub(1, 8)
        ),
        TextColor3 = T.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)

    xBtn.Activated:Connect(function()
        xBtn.Text = "..."
        local ok = removeListingUUID(l.ListingUUID)
        task.wait(0.35)
        refreshMyListingsLog()
        if not ok then
            log("X remove failed", tostring(l.ListingUUID))
        end
    end)
end

function refreshMyListingsLog()
    local my = getMyListings()
    State.TrackSoldListings(my)
    clearListingRows()

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = "My listings: " .. tostring(#my) .. "   |   tap X to remove",
        TextColor3 = T.Sub,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, myListingList)

    for i, l in ipairs(my) do
        if i > 50 then
            make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Text = "... +" .. tostring(#my - 50) .. " more",
                TextColor3 = T.Sub,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, myListingList)
            break
        end
        makeListingRow(i, l)
    end
end

local function refreshMarketSample()
    local all = getAllListings()
    local lines = {"All listings: " .. tostring(#all), "------------------------------"}

    for i, l in ipairs(all) do
        if i > 10 then
            table.insert(lines, "... +" .. tostring(#all - 10) .. " more")
            break
        end
        table.insert(lines, string.format(
            "%02d. %s | price %s | owner %s",
            i,
            l.PetType,
            tostring(l.Price),
            l.OwnerName
        ))
    end

    addLines(marketLog, lines)
end

myListingSec:AddButton("Refresh My Listings", refreshMyListingsLog)
myListingSec:AddButton("REMOVE ALL MY LISTINGS", function()
    task.spawn(function()
        removeAllMyListings(CFG.Listings.RemoveAllMax or 50)
        task.wait(0.6)
        refreshMyListingsLog()
    end)
end, "outline")

allListingSec:AddButton("Refresh Market Sample", refreshMarketSample)

--// SNIPER PAGE
local sniperPage = win:CreatePage("Sniper")
local sniperRow = sniperPage:AddRow()
local sniperCtrl = sniperPage:AddSectionInRow(sniperRow, "Sniper Control", 0.45)
local sniperResultSec = sniperPage:AddSectionInRow(sniperRow, "Sniper Matches", 0.55)

sniperCtrl:AddToggle("Enabled", CFG.Sniper.Enabled, function(v)
    CFG.Sniper.Enabled = v
    State.SaveRuntimeSettings()
    log("Sniper Enabled", tostring(v))
end)

sniperCtrl:AddToggle("Dry Run", CFG.Sniper.DryRun, function(v)
    CFG.Sniper.DryRun = v
    State.SaveRuntimeSettings()
    log("Sniper DryRun", tostring(v))
end)

sniperCtrl:AddToggle("Rescan Before Buy", CFG.Sniper.RescanBeforeBuy, function(v)
    CFG.Sniper.RescanBeforeBuy = v
    State.SaveRuntimeSettings()
    log("Sniper RescanBeforeBuy", tostring(v))
end)

local sPet = sniperCtrl:AddSearchDropdown("Pet", getPetList(), "Red Fox")
local sMax = sniperCtrl:AddInput("Max Price", "6")
State.SniperWeightModeInput = sniperCtrl:AddDropdown("Weight Mode", {"Base", "Visual"}, CFG.Sniper.WeightMode or "Base", function(v)
    CFG.Sniper.WeightMode = normalizeSniperWeightMode(v)
    log("SniperWeightMode", CFG.Sniper.WeightMode)
end)
State.SniperMinKgInput = sniperCtrl:AddInput("Min KG", "0", function(v)
    CFG.Sniper.MinWeight = toNumber(v) or 0
end)
State.SniperMaxKgInput = sniperCtrl:AddInput("Max KG", "", function(v)
    CFG.Sniper.MaxWeight = toNumber(v)
end)
local sShow = sniperCtrl:AddInput("Show", tostring(CFG.Sniper.MaxMatchesShown or 20), function(v)
    CFG.Sniper.MaxMatchesShown = toInt(v) or CFG.Sniper.MaxMatchesShown or 20
end)
local sPerPet = sniperCtrl:AddInput("Per Pet", tostring(CFG.Sniper.MaxMatchesPerPet or 5), function(v)
    CFG.Sniper.MaxMatchesPerPet = toInt(v) or CFG.Sniper.MaxMatchesPerPet or 5
end)
State.SniperWatchlistIdInput = sniperCtrl:AddInput("Watchlist ID", tostring(CFG.Sniper.WatchlistId or "1"), function(v)
    CFG.Sniper.WatchlistId = tostring(v or "1")
    State.SaveRuntimeSettings()
    State.ReloadSniperConfig()
    State.RefreshSniperLog()
end)

local sniperLog = sniperResultSec:AddLog(315)

State.ApplySniperLimits = function()
    CFG.Sniper.BuyCooldown = 0
    CFG.Sniper.WeightMode = normalizeSniperWeightMode(State.SniperWeightModeInput:Get())
    CFG.Sniper.MinWeight = toNumber(State.SniperMinKgInput:Get()) or 0
    CFG.Sniper.MaxWeight = toNumber(State.SniperMaxKgInput:Get())
    CFG.Sniper.MaxMatchesShown = toInt(sShow:Get()) or CFG.Sniper.MaxMatchesShown or 20
    CFG.Sniper.MaxMatchesPerPet = toInt(sPerPet:Get()) or CFG.Sniper.MaxMatchesPerPet or 5
end

State.OpenSniperWatchEditPopup = function(name, managerOverlay)
    local cfg = CFG.Sniper.Watchlist and CFG.Sniper.Watchlist[name]
    if not cfg then
        log("Edit watch failed", tostring(name))
        return
    end
    local maxPrice = type(cfg) == "table" and cfg.MaxPrice or cfg
    local minKg = type(cfg) == "table" and cfg.MinWeight or 0
    local maxKg = type(cfg) == "table" and cfg.MaxWeight or nil
    local perPet = type(cfg) == "table" and (toInt(cfg.MaxMatchesPerPet or cfg.PerPet) or toInt(CFG.Sniper.MaxMatchesPerPet) or 5) or (toInt(CFG.Sniper.MaxMatchesPerPet) or 5)
    local mode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode)

    local overlay = make("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 100,
    }, win.Gui)
    local modal = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(420, 290),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ZIndex = 101,
    }, overlay)
    corner(modal, 10); stroke(modal); pad(modal, 12)

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "Edit Watch - " .. tostring(name),
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
    }, modal)

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.fromOffset(0, 34),
        BackgroundTransparency = 1,
        Text = tostring(mode) .. " weight mode",
        TextColor3 = T.Sub,
        Font = Enum.Font.Code,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
    }, modal)

    local function label(text, y)
        make("TextLabel", {
            Size = UDim2.new(0, 120, 0, 26),
            Position = UDim2.fromOffset(0, y),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = T.Sub,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 102,
        }, modal)
    end
    local function box(text, y)
        local b = make("TextBox", {
            Size = UDim2.new(1, -130, 0, 26),
            Position = UDim2.fromOffset(130, y),
            BackgroundColor3 = T.Card2,
            Text = tostring(text or ""),
            TextColor3 = T.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            ClearTextOnFocus = false,
            BorderSizePixel = 0,
            ZIndex = 102,
        }, modal)
        corner(b, 6); stroke(b); pad(b, 0, 0, 6, 6)
        return b
    end

    label("Price", 70)
    local priceBox = box(maxPrice, 70)
    label("Min KG", 104)
    local minBox = box(minKg, 104)
    label("Max KG", 138)
    local maxBox = box(maxKg or "", 138)
    label("Max Per Pet", 172)
    local perPetBox = box(perPet, 172)

    local saveBtn = make("TextButton", {
        Size = UDim2.fromOffset(130, 30),
        Position = UDim2.new(1, -272, 1, -34),
        BackgroundColor3 = T.Accent,
        Text = "Save",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, modal)
    corner(saveBtn, 7)
    local cancelBtn = make("TextButton", {
        Size = UDim2.fromOffset(130, 30),
        Position = UDim2.new(1, -134, 1, -34),
        BackgroundColor3 = T.Card2,
        Text = "Cancel",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, modal)
    corner(cancelBtn, 7); stroke(cancelBtn)

    cancelBtn.Activated:Connect(function()
        overlay:Destroy()
    end)
    saveBtn.Activated:Connect(function()
        CFG.Sniper.Watchlist = CFG.Sniper.Watchlist or {}
        CFG.Sniper.Watchlist[name] = {
            MaxPrice = clampPrice(priceBox.Text) or maxPrice or 0,
            MinWeight = toNumber(minBox.Text) or 0,
            MaxWeight = toNumber(maxBox.Text),
            WeightMode = mode,
            MaxMatchesPerPet = toInt(perPetBox.Text) or perPet or 5,
        }
        local ok = State.SaveSniperWatchlist()
        log("Updated watch", tostring(name), "price", tostring(CFG.Sniper.Watchlist[name].MaxPrice), "max", tostring(CFG.Sniper.Watchlist[name].MaxMatchesPerPet), "saved=" .. tostring(ok), getSniperFilterPath())
        State.RefreshSniperLog()
        overlay:Destroy()
        if managerOverlay then managerOverlay:Destroy() end
        State.OpenSniperWatchlistManager()
    end)
end

State.OpenSniperWatchlistManager = function()
    local watches = State.GetSortedSniperWatches()
    local overlay = make("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 90,
    }, win.Gui)
    local modal = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(560, 390),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ZIndex = 91,
    }, overlay)
    corner(modal, 10); stroke(modal); pad(modal, 10)

    make("TextLabel", {
        Size = UDim2.new(1, -74, 0, 26),
        BackgroundTransparency = 1,
        Text = "Manage Sniper Watchlist (" .. tostring(#watches) .. ")",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 92,
    }, modal)
    local closeBtn = make("TextButton", {
        Size = UDim2.fromOffset(64, 24),
        Position = UDim2.new(1, -64, 0, 0),
        BackgroundColor3 = T.Card2,
        Text = "Done",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 92,
    }, modal)
    corner(closeBtn, 7); stroke(closeBtn)

    local list = make("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -36),
        Position = UDim2.fromOffset(0, 34),
        BackgroundColor3 = T.Card2,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ZIndex = 92,
    }, modal)
    corner(list, 8); pad(list, 5); vlist(list, 4)

    closeBtn.Activated:Connect(function() overlay:Destroy() end)

    local idx = 0
    for _, watch in ipairs(watches) do
        local name, cfg = watch.Name, watch.Config
        idx += 1
        local maxPrice = type(cfg) == "table" and cfg.MaxPrice or cfg
        local minKg = type(cfg) == "table" and cfg.MinWeight or 0
        local maxKg = type(cfg) == "table" and cfg.MaxWeight or nil
        local perPet = type(cfg) == "table" and (toInt(cfg.MaxMatchesPerPet or cfg.PerPet) or toInt(CFG.Sniper.MaxMatchesPerPet) or 5) or (toInt(CFG.Sniper.MaxMatchesPerPet) or 5)
        local mode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode)
        local row = make("Frame", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T.Card,
            BorderSizePixel = 0,
            ZIndex = 93,
        }, list)
        corner(row, 7); stroke(row)
        make("TextLabel", {
            Size = UDim2.new(1, -116, 1, 0),
            Position = UDim2.fromOffset(8, 0),
            BackgroundTransparency = 1,
            Text = string.format("%02d. %s | Price %s | %s | Max %s per pet",
                idx,
                tostring(name),
                formatSniperMax(maxPrice),
                State.FormatSniperKgRange(mode, minKg, maxKg),
                tostring(perPet)
            ),
            TextColor3 = T.Text,
            Font = Enum.Font.Code,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 94,
        }, row)
        local editBtn = make("TextButton", {
            Size = UDim2.fromOffset(50, 24),
            Position = UDim2.new(1, -104, 0.5, -12),
            BackgroundColor3 = T.Card2,
            Text = "Edit",
            TextColor3 = T.Accent,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            BorderSizePixel = 0,
            ZIndex = 94,
        }, row)
        corner(editBtn, 6); stroke(editBtn)
        local delBtn = make("TextButton", {
            Size = UDim2.fromOffset(36, 24),
            Position = UDim2.new(1, -44, 0.5, -12),
            BackgroundColor3 = Color3.fromRGB(255, 72, 86),
            Text = "X",
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            BorderSizePixel = 0,
            ZIndex = 94,
        }, row)
        corner(delBtn, 6)

        editBtn.Activated:Connect(function()
            State.OpenSniperWatchEditPopup(name, overlay)
        end)
        delBtn.Activated:Connect(function()
            removeWatch(name)
            State.RefreshSniperLog()
            overlay:Destroy()
            State.OpenSniperWatchlistManager()
        end)
    end
end

State.RefreshSniperLog = function()
    local lines = {
        "Safety: exact pet " .. tostring(CFG.Sniper.RequireExactPetName) .. " | max price required " .. tostring(not CFG.Sniper.AllowNoMaxPrice),
        "Rescan before buy: " .. tostring(CFG.Sniper.RescanBeforeBuy) .. " | DryRun: " .. tostring(CFG.Sniper.DryRun),
        "------------------------------",
        "Watchlist:",
    }

    local watchCount = 0
    local watches = State.GetSortedSniperWatches()
    for _, watch in ipairs(watches) do
        local name, cfg = watch.Name, watch.Config
        watchCount += 1
        local maxPrice = type(cfg) == "table" and cfg.MaxPrice or cfg
        local minKg = type(cfg) == "table" and cfg.MinWeight or 0
        local maxKg = type(cfg) == "table" and cfg.MaxWeight or nil
        local perPet = type(cfg) == "table" and (toInt(cfg.MaxMatchesPerPet or cfg.PerPet) or toInt(CFG.Sniper.MaxMatchesPerPet) or 5) or (toInt(CFG.Sniper.MaxMatchesPerPet) or 5)
        local mode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode)
        if watchCount <= 8 then
            table.insert(lines, "- " .. tostring(name) .. " | Price " .. formatSniperMax(maxPrice) .. " | " .. State.FormatSniperKgRange(mode, minKg, maxKg) .. " | Max " .. tostring(perPet) .. " per pet")
        end
    end
    if watchCount > 8 then
        table.insert(lines, "... +" .. tostring(watchCount - 8) .. " more watches")
    end

    table.insert(lines, "------------------------------")
    table.insert(lines, "Matches: " .. tostring(#State.LastSniperMatches) .. " shown / raw " .. tostring(State.LastSniperRawCount or #State.LastSniperMatches))

    for i, m in ipairs(State.LastSniperMatches) do
        if i > 18 then
            table.insert(lines, "... +" .. tostring(#State.LastSniperMatches - 18) .. " more shown")
            break
        end

        local l = m.Listing
        table.insert(lines, string.format(
            "%02d. %s | Price %s | %s KG %.2f | owner %s",
            i,
            l.PetType,
            tostring(l.Price),
            tostring(m.SniperWeightMode or ""),
            tonumber(m.SniperWeight) or 0,
            l.OwnerName
        ))
    end

    addLines(sniperLog, lines)
end

sniperCtrl:AddButton("Add Watch", function()
    State.ApplySniperLimits()
    addWatch(sPet:Get(), sMax:Get())
    State.RefreshSniperLog()
end)

sniperCtrl:AddButton("Manage Watchlist", function()
    State.OpenSniperWatchlistManager()
end, "outline")

sniperCtrl:AddButton("Dry Run Scan", function()
    State.ApplySniperLimits()
    snipeDryRun()
    State.RefreshSniperLog()
end, "outline")

sniperCtrl:AddButton("Clear Watchlist", function()
    clearWatch()
    State.LastSniperMatches = {}
    State.LastSniperRawCount = 0
    State.RefreshSniperLog()
end, "outline")

sniperCtrl:AddButton("BUY FIRST (blocked if DryRun)", function()
    buyFirstMatch()
    State.RefreshSniperLog()
end, "outline")

--// SETTINGS PAGE
State.SettingsPage = win:CreatePage("Settings")
State.SettingSec = State.SettingsPage:AddSection("Settings")
State.FilterPathInput = State.SettingSec:AddInput("Filter Path", getConfigFolder(), function(v)
    CFG.Seller.ListingFilterPath = v
    reloadFilters()
end)

State.SettingSec:AddToggle("Compact Booth Data", CFG.UI.CompactBoothData ~= false, function(v)
    CFG.UI.CompactBoothData = v
    log("CompactBoothData", tostring(v))
end)

State.SettingSec:AddToggle("Filter Game Warn Spam", CFG.UI.FilterGameSpam ~= false, function(v)
    CFG.UI.FilterGameSpam = v
    if v then
        local ok = installWarnFilter()
        log("WarnFilter", tostring(ok))
    else
        log("WarnFilter disabled after next reload")
    end
end)

State.SettingSec:AddToggle("Enable Webhook", CFG.Webhook.Enabled == true, function(v)
    CFG.Webhook.Enabled = v
    State.SaveRuntimeSettings()
    log("Webhook", tostring(v))
end)

State.WebhookUrlInput = State.SettingSec:AddInput("Webhook URL", tostring(CFG.Webhook.Url or ""), function(v)
    CFG.Webhook.Url = tostring(v or "")
    State.SaveRuntimeSettings()
end)

State.SettingSec:AddToggle("Webhook Pet Sold", CFG.Webhook.PetSold ~= false, function(v)
    CFG.Webhook.PetSold = v
    State.SaveRuntimeSettings()
end)

State.SettingSec:AddToggle("Webhook Snipes", CFG.Webhook.SuccessfulSnipe ~= false, function(v)
    CFG.Webhook.SuccessfulSnipe = v
    State.SaveRuntimeSettings()
end)

State.SettingSec:AddButton("Test Webhook", function()
    CFG.Webhook.Url = State.WebhookUrlInput:Get()
    State.SaveRuntimeSettings()
    local wasEnabled = CFG.Webhook.Enabled
    CFG.Webhook.Enabled = true
    local sent = State.WebhookPost({
        username = "NOMO Market",
        embeds = {{
            title = "NOMO webhook test",
            color = 3447003,
            description = "Webhook is connected.",
            footer = {text = "NOMO " .. VERSION},
        }},
    })
    CFG.Webhook.Enabled = wasEnabled
    log("Webhook test sent", tostring(sent))
end, "outline")

State.SettingSec:AddButton("Reload Pet API List", function()
    loadGamePetList()
    log("PetList reloaded", tostring(#State.PetList))
end, "outline")

State.SettingSec:AddButton("Save / Reload Filter Path", function()
    CFG.Seller.ListingFilterPath = State.FilterPathInput:Get()
    State.SaveRuntimeSettings()
    reloadFilters()
    State.ReloadSniperConfig()
    log("Config path set", tostring(CFG.Seller.ListingFilterPath), "listing", getFilterPath(), "sniper", getSniperFilterPath())
end)

State.SettingSec:AddButton("Stop Script", function()
    State.Stop("settings stop")
end, "outline")

State.ActivitySec = State.SettingsPage:AddSection("Activity Log")
State.ActivityLog = State.ActivitySec:AddLog(230)

State.ActivitySec:AddButton("Refresh Activity", function()
    addLines(State.ActivityLog, State.Logs)
end)

--// Public helpers
getgenv().NOMO_V32_REFRESH_BOOTH = refreshBoothLog
getgenv().NOMO_V32_REFRESH_SELLER = function() refreshSellerLog(true) end
getgenv().NOMO_V32_REFRESH_LISTINGS = function() refreshMyListingsLog(); refreshMarketSample() end
getgenv().NOMO_V39_REMOVE_ALL_MY_LISTINGS = removeAllMyListings
getgenv().NOMO_V40_LIST_ONCE = listOnce
getgenv().NOMO_V42_LIST_UNTIL_BOOTH_FULL = listOnce
getgenv().NOMO_V49_REBUILD_BOOTH = rebuildBooth
getgenv().NOMO_V50_SMART_REBUILD_BOOTH = smartRebuildBooth
getgenv().NOMO_V61_VERIFY_LISTING = function(petName)
    petName = norm(petName or "")
    for _, l in ipairs(getMyListings()) do
        if petName == "" or norm(l.PetType) == petName then
            print("[NOMO LISTING]", tostring(l.PetType), "price", tostring(l.Price), "item", tostring(l.ItemId), "uuid", tostring(l.ListingUUID))
        end
    end
end

getgenv().NOMO_V57_MUTATION_LIST = function()
    for i, name in ipairs(getMutationList()) do print("[NOMO MUTATION]", i, name) end
    return getMutationList()
end

getgenv().NOMO_V52_DUMP_PET_TRAITS = function(petName)
    petName = norm(petName or "")
    for _, p in ipairs(getInventoryPets()) do
        if petName == "" or p.NameNorm == petName then
            print("[NOMO TRAIT]", p.Name, "Base", fmtKg(p.BaseWeight), "Visual", fmtKg(p.VisualWeight), "Age", tostring(p.Age), "RawVariant", tostring(p.Variant), "Mutation", tostring(p.Mutation))
        end
    end
end

getgenv().NOMO_V51_RELOAD_REMOTE_CONFIG = function(url)
    if url then CFG.Seller.RemoteConfigURL = tostring(url) end
    return reloadFilters()
end
getgenv().NOMO_V46_DIAGNOSE_PET = function(name)
    local lines = diagnosePetFilter(name)
    for _, line in ipairs(lines) do print("[NOMO DIAG]", line) end
    return lines
end

getgenv().NOMO_V45_SET_WEIGHT_MODE = function(mode)
    mode = tostring(mode or "Base")
    if mode ~= "Visual" then mode = "Base" end
    CFG.Seller.WeightMode = mode
    log("WeightMode", mode)
end
getgenv().NOMO_V40_RESET_SESSION_COUNT = function()
    State.ListedThisSession = 0
    log("Session list count reset")
end
getgenv().NOMO_V32_REFRESH_SNIPER = State.RefreshSniperLog
getgenv().NOMO_V32_STOP = function() State.Stop("manual") end

--// startup
ensureFolder()
loadGamePetList()
loadGameMutationList()
reloadFilters()
State.ReloadSniperConfig()
installWarnFilter()

log("Started", VERSION .. " PRIVATE UI")
refreshPills()
log("PetList", #State.PetList, "| ConfigFolder", getConfigFolder(), "| Listing", getFilterPath())

refreshBoothLog()
refreshSellerLog(false)
refreshMyListingsLog()
refreshMarketSample()
State.RefreshSniperLog()

win:SelectPage("Booth")

--// Auto smart rebuild once per server/job after first execution.
task.spawn(function()
    local autoKey = "__NOMO_MARKET_SMART_REBUILD_DONE_" .. tostring(game.JobId)
    local runningKey = "__NOMO_MARKET_SMART_REBUILD_RUNNING_" .. tostring(game.JobId)
    if not CFG.Seller.AutoSmartRebuildOnStart then
        log("Auto Smart Rebuild", "disabled")
        return
    end
    if getgenv()[autoKey] then
        log("Auto Smart Rebuild", "already done for this server")
        return
    end
    if getgenv()[runningKey] then
        log("Auto Smart Rebuild", "already running")
        return
    end

    getgenv()[runningKey] = true
    local delayTime = tonumber(CFG.Seller.StartupSmartRebuildDelay) or 8
    log("Auto Smart Rebuild scheduled", tostring(delayTime) .. "s")
    task.wait(delayTime)

    local retries = math.max(1, toInt(CFG.Seller.StartupSmartRebuildRetries) or 5)
    local retryDelay = tonumber(CFG.Seller.StartupSmartRebuildRetryDelay) or 4

    for attempt = 1, retries do
        if not State.Running then break end

        local boothReady = ensureBoothForListing()
        local filtersReady = #(getFilters() or {}) > 0
        if not boothReady then
            log("Auto Smart Rebuild waiting", "no booth", "try", tostring(attempt) .. "/" .. tostring(retries))
        elseif not filtersReady then
            log("Auto Smart Rebuild waiting", "no filters", "try", tostring(attempt) .. "/" .. tostring(retries))
        else
            local ok, result = pcall(smartRebuildBooth)
            if ok then
                getgenv()[autoKey] = true
                getgenv()[runningKey] = nil
                log("Auto Smart Rebuild complete", "try", tostring(attempt), "listed", tostring(type(result) == "table" and result.Listed or "?"))
                return
            end
            log("Auto Smart Rebuild error", tostring(result), "try", tostring(attempt) .. "/" .. tostring(retries))
        end

        task.wait(retryDelay)
    end

    getgenv()[runningKey] = nil
    log("Auto Smart Rebuild gave up", "will retry next reload/server")
end)

--// Main background loops
task.spawn(function()
    while State.Running do
        local now = os.clock()

        if CFG.Booth.AutoClaim and now - (State.LastAutoClaimAt or 0) >= (tonumber(CFG.Booth.ClaimInterval) or 10) then
            State.LastAutoClaimAt = now
            local ok, err = pcall(function()
                local target, status = findBestBooth()
                if status == "MINE" then
                    State.LastBooth = target
                elseif status == "FREE" then
                    log("AutoClaim attempting best free booth")
                    claimBestFreeBooth()
                end
            end)
            if not ok then
                log("AutoClaim error", tostring(err))
            end
        end

        if CFG.Seller.Enabled and CFG.Seller.AutoList and now - State.LastSellerScanAt >= (tonumber(CFG.Seller.ScanInterval) or 15) then
            State.LastSellerScanAt = now
            local ok, scan = pcall(buildCandidates)
            if ok then
                autoList(scan)
            else
                log("Seller scan error", tostring(scan))
            end
        end

        if CFG.Sniper.Enabled and now - State.LastSniperScanAt >= (tonumber(CFG.Sniper.ScanInterval) or 10) then
            State.LastSniperScanAt = now
            local ok, err = pcall(function()
                State.ApplySniperLimits()
                snipeDryRun()
            end)
            if not ok then log("Sniper scan error", tostring(err)) end
        end

        if CFG.Webhook.Enabled and CFG.Webhook.PetSold and now - (State.LastSoldCheckAt or 0) >= 10 then
            State.LastSoldCheckAt = now
            local ok, err = pcall(function()
                State.TrackSoldListings(getMyListings(true))
            end)
            if not ok then log("Sold webhook check error", tostring(err)) end
        end

        refreshPills()
        task.wait(1)
    end
end)
