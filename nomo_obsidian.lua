--//====================================================--
--// NOMO MARKET SELLER LITE V3.0
--// Blue Rose Full UI + Exact Booth/Listings Data Core
--// Seller focused. Live market automation by default.
--//====================================================--

local VERSION = "V14.6 STABLE FIND SELLER FALLBACK HOP"
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
    PreviewOnly = false,
    AutoList = true,
    ScanInterval = 1,
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

CFG.Fruit = CFG.Fruit or {
    Enabled = true,
    AutoList = true,
    RequireExactName = true,
    ItemType = "Holdable",
    MaxListed = 0,
}

CFG.Sniper = CFG.Sniper or {
    Enabled = true,
    DryRun = false,
    ScanInterval = 0.75,
    BuyCooldown = 0,
    MaxBuyPerMinute = 999,

    -- V3.1 display/safety limits
    MaxMatchesShown = 20,      -- UI display cap
    MaxMatchesPerPet = 0,      -- unlimited; price/KG safety does the real filtering
    MaxMatchesPerOwner = 0,    -- disabled; price/KG/watchlist safety only

    Watchlist = {},
}

local DEFAULT_SNIPE_WEBHOOK_URL = "https://discord.com/api/webhooks/1513789233452683274/F5BMQCirB8XynzuYi5HkecUOeSiY4a9U2Ujjvjn60CFHFpHehtbgBnSUaoMkzoMCAQVc"
local DEFAULT_SOLD_WEBHOOK_URL = "https://discord.com/api/webhooks/1513789342492131449/Eucoqq2nxHD_7-lrM_l8LXDKRXEJiQcsZZySuqOf6z0Mf5hakp8B5tTB_EoW62lX_rZL"

CFG.Webhook = CFG.Webhook or {
    Enabled = false,
    Url = "",
    SnipeUrl = tostring(getgenv().nomo_sniper_webhook or getgenv().NOMO_SNIPER_WEBHOOK or DEFAULT_SNIPE_WEBHOOK_URL),
    SoldUrl = tostring(getgenv().nomo_market_webhook or getgenv().NOMO_MARKET_WEBHOOK or DEFAULT_SOLD_WEBHOOK_URL),
    IconUrl = "",
    DeviceName = tostring(getgenv().nomo_device_name or getgenv().NOMO_DEVICE_NAME or ""),
    PetSold = true,
    SuccessfulSnipe = true,
}

CFG.Debug = CFG.Debug or false
if CFG.Booth.MaxMiddleDistance == nil or tonumber(CFG.Booth.MaxMiddleDistance) == 200 then
    CFG.Booth.MaxMiddleDistance = 85
end
CFG.Booth.ClaimInterval = CFG.Booth.ClaimInterval or 10
CFG.Booth.DataCacheSeconds = tonumber(CFG.Booth.DataCacheSeconds) or 1
if CFG.Booth.DataCacheSeconds < 1 then CFG.Booth.DataCacheSeconds = 1 end
CFG.Booth.ClaimVerifyAttempts = CFG.Booth.ClaimVerifyAttempts or 6
CFG.Booth.ClaimVerifyDelay = CFG.Booth.ClaimVerifyDelay or 0.35
CFG.Seller.BoothCap = 50
CFG.Seller.WeightMode = CFG.Seller.WeightMode or "Base"
CFG.Seller.ShowSkipReasons = CFG.Seller.ShowSkipReasons ~= false
CFG.Seller.RequireBoothBeforeList = CFG.Seller.RequireBoothBeforeList ~= false
CFG.Seller.ScanInterval = tonumber(CFG.Seller.ScanInterval) or 1
if CFG.Seller.ScanInterval < 0.75 then CFG.Seller.ScanInterval = 0.75 end
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
CFG.Fruit = CFG.Fruit or {}
CFG.Fruit.Enabled = CFG.Fruit.Enabled == true
CFG.Fruit.AutoList = CFG.Fruit.AutoList == true
CFG.Fruit.RequireExactName = CFG.Fruit.RequireExactName ~= false
CFG.Fruit.ItemType = tostring(CFG.Fruit.ItemType or "Holdable")
CFG.Fruit.MaxListed = 0
CFG.Listings.RemoveCooldown = CFG.Listings.RemoveCooldown or 1.2
CFG.Listings.RemoveAllMax = CFG.Listings.RemoveAllMax or 50
CFG.Listings.VerifyRemoveDelay = CFG.Listings.VerifyRemoveDelay or 0.45
CFG.Listings.VerifyRemoveAttempts = CFG.Listings.VerifyRemoveAttempts or 4
CFG.Sniper.RescanBeforeBuy = CFG.Sniper.RescanBeforeBuy ~= false
CFG.Sniper.SkipOwnListings = CFG.Sniper.SkipOwnListings ~= false
CFG.Sniper.RequireExactPetName = CFG.Sniper.RequireExactPetName ~= false
CFG.Sniper.AllowNoMaxPrice = CFG.Sniper.AllowNoMaxPrice == true
CFG.Sniper.MinTokensAfterBuy = CFG.Sniper.MinTokensAfterBuy or 0
CFG.Sniper.ScanInterval = tonumber(CFG.Sniper.ScanInterval) or 0.75
if CFG.Sniper.ScanInterval < 0.5 then CFG.Sniper.ScanInterval = 0.5 end
CFG.Performance = CFG.Performance or {}
CFG.Performance.ListingCacheSeconds = tonumber(CFG.Performance.ListingCacheSeconds) or 0.75
if CFG.Performance.ListingCacheSeconds < 0.25 then CFG.Performance.ListingCacheSeconds = 0.25 end
CFG.Performance.InventoryCacheSeconds = tonumber(CFG.Performance.InventoryCacheSeconds) or 0.75
if CFG.Performance.InventoryCacheSeconds < 0.25 then CFG.Performance.InventoryCacheSeconds = 0.25 end
CFG.Performance.BoothChoiceCacheSeconds = tonumber(CFG.Performance.BoothChoiceCacheSeconds) or 1
if CFG.Performance.BoothChoiceCacheSeconds < 0.25 then CFG.Performance.BoothChoiceCacheSeconds = 0.25 end
CFG.Performance.NoUI = false
CFG.Performance.FpsLimit = tonumber(getgenv().fps_limit) or tonumber(CFG.Performance.FpsLimit) or 0
CFG.Performance.FpsLimitSet = getgenv().fps_limit ~= nil or CFG.Performance.FpsLimitSet == true
CFG.Performance.RemovePlants = CFG.Performance.RemovePlants == true or getgenv().remove_plants == true
CFG.Performance.RemoveWeatherVisuals = CFG.Performance.RemoveWeatherVisuals == true or getgenv().remove_weather_visuals == true
CFG.Performance.FullPerformanceMode = CFG.Performance.FullPerformanceMode == true or getgenv().full_performance_mode == true
if CFG.Performance.FullPerformanceMode then
    CFG.Performance.RemovePlants = true
    CFG.Performance.RemoveWeatherVisuals = true
end
CFG.Performance.AntiAfk = CFG.Performance.AntiAfk ~= false
CFG.Performance.ClearLoadingScreens = CFG.Performance.ClearLoadingScreens ~= false
CFG.Performance.ConsoleLogs = CFG.Performance.ConsoleLogs == true
CFG.Sniper.BuyCooldown = 0
CFG.Sniper.WeightMode = CFG.Sniper.WeightMode or "Base"
CFG.Sniper.MaxMatchesPerPet = 0
CFG.Sniper.MaxMatchesPerOwner = 0
CFG.UI = CFG.UI or {
    CompactBoothData = true,
    FilterGameSpam = true,
}
CFG.UI.MaxDropdownRows = CFG.UI.MaxDropdownRows or 80
CFG.UI.FilterGameSpam = true
if CFG.UI.AutoMinimized == nil then
    CFG.UI.AutoMinimized = (getgenv().nomo_auto_minimized ~= false and getgenv().NOMO_AUTO_MINIMIZED ~= false)
end
if tostring(CFG.Webhook.SnipeUrl or "") == "" then
    CFG.Webhook.SnipeUrl = tostring(getgenv().nomo_sniper_webhook or getgenv().NOMO_SNIPER_WEBHOOK or DEFAULT_SNIPE_WEBHOOK_URL)
end
if tostring(CFG.Webhook.SoldUrl or "") == "" then
    CFG.Webhook.SoldUrl = tostring(getgenv().nomo_market_webhook or getgenv().NOMO_MARKET_WEBHOOK or DEFAULT_SOLD_WEBHOOK_URL)
end

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
    StartedAt = os.clock(),
    CurrentTab = "Booth",
    Logs = {},
    LastSellerScanAt = 0,
    LastSniperScanAt = 0,
    LastSoldCheckAt = 0,
    LastAutoClaimAt = 0,
    LastListAt = 0,
    ListTimes = {},
    ListedThisSession = 0,
    SnipedThisSession = 0,
    LastBuyAt = 0,
    BuyTimes = {},
    PetList = {},
    FilterData = {Filters = {}},
    LastScan = nil,
    LastListings = {},
    LastMyListings = {},
    LastSniperMatches = {},
    LastSniperSkipReasons = {},
    LastSniperSkipTotal = 0,
    ListingsCache = nil,
    LastListingsCacheAt = 0,
    MyListingsCache = nil,
    LastMyListingsCacheAt = 0,
    InventoryCache = nil,
    LastInventoryCacheAt = 0,
    TokenBalanceCache = nil,
    LastTokenBalanceAt = 0,
    BestBoothCache = nil,
    LastBestBoothCacheAt = 0,
    BoothDataCache = nil,
    LastBoothDataAt = 0,
    LastClonePanelAt = 0,
    LastCloneInventoryAt = 0,
    LastDashboardRefreshAt = 0,
    LastPillRefreshAt = 0,
    UiMinimized = false,
    UiRefreshDirty = true,
    CloneInventoryCount = 0,
    ClonePanelDirty = true,
    CloneInventoryDirty = true,
    PendingListUUIDs = {},
    PendingRemoveUUIDs = {},
    ManualRemoveUUIDs = {},
    KnownMyListings = {},
    KnownMyListingsReady = false,
    MissingMyListings = {},
    BoothHistoryCache = {},
    LastBoothHistoryFetchAt = 0,
    SentSoldWebhooks = {},
    SentSnipeWebhooks = {},
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
    if State.Gui then
        pcall(function() State.Gui:Destroy() end)
        State.Gui = nil
    end
end

getgenv()[STATE_KEY] = State

--//====================================================--
--// Services/modules/remotes
--//====================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
State.TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

State.InstallAntiAfk = function()
    if not CFG.Performance.AntiAfk or State.AntiAfkInstalled then return end
    State.AntiAfkInstalled = true

    local ok, virtualUser = pcall(function()
        return game:GetService("VirtualUser")
    end)
    if not ok or not virtualUser then
        print("[NOMO V3] AntiAFK unavailable")
        return
    end

    LocalPlayer.Idled:Connect(function()
        pcall(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
        print("[NOMO V3] AntiAFK pulse")
    end)
end

State.ClearLoadingScreens = function()
    if not CFG.Performance.ClearLoadingScreens then return end

    pcall(function()
        game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
    end)

    task.spawn(function()
        local pg = LocalPlayer:WaitForChild("PlayerGui", 15)
        if not pg then return end

        local loadingWords = {
            "loading",
            "preload",
            "intro",
            "memuat",
            "mohon tunggu",
            "please wait",
            "pleasewait",
        }

        local function looksLikeLoadingGui(gui)
            local n = tostring(gui.Name or ""):lower()
            for _, word in ipairs(loadingWords) do
                if n:find(word, 1, true) then
                    return true
                end
            end
            for _, inst in ipairs(gui:GetDescendants()) do
                if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                    local text = tostring(inst.Text or ""):lower()
                    for _, word in ipairs(loadingWords) do
                        if text:find(word, 1, true) then
                            return true
                        end
                    end
                end
            end
            return false
        end

        for _ = 1, 20 do
            for _, child in ipairs(pg:GetChildren()) do
                if child.Name ~= "NomoHub" and child.Name ~= "NomoHeadless" and child:IsA("ScreenGui") and looksLikeLoadingGui(child) then
                    pcall(function()
                        child.Enabled = false
                        child:Destroy()
                    end)
                end
            end
            task.wait(0.5)
        end
    end)
end

State.InstallAntiAfk()
State.ClearLoadingScreens()

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
    local modules = ReplicatedStorage:WaitForChild("Modules", 20)
    local petServices = modules and modules:WaitForChild("PetServices", 10)
    local petUtilities = petServices and petServices:WaitForChild("PetUtilities", 10)
    if petUtilities then
        PetUtilities = require(petUtilities)
    end
end)
pcall(function()
    State.FruitWeightCalculator = require(ReplicatedStorage:WaitForChild("Calculate_Weight", 20))
end)

pcall(function()
    local dataFolder = ReplicatedStorage:WaitForChild("Data", 20)
    local seedDataModule = dataFolder and dataFolder:WaitForChild("SeedData", 10)
    if seedDataModule then
        State.FruitSeedData = require(seedDataModule)
    end
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
    if CFG.Performance.ConsoleLogs then
        print("[NOMO V3]", table.concat(parts, " "))
    end
    table.insert(State.Logs, 1, text)
    while #State.Logs > 50 do table.remove(State.Logs) end
    State.ActivityLogDirty = true
    if State.RefreshActivityLog and not State.ActivityLogRefreshQueued then
        State.ActivityLogRefreshQueued = true
        task.delay(1, function()
            State.ActivityLogRefreshQueued = false
            if State.RefreshActivityLog then
                State.RefreshActivityLog()
            end
        end)
    end
end

State.Rejoin = function(reason)
    if State.RejoinRequested then return false end
    State.RejoinRequested = true
    State.Running = false
    log("Rejoin requested", tostring(reason or "manual"), tostring(game.PlaceId) .. ":" .. tostring(game.JobId))
    task.spawn(function()
        task.wait(1)
        local ok, err = pcall(function()
            State.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
        if not ok then
            log("Same-server rejoin failed", tostring(err), "trying place")
            pcall(function()
                State.TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        end
    end)
    return true
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

local function getTokenBalance(force)
    local now = os.clock()
    if not force and State.TokenBalanceCache ~= nil and (now - (State.LastTokenBalanceAt or 0)) <= 1 then
        return State.TokenBalanceCache
    end

    local ok, data = pcall(function()
        return DataService:GetData()
    end)
    if ok and type(data) == "table" and data.TradeData and data.TradeData.Tokens ~= nil then
        State.TokenBalanceCache = tonumber(data.TradeData.Tokens) or 0
        State.LastTokenBalanceAt = now
        return State.TokenBalanceCache
    end
    return State.TokenBalanceCache or 0
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
        local createWaitNeedles = {
            "please wait before trying to create another listing",
            "wait before trying to create another listing",
            "create another listing",
            "membuat listing",
            "membuat daftar",
            "buat listing",
            "buat daftar",
            "tunggu sebelum",
            "harap tunggu",
            "coba lagi",
            "listing lain",
            "daftar lain",
        }
        NotificationRemote.OnClientEvent:Connect(function(message)
            if type(message) ~= "string" then return end
            local text = string.lower(message)
            for _, needle in ipairs(createWaitNeedles) do
                if text:find(needle, 1, true) then
                    registerCreateWait("game notification")
                    return
                end
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
                return data
            end
        end
    end
    return {Filters = {}}
end

local function saveJson(path, data)
    data = type(data) == "table" and data or {}
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

State.GetFruitFilterPath = function()
    return joinConfigPath(getConfigFolder(), "fruit_listing_filters.json")
end

State.GetSettingsPath = function()
    return joinConfigPath(getConfigFolder(), "settings.json")
end

State.LoadRuntimeSettings = function()
    local data = readJson(State.GetSettingsPath())
    local defaultsVersion = "v9_9_fruit_perf_off"
    local applyLiveAutomationDefaults = type(data.Meta) ~= "table" or data.Meta.DefaultsVersion ~= defaultsVersion
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
    end
    if type(data.Fruit) == "table" then
        if data.Fruit.Enabled ~= nil then CFG.Fruit.Enabled = data.Fruit.Enabled == true end
        if data.Fruit.AutoList ~= nil then CFG.Fruit.AutoList = data.Fruit.AutoList == true end
        CFG.Fruit.MaxListed = 0
    end
    if type(data.Webhook) == "table" then
        if data.Webhook.Enabled ~= nil then CFG.Webhook.Enabled = data.Webhook.Enabled == true end
        if type(data.Webhook.Url) == "string" then CFG.Webhook.Url = data.Webhook.Url end
        if type(data.Webhook.SnipeUrl) == "string" then CFG.Webhook.SnipeUrl = data.Webhook.SnipeUrl end
        if type(data.Webhook.SoldUrl) == "string" then CFG.Webhook.SoldUrl = data.Webhook.SoldUrl end
        if type(data.Webhook.IconUrl) == "string" then CFG.Webhook.IconUrl = data.Webhook.IconUrl end
        if type(data.Webhook.DeviceName) == "string" then CFG.Webhook.DeviceName = data.Webhook.DeviceName end
        if data.Webhook.PetSold ~= nil then CFG.Webhook.PetSold = data.Webhook.PetSold == true end
        if data.Webhook.SuccessfulSnipe ~= nil then CFG.Webhook.SuccessfulSnipe = data.Webhook.SuccessfulSnipe == true end
    end
    if type(data.UI) == "table" then
        if data.UI.AutoMinimized ~= nil then CFG.UI.AutoMinimized = data.UI.AutoMinimized == true end
        if data.UI.CompactBoothData ~= nil then CFG.UI.CompactBoothData = data.UI.CompactBoothData == true end
    end
    if tostring(CFG.Webhook.DeviceName or "") == "" then CFG.Webhook.DeviceName = tostring(getgenv().nomo_device_name or getgenv().NOMO_DEVICE_NAME or "") end
    if tostring(CFG.Webhook.SnipeUrl or "") == "" then CFG.Webhook.SnipeUrl = tostring(CFG.Webhook.Url or DEFAULT_SNIPE_WEBHOOK_URL) end
    if tostring(CFG.Webhook.SoldUrl or "") == "" then CFG.Webhook.SoldUrl = tostring(CFG.Webhook.Url or DEFAULT_SOLD_WEBHOOK_URL) end
    if tostring(CFG.Webhook.SnipeUrl or "") == "" then CFG.Webhook.SnipeUrl = DEFAULT_SNIPE_WEBHOOK_URL end
    if tostring(CFG.Webhook.SoldUrl or "") == "" then CFG.Webhook.SoldUrl = DEFAULT_SOLD_WEBHOOK_URL end
    if CFG.Seller.AutoList then
        CFG.Seller.PreviewOnly = false
    end
    if applyLiveAutomationDefaults then
        CFG.Booth.AutoClaim = true
        CFG.Booth.SmartReclaim = true
        CFG.Seller.AutoList = true
        CFG.Seller.PreviewOnly = false
        CFG.Sniper.Enabled = true
        CFG.Sniper.DryRun = false
        CFG.UI.AutoMinimized = true
        CFG.Fruit.Enabled = false
        CFG.Fruit.AutoList = false
        State.PendingRuntimeDefaultsSave = true
    end
    return data
end

State.SaveRuntimeSettings = function()
    local data = {
        Meta = {
            DefaultsVersion = "v9_9_fruit_perf_off",
        },
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
        },
        Fruit = {
            Enabled = CFG.Fruit.Enabled == true,
            AutoList = CFG.Fruit.AutoList == true,
        },
        Webhook = {
            Enabled = CFG.Webhook.Enabled == true,
            Url = tostring(CFG.Webhook.Url or ""),
            SnipeUrl = tostring(CFG.Webhook.SnipeUrl or ""),
            SoldUrl = tostring(CFG.Webhook.SoldUrl or ""),
            IconUrl = tostring(CFG.Webhook.IconUrl or ""),
            DeviceName = tostring(CFG.Webhook.DeviceName or ""),
            PetSold = CFG.Webhook.PetSold == true,
            SuccessfulSnipe = CFG.Webhook.SuccessfulSnipe == true,
        },
        UI = {
            AutoMinimized = CFG.UI.AutoMinimized == true,
            CompactBoothData = CFG.UI.CompactBoothData ~= false,
        },
    }
    return saveJson(State.GetSettingsPath(), data)
end

State.LoadRuntimeSettings()
if State.PendingRuntimeDefaultsSave then
    State.PendingRuntimeDefaultsSave = false
    State.SaveRuntimeSettings()
end

--//====================================================--
--// Pet database
--//====================================================--

local function loadGamePetList()
    local names, seen = {}, {}
    local ok, petList = pcall(function()
        local data = ReplicatedStorage:WaitForChild("Data", 20)
        local registry = data and data:WaitForChild("PetRegistry", 10)
        local petListModule = registry and registry:WaitForChild("PetList", 10)
        if not petListModule then return nil end
        return require(petListModule)
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
    if #State.PetList == 0 and not State.PetListLoading then
        State.PetListLoading = true
        task.spawn(function()
            local ok, result = pcall(loadGamePetList)
            if not ok then
                log("PetList background load failed", tostring(result))
            end
            State.PetListLoading = false
            if State.PetNameInput and State.PetNameInput.SetOptions and type(State.PetList) == "table" then
                pcall(function() State.PetNameInput:SetOptions(State.PetList) end)
            end
            if State.SniperPetInput and State.SniperPetInput.SetOptions and type(State.PetList) == "table" then
                pcall(function() State.SniperPetInput:SetOptions(State.PetList) end)
            end
        end)
    end
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
        local data = ReplicatedStorage:WaitForChild("Data", 20)
        local petRegistry = data and data:WaitForChild("PetRegistry", 10)
        local mutationRegistry = petRegistry and petRegistry:WaitForChild("PetMutationRegistry", 10)
        if not mutationRegistry then return nil end
        return require(mutationRegistry)
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
        if not State.MutationListLoading then
            State.MutationListLoading = true
            task.spawn(function()
                local ok, result = pcall(loadGameMutationList)
                if not ok then
                    log("MutationList background load failed", tostring(result))
                    State.MutationList = {"Any", "Normal", "Mutated Only"}
                end
                State.MutationListLoading = false
                if State.MutationInput and State.MutationInput.SetOptions and type(State.MutationList) == "table" then
                    pcall(function() State.MutationInput:SetOptions(State.MutationList) end)
                end
            end)
        end
        return {"Any", "Normal", "Mutated Only"}
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

State.InvalidateListingCache = function()
    State.ListingsCache = nil
    State.LastListingsCacheAt = 0
    State.MyListingsCache = nil
    State.LastMyListingsCacheAt = 0
    State.InventoryCache = nil
    State.LastInventoryCacheAt = 0
    State.ClonePanelDirty = true
    State.CloneInventoryDirty = true
    State.LastClonePanelAt = 0
    if State.RefreshCloneStatus then
        task.defer(State.RefreshCloneStatus, true)
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
    State.InvalidateListingCache()
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

local function boothOwnerStatus(owner)
    if owner == nil or owner == false then
        return "FREE"
    end

    local ownerText = trim(tostring(owner))
    local ownerNorm = ownerText:lower()
    if ownerText == "" or ownerNorm == "nil" or ownerNorm == "none" or ownerNorm == "false" or ownerNorm == "0"
        or ownerNorm == "free" or ownerNorm == "empty" or ownerNorm == "kosong" or ownerNorm == "tidak ada"
    then
        return "FREE"
    end

    local myId = tostring(getPlayerId())
    if ownerText == myId or ownerText == tostring(LocalPlayer.UserId) or ownerText == tostring(LocalPlayer.Name) then
        return "MINE"
    end

    return "TAKEN"
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

    local items = {}

    for boothId, bd in pairs(data.Booths) do
        local id = tostring(boothId)
        local inst = folder:FindFirstChild(id)
        local pos = inst and getPos(inst)
        if pos then
            local owner = bd.Owner
            local status = boothOwnerStatus(owner)
            if State.AssumedBoothId == id and os.clock() < (tonumber(State.AssumedBoothUntil) or 0) then
                status = "MINE"
                owner = getPlayerId()
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

local function findBestBooth(force, maxDistOverride)
    local now = os.clock()
    if not force and type(State.BestBoothCache) == "table" and (now - (State.LastBestBoothCacheAt or 0)) <= (tonumber(CFG.Performance.BoothChoiceCacheSeconds) or 1) then
        return State.BestBoothCache.Target, State.BestBoothCache.Status
    end

    local maxDist = tonumber(maxDistOverride) or tonumber(CFG.Booth.MaxMiddleDistance) or 200
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

    local target = mine or free
    local status = mine and "MINE" or (free and "FREE" or "NONE")
    if not force then
        State.BestBoothCache = {Target = target, Status = status}
        State.LastBestBoothCacheAt = now
    end
    return target, status
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
    local maxDist = tonumber(CFG.Booth.MaxMiddleDistance) or 85
    local candidates = {}
    local seen = {}
    State.FailedClaimBooths = State.FailedClaimBooths or {}
    local now = os.clock()

    local function addCandidates(limit, label)
        for _, item in ipairs(getBoothSnapshot(true)) do
            if (item.Status == "MINE" or item.Status == "FREE") and not seen[item.Id] then
                local failedUntil = tonumber(State.FailedClaimBooths[item.Id]) or 0
                if failedUntil <= now and (item.MiddleDistance or 999999) <= limit then
                    seen[item.Id] = true
                    item.ClaimRangeLabel = label
                    table.insert(candidates, item)
                end
            end
        end
    end

    addCandidates(maxDist, "normal")
    if #candidates == 0 then
        addCandidates(999999, "fallback")
    end

    if #candidates == 0 then
        log("No FREE/MINE booth in distance", tostring(CFG.Booth.MaxMiddleDistance))
        return false
    end

    for _, target in ipairs(candidates) do
        if target.Status == "MINE" then
            if os.clock() - (tonumber(State.LastOwnBoothLogAt) or 0) > 45 then
                State.LastOwnBoothLogAt = os.clock()
                log("Already own booth", target.Id, "dist", math.floor(target.MiddleDistance or 0))
            end
            State.LastBooth = target
            State.AutoClaimOwnedSleepUntil = os.clock() + 60
            getgenv().NOMO_BOOTH_LAST_CLAIMED = target
            return true
        end
    end

    local delay = math.max(tonumber(CFG.Booth.ClaimVerifyDelay) or 0.35, 0.55)

    local function verifyTarget(target, label)
        task.wait(delay)
        for _, item in ipairs(getBoothSnapshot(true)) do
            if item.Id == target.Id then
                log("Post claim", item.Id, item.Status, "owner", item.OwnerText, tostring(label))
                if item.Status == "MINE" then
                    State.LastBooth = item
                    getgenv().NOMO_BOOTH_LAST_CLAIMED = item
                    return true
                end
                return false
            end
        end
        return false
    end

    local function sendClaim(target, arg, label)
        log("Claiming FREE booth", target.Id, "dist", math.floor(target.MiddleDistance or 0), tostring(target.ClaimRangeLabel or ""), tostring(label))
        local ok, err = pcall(function()
            ClaimBooth:FireServer(arg)
        end)
        if not ok then
            log("ClaimBooth failed", tostring(label), tostring(err))
            return false
        end
        if verifyTarget(target, label) then
            return true
        end
        State.AssumedBoothId = target.Id
        State.AssumedBoothUntil = os.clock() + 20
        State.AutoClaimOwnedSleepUntil = os.clock() + 60
        State.LastBooth = target
        State.LastBooth.Status = "MINE"
        getgenv().NOMO_BOOTH_LAST_CLAIMED = target
        State.InvalidateListingCache()
        log("Claim accepted assumed", target.Id, "data stale", tostring(label))
        return true
    end

    local limit = math.min(#candidates, 8)
    for i = 1, limit do
        local target = candidates[i]
        if target.Status == "FREE" then
            local claimed = false
            if sendClaim(target, target.Instance, "instance") then
                claimed = true
            elseif sendClaim(target, target.Id, "id") then
                claimed = true
            end
            if claimed then
                State.FailedClaimBooths[target.Id] = nil
                equipSkin()
                return true
            end
            State.FailedClaimBooths[target.Id] = os.clock() + 30
            log("Claim candidate failed", target.Id, "skip 30s")
            task.wait(0.25)
        end
    end

    log("Claim not verified", tostring(limit) .. "/" .. tostring(#candidates), "candidate(s)")
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

    local now = os.clock()
    local cached = State.ListingsCache
    if not force and type(cached) == "table" and (now - (State.LastListingsCacheAt or 0)) <= (tonumber(CFG.Performance.ListingCacheSeconds) or 0.75) then
        if includePendingRemoves then
            State.LastListings = cached
            return cached
        end

        local filtered = {}
        for _, l in ipairs(cached) do
            if not State.PendingRemoveUUIDs[tostring(l.ListingUUID or "")] then
                table.insert(filtered, l)
            end
        end
        State.LastListings = filtered
        return filtered
    end

    local data = fetchBoothData(force)
    local out = {}
    if not data then return out end

    for boothId, boothData in pairs(data.Booths) do
        local ownerId = boothData.Owner
        local pd = ownerId and data.Players[ownerId]
        if type(pd) == "table" and type(pd.Listings) == "table" and type(pd.Items) == "table" then
            for listingUUID, listing in pairs(pd.Listings) do
                listingUUID = tostring(listingUUID)

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

    State.ListingsCache = out
    State.LastListingsCacheAt = now

    if not includePendingRemoves then
        local filtered = {}
        for _, l in ipairs(out) do
            if not State.PendingRemoveUUIDs[tostring(l.ListingUUID or "")] then
                table.insert(filtered, l)
            end
        end
        State.LastListings = filtered
        return filtered
    end

    State.LastListings = out
    return out
end

local function getMyListings(force, includePendingRemoves)
    local now = os.clock()
    if not force and not includePendingRemoves and type(State.MyListingsCache) == "table" and (now - (State.LastMyListingsCacheAt or 0)) <= (tonumber(CFG.Performance.ListingCacheSeconds) or 0.75) then
        State.LastMyListings = State.MyListingsCache
        return State.MyListingsCache
    end

    local myId = tostring(getPlayerId())
    local out = {}
    for _, l in ipairs(getAllListings(force, includePendingRemoves)) do
        if tostring(l.OwnerId) == myId then
            table.insert(out, l)
        end
    end
    if not force and not includePendingRemoves then
        State.MyListingsCache = out
        State.LastMyListingsCacheAt = now
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
        State.InvalidateListingCache()
        local attempts = math.max(1, toInt(CFG.Listings.VerifyRemoveAttempts) or 4)
        local delay = tonumber(CFG.Listings.VerifyRemoveDelay) or 0.45

        for attempt = 1, attempts do
            task.wait(delay)
            if not listingStillExists(id) then
                State.PendingRemoveUUIDs[id] = nil
                State.InvalidateListingCache()
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

    local filters = data.Filters or data.listing or data.Listing or data.listings
    if type(filters) == "table" then
        State.FilterData = {Filters = filters}
        if CFG.Seller.RemoteConfigSaveLocal then
            saveFilters()
        end
        return true
    end

    return false
end

State.NormalizeListingConfigData = function(data)
    if type(data) ~= "table" then
        return {Filters = {}}
    end

    if type(data.Filters) == "table" and #data.Filters > 0 then
        return data
    end

    if type(data.listing) == "table" then
        data.Filters = data.listing
        return data
    end

    if type(data.Listing) == "table" then
        data.Filters = data.Listing
        return data
    end

    if type(data.listings) == "table" then
        data.Filters = data.listings
        return data
    end

    data.Filters = type(data.Filters) == "table" and data.Filters or {}
    return data
end

local function reloadFilters(force)
    local path = getFilterPath()
    local now = os.clock()
    if not force and State.FilterData and State.LastFilterPath == path and now - (State.LastFilterLoadAt or 0) < 5 then
        return State.FilterData
    end

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

    State.FilterData = State.NormalizeListingConfigData(readJson(path))
    if type(State.FilterData.Filters) ~= "table" or #State.FilterData.Filters == 0 then
        local fallback = "Nomo/listing_filters.json"
        if path ~= fallback then
            local fallbackData = State.NormalizeListingConfigData(readJson(fallback))
            if type(fallbackData.Filters) == "table" and #fallbackData.Filters > 0 then
                State.FilterData = fallbackData
                CFG.Seller.ListingFilterPath = "Nomo"
                State.PendingRuntimeDefaultsSave = true
                log("Local filters fallback", fallback, tostring(#fallbackData.Filters) .. " filters")
                return State.FilterData
            end
        end
    end
    local countNow = #(State.FilterData.Filters or {})
    State.LastFilterPath = path
    State.LastFilterLoadAt = now
    if force or State.LastFilterLogPath ~= path or State.LastFilterLogCount ~= countNow then
        State.LastFilterLogPath = path
        State.LastFilterLogCount = countNow
        log("Local filters loaded", path, tostring(countNow) .. " filters")
    end
    return State.FilterData
end

State.LoadLocalFilters = function()
    State.FilterData = State.NormalizeListingConfigData(readJson(getFilterPath()))
    return State.FilterData
end

saveFilters = function()
    State.FilterData = State.NormalizeListingConfigData(State.FilterData)
    return saveJson(getFilterPath(), {
        version = 1,
        listing = State.FilterData.Filters or {},
    })
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
                    MinWeight = toNumber(row.MinWeight or row.minWeight or row.MinKG or row.minKG or row.minKg or row.MinBaseWeight),
                    MaxWeight = toNumber(row.MaxWeight or row.maxWeight or row.MaxKG or row.maxKG or row.maxKg or row.MaxBaseWeight),
                    MinLevel = toInt(row.MinLevel or row.minLevel or row.MinAge or row.minAge),
                    MaxLevel = toInt(row.MaxLevel or row.maxLevel or row.MaxAge or row.maxAge),
                    Mutation = normalizeMutationConfig(row.Mutation or row.mutation or "Any"),
                    -- Hatch types like GIANT/Rainbow-hatched pets appear as different Pet names in the game API.
                    -- Keep Variant fields only for backward compatibility, but do not require them by default.
                    Variant = "Any",
                    ExcludeMutations = splitList(row.ExcludeMutations or row.ExcludedMutations or row.excludeMutations or row.excludedMutations),
                    ExcludeVariants = {},
                    MaxListedPet = toInt(row.MaxListedPet or row.maxListedPet or row.MaxListed or row.maxListed or row.MaxListing or row.maxListing) or 0,
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

local function getOwnPetsFromData(force)
    local now = os.clock()
    if not force and type(State.InventoryCache) == "table" and (now - (State.LastInventoryCacheAt or 0)) <= (tonumber(CFG.Performance.InventoryCacheSeconds) or 0.75) then
        return State.InventoryCache
    end

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
            Locked = (tradeLock == true or type(tradeLock) == "table" or type(tradeLock) == "string"),
            AlreadyListed = listed[tostring(uuid)] == true,
            Raw = petData,
        })
    end

    table.sort(out, function(a,b)
        if a.NameNorm ~= b.NameNorm then return a.NameNorm < b.NameNorm end
        return (a.Weight or 999999) < (b.Weight or 999999)
    end)

    State.InventoryCache = out
    State.LastInventoryCacheAt = now
    return out
end

State.DiagnoseFruits = function()
    local function cleanShort(v)
        local s = tostring(v or "")
        s = s:gsub("\\n", " "):gsub("\\r", " ")
        if #s > 80 then s = s:sub(1, 77) .. "..." end
        return s
    end

    local function logFruitTool(tool, label)
        if typeof(tool) ~= "Instance" or not tool:IsA("Tool") then return false end

        local harvested = tool:GetAttribute("HarvestedFruit")
        local itemType = tool:GetAttribute("ItemType")
        local fruitId = tool:GetAttribute("Id") or tool:GetAttribute("UUID") or tool:GetAttribute("ItemId")
        local fruitName = tool:GetAttribute("FruitName") or tool:GetAttribute("Fruit") or tool:GetAttribute("ItemName") or tool:GetAttribute("Name")
        local kg = tool:GetAttribute("Weight") or tool:GetAttribute("KG") or tool:GetAttribute("Kilo")
        local mutation = tool:GetAttribute("Mutation") or tool:GetAttribute("Variant")

        local looksFruit = harvested == true or tostring(itemType or ""):lower():find("fruit", 1, true) ~= nil or fruitName ~= nil
        if not looksFruit then return false end

        log("Fruit tool", label, cleanShort(tool.Name), "type=" .. cleanShort(itemType), "id=" .. cleanShort(fruitId), "fruit=" .. cleanShort(fruitName), "kg=" .. cleanShort(kg), "mut=" .. cleanShort(mutation))
        return true
    end

    log("Fruit diag started", "read-only")

    local foundTools = 0
    local backpack = LocalPlayer and LocalPlayer:FindFirstChildOfClass("Backpack")
    local character = LocalPlayer and LocalPlayer.Character
    local containers = {
        {Name = "Backpack", Obj = backpack},
        {Name = "Character", Obj = character},
    }

    for _, entry in ipairs(containers) do
        local obj = entry.Obj
        if typeof(obj) == "Instance" then
            for _, child in ipairs(obj:GetChildren()) do
                if logFruitTool(child, entry.Name) then
                    foundTools = foundTools + 1
                end
            end
        end
    end
    log("Fruit diag tools", tostring(foundTools), "candidate fruit tool(s)")

    local okData, data = pcall(function()
        return DataService:GetData()
    end)
    if okData and type(data) == "table" then
        local foundData = 0
        local function scanData(node, path, depth)
            if foundData >= 20 or depth > 5 or type(node) ~= "table" then return end

            local pathLower = tostring(path):lower()
            local itemType = node.ItemType or node.Type
            local fruitName = node.FruitName or node.Fruit or node.ItemName or node.Name
            local fruitId = node.Id or node.UUID or node.ItemId
            local kg = node.Weight or node.KG or node.Kilo
            local looksFruit = pathLower:find("fruit", 1, true) ~= nil or tostring(itemType or ""):lower():find("fruit", 1, true) ~= nil or node.HarvestedFruit == true

            if looksFruit and (fruitName ~= nil or fruitId ~= nil or itemType ~= nil) then
                foundData = foundData + 1
                log("Fruit data", tostring(path), "type=" .. cleanShort(itemType), "id=" .. cleanShort(fruitId), "name=" .. cleanShort(fruitName), "kg=" .. cleanShort(kg))
            end

            for k, v in pairs(node) do
                if type(v) == "table" then
                    local key = tostring(k)
                    local keyLower = key:lower()
                    if depth < 2 or keyLower:find("fruit", 1, true) or keyLower:find("inventory", 1, true) or keyLower:find("trade", 1, true) then
                        scanData(v, tostring(path) .. "." .. key, depth + 1)
                        if foundData >= 20 then return end
                    end
                end
            end
        end

        scanData(data, "Data", 0)
        log("Fruit diag data", tostring(foundData), "candidate data row(s)")
    else
        log("Fruit diag data failed", tostring(data))
    end

    local nonPet = 0
    for _, l in ipairs(getAllListings(true, true)) do
        if tostring(l.ItemType or "") ~= "Pet" then
            nonPet = nonPet + 1
            if nonPet <= 15 then
                local item = l.Item or {}
                log("Market non-pet", "type=" .. cleanShort(l.ItemType), "name=" .. cleanShort(item.FruitName or item.Fruit or item.ItemName or item.Name or l.PetType), "price=" .. cleanShort(l.Price), "id=" .. cleanShort(l.ItemId))
            end
        end
    end
    log("Fruit diag market", tostring(nonPet), "non-pet listing(s) visible")
end

_G.NOMO_DIAGNOSE_FRUITS = State.DiagnoseFruits
getgenv().NOMO_DIAGNOSE_FRUITS = State.DiagnoseFruits
local function findOwnPetByUUID(uuid, force)
    local target = tostring(uuid or "")
    if target == "" then return nil end

    for _, pet in ipairs(getOwnPetsFromData(force)) do
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

    local fresh = findOwnPetByUUID(pet.UUID, true)
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

State.WebhookPost = function(payload, route)
    if not CFG.Webhook or CFG.Webhook.Enabled ~= true then return false end
    local url = tostring(CFG.Webhook.Url or "")
    if route == "snipe" then
        url = tostring(CFG.Webhook.SnipeUrl or CFG.Webhook.Url or "")
    elseif route == "sold" then
        url = tostring(CFG.Webhook.SoldUrl or CFG.Webhook.Url or "")
    end
    if url == "" then return false end

    table.insert(State.WebhookQueue, {Payload = payload, Url = url})
    if State.WebhookBusy then return true end
    State.WebhookBusy = true

    task.spawn(function()
        while #State.WebhookQueue > 0 and State.Running do
            local item = table.remove(State.WebhookQueue, 1)
            local payload = type(item) == "table" and item.Payload or item
            local sendUrl = type(item) == "table" and item.Url or url
            local ok, body = pcall(function()
                return HttpService:JSONEncode(payload)
            end)
            if ok then
                local req = (type(request) == "function" and request)
                    or (type(http_request) == "function" and http_request)
                    or (syn and type(syn.request) == "function" and syn.request)
                    or (http and type(http.request) == "function" and http.request)
                if req then
                    local sent, err = pcall(function()
                        return req({
                            Url = sendUrl,
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = body,
                        })
                    end)
                    if not sent then log("Webhook failed", tostring(err)) end
                else
                    local sent, err = pcall(function()
                        return HttpService:PostAsync(sendUrl, body, Enum.HttpContentType.ApplicationJson)
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

    local titlePrefix = kind == "snipe" and "⚡ SNIPED" or "💰 BOOTH SALE"
    local color = kind == "snipe" and 0xEB44D5 or 0xFFB800
    local priceLabel = kind == "snipe" and "🪙 Bought For" or "🪙 Sold For"
    local userLabel = "👤 By User"
    local userValue = tostring(LocalPlayer.Name or "")
    local sellerValue = kind == "snipe" and tostring(extra.User or l.OwnerName or "") or ""
    local buyerValue = kind == "sold" and tostring(extra.User or l.BuyerName or "") or ""
    local deviceName = tostring(extra.DeviceName or CFG.Webhook.DeviceName or getgenv().nomo_device_name or getgenv().NOMO_DEVICE_NAME or "")
    local fromHistory = kind == "sold" and (type(l.History) == "table" or extra.Source == "history")
    local displayPrice = kind == "sold" and (tonumber(l.NetPrice) or tonumber(l.Price) or 0) or l.Price
    local description = kind == "snipe" and "Successful market snipe detected."
        or (fromHistory and "Booth sale confirmed from trade history." or "Booth sale inferred from booth listing data.")
    local displayKg = tonumber(pet.VisualWeight or pet.BaseWeight) or 0
    local fallbackIconUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=150&height=150&format=png"
    local iconUrl = tostring(CFG.Webhook.IconUrl or "")
    if iconUrl == "" then iconUrl = fallbackIconUrl end
    local fields = {}

    if userValue ~= "" and userValue ~= "Unknown" then
        table.insert(fields, {name = userLabel, value = userValue, inline = false})
    end
    if kind == "snipe" and sellerValue ~= "" and sellerValue ~= "Unknown" then
        table.insert(fields, {name = "👤 Seller", value = sellerValue, inline = true})
    end
    if kind == "sold" and buyerValue ~= "" and buyerValue ~= "Unknown" then
        table.insert(fields, {name = "👤 Buyer", value = buyerValue, inline = true})
    end
    if deviceName ~= "" and deviceName ~= "Unknown" then
        table.insert(fields, {name = "📱 Device", value = deviceName, inline = true})
    end
    table.insert(fields, {name = priceLabel, value = "**" .. commaNumber(displayPrice) .. " Tokens**", inline = true})
    table.insert(fields, {name = "🐾 Pet", value = tostring(pet.Name or "?"), inline = true})
    table.insert(fields, {name = "🧬 Mutation", value = tostring(pet.Mutation or "Normal"), inline = true})
    table.insert(fields, {name = "🎂 Age", value = tostring(pet.Age or "?"), inline = true})
    table.insert(fields, {name = "⚖️ BaseWeight", value = fmtKg(pet.BaseWeight), inline = true})
    table.insert(fields, {name = "📏 KG", value = fmtKg(displayKg), inline = true})
    table.insert(fields, {name = "🪙 Token Balance", value = commaNumber(getTokenBalance()) .. " Tokens", inline = true})
    table.insert(fields, {name = "🎒 Pet Inventory", value = tostring(#getOwnPetsFromData()) .. " pets", inline = true})
    table.insert(fields, {name = "🌐 Server", value = "```" .. tostring(game.PlaceId) .. ":" .. tostring(game.JobId) .. "```", inline = false})

    return {
        username = "NOMO Market",
        avatar_url = iconUrl,
        embeds = {{
            title = string.format("%s - %s [Age %s] [%.2f KG]", titlePrefix, tostring(pet.Name or "?"), tostring(pet.Age or "?"), displayKg),
            description = description,
            color = color,
            author = {name = "NOMO Market", icon_url = iconUrl},
            fields = fields,
            thumbnail = {url = iconUrl},
            footer = {text = "NOMO Market - " .. VERSION},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }},
    }
end

State.SendSoldWebhook = function(l, extra)
    if not CFG.Webhook or CFG.Webhook.Enabled ~= true or CFG.Webhook.PetSold ~= true then return false end
    l = type(l) == "table" and l or {}
    extra = type(extra) == "table" and extra or {}
    local now = os.clock()
    for id, expires in pairs(State.SentSoldWebhooks or {}) do
        if tonumber(expires) and expires < now then
            State.SentSoldWebhooks[id] = nil
        end
    end
    local id = tostring(l.ListingUUID or l.ItemId or "")
    local itemId = tostring(l.ItemId or "")
    if id ~= "" and State.SentSoldWebhooks[id] then return false end
    if itemId ~= "" and State.SentSoldWebhooks[itemId] then return false end
    local sent = State.WebhookPost(State.WebhookEmbedForListing("sold", l, extra), "sold")
    if sent and id ~= "" then
        State.SentSoldWebhooks[id] = now + 1800
    end
    if sent and itemId ~= "" then
        State.SentSoldWebhooks[itemId] = now + 1800
    end
    return sent
end

State.SendSnipeWebhook = function(match)
    if not CFG.Webhook or CFG.Webhook.Enabled ~= true or CFG.Webhook.SuccessfulSnipe ~= true then return false end
    if type(match) ~= "table" or type(match.Listing) ~= "table" then return false end
    local l = match.Listing
    local now = os.clock()
    for id, expires in pairs(State.SentSnipeWebhooks or {}) do
        if tonumber(expires) and expires < now then
            State.SentSnipeWebhooks[id] = nil
        end
    end
    local id = tostring(l.ListingUUID or l.ItemId or "")
    if id ~= "" and State.SentSnipeWebhooks[id] then return false end
    local sent = State.WebhookPost(State.WebhookEmbedForListing("snipe", l, {User = l.OwnerName}), "snipe")
    if sent and id ~= "" then
        State.SentSnipeWebhooks[id] = now + 1800
    end
    return sent
end

local function listingFromBoothHistory(history)
    if type(history) ~= "table" then return nil end
    if type(history.status) == "table" and tostring(history.status.result or "") == "Failed" then return nil end
    local seller = type(history.seller) == "table" and history.seller or {}
    local buyer = type(history.buyer) == "table" and history.buyer or {}
    if tostring(seller.userId or "") ~= tostring(LocalPlayer.UserId) then return nil end
    local item = type(history.item) == "table" and history.item or {}
    local data = type(item.data) == "table" and item.data or {}
    local itemData = type(data.ItemData) == "table" and data.ItemData or {}
    local petType = tostring(data.PetType or data.SkinID or itemData.ItemName or data.ItemName or "Unknown")
    local itemId = tostring(data.UUID or data.ItemId or data.ItemID or history.itemId or history.id or "")
    local historyId = tostring(history.id or history.listingId or history.listingUUID or itemId or "")
    if historyId == "" and itemId == "" then return nil end
    local grossPrice = tonumber(history.price) or tonumber(history.grossPrice) or 0
    local netPrice = tonumber(history.netPrice) or tonumber(history.NetPrice) or grossPrice
    return {
        ListingUUID = historyId ~= "" and historyId or itemId,
        ItemId = itemId ~= "" and itemId or historyId,
        PetType = petType,
        Price = netPrice,
        GrossPrice = grossPrice,
        NetPrice = netPrice,
        FinishTime = tonumber(history.finishTime),
        Status = type(history.status) == "table" and tostring(history.status.result or "") or "",
        OwnerName = tostring(seller.username or LocalPlayer.Name or ""),
        BuyerName = tostring(buyer.username or ""),
        Item = data,
        History = history,
    }
end

local function historyMatchesListing(historyListing, oldListing)
    if type(historyListing) ~= "table" or type(oldListing) ~= "table" then return false end
    local oldListingId = tostring(oldListing.ListingUUID or "")
    local oldItemId = tostring(oldListing.ItemId or "")
    local historyListingId = tostring(historyListing.ListingUUID or "")
    local historyItemId = tostring(historyListing.ItemId or "")
    if oldListingId ~= "" and (historyListingId == oldListingId or historyItemId == oldListingId) then return true end
    if oldItemId ~= "" and (historyItemId == oldItemId or historyListingId == oldItemId) then return true end
    if norm(historyListing.PetType) == norm(oldListing.PetType) and clampPrice(historyListing.Price) == clampPrice(oldListing.Price) then
        return true
    end
    return false
end

local function collectHistoryRows(root, out, depth)
    if type(root) ~= "table" or depth > 3 then return end
    local parsed = listingFromBoothHistory(root)
    if parsed then
        table.insert(out, parsed)
        return
    end
    for k, v in pairs(root) do
        if type(v) == "table" and (type(k) == "number" or k == "History" or k == "history" or k == "Data" or k == "data" or k == "Result" or k == "result" or k == "Entries" or k == "entries" or k == "Sales" or k == "sales") then
            collectHistoryRows(v, out, depth + 1)
        end
    end
end

State.FetchBoothHistorySales = function(force)
    local now = os.clock()
    if not force and type(State.BoothHistoryCache) == "table" and now - (State.LastBoothHistoryFetchAt or 0) < 8 then
        return State.BoothHistoryCache
    end
    State.LastBoothHistoryFetchAt = now
    local FetchHistory = BoothRemotes:FindFirstChild("FetchHistory")
    if not FetchHistory or type(FetchHistory.InvokeServer) ~= "function" then
        return State.BoothHistoryCache or {}
    end
    local ok, result = pcall(function()
        return FetchHistory:InvokeServer()
    end)
    if not ok then
        dlog("FetchHistory failed", tostring(result))
        return State.BoothHistoryCache or {}
    end
    local rows = {}
    collectHistoryRows(result, rows, 0)
    State.BoothHistoryCache = rows
    return rows
end

State.FindHistorySaleForListing = function(oldListing)
    for _, row in ipairs(State.FetchBoothHistorySales(true)) do
        if historyMatchesListing(row, oldListing) then
            return row
        end
    end
    return nil
end

State.ConnectBoothHistory = function()
    if State.BoothHistoryConnected then return end
    local AddToHistory = BoothRemotes:FindFirstChild("AddToHistory")
    if not AddToHistory or not AddToHistory.OnClientEvent then return end
    State.BoothHistoryConnected = true
    AddToHistory.OnClientEvent:Connect(function(history)
        local listing = listingFromBoothHistory(history)
        if not listing then return end
        local buyer = type(history.buyer) == "table" and history.buyer or {}
        local buyerName = tostring(buyer.username or "")
        local sent = State.SendSoldWebhook(listing, {User = buyerName, Source = "history"})
        table.insert(State.BoothHistoryCache, 1, listing)
        State.InvalidateListingCache()
        if sent then
            log("History sold webhook", tostring(listing.PetType), tostring(listing.Price), tostring(listing.ListingUUID))
        end
    end)
    log("Booth history sale listener connected")
end
State.ConnectBoothHistory()

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
                    local listing = missing.Listing or oldListing
                    local historySale = State.FindHistorySaleForListing(listing)
                    if historySale then
                        State.SendSoldWebhook(historySale, {User = historySale.BuyerName, Source = "history"})
                        log("Webhook sold confirmed by history", tostring(historySale.PetType), tostring(historySale.Price), id)
                    else
                        State.SendSoldWebhook(listing, {Source = "inferred"})
                        log("Webhook sold inferred", tostring(oldListing.PetType), tostring(oldListing.Price), id)
                    end
                    State.MissingMyListings[id] = nil
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

local function countMyGoodListingsByFilter(filters, myListings)
    filters = filters or getFilters()
    local counts = {}

    for _, l in ipairs(myListings or getMyListings()) do
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
    local myListings = getMyListings()
    local currentBoothListings = #myListings
    local alreadyListedByFilter = countMyGoodListingsByFilter(filters, myListings)
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
            elseif maxFruitListings > 0 and currentFruitListings >= maxFruitListings then
                reason = "fruit global cap reached"
            elseif maxFruitListings > 0 and chosenFruitTotal >= math.max(0, maxFruitListings - currentFruitListings) then
                reason = "fruit global cap"
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
        State.InvalidateListingCache()
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
        MaxMatchesPerPet = 0,
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
    local data = { version = 1, sniper = {} }
    for name, cfg in pairs(CFG.Sniper.Watchlist or {}) do
        table.insert(data.sniper, {
            pet = tostring(name),
            price = type(cfg) == "table" and (cfg.MaxPrice or cfg.maxPrice or cfg.Price or cfg.price) or cfg,
            weightMode = type(cfg) == "table" and tostring(cfg.WeightMode or cfg.weightMode or CFG.Sniper.WeightMode or "Base") or tostring(CFG.Sniper.WeightMode or "Base"),
            minKg = type(cfg) == "table" and (toNumber(cfg.MinWeight or cfg.minWeight or cfg.MinKG or cfg.minKG or cfg.minKg or cfg.MinBaseWeight) or 0) or 0,
            maxKg = type(cfg) == "table" and toNumber(cfg.MaxWeight or cfg.maxWeight or cfg.MaxKG or cfg.maxKG or cfg.maxKg or cfg.MaxBaseWeight) or nil,
            priority = type(cfg) == "table" and toInt(cfg.Priority or cfg.priority) or nil,
        })
    end
    return saveJson(getSniperFilterPath(), data)
end

local function extractSniperWatchSource(data)
    if type(data) ~= "table" then
        return nil, nil
    end

    if type(data.sniper) == "table" and next(data.sniper) ~= nil then
        return data.sniper, "sniper"
    end
    if type(data.Sniper) == "table" and next(data.Sniper) ~= nil and type(data.Sniper.Watchlist) ~= "table" then
        return data.Sniper, "sniper"
    end

    if type(data.Watchlist) == "table" and next(data.Watchlist) ~= nil then
        return data.Watchlist, "legacy-watchlist"
    end
    if type(data.watchlist) == "table" and next(data.watchlist) ~= nil then
        return data.watchlist, "legacy-watchlist"
    end

    return nil, nil
end

local function importSniperWatchlist(path)
    path = tostring(path or getSniperFilterPath())
    local data = readJson(path)
    local source, usedId = extractSniperWatchSource(data)
    if type(source) ~= "table" then
        log("Sniper config import failed", "no sniper entries", path)
        return false, 0
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
            minWeight = toNumber(cfg.MinWeight or cfg.minWeight or cfg.MinKG or cfg.minKG or cfg.minKg or cfg.MinBaseWeight) or 0
            maxWeight = toNumber(cfg.MaxWeight or cfg.maxWeight or cfg.MaxKG or cfg.maxKG or cfg.maxKg or cfg.MaxBaseWeight)
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
            MaxMatchesPerPet = 0,
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

    if imported <= 0 then
        log("Sniper config import empty", "id", tostring(usedId), "skipped", tostring(skipped), path)
        return false, 0
    end

    CFG.Sniper.Watchlist = nextWatch
    log("Sniper config imported", tostring(imported), "watch(es)", "skipped", tostring(skipped), "id", tostring(usedId), path)
    return true, imported
end

State.ReloadSniperConfig = function()
    local path = getSniperFilterPath()
    local ok, count = importSniperWatchlist(path)
    if ok and (tonumber(count) or 0) > 0 then
        return true
    end

    local fallback = "Nomo/sniper_filters.json"
    if path ~= fallback then
        local fbOk, fbCount = importSniperWatchlist(fallback)
        if fbOk and (tonumber(fbCount) or 0) > 0 then
            CFG.Seller.ListingFilterPath = "Nomo"
            State.PendingRuntimeDefaultsSave = true
            log("Sniper config fallback", fallback, tostring(fbCount) .. " watch(es)")
            return true
        end
    end

    return false
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

local function getSniperPriority(cfg)
    if type(cfg) ~= "table" then return 0 end
    return toInt(cfg.Priority or cfg.priority) or 0
end

local function getSniperMinWeight(cfg)
    if type(cfg) ~= "table" then return 0 end
    return toNumber(cfg.MinWeight or cfg.minWeight or cfg.MinKG or cfg.minKG or cfg.minKg or cfg.MinBaseWeight) or 0
end

local function getSniperMaxWeight(cfg)
    if type(cfg) ~= "table" then return nil end
    return toNumber(cfg.MaxWeight or cfg.maxWeight or cfg.MaxKG or cfg.maxKG or cfg.maxKg or cfg.MaxBaseWeight)
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
        local ap = getSniperPriority(a.Config)
        local bp = getSniperPriority(b.Config)
        if ap ~= bp then return ap > bp end
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
    local skipReasons, skipTotal = {}, 0

    local function recordSkip(l, why)
        skipTotal += 1
        if #skipReasons < 8 then
            table.insert(skipReasons, string.format("%s | price %s | %s",
                tostring(l and l.PetType or "?"),
                tostring(l and l.Price or "?"),
                tostring(why or "skipped")
            ))
        end
    end

    for name, cfg in pairs(CFG.Sniper.Watchlist or {}) do
        watchNorm[norm(name)] = {
            Name = name,
            MaxPrice = tonumber(type(cfg) == "table" and cfg.MaxPrice or cfg) or 0,
            MinWeight = getSniperMinWeight(cfg),
            MaxWeight = getSniperMaxWeight(cfg),
            WeightMode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode or cfg.weightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode),
            MaxMatchesPerPet = 0,
            Priority = getSniperPriority(cfg),
        }
    end

    local raw = {}

    for _, l in ipairs(getAllListings(force)) do
        local isOwnListing = tostring(l.OwnerId) == myId
        if (not CFG.Sniper.SkipOwnListings or not isOwnListing) and tostring(l.ItemType) == "Pet" then
            local w = watchNorm[norm(l.PetType)]

            if w then
                local match = {
                    Listing = l,
                    Watch = w,
                }
                local safe, why = validateSniperMatch and validateSniperMatch(match)
                if safe then
                    table.insert(raw, match)
                else
                    recordSkip(l, why)
                    dlog("sniper scan skipped", tostring(l.PetType), tostring(why))
                end
            end
        end
    end

    table.sort(raw, function(a, b)
        local apr = tonumber(a.Watch and a.Watch.Priority) or 0
        local bpr = tonumber(b.Watch and b.Watch.Priority) or 0
        if apr ~= bpr then
            return apr > bpr
        end

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
        local maxPerPet = 0

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
    State.LastSniperSkipReasons = skipReasons
    State.LastSniperSkipTotal = skipTotal

    local scanSig = tostring(#filtered) .. "/" .. tostring(#raw)
    local now = os.clock()
    if State.LastSniperScanLogSig ~= scanSig or (now - (State.LastSniperScanLogAt or 0)) >= 15 then
        State.LastSniperScanLogSig = scanSig
        State.LastSniperScanLogAt = now
        log("Sniper dry-run matches", #filtered, "shown from raw", #raw)
    end
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
    if minAfter > 0 and (getTokenBalance(true) - price) < minAfter then
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
                MinWeight = getSniperMinWeight(cfg),
                MaxWeight = getSniperMaxWeight(cfg),
                WeightMode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode or cfg.weightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode),
                MaxMatchesPerPet = 0,
                Priority = getSniperPriority(cfg),
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
    local firstListing = m.Listing or {}

    local safeBefore, whyBefore = validateSniperMatch(m)
    if not safeBefore then
        log("Buy blocked:", tostring(whyBefore), tostring(firstListing.PetType), "price", tostring(firstListing.Price))
        return false
    end

    if CFG.Sniper.RescanBeforeBuy then
        local fresh = findFreshSniperMatch(m)
        if not fresh then
            log("Buy blocked: listing no longer matches after rescan", tostring(firstListing.PetType), "price", tostring(firstListing.Price))
            return false
        end
        m = fresh
    end

    local l = m.Listing
    local safeAfter, whyAfter = validateSniperMatch(m)
    if not safeAfter then
        log("Buy blocked:", tostring(whyAfter), tostring(l.PetType), "price", tostring(l.Price))
        return false
    end

    local canBuy, why = canBuyNow(l.Price)
    if not canBuy then
        log("Buy blocked:", tostring(why), tostring(l.PetType), "price", tostring(l.Price))
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
            State.InvalidateListingCache()
            State.SnipedThisSession = (State.SnipedThisSession or 0) + 1
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

local SCALE = 0.8 -- compact Redfinger 2x2 window target

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
	if CFG and CFG.Performance and CFG.Performance.NoUI and State and State.NoopWidget then
		return State.NoopWidget()
	end
	if parent ~= nil and typeof(parent) ~= "Instance" then
		if State and State.NoopWidget then
			return State.NoopWidget()
		end
		parent = nil
	end
	local o = Instance.new(class)
	pcall(function() o.AutoLocalize = false end)
	for k, v in pairs(props) do o[k] = v end
	pcall(function() o.AutoLocalize = false end)
	o.Parent = parent
	return o
end
State.DisableAutoLocalize = function(root)
    pcall(function() root.AutoLocalize = false end)
    pcall(function() root.RootLocalizationTable = nil end)
    if typeof(root) == "Instance" then
        for _, child in ipairs(root:GetDescendants()) do
            pcall(function() child.AutoLocalize = false end)
        end
    end
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

local win

State.OpenConfirmPopup = function(titleText, bodyText, confirmText, onConfirm)
    if not win or not win.Gui then
        if onConfirm then onConfirm() end
        return
    end

    local overlay = make("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 120,
    }, win.Gui)

    local modal = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(360, 160),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ZIndex = 121,
    }, overlay)
    corner(modal, 10); stroke(modal); pad(modal, 12)

    make("TextLabel", {
        Size = UDim2.new(1, -8, 0, 24),
        BackgroundTransparency = 1,
        Text = tostring(titleText or "Confirm"),
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 122,
    }, modal)

    make("TextLabel", {
        Size = UDim2.new(1, -8, 0, 48),
        Position = UDim2.fromOffset(0, 34),
        BackgroundTransparency = 1,
        Text = tostring(bodyText or "Are you sure?"),
        TextColor3 = T.Sub,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 122,
    }, modal)

    local cancelBtn = make("TextButton", {
        Size = UDim2.fromOffset(130, 30),
        Position = UDim2.new(1, -272, 1, -34),
        BackgroundColor3 = T.Card2,
        Text = "Cancel",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 122,
    }, modal)
    corner(cancelBtn, 7); stroke(cancelBtn)

    local okBtn = make("TextButton", {
        Size = UDim2.fromOffset(130, 30),
        Position = UDim2.new(1, -134, 1, -34),
        BackgroundColor3 = T.Red,
        Text = tostring(confirmText or "Confirm"),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        ZIndex = 122,
    }, modal)
    corner(okBtn, 7)

    cancelBtn.Activated:Connect(function()
        overlay:Destroy()
    end)
    okBtn.Activated:Connect(function()
        overlay:Destroy()
        if onConfirm then onConfirm() end
    end)
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
	pcall(function() gui.AutoLocalize = false end)
	pcall(function() gui.RootLocalizationTable = nil end)
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DescendantAdded:Connect(function(child)
		pcall(function() child.AutoLocalize = false end)
	end)
	-- Arceus-safe: PlayerGui first. CoreGui can trigger capability errors on some executors.
	local pg = Players.LocalPlayer:WaitForChild("PlayerGui", 20)
	if not pg then error("PlayerGui not ready") end
	gui.Parent = pg

	local main = make("Frame", {
		Size = UDim2.fromOffset(700, 400),
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
		Size = UDim2.fromOffset(185, 32),
		Position = UDim2.fromOffset(164, 10),
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
		Size = UDim2.new(1, -430, 0, 32),
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
		local f = make("Frame", {Size = UDim2.fromOffset(86, 32), BackgroundColor3 = T.Card, BorderSizePixel = 0}, pillHolder)
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
	winBtn("×", -36, function() State.Stop("window close") end)

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

	local clonePanel = make("Frame", {
		Size = UDim2.fromOffset(260, 168),
		Position = cfg.ClonePanelPosition or UDim2.new(0.5, -130, 0.5, -84),
		BackgroundColor3 = T.Card,
		BorderSizePixel = 0,
		Visible = false,
	}, gui)
	corner(clonePanel, 10); stroke(clonePanel, T.Accent, 0); pad(clonePanel, 10)
	make("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 17, 31)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 11, 22)),
		}),
		Rotation = 90,
	}, clonePanel)
	make("TextLabel", {
		Size = UDim2.new(1, -22, 0, 20),
		BackgroundTransparency = 1,
		Text = "NOMO MARKET",
		TextColor3 = T.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, clonePanel)
	local cloneClose = make("TextButton", {
		Size = UDim2.fromOffset(20, 20),
		Position = UDim2.new(1, -20, 0, 0),
		BackgroundTransparency = 1,
		Text = "-",
		TextColor3 = T.Accent,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		BorderSizePixel = 0,
	}, clonePanel)
	local cloneText = make("TextLabel", {
		Size = UDim2.new(1, 0, 1, -44),
		Position = UDim2.fromOffset(0, 28),
		BackgroundTransparency = 1,
		RichText = true,
		Text = "Loading...",
		TextColor3 = T.Text,
		Font = Enum.Font.Code,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	}, clonePanel)
	local cloneFooter = make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 16),
		Position = UDim2.new(0, 0, 1, -16),
		BackgroundTransparency = 1,
		RichText = true,
		Text = "",
		TextColor3 = T.Sub,
		Font = Enum.Font.Code,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, clonePanel)
	cloneClose.Activated:Connect(function()
		clonePanel.Visible = false
	end)

	local function setMinimized(v)
		main.Visible = not v
		mini.Visible = v
		clonePanel.Visible = v
		State.UiMinimized = v == true
		State.UiRefreshDirty = true
	end

	winBtn("–", -66, function()
		setMinimized(true)
	end)

	mini.Activated:Connect(function()
		setMinimized(false)
	end)

	if cfg.AutoMinimized then
		task.defer(function()
			setMinimized(true)
		end)
	end

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
		Size = UDim2.new(0, 150, 1, 0),
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

	local navHolder = make("ScrollingFrame", {
		Size = UDim2.new(1, -16, 1, -140), Position = UDim2.fromOffset(8, 64),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = T.Border,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
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
		Size = UDim2.new(1, -166, 1, -100), Position = UDim2.fromOffset(158, 60),
		BackgroundTransparency = 1,
	}, main)

	local runtimeFooter = make("Frame", {
		Size = UDim2.new(1, -174, 0, 26),
		Position = UDim2.new(0, 158, 1, -34),
		BackgroundColor3 = T.Card,
		BorderSizePixel = 0,
	}, main)
	corner(runtimeFooter, 8); stroke(runtimeFooter)
	local runtimeFooterText = make("TextLabel", {
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1,
		RichText = true,
		Text = "Session: ...",
		TextColor3 = T.Text,
		Font = Enum.Font.Code,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, runtimeFooter)

	local window = {Pills = pills, SearchBox = search, CloneStatusText = cloneText, CloneFooterText = cloneFooter, RuntimeFooterText = runtimeFooterText}
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
				local rawValue = tostring(default or "")
				local displayTransform, focused
				local box = make("TextBox", {
					Size = UDim2.fromOffset(130, 24), Position = UDim2.new(1, -130, 0.5, -12),
					BackgroundColor3 = T.Card2, Text = rawValue, TextColor3 = T.Text,
					Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false, BorderSizePixel = 0,
				}, row)
				corner(box, 6); stroke(box); pad(box, 0, 0, 6, 6)
				local function displayValue(v)
					if displayTransform then return displayTransform(v) end
					return tostring(v or "")
				end
				box.Focused:Connect(function()
					focused = true
				end)
				box.FocusLost:Connect(function()
					focused = false
					if displayTransform and tostring(box.Text or "") == "" then
						box.Text = displayValue(rawValue)
						return
					end
					rawValue = tostring(box.Text or "")
					if cb then cb(rawValue) end
					box.Text = displayValue(rawValue)
				end)
				return {
					Set = function(_, v)
						rawValue = tostring(v or "")
						box.Text = focused and rawValue or displayValue(rawValue)
					end,
					Get = function() return rawValue end,
					SetClearOnFocus = function(_, v) box.ClearTextOnFocus = v == true end,
					SetDisplayTransform = function(_, fn)
						displayTransform = fn
						box.Text = focused and rawValue or displayValue(rawValue)
					end,
				}
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
                    if State.DisableAutoLocalize then State.DisableAutoLocalize(overlay) end
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
                    Open = function() overlay.Visible = true; if State.DisableAutoLocalize then State.DisableAutoLocalize(overlay) end; searchBox.Text = ""; rebuildList() end,
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
				function log:AddRich(text)
					make("TextLabel", {
						Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1,
						RichText = true,
						Text = ("%s  %s"):format(os.date("%H:%M:%S"), tostring(text or "")),
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

State.NoopWidget = function(default)
    local obj = {}
    setmetatable(obj, {
        __index = function(_, key)
            if key == "Get" then
                return function() return default or "" end
            elseif key == "Set" or key == "Add" or key == "Clear" or key == "Refresh" then
                return function() end
            elseif key == "GetChildren" then
                return function() return {} end
            elseif key == "IsA" then
                return function() return false end
            elseif key == "Destroy" then
                return function() end
            elseif key == "Activated" or key == "MouseButton1Click" or key == "FocusLost" or key == "InputBegan" or key == "InputChanged" or key == "Changed" then
                return {Connect = function() end}
            end
            return function() return State.NoopWidget(default) end
        end,
    })
    return obj
end

State.ApplyPerformanceMode = function()
    if CFG.Performance.FpsLimitSet and type(setfpscap) == "function" then
        pcall(setfpscap, CFG.Performance.FpsLimit)
    end

    if CFG.Performance.FullPerformanceMode then
        pcall(function()
            game:GetService("RunService"):Set3dRenderingEnabled(false)
        end)
        pcall(function()
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 100000
        end)
    end

    if CFG.Performance.RemoveWeatherVisuals or CFG.Performance.RemovePlants then
        pcall(function()
            for _, inst in ipairs(workspace:GetDescendants()) do
                local className = inst.ClassName
                local name = tostring(inst.Name or ""):lower()
                if CFG.Performance.RemoveWeatherVisuals and (className == "ParticleEmitter" or className == "Trail" or className == "Beam" or className == "Smoke" or className == "Fire" or className == "Sparkles") then
                    inst.Enabled = false
                elseif CFG.Performance.RemovePlants and (name:find("plant", 1, true) or name:find("fruit", 1, true)) and inst:IsA("BasePart") then
                    inst.LocalTransparencyModifier = 1
                    inst.CanCollide = false
                elseif CFG.Performance.FullPerformanceMode and (className == "Decal" or className == "Texture") then
                    inst.Transparency = 1
                end
            end
        end)
    end
end

State.CreateHeadlessWindow = function()
    State.ApplyPerformanceMode()

    local gui = Instance.new("ScreenGui")
    gui.Name = "NomoHeadless"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local pg = Players.LocalPlayer:WaitForChild("PlayerGui", 20)
    if not pg then error("PlayerGui not ready") end
    gui.Parent = pg

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local panel = Instance.new("TextLabel")
    panel.AnchorPoint = Vector2.new(0.5, 0)
    panel.Position = UDim2.new(0.5, 0, 0, 26)
    panel.Size = UDim2.fromOffset(520, 220)
    panel.BackgroundTransparency = 1
    panel.TextColor3 = Color3.fromRGB(235, 241, 255)
    panel.Font = Enum.Font.GothamBold
    panel.TextSize = 24
    panel.TextWrapped = true
    panel.TextYAlignment = Enum.TextYAlignment.Top
    panel.Text = "NOMO Market loading..."
    panel.Parent = gui
    State.PerfStatsLabel = panel

    local section = State.NoopWidget()
    local page = State.NoopWidget()
    page.AddSection = function() return section end
    page.AddSectionInRow = function() return section end

    return {
        Gui = gui,
        Pills = {Status = State.NoopWidget(), Booth = State.NoopWidget(), Balance = State.NoopWidget()},
        CreatePage = function() return page end,
        SelectPage = function() end,
    }
end

State.UpdatePerfStats = function()
    if not State.PerfStatsLabel then return end
    local session = math.floor(os.clock())
    local mins = math.floor(session / 60)
    local secs = session % 60
    State.PerfStatsLabel.Text = table.concat({
        "NOMO MARKET",
        "Mode: PERFORMANCE / NO UI",
        "Booth: " .. tostring(State.LastBooth and State.LastBooth.Id or "?"),
        "Tokens: " .. commaNumber(getTokenBalance()),
        "Listed Session: " .. tostring(State.ListedThisSession or 0),
        "Listings Cached: " .. tostring(type(State.ListingsCache) == "table" and #State.ListingsCache or 0),
        "Sniper Matches: " .. tostring(type(State.LastSniperMatches) == "table" and #State.LastSniperMatches or 0),
        string.format("Session: %dm %02ds", mins, secs),
        "Version: " .. VERSION,
    }, "\n")
end

win = (CFG.Performance.NoUI and State.CreateHeadlessWindow() or Library:CreateWindow({
    TitleAccent = "NOMO",
    Title = "MARKET",
    Subtitle = "SELLER LITE",
    PlanText = "PRIVATE DATA CORE",
    VersionText = VERSION,
    MiniText = "NOMO",
    AutoMinimized = CFG.UI.AutoMinimized == true,

    -- bottom-left: avoids the game's top and center UI.
    MiniPosition = UDim2.new(0, 12, 1, -210),

    -- Optional later:
    -- MiniImage = "rbxassetid://YOUR_IMAGE_ID",
    -- MiniImage = "Nomo/blue_rose.png",
}))
State.Gui = win.Gui

State.SetBootStatus = function(step)
    State.LastBootStep = tostring(step or "?")
    local text = "Boot: " .. State.LastBootStep
    if not State.BootComplete and win and win.CloneStatusText then
        pcall(function()
            win.CloneStatusText.Text = text
        end)
    end
    if win and win.Pills and win.Pills.Status and win.Pills.Status.Set then
        pcall(function()
            win.Pills.Status:Set(State.LastBootStep, T.Accent)
        end)
    end
end

State.SetBootStatus("window ready")

if not CFG.Performance.NoUI then
    State.SetBootStatus("performance")
    State.ApplyPerformanceMode()
end

State.SetBootStatus("pills")
win.Pills.Status:Set("Boot", T.Accent)
win.Pills.Booth:Set("Data", T.Accent)
win.Pills.Balance:Set("...", T.Sub)
task.defer(function()
    local okBalance, balance = pcall(getTokenBalance)
    if okBalance then
        win.Pills.Balance:Set(commaNumber(balance), T.Green)
    end
end)

local function richEscape(v)
    return tostring(v or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

local function formatEventLine(line)
    line = tostring(line or "")
        :gsub("^%d%d:%d%d:%d%d%s*|%s*", "")
        :gsub("^%[%d%d:%d%d:%d%d%]%s*", "")
    local low = line:lower()
    local tag, col
    if low:find("failed", 1, true) or low:find("unsafe", 1, true) or low:find("error", 1, true) then
        tag, col = "ERR", T.Red
    elseif low:find("warn", 1, true) or low:find("wait", 1, true) or low:find("skip", 1, true) then
        tag, col = "WARN", T.Yellow
    elseif low:find("started", 1, true) or low:find("attempt", 1, true) or low:find("scan", 1, true) then
        tag, col = "RUN", T.Accent
    elseif low:find("ok", 1, true) or low:find("done", 1, true) or low:find("complete", 1, true) or low:find("verified", 1, true) then
        tag, col = "OK", T.Green
    else
        tag, col = "INFO", T.Sub
    end
    return ('<font color="#%s">[%s]</font> %s'):format(col:ToHex(), tag, richEscape(line))
end

local function addLines(logObj, lines, colorEvents)
    logObj:Clear()
    for _, line in ipairs(lines) do
        if colorEvents and logObj.AddRich then
            logObj:AddRich(formatEventLine(line))
        else
            logObj:Add(line)
        end
    end
end

local function safeLine(v)
    return tostring(v or "-")
end

local refreshSellerLog

State.RefreshCloneStatus = function(forceInventory)
    if not win.CloneStatusText then return end
    local boothText = "..."
    local okBooth, best = pcall(findBestBooth)
    if okBooth and best then
        boothText = best.Status or "No Booth"
    elseif State.LastBooth and State.LastBooth.Status then
        boothText = State.LastBooth.Status
    end
    local listings = State.LastMyListings
    if type(listings) ~= "table" then
        local okListings, listingResult = pcall(getMyListings)
        listings = (okListings and type(listingResult) == "table") and listingResult or {}
    end
    local device = tostring(CFG.Webhook.DeviceName or getgenv().nomo_device_name or getgenv().NOMO_DEVICE_NAME or "")
    if device == "" then device = tostring(LocalPlayer.Name or "NOMO") end
    local uptime = math.max(0, math.floor(os.clock() - (State.StartedAt or os.clock())))
    local session = string.format("%02d:%02d", math.floor(uptime / 60), uptime % 60)
    local seller = CFG.Seller.AutoList and "ON" or (CFG.Seller.PreviewOnly and "PREVIEW" or "OFF")
    local sniper = CFG.Sniper.Enabled and (CFG.Sniper.DryRun and "DRY" or "ON") or "OFF"
    local webhook = CFG.Webhook.Enabled and "ON" or "OFF"
    if forceInventory or State.CloneInventoryDirty or os.clock() - (State.LastCloneInventoryAt or 0) >= 10 then
        State.LastCloneInventoryAt = os.clock()
        local okPets, pets = pcall(getOwnPetsFromData, forceInventory or State.CloneInventoryDirty)
        if okPets and type(pets) == "table" then
            State.CloneInventoryCount = #pets
        end
        State.CloneInventoryDirty = false
    end
    State.ClonePanelDirty = false
    State.LastClonePanelAt = os.clock()
    local function miniPad(label)
        label = tostring(label or "")
        return label .. string.rep(" ", math.max(1, 9 - #label))
    end
    local function miniRow(label, value, color)
        return ('<font color="#%s">%s</font><font color="#%s">%s</font>'):format(
            T.Sub:ToHex(),
            miniPad(label),
            (color or T.Text):ToHex(),
            tostring(value)
        )
    end
    win.CloneStatusText.Text = table.concat({
        miniRow("Device", device, T.Text),
        miniRow("Booth", boothText .. "  " .. tostring(#listings) .. "/50", boothText == "MINE" and T.Green or T.Sub),
        miniRow("Pets", tostring(State.CloneInventoryCount or 0), T.Red),
        miniRow("Seller", seller .. "  +" .. tostring(State.ListedThisSession or 0), CFG.Seller.AutoList and T.Green or T.Sub),
        miniRow("Sniper", sniper .. "  +" .. tostring(State.SnipedThisSession or 0), CFG.Sniper.Enabled and T.Green or T.Sub),
        miniRow("Webhook", webhook, CFG.Webhook.Enabled and T.Green or T.Sub),
        miniRow("Session", session, T.Accent),
    }, "\n")
    if win.CloneFooterText then
        win.CloneFooterText.Text = ('<font color="#%s">FPS</font> --   |   <font color="#%s">RAM</font> --   |   <font color="#%s">Ping</font> --'):format(
            T.Sub:ToHex(),
            T.Sub:ToHex(),
            T.Sub:ToHex()
        )
    end
end

State.RefreshDashboard = function()
    if State.DashLog then
        State.DashLog:Clear()
        for i = 1, math.min(5, #State.Logs) do
            State.DashLog:AddRich(formatEventLine(State.Logs[i]))
        end
    end
    if win.RuntimeFooterText then
        local session = math.floor(os.clock())
        local mins = math.floor(session / 60)
        local secs = session % 60
        local boothText = "..."
        local okBooth, best = pcall(findBestBooth)
        if okBooth and best then
            boothText = best.Status or "No Booth"
        elseif State.LastBooth and State.LastBooth.Status then
            boothText = State.LastBooth.Status
        end
        win.RuntimeFooterText.Text = ('<font color="#%s">Session:</font> <font color="#%s">%dm %02ds</font>   |   <font color="#%s">Seller:</font> <font color="#%s">%s/%s</font>   |   <font color="#%s">Sniper:</font> <font color="#%s">%s/%s</font>   |   <font color="#%s">Booth:</font> <font color="#%s">%s</font>   |   <font color="#%s">Pets:</font> <font color="#%s">%s</font>'):format(
            T.Sub:ToHex(),
            T.Accent:ToHex(),
            mins,
            secs,
            T.Sub:ToHex(),
            (CFG.Seller.AutoList and T.Green or T.Sub):ToHex(),
            CFG.Seller.AutoList and "ON" or "OFF",
            tostring(State.ListedThisSession or 0),
            T.Sub:ToHex(),
            (CFG.Sniper.Enabled and T.Green or T.Sub):ToHex(),
            CFG.Sniper.Enabled and "ON" or "OFF",
            tostring(State.SnipedThisSession or 0),
            T.Sub:ToHex(),
            (boothText == "MINE" and T.Green or T.Sub):ToHex(),
            tostring(boothText),
            T.Sub:ToHex(),
            T.Text:ToHex(),
            tostring(State.CloneInventoryCount or 0)
        )
    end
end

local function refreshPills()
    local now = os.clock()
    local minimized = State.UiMinimized == true
    local pillInterval = minimized and 10 or 1
    local cloneInterval = minimized and 10 or 2
    local dashboardInterval = minimized and 30 or 10

    if State.UiRefreshDirty or now - (State.LastPillRefreshAt or 0) >= pillInterval then
        State.LastPillRefreshAt = now
        local boothText = "..."
        local okBooth, best = pcall(findBestBooth)
        if okBooth and best then
            boothText = best.Status or "No Booth"
        elseif State.LastBooth and State.LastBooth.Status then
            boothText = State.LastBooth.Status
        end
        if not minimized or State.UiRefreshDirty then
            win.Pills.Booth:Set(boothText, boothText == "MINE" and T.Green or (boothText == "FREE" and T.Yellow or T.Sub))
            local okBalance, balance = pcall(getTokenBalance)
            win.Pills.Balance:Set(commaNumber(okBalance and balance or 0), T.Green)
        end
        State.UpdatePerfStats()
    end

    if State.ClonePanelDirty or now - (State.LastClonePanelAt or 0) >= cloneInterval then
        local okClone, cloneErr = pcall(State.RefreshCloneStatus, State.CloneInventoryDirty)
        if not okClone then
            State.LastClonePanelAt = now
            if win.CloneStatusText then
                win.CloneStatusText.Text = '<font color="#ff5c7a">Status refresh paused</font>\nScript still running'
            end
            dlog("Clone status refresh error", tostring(cloneErr))
        end
    end

    if (not minimized) and (State.UiRefreshDirty or now - (State.LastDashboardRefreshAt or 0) >= dashboardInterval) then
        State.LastDashboardRefreshAt = now
        local okDash, dashErr = pcall(State.RefreshDashboard)
        if not okDash then dlog("Dashboard refresh error", tostring(dashErr)) end
    end

    State.UiRefreshDirty = false
end


--// DASHBOARD PAGE
State.SetBootStatus("dashboard ui")
State.DashboardPage = win:CreatePage("Dashboard")
State.DashToggleRow = State.DashboardPage:AddRow()
State.DashAutoSec = State.DashboardPage:AddSectionInRow(State.DashToggleRow, "Auto List", 1 / 3)
State.DashSniperSec = State.DashboardPage:AddSectionInRow(State.DashToggleRow, "Sniper", 1 / 3)
State.DashWebhookSec = State.DashboardPage:AddSectionInRow(State.DashToggleRow, "Webhook", 1 / 3)

State.DashAutoSec:AddToggle("Enabled", CFG.Seller.AutoList, function(v)
    CFG.Seller.AutoList = v
    CFG.Seller.PreviewOnly = not v
    State.SaveRuntimeSettings()
    log("Dashboard AutoList", tostring(v))
end)
State.DashSniperSec:AddToggle("Enabled", CFG.Sniper.Enabled, function(v)
    CFG.Sniper.Enabled = v
    if v then CFG.Sniper.DryRun = false end
    State.SaveRuntimeSettings()
    log("Dashboard Sniper", tostring(v), "DryRun", tostring(CFG.Sniper.DryRun))
end)
State.DashWebhookSec:AddToggle("Enabled", CFG.Webhook.Enabled == true, function(v)
    CFG.Webhook.Enabled = v
    State.SaveRuntimeSettings()
    log("Dashboard Webhook", tostring(v))
end)

State.DashActionRow = State.DashboardPage:AddRow()
State.DashRebuildSec = State.DashboardPage:AddSectionInRow(State.DashActionRow, "Rebuild", 0.20)
State.DashListingsSec = State.DashboardPage:AddSectionInRow(State.DashActionRow, "My Listing", 0.20)
State.DashFiltersSec = State.DashboardPage:AddSectionInRow(State.DashActionRow, "Filters", 0.20)
State.DashSniperNavSec = State.DashboardPage:AddSectionInRow(State.DashActionRow, "Sniper", 0.20)
State.DashFruitSec = State.DashboardPage:AddSectionInRow(State.DashActionRow, "Fruit", 0.20)

State.DashRebuildSec:AddButton("Smart Rebuild", function()
    task.spawn(function()
        smartRebuildBooth()
        task.wait(0.5)
        State.RefreshDashboard()
    end)
end)
State.DashListingsSec:AddButton("Manage", function()
    if State.OpenMyListingsManager then
        State.OpenMyListingsManager()
    else
        win:SelectPage("Listings")
    end
end, "outline")
State.DashFiltersSec:AddButton("Manage", function()
    if State.OpenFilterManager then
        State.OpenFilterManager()
    else
        win:SelectPage("Seller")
    end
end, "outline")
State.DashSniperNavSec:AddButton("Manage", function()
    if State.OpenSniperWatchlistManager then
        State.OpenSniperWatchlistManager()
    else
        win:SelectPage("Sniper")
    end
end, "outline")
State.DashSniperNavSec:AddButton("Find Seller", function()
    log("Dashboard Find Seller watchlist")
    State.FindSellerHopWatchlist()
end, "outline")

State.DashFruitSec:AddButton("Manage", function()
    if State.OpenFruitFilterManager then
        State.OpenFruitFilterManager()
    else
        win:SelectPage("Fruit")
    end
end, "outline")
State.DashEventsSec = State.DashboardPage:AddSection("Recent Events")
State.DashLog = State.DashEventsSec:AddLog(64)

--// BOOTH PAGE
State.SetBootStatus("booth ui")
local boothPage = win:CreatePage("Booth")
State.BoothControlRow = boothPage:AddRow()
State.BoothAutoSec = boothPage:AddSectionInRow(State.BoothControlRow, "Auto Claim", 1 / 3)
State.BoothReclaimSec = boothPage:AddSectionInRow(State.BoothControlRow, "Smart Reclaim", 1 / 3)
State.BoothDistanceSec = boothPage:AddSectionInRow(State.BoothControlRow, "Distance", 1 / 3)

State.BoothAutoSec:AddToggle("Enabled", CFG.Booth.AutoClaim, function(v)
    CFG.Booth.AutoClaim = v
    State.SaveRuntimeSettings()
    log("AutoClaim", tostring(v))
end)


State.BoothReclaimSec:AddToggle("Enabled", CFG.Booth.SmartReclaim, function(v)
    CFG.Booth.SmartReclaim = v
    State.SaveRuntimeSettings()
    log("SmartReclaim", tostring(v))
end)

local boothMaxDist = State.BoothDistanceSec:AddInput("Max Middle", tostring(CFG.Booth.MaxMiddleDistance), function(v)
    CFG.Booth.MaxMiddleDistance = toNumber(v) or CFG.Booth.MaxMiddleDistance
end)

State.BoothActionRow = boothPage:AddRow()
State.BoothClaimSec = boothPage:AddSectionInRow(State.BoothActionRow, "Claim", 1 / 3)
State.BoothRefreshSec = boothPage:AddSectionInRow(State.BoothActionRow, "Refresh", 1 / 3)
State.BoothRebuildSec = boothPage:AddSectionInRow(State.BoothActionRow, "Rebuild", 1 / 3)

State.BoothInfoRow = boothPage:AddRow()
State.BoothStatusSec = boothPage:AddSectionInRow(State.BoothInfoRow, "Booth Status", 0.42)
State.BoothDataSec = boothPage:AddSectionInRow(State.BoothInfoRow, "Booth Data", 0.58)

State.BoothStatusLabel = State.BoothStatusSec:AddLabel("Booth: checking...", T.Sub)
State.BoothListingLabel = State.BoothStatusSec:AddLabel("Listings: ...", T.Text)
State.BoothSkinLabel = State.BoothStatusSec:AddLabel("Skin: " .. tostring(CFG.Booth.BoothSkin or "Default"), T.Text)
State.BoothClaimLabel = State.BoothStatusSec:AddLabel("Claim: every " .. tostring(CFG.Booth.ClaimInterval or 10) .. "s", T.Sub)

local boothLog = State.BoothDataSec:AddLog(112)

local function refreshBoothLog()
    refreshPills()
    CFG.Booth.MaxMiddleDistance = toNumber(boothMaxDist:Get()) or CFG.Booth.MaxMiddleDistance
    CFG.Booth.BoothSkin = tostring(CFG.Booth.BoothSkin or "Default")
    CFG.Booth.ClaimInterval = tonumber(CFG.Booth.ClaimInterval) or 10

    local items = getBoothSnapshot()
    local target, status = findBestBooth()
    local myListings = getMyListings()
    if State.BoothStatusLabel then
        State.BoothStatusLabel:Set("Booth: " .. tostring(status) .. " | " .. tostring(target and tostring(target.Id):sub(1, 8) or "none"), status == "MINE" and T.Green or (status == "FREE" and T.Yellow or T.Sub))
        State.BoothListingLabel:Set("Listings: " .. tostring(#myListings) .. "/50", T.Text)
        State.BoothSkinLabel:Set("Skin: " .. tostring(CFG.Booth.BoothSkin or "Default"), T.Text)
        State.BoothClaimLabel:Set("Claim: every " .. tostring(CFG.Booth.ClaimInterval or 10) .. "s | max d" .. tostring(CFG.Booth.MaxMiddleDistance), T.Sub)
    end
    local lines = {
        "Booths: " .. tostring(#items),
        "Best: " .. tostring(target and (target.Id:sub(1, 8) .. "...") or "None") .. " / " .. tostring(status),
        "------------------------------",
    }

    for i, item in ipairs(items) do
        if i > 8 then
            table.insert(lines, "... +" .. tostring(#items - 8) .. " more")
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

State.BoothClaimSec:AddButton("Claim Best Free", function()
    claimBestFreeBooth()
    refreshBoothLog()
end)
State.BoothRefreshSec:AddButton("Refresh Data", refreshBoothLog, "outline")
State.BoothRebuildSec:AddButton("Smart Rebuild", function()
    task.spawn(function()
        smartRebuildBooth()
        task.wait(0.6)
        refreshBoothLog()
    end)
end)

--// SELLER PAGE
State.SetBootStatus("seller ui")
local sellerPage = win:CreatePage("Seller")
local sellerCtrl = sellerPage:AddSection("Seller Control")
sellerCtrl.Frame.LayoutOrder = 30
local filterRow = sellerPage:AddRow()
filterRow.LayoutOrder = 10
local filterSec = sellerPage:AddSectionInRow(filterRow, "Filter Builder", 0.5)
local filterRangeSec = sellerPage:AddSectionInRow(filterRow, "Filter Limits", 0.5)

State.SellerCompactRow = function(section, height)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, height or 30),
        BackgroundTransparency = 1,
    }, section.Frame)
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, row)
    return row
end

State.SellerCompactToggle = function(row, text, default, cb)
    local state = default == true
    local btn = make("TextButton", {
        Size = UDim2.new(0.5, -4, 1, 0),
        BackgroundColor3 = T.Card2,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, row)
    corner(btn, 7); stroke(btn)
    make("TextLabel", {
        Size = UDim2.new(1, -52, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = T.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, btn)
    local bg = make("Frame", {
        Size = UDim2.fromOffset(34, 18),
        Position = UDim2.new(1, -42, 0.5, -9),
        BackgroundColor3 = state and T.Accent or T.Toggle0,
        BorderSizePixel = 0,
    }, btn)
    corner(bg, 9)
    local knob = make("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = T.Text,
        BorderSizePixel = 0,
    }, bg)
    corner(knob, 7)
    local function set(v)
        state = v == true
        bg.BackgroundColor3 = state and T.Accent or T.Toggle0
        knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        if cb then cb(state) end
    end
    btn.Activated:Connect(function() set(not state) end)
    return {Set = function(_, v) set(v) end, Get = function() return state end}
end

State.SellerCompactButton = function(row, text, cb, style)
    local filled = style ~= "outline"
    local btn = make("TextButton", {
        Size = UDim2.new(1 / 3, -6, 1, 0),
        BackgroundColor3 = filled and T.Accent or T.Card2,
        Text = text,
        TextColor3 = filled and Color3.new(1, 1, 1) or T.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
    }, row)
    corner(btn, 7)
    if not filled then stroke(btn, T.Accent, 0.45) end
    btn.Activated:Connect(function() if cb then cb() end end)
    return btn
end

State.SellerToggleRow = State.SellerCompactRow(sellerCtrl, 30)
State.SellerCompactToggle(State.SellerToggleRow, "Auto List", CFG.Seller.AutoList, function(v)
    CFG.Seller.AutoList = v
    CFG.Seller.PreviewOnly = not v
    State.SaveRuntimeSettings()
    log("AutoList", tostring(v))
end)

State.SellerCompactToggle(State.SellerToggleRow, "Preview Only", CFG.Seller.PreviewOnly, function(v)
    CFG.Seller.PreviewOnly = v
    if v then CFG.Seller.AutoList = false end
    State.SaveRuntimeSettings()
    log("PreviewOnly", tostring(v))
end)

State.SellerActionRow = State.SellerCompactRow(sellerCtrl, 32)
State.SellerCompactButton(State.SellerActionRow, "LIST UNTIL BOOTH FULL", function()
    CFG.Seller.BoothCap = 50
    CFG.Seller.ListOnceMax = 50
    CFG.Seller.MaxAutoListSession = 50
    task.spawn(function()
        listOnce(50)
    end)
end)

State.SellerCompactButton(State.SellerActionRow, "REMOVE ALL LISTINGS", function()
    task.spawn(function()
        removeAllMyListings(CFG.Listings.RemoveAllMax or 50)
        task.wait(0.6)
        refreshSellerLog(true)
    end)
end, "outline")

State.SellerCompactButton(State.SellerActionRow, "RELOAD CONFIG", function()
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

local petInput = filterSec:AddSearchDropdown("Pet", State.PetList or {}, "Ankylosaurus")
State.PetNameInput = petInput
local priceInput = filterSec:AddInput("Price", "111")
local mutationInput = filterSec:AddSearchDropdown("Mutation", State.MutationList or {"Any", "Normal", "Mutated Only"}, "Any")
State.MutationInput = mutationInput
local minKgInput = filterRangeSec:AddInput("Min Base KG", "0")
local maxKgInput = filterRangeSec:AddInput("Max Base KG", "3")
local minAgeInput = filterRangeSec:AddInput("Min Age", "1")
local maxAgeInput = filterRangeSec:AddInput("Max Age", "100")
local variantInput = { Get = function() return "Any" end } -- hatch type is part of Pet name, e.g. GIANT Barn Owl
local maxListedInput = filterRangeSec:AddInput("Per Filter Cap", "5")
filterRangeSec:AddButton("Manage Filters", function()
    if State.OpenFilterManager then
        State.OpenFilterManager()
    end
end)

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
        Position = UDim2.fromOffset(0, 32),
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
    State.LoadLocalFilters()
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
        Size = UDim2.fromOffset(540, 300),
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
        Size = UDim2.new(1, 0, 1, -34),
        Position = UDim2.fromOffset(0, 32),
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
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = T.Card,
            BorderSizePixel = 0,
            ZIndex = 93,
        }, list)
        corner(row, 7); stroke(row)
        make("TextLabel", {
            Size = UDim2.new(1, -116, 0, 20),
            Position = UDim2.fromOffset(8, 5),
            BackgroundTransparency = 1,
            RichText = true,
            Text = string.format('%02d. %s | <font color="#%s">P %s</font> | <font color="#%s">KG %s-%s</font> | Age %s-%s',
                i,
                tostring(f.Pet or "?"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"),
                T.Yellow:ToHex(),
                tostring(f.Price or "?"),
                T.Accent:ToHex(),
                tostring(f.MinWeight or 0),
                tostring(f.MaxWeight or "?"),
                tostring(f.MinLevel or 1),
                tostring(f.MaxLevel or 100)
            ),
            TextColor3 = T.Text,
            Font = Enum.Font.Code,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 94,
        }, row)
        make("TextLabel", {
            Size = UDim2.new(1, -116, 0, 18),
            Position = UDim2.fromOffset(8, 24),
            BackgroundTransparency = 1,
            RichText = true,
            Text = string.format('Mutation <font color="#%s">%s</font> | <font color="#%s">Max %s</font> per filter',
                T.Text:ToHex(),
                tostring(f.Mutation or "Any"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"),
                T.Green:ToHex(),
                tostring(f.MaxListedPet or 5)
            ),
            TextColor3 = T.Sub,
            Font = Enum.Font.Code,
            TextSize = 10,
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
            State.OpenConfirmPopup("Delete Filter", "Remove this listing filter from config?", "Delete", function()
                deleteFilter(f.Row or i)
                refreshSellerLog(true)
                overlay:Destroy()
                State.OpenFilterManager()
            end)
        end)
    end
end

local filterLogSec = sellerPage:AddSection("Active Filters / Candidates")
filterLogSec.Frame.LayoutOrder = 20
sellerLog = filterLogSec:AddLog(125)

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

filterLogSec:AddButton("Clear All Filters", function()
    State.OpenConfirmPopup("Clear Filters", "Remove every listing filter from config?", "Clear", function()
        clearFilters()
        refreshSellerLog(false)
    end)
end, "outline")

--// LISTINGS PAGE
State.SetBootStatus("listings ui")
local listingsPage = win:CreatePage("Listings")
State.ListingActionRow = listingsPage:AddRow()
State.ListingManageSec = listingsPage:AddSectionInRow(State.ListingActionRow, "My Listing", 0.25)
State.ListingRefreshSec = listingsPage:AddSectionInRow(State.ListingActionRow, "Refresh", 0.25)
State.ListingRemoveSec = listingsPage:AddSectionInRow(State.ListingActionRow, "Remove All", 0.25)
State.ListingMarketSec = listingsPage:AddSectionInRow(State.ListingActionRow, "Compare", 0.25)
local listingRow = listingsPage:AddRow()
local myListingSec = listingsPage:AddSectionInRow(listingRow, "My Listings", 0.55)
local allListingSec = listingsPage:AddSectionInRow(listingRow, "Price Compare", 0.45)

local myListingList = make("ScrollingFrame", {
    Size = UDim2.new(1, 0, 0, 156),
    BackgroundColor3 = T.BG,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = T.Border,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, myListingSec.Frame)
corner(myListingList, 8); stroke(myListingList); pad(myListingList, 6, 6, 6, 6); vlist(myListingList, 4)

local marketLog = allListingSec:AddLog(156)

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

State.OpenMyListingsManager = function()
    local my = getMyListings()
    State.TrackSoldListings(my)

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
        Size = UDim2.fromOffset(540, 300),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ZIndex = 91,
    }, overlay)
    corner(modal, 10); stroke(modal); pad(modal, 10)

    make("TextLabel", {
        Size = UDim2.new(1, -74, 0, 26),
        BackgroundTransparency = 1,
        Text = "Manage My Listings",
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
        Size = UDim2.new(1, 0, 1, -34),
        Position = UDim2.fromOffset(0, 32),
        BackgroundColor3 = T.Card2,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ZIndex = 92,
    }, modal)
    corner(list, 8); pad(list, 5); vlist(list, 4)

    closeBtn.Activated:Connect(function() overlay:Destroy() end)

    if #my == 0 then
        make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            Text = "No active booth listings found.",
            TextColor3 = T.Sub,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 93,
        }, list)
        return
    end

    for i, l in ipairs(my) do
        if i > 50 then
            make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
                Text = "... +" .. tostring(#my - 50) .. " more",
                TextColor3 = T.Sub,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 93,
            }, list)
            break
        end

        local row = make("Frame", {
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = T.Card,
            BorderSizePixel = 0,
            ZIndex = 93,
        }, list)
        corner(row, 7); stroke(row)
        make("TextLabel", {
            Size = UDim2.new(1, -54, 0, 20),
            Position = UDim2.fromOffset(8, 5),
            BackgroundTransparency = 1,
            RichText = true,
            Text = string.format('%02d. %s | <font color="#%s">%s Tokens</font>',
                i,
                tostring(l.PetType or "?"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"),
                T.Yellow:ToHex(),
                commaNumber(l.Price)
            ),
            TextColor3 = T.Text,
            Font = Enum.Font.Code,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 94,
        }, row)
        make("TextLabel", {
            Size = UDim2.new(1, -54, 0, 18),
            Position = UDim2.fromOffset(8, 24),
            BackgroundTransparency = 1,
            RichText = true,
            Text = string.format('%s | <font color="#%s">id %s</font>',
                tostring(l.ItemType or "?"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"),
                T.Accent:ToHex(),
                tostring(l.ListingUUID or ""):sub(1, 8)
            ),
            TextColor3 = T.Sub,
            Font = Enum.Font.Code,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 94,
        }, row)
        local delBtn = make("TextButton", {
            Size = UDim2.fromOffset(36, 24),
            Position = UDim2.new(1, -44, 0.5, -12),
            BackgroundColor3 = T.Red,
            Text = "X",
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            BorderSizePixel = 0,
            ZIndex = 94,
        }, row)
        corner(delBtn, 6)
        delBtn.Activated:Connect(function()
            delBtn.Text = "..."
            local ok = removeListingUUID(l.ListingUUID)
            task.wait(0.35)
            refreshMyListingsLog()
            if not ok then
                log("Popup remove failed", tostring(l.ListingUUID))
            end
            overlay:Destroy()
            State.OpenMyListingsManager()
        end)
    end
end

local function refreshMarketSample()
    local all = getAllListings()
    local my = getMyListings()
    local myId = tostring(getPlayerId())
    local wanted, wantedCount, mineByKey, nameByKey = {}, 0, {}, {}
    for _, l in ipairs(my) do
        local key = norm(l.PetType)
        if key ~= "" and not wanted[key] then
            wanted[key] = true
            wantedCount += 1
        end
        if key ~= "" then
            mineByKey[key] = mineByKey[key] or {}
            table.insert(mineByKey[key], tonumber(l.Price) or 0)
            nameByKey[key] = tostring(l.PetType or "?")
        end
    end

    local sample, marketByKey = {}, {}
    if wantedCount > 0 then
        for _, l in ipairs(all) do
            local key = norm(l.PetType)
            if wanted[key] then
                table.insert(sample, l)
                if tostring(l.OwnerId or "") ~= myId then
                    marketByKey[key] = marketByKey[key] or {}
                    table.insert(marketByKey[key], tonumber(l.Price) or 0)
                    nameByKey[key] = nameByKey[key] or tostring(l.PetType or "?")
                end
            end
        end
        table.sort(sample, function(a, b)
            local an, bn = tostring(a.PetType or ""), tostring(b.PetType or "")
            if an == bn then return (tonumber(a.Price) or 0) < (tonumber(b.Price) or 0) end
            return an < bn
        end)
    else
        sample = all
    end

    local lines = {}
    if wantedCount > 0 then
        table.insert(lines, "Price compare: " .. tostring(wantedCount) .. " listed pet type(s) | market rows " .. tostring(#sample))
        table.insert(lines, "------------------------------")

        local keys = {}
        for key in pairs(mineByKey) do table.insert(keys, key) end
        table.sort(keys, function(a, b) return tostring(nameByKey[a] or a) < tostring(nameByKey[b] or b) end)

        for i, key in ipairs(keys) do
            if i > 8 then
                table.insert(lines, "... +" .. tostring(#keys - 8) .. " more pet type(s)")
                break
            end

            local minePrices = mineByKey[key] or {}
            table.sort(minePrices)
            local mineLow = minePrices[1] or 0
            local mineHigh = minePrices[#minePrices] or mineLow
            local mineText = mineLow == mineHigh and commaNumber(mineLow) or (commaNumber(mineLow) .. "-" .. commaNumber(mineHigh))

            local prices = marketByKey[key] or {}
            table.sort(prices)
            if #prices == 0 then
                table.insert(lines, string.format("%02d. [NO DATA] %s | mine %s | market none",
                    i,
                    tostring(nameByKey[key] or "?"),
                    mineText
                ))
            else
                local sum = 0
                for _, p in ipairs(prices) do sum += tonumber(p) or 0 end
                local low = prices[1] or 0
                local high = prices[#prices] or low
                local avg = math.floor((sum / math.max(1, #prices)) + 0.5)
                local verdict = "FAIR"
                if mineLow > math.max(low, avg * 1.2) then
                    verdict = "HIGH"
                elseif mineHigh < avg * 0.85 then
                    verdict = "LOW"
                end
                table.insert(lines, string.format("%02d. [%s] %s | mine %s | mkt %s-%s avg %s",
                    i,
                    verdict,
                    tostring(nameByKey[key] or "?"),
                    mineText,
                    commaNumber(low),
                    commaNumber(high),
                    commaNumber(avg)
                ))
                table.insert(lines, "    samples " .. tostring(math.min(#prices, 5)) .. "/" .. tostring(#prices) .. ": " .. table.concat((function()
                    local out = {}
                    for j = 1, math.min(#prices, 5) do table.insert(out, commaNumber(prices[j])) end
                    return out
                end)(), ", "))
            end
        end
    else
        table.insert(lines, "All listings: " .. tostring(#all) .. " (no booth listings to match)")
        table.insert(lines, "------------------------------")

        for i, l in ipairs(sample) do
            if i > 10 then
                table.insert(lines, "... +" .. tostring(#sample - 10) .. " more")
                break
            end
            table.insert(lines, string.format(
                "%02d. %s | price %s | owner %s",
                i,
                tostring(l.PetType or "?"),
                commaNumber(l.Price),
                tostring(l.OwnerName or "?")
            ))
        end
    end
    if #sample == 0 and wantedCount > 0 then
        table.insert(lines, "No matching market listings found for your booth pets.")
    end

    addLines(marketLog, lines)
end

State.ListingManageSec:AddButton("Manage", function()
    if State.OpenMyListingsManager then
        State.OpenMyListingsManager()
    else
        refreshMyListingsLog()
    end
end)
State.ListingRefreshSec:AddButton("Refresh", refreshMyListingsLog, "outline")
State.ListingRemoveSec:AddButton("Remove All", function()
    task.spawn(function()
        removeAllMyListings(CFG.Listings.RemoveAllMax or 50)
        task.wait(0.6)
        refreshMyListingsLog()
    end)
end, "outline")
State.ListingMarketSec:AddButton("Price Check", refreshMarketSample, "outline")

--// SNIPER PAGE
State.SetBootStatus("sniper ui")
local sniperPage = win:CreatePage("Sniper")
State.SniperConfigRow = sniperPage:AddRow()
State.SniperWatchSec = sniperPage:AddSectionInRow(State.SniperConfigRow, "Watch Builder", 0.5)
State.SniperLimitSec = sniperPage:AddSectionInRow(State.SniperConfigRow, "Watch Limits", 0.5)
State.SniperResultSec = sniperPage:AddSection("Sniper Matches")

State.SniperWatchSec:AddToggle("Enabled", CFG.Sniper.Enabled, function(v)
    CFG.Sniper.Enabled = v
    if v then CFG.Sniper.DryRun = false end
    State.SaveRuntimeSettings()
    log("Sniper Enabled", tostring(v), "DryRun", tostring(CFG.Sniper.DryRun))
end)

State.SniperWatchSec:AddToggle("Dry Run", CFG.Sniper.DryRun, function(v)
    CFG.Sniper.DryRun = v
    State.SaveRuntimeSettings()
    log("Sniper DryRun", tostring(v))
end)

State.SniperWatchSec:AddToggle("Rescan Before Buy", CFG.Sniper.RescanBeforeBuy, function(v)
    CFG.Sniper.RescanBeforeBuy = v
    State.SaveRuntimeSettings()
    log("Sniper RescanBeforeBuy", tostring(v))
end)

local sPet = State.SniperWatchSec:AddSearchDropdown("Pet", State.PetList or {}, "Red Fox")
State.SniperPetInput = sPet
local sMax = State.SniperWatchSec:AddInput("Max Price", "6")
State.SniperWeightModeInput = State.SniperLimitSec:AddDropdown("Weight Mode", {"Base", "Visual"}, CFG.Sniper.WeightMode or "Base", function(v)
    CFG.Sniper.WeightMode = normalizeSniperWeightMode(v)
    log("SniperWeightMode", CFG.Sniper.WeightMode)
end)
State.SniperMinKgInput = State.SniperLimitSec:AddInput("Min KG", "0", function(v)
    CFG.Sniper.MinWeight = toNumber(v) or 0
end)
State.SniperMaxKgInput = State.SniperLimitSec:AddInput("Max KG", "", function(v)
    CFG.Sniper.MaxWeight = toNumber(v)
end)
local sShow = State.SniperLimitSec:AddInput("Show", tostring(CFG.Sniper.MaxMatchesShown or 20), function(v)
    CFG.Sniper.MaxMatchesShown = toInt(v) or CFG.Sniper.MaxMatchesShown or 20
end)
local sniperLog = State.SniperResultSec:AddLog(138)

State.ApplySniperLimits = function()
    CFG.Sniper.BuyCooldown = 0
    CFG.Sniper.WeightMode = normalizeSniperWeightMode(State.SniperWeightModeInput:Get())
    CFG.Sniper.MinWeight = toNumber(State.SniperMinKgInput:Get()) or 0
    CFG.Sniper.MaxWeight = toNumber(State.SniperMaxKgInput:Get())
    CFG.Sniper.MaxMatchesShown = toInt(sShow:Get()) or CFG.Sniper.MaxMatchesShown or 20
    CFG.Sniper.MaxMatchesPerPet = 0
end

State.FindSellerLog = function(...)
    local parts = {}
    for i = 1, select("#", ...) do
        table.insert(parts, tostring(select(i, ...)))
    end
    local ok, err = pcall(log, ...)
    if not ok then
        print("[NOMO FIND SELLER LOG ERROR]", tostring(err))
    end
    if State.RefreshActivityLog then
        pcall(State.RefreshActivityLog, true)
    end
end

if not State.FindSellerTeleportFailHooked and State.TeleportService and State.TeleportService.TeleportInitFailed then
    State.FindSellerTeleportFailHooked = true
    pcall(function()
        State.TeleportService.TeleportInitFailed:Connect(function(player, result, message)
            if player ~= LocalPlayer then return end
            State.LastFindSellerTeleportFailAt = os.clock()
            State.LastFindSellerTeleportFailReason = tostring(result) .. " " .. tostring(message)
            State.FindSellerLog("Find Seller teleport failed", State.LastFindSellerTeleportFailReason)
        end)
    end)
end

State.FindIndexSellerForItem = function(itemType, itemName, bypassCooldown)
    itemType = trim(itemType or "Pet")
    itemName = trim(itemName)
    if itemName == "" then
        State.FindSellerLog("Find Seller blocked", "empty item")
        return false
    end
    if not bypassCooldown and os.clock() - (tonumber(State.LastFindSellerAt) or 0) < 10 then
        State.FindSellerLog("Find Seller cooldown", tostring(itemName))
        return false
    end
    if not bypassCooldown then
        State.LastFindSellerAt = os.clock()
    end

    if not State.TokenRAPUtil then
        local okUtil, tokenRapUtil = pcall(function()
            return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("TradeTokens"):WaitForChild("TokenRAPUtil"))
        end)
        if okUtil and tokenRapUtil then
            State.TokenRAPUtil = tokenRapUtil
        else
            State.FindSellerLog("Find Seller util failed", tostring(tokenRapUtil))
            return false
        end
    end
    if type(State.TokenRAPUtil.GetDefaultItemData) ~= "function" then
        State.FindSellerLog("Find Seller util missing GetDefaultItemData")
        return false
    end

    local okData, defaultData = pcall(function()
        return State.TokenRAPUtil.GetDefaultItemData(itemType, itemName)
    end)
    if not okData or not defaultData then
        State.FindSellerLog("Find Seller default data failed", tostring(itemType), tostring(itemName), tostring(defaultData))
        return false
    end

    local tradeEvents = GameEvents:FindFirstChild("TradeEvents")
    local tokenRaps = tradeEvents and tradeEvents:FindFirstChild("TokenRAPs")
    local findSellers = tokenRaps and tokenRaps:FindFirstChild("FindSellers")
    local teleportToListing = tokenRaps and tokenRaps:FindFirstChild("TeleportToListing")
    if not findSellers or not teleportToListing then
        State.FindSellerLog("Find Seller failed", "remote missing")
        return false
    end

    local ok, hasSeller, listingId = pcall(function()
        return findSellers:InvokeServer(itemType, defaultData)
    end)
    if not ok then
        State.FindSellerLog("Find Seller error", tostring(hasSeller))
        return false
    end
    if hasSeller and listingId then
        State.FindSellerLog("Find Seller teleporting", tostring(itemName))
        local startedAt = os.clock()
        State.LastFindSellerTeleportFailAt = 0
        State.LastFindSellerTeleportFailReason = nil
        local okTeleport, teleportResult = pcall(function()
            return teleportToListing:InvokeServer(listingId, true)
        end)
        if not okTeleport or teleportResult == false then
            return false
        end

        local waitUntil = os.clock() + 8
        while State.Running and os.clock() < waitUntil do
            if (tonumber(State.LastFindSellerTeleportFailAt) or 0) >= startedAt then
                State.FindSellerLog("Find Seller server full", tostring(itemName), "waiting 2s")
                task.wait(2)
                State.FindSellerLog("Find Seller retry next", tostring(itemName))
                return false
            end
            task.wait(0.25)
        end

        State.FindSellerLog("Find Seller no teleport", tostring(itemName), "retry next")
        return false
    end

    State.FindSellerLog("Find Seller no seller", tostring(itemName))
    return false
end

State.FindIndexSellerForPet = function(petName, bypassCooldown)
    return State.FindIndexSellerForItem("Pet", petName, bypassCooldown)
end

State.FindSellerHopWatchlist = function()
    if State.FindSellerLoopRunning then
        State.FindSellerLog("Find Seller already running")
        return false
    end
    if os.clock() - (tonumber(State.LastFindSellerAt) or 0) < 5 then
        State.FindSellerLog("Find Seller watchlist cooldown")
        return false
    end

    State.FindSellerLoopRunning = true
    State.LastFindSellerAt = os.clock()
    State.FindSellerBusyUntil = os.clock() + 90
    State.AutoSmartRebuildPausedUntil = math.max(tonumber(State.AutoSmartRebuildPausedUntil) or 0, State.FindSellerBusyUntil)

    task.spawn(function()
        local okLoop, errLoop = pcall(function()
            local maxPasses = 8
            for pass = 1, maxPasses do
                if not State.Running then break end
                local watches = State.GetSortedSniperWatches and State.GetSortedSniperWatches() or {}
                if #watches == 0 then
                    State.FindSellerLog("Find Seller watchlist empty")
                    break
                end

                State.FindSellerLog("Find Seller scan", "pass", tostring(pass) .. "/" .. tostring(maxPasses), tostring(#watches), "watch(es)")
                for i, watch in ipairs(watches) do
                    if not State.Running then break end
                    local petName = tostring(watch.Name or "")
                    State.FindSellerLog("Find Seller try", tostring(i) .. "/" .. tostring(#watches), petName, "prio", tostring(getSniperPriority(watch.Config)))
                    if petName ~= "" and State.FindIndexSellerForPet(petName, true) then
                        State.FindSellerLog("Find Seller found", petName)
                        State.FindSellerLoopRunning = false
                        return
                    end
                    task.wait(0.6)
                end

                if pass < maxPasses then
                    State.FindSellerLog("Find Seller pass done", "waiting 4s")
                    task.wait(4)
                end
            end
            State.FindSellerLog("Find Seller fallback hop mode")
            local fallback = State.FindSellerFallbackTargets or {
                {Type = "Pet", Name = "Red Fox"},
                {Type = "Pet", Name = "Mimic Octopus"},
                {Type = "Pet", Name = "Butterfly"},
                {Type = "Pet", Name = "Bacon Pig"},
                {Type = "Pet", Name = "Ankylosaurus"},
                {Type = "Holdable", Name = "Bone Blossom"},
                {Type = "Holdable", Name = "Candy Blossom"},
                {Type = "Holdable", Name = "Beanstalk"},
            }
            local fallbackPasses = 3
            for pass = 1, fallbackPasses do
                for i, target in ipairs(fallback) do
                    if not State.Running then break end
                    local itemType = tostring(target.Type or "Pet")
                    local itemName = tostring(target.Name or "")
                    State.FindSellerLog("Find Seller fallback", tostring(pass) .. "/" .. tostring(fallbackPasses), tostring(i) .. "/" .. tostring(#fallback), itemName)
                    if itemName ~= "" and State.FindIndexSellerForItem(itemType, itemName, true) then
                        State.FindSellerLog("Find Seller fallback found", itemName)
                        State.FindSellerLoopRunning = false
                        return
                    end
                    task.wait(0.6)
                end
                if pass < fallbackPasses then
                    State.FindSellerLog("Find Seller fallback wait", "4s")
                    task.wait(4)
                end
            end
            State.FindSellerLog("Find Seller no sellers after retry")
        end)
        if not okLoop then
            State.FindSellerLog("Find Seller loop error", tostring(errLoop))
        end
        State.FindSellerLoopRunning = false
        State.FindSellerBusyUntil = os.clock() + 5
    end)

    return true
end
getgenv().NOMO_FIND_SELLER = State.FindIndexSellerForPet
_G.NOMO_FIND_SELLER = State.FindIndexSellerForPet
log("Find Seller hook registered", "use NOMO_FIND_SELLER('Pet Name')")
if getgenv().nomo_find_seller_test ~= nil then
    task.delay(4, function()
        local petName = tostring(getgenv().nomo_find_seller_test or "")
        State.FindSellerLog("Find Seller auto test", petName)
        State.FindIndexSellerForPet(petName)
    end)
end

State.OpenSniperWatchEditPopup = function(name, managerOverlay)
    local cfg = CFG.Sniper.Watchlist and CFG.Sniper.Watchlist[name]
    if not cfg then
        log("Edit watch failed", tostring(name))
        return
    end
    local maxPrice = type(cfg) == "table" and cfg.MaxPrice or cfg
    local minKg = getSniperMinWeight(cfg)
    local maxKg = getSniperMaxWeight(cfg)
    local mode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode)
    local priority = getSniperPriority(cfg)

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
        Position = UDim2.fromOffset(0, 32),
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
            MaxMatchesPerPet = 0,
            Priority = priority,
        }
        local ok = State.SaveSniperWatchlist()
        log("Updated watch", tostring(name), "price", tostring(CFG.Sniper.Watchlist[name].MaxPrice), "saved=" .. tostring(ok), getSniperFilterPath())
        State.RefreshSniperLog()
        overlay:Destroy()
        if managerOverlay then managerOverlay:Destroy() end
        State.OpenSniperWatchlistManager()
    end)
end

State.OpenSniperWatchlistManager = function()
    State.ReloadSniperConfig()
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
        Size = UDim2.fromOffset(540, 300),
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
        Size = UDim2.new(1, 0, 1, -34),
        Position = UDim2.fromOffset(0, 32),
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
        local minKg = getSniperMinWeight(cfg)
        local maxKg = getSniperMaxWeight(cfg)
        local mode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode)
        local row = make("Frame", {
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = T.Card,
            BorderSizePixel = 0,
            ZIndex = 93,
        }, list)
        corner(row, 7); stroke(row)
        make("TextLabel", {
            Size = UDim2.new(1, -116, 0, 20),
            Position = UDim2.fromOffset(8, 5),
            BackgroundTransparency = 1,
            RichText = true,
            Text = string.format('%02d. %s | <font color="#%s">Price %s</font> | <font color="#%s">%s</font>',
                idx,
                tostring(name):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"),
                T.Yellow:ToHex(),
                formatSniperMax(maxPrice),
                T.Accent:ToHex(),
                State.FormatSniperKgRange(mode, minKg, maxKg)
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
            State.OpenConfirmPopup("Delete Watch", "Remove this sniper watch from config?", "Delete", function()
                removeWatch(name)
                State.RefreshSniperLog()
                overlay:Destroy()
                State.OpenSniperWatchlistManager()
            end)
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
        local minKg = getSniperMinWeight(cfg)
        local maxKg = getSniperMaxWeight(cfg)
        local mode = type(cfg) == "table" and normalizeSniperWeightMode(cfg.WeightMode) or normalizeSniperWeightMode(CFG.Sniper.WeightMode)
        local priority = getSniperPriority(cfg)
        local priorityText = priority > 0 and (" | P" .. tostring(priority)) or ""
        if watchCount <= 8 then
            table.insert(lines, "- " .. tostring(name) .. " | Price " .. formatSniperMax(maxPrice) .. " | " .. State.FormatSniperKgRange(mode, minKg, maxKg) .. priorityText)
        end
    end
    if watchCount > 8 then
        table.insert(lines, "... +" .. tostring(watchCount - 8) .. " more watches")
    end

    table.insert(lines, "------------------------------")
    table.insert(lines, "Matches: " .. tostring(#State.LastSniperMatches) .. " shown / raw " .. tostring(State.LastSniperRawCount or #State.LastSniperMatches))

    if #State.LastSniperMatches == 0 and (tonumber(State.LastSniperSkipTotal) or 0) > 0 then
        table.insert(lines, "Skipped: " .. tostring(State.LastSniperSkipTotal) .. " safety reject(s)")
        for i, why in ipairs(State.LastSniperSkipReasons or {}) do
            table.insert(lines, string.format("%02d. %s", i, tostring(why)))
        end
    end

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

State.SniperWatchSec:AddButton("Add Watch", function()
    State.ApplySniperLimits()
    addWatch(sPet:Get(), sMax:Get())
    State.RefreshSniperLog()
end)

State.SniperWatchSec:AddButton("Manage Watchlist", function()
    State.OpenSniperWatchlistManager()
end, "outline")

State.SniperWatchSec:AddButton("Dry Run Scan", function()
    State.ApplySniperLimits()
    snipeDryRun()
    State.RefreshSniperLog()
end, "outline")

State.SniperWatchSec:AddButton("Find Seller Hop", function()
    log("Find Seller watchlist button")
    State.FindSellerHopWatchlist()
end, "outline")

State.SniperLimitSec:AddButton("Clear Watchlist", function()
    State.OpenConfirmPopup("Clear Watchlist", "Remove every sniper watch from config?", "Clear", function()
        clearWatch()
        State.LastSniperMatches = {}
        State.LastSniperRawCount = 0
        State.RefreshSniperLog()
    end)
end, "outline")

State.SniperLimitSec:AddButton("Buy First", function()
    buyFirstMatch()
    State.RefreshSniperLog()
end, "outline")

--// FRUIT PAGE
State.SetBootStatus("fruit ui")
State.FruitPage = win:CreatePage("Fruit")
State.FruitTopRow = State.FruitPage:AddRow()
State.FruitControlSec = State.FruitPage:AddSectionInRow(State.FruitTopRow, "Auto Fruit", 0.36)
State.FruitFilterSec = State.FruitPage:AddSectionInRow(State.FruitTopRow, "Filter Builder", 0.64)
State.FruitLogSec = State.FruitPage:AddSection("Fruit Preview")
State.FruitLog = State.FruitLogSec:AddLog(112)

State.FruitControlSec:AddToggle("Enabled", CFG.Fruit.Enabled == true, function(v)
    CFG.Fruit.Enabled = v == true
    CFG.Fruit.AutoList = v == true
    State.SaveRuntimeSettings()
    log("FruitListing", tostring(v), "path", State.GetFruitFilterPath())
end)
State.FruitControlSec:AddButton("Preview Fruits", function()
    if State.BuildFruitCandidates then
        local ok, scan = pcall(State.BuildFruitCandidates)
        if ok and type(scan) == "table" then
            State.RefreshFruitLog(scan)
            log("Fruit scan", "filters", tostring(#(scan.Filters or {})), "fruits", tostring(#(scan.Fruits or {})), "candidates", tostring(#(scan.Candidates or {})))
        else
            log("Fruit scan error", tostring(scan))
        end
    else
        log("Fruit scan unavailable")
    end
end)
State.FruitControlSec:AddButton("Reload Config", function()
    if State.ReloadFruitFilters then State.ReloadFruitFilters(true) end
    if State.BuildFruitCandidates then
        local ok, scan = pcall(State.BuildFruitCandidates)
        if ok then State.RefreshFruitOptions(scan); State.RefreshFruitLog(scan) end
    end
end, "outline")
State.FruitControlSec:AddButton("Manage Filters", function()
    if State.OpenFruitFilterManager then
        State.OpenFruitFilterManager()
    else
        log("Fruit filter manager not ready")
    end
end, "outline")

State.RefreshFruitOptions = function(scan)
    local seen, names = {}, {}
    local function addName(v)
        v = trim(v)
        if v ~= "" and not seen[v] then
            seen[v] = true
            table.insert(names, v)
        end
    end

    if type(State.FruitSeedData) == "table" then
        for name in pairs(State.FruitSeedData) do
            addName(name)
        end
    end

    if type(scan) == "table" then
        for _, fruit in ipairs(scan.Fruits or {}) do
            addName(fruit.Name)
        end
        for _, f in ipairs(scan.Filters or {}) do
            addName(f.Fruit)
        end
    end

    if State.FruitFilterData and type(State.FruitFilterData.Fruit) == "table" then
        for _, row in ipairs(State.FruitFilterData.Fruit) do
            if type(row) == "table" then
                addName(row.Fruit or row.fruit or row.Name or row.name)
            end
        end
    end

    for _, l in ipairs(getAllListings(false, true)) do
        if tostring(l.ItemType or "") == tostring(CFG.Fruit.ItemType or "Holdable") then
            local item = l.Item or {}
            addName(item.FruitName or item.Fruit or item.ItemName or item.Name or l.PetType)
        end
    end

    table.sort(names)
    State.FruitNameOptions = names
    if State.FruitNameInput and State.FruitNameInput.SetOptions then
        State.FruitNameInput:SetOptions(names)
    end
    return names
end

State.FruitNameInput = State.FruitFilterSec:AddSearchDropdown("Fruit", State.RefreshFruitOptions(), "Bone Blossom")
State.FruitPriceInput = State.FruitFilterSec:AddInput("Price", "11")
State.FruitMinInput = State.FruitFilterSec:AddInput("Min KG", "0")
State.FruitMaxInput = State.FruitFilterSec:AddInput("Max KG", "")
State.FruitMutInput = State.FruitFilterSec:AddInput("Variant", "Any")
State.FruitCapInput = State.FruitFilterSec:AddInput("Max Listed", "5")
State.FruitFilterSec:AddButton("+ Add Fruit Filter", function()
    if State.AddFruitFilter then
        State.AddFruitFilter(
            State.FruitNameInput:Get(),
            State.FruitPriceInput:Get(),
            State.FruitMinInput:Get(),
            State.FruitMaxInput:Get(),
            State.FruitMutInput:Get(),
            State.FruitCapInput:Get()
        )
    end
    if State.BuildFruitCandidates then
        local ok, scan = pcall(State.BuildFruitCandidates)
        if ok then State.RefreshFruitOptions(scan); State.RefreshFruitLog(scan) end
    end
end)


State.RefreshFruitLog = function(scan)
    scan = scan or State.LastFruitScan
    local lines = {
        string.format("Auto %s | Filters %s | Inventory %s | Ready %s",
            CFG.Fruit.Enabled == true and "ON" or "OFF",
            tostring(type(scan) == "table" and #(scan.Filters or {}) or 0),
            tostring(type(scan) == "table" and #(scan.Fruits or {}) or 0),
            tostring(type(scan) == "table" and #(scan.Candidates or {}) or 0)
        ),
        "Path: " .. tostring(State.GetFruitFilterPath()),
    }
    if type(scan) == "table" then
        if #(scan.Candidates or {}) > 0 then
            table.insert(lines, "Ready:")
            for i, c in ipairs(scan.Candidates or {}) do
                if i > 6 then table.insert(lines, "... +" .. tostring(#scan.Candidates - 6) .. " more ready") break end
                local fruit = c.Fruit or {}
                local filter = c.Filter or {}
                table.insert(lines, string.format("%02d. %s | %s KG | %s tokens", i, tostring(fruit.Name or "?"), fmtKg(fruit.Weight), tostring(filter.Price or "?")))
            end
        else
            table.insert(lines, "Ready: 0")
        end

        local reasonCounts, reasonOrder = {}, {}
        for _, s in ipairs(scan.Skipped or {}) do
            local reason = tostring(s.Reason or "unknown")
            if not reasonCounts[reason] then table.insert(reasonOrder, reason) end
            reasonCounts[reason] = (reasonCounts[reason] or 0) + 1
        end
        if #reasonOrder > 0 then
            table.insert(lines, "Skipped summary:")
            for i, reason in ipairs(reasonOrder) do
                if i > 5 then table.insert(lines, "... +" .. tostring(#reasonOrder - 5) .. " more reason(s)") break end
                table.insert(lines, string.format("- %s: %s", reason, tostring(reasonCounts[reason] or 0)))
            end
        end
    else
        table.insert(lines, "Press Preview Fruits to inspect current inventory fruit.")
    end
    addLines(State.FruitLog, lines)
end
State.RefreshFruitLog()
--// WEBHOOK PAGE
State.SetBootStatus("webhook ui")
State.WebhookPage = win:CreatePage("Webhook")
State.WebhookTopRow = State.WebhookPage:AddRow()
State.WebhookSec = State.WebhookPage:AddSectionInRow(State.WebhookTopRow, "Delivery", 0.35)
State.WebhookRouteSec = State.WebhookPage:AddSectionInRow(State.WebhookTopRow, "Routes", 0.65)
State.WebhookTestSec = State.WebhookPage:AddSection("Tests")

State.WebhookSec:AddToggle("Enabled", CFG.Webhook.Enabled == true, function(v)
    CFG.Webhook.Enabled = v
    State.SaveRuntimeSettings()
    log("Webhook", tostring(v))
end)

State.WebhookSec:AddToggle("Successful Snipes", CFG.Webhook.SuccessfulSnipe ~= false, function(v)
    CFG.Webhook.SuccessfulSnipe = v
    State.SaveRuntimeSettings()
end)

State.WebhookSec:AddToggle("Booth Sales", CFG.Webhook.PetSold ~= false, function(v)
    CFG.Webhook.PetSold = v
    State.SaveRuntimeSettings()
end)

State.WebhookMaskValue = function(v)
    local s = tostring(v or "")
    if s == "" then return "" end
    if #s <= 18 then return s end
    return "..." .. s:sub(-14)
end

State.SnipeWebhookUrlInput = State.WebhookRouteSec:AddInput("Snipe Webhook URL", tostring(CFG.Webhook.SnipeUrl or CFG.Webhook.Url or ""), function(v)
    CFG.Webhook.SnipeUrl = tostring(v or "")
    State.SaveRuntimeSettings()
end)
State.SnipeWebhookUrlInput:SetClearOnFocus(true)
State.SnipeWebhookUrlInput:SetDisplayTransform(State.WebhookMaskValue)

State.SoldWebhookUrlInput = State.WebhookRouteSec:AddInput("Booth Sale Webhook URL", tostring(CFG.Webhook.SoldUrl or CFG.Webhook.Url or ""), function(v)
    CFG.Webhook.SoldUrl = tostring(v or "")
    State.SaveRuntimeSettings()
end)
State.SoldWebhookUrlInput:SetClearOnFocus(true)
State.SoldWebhookUrlInput:SetDisplayTransform(State.WebhookMaskValue)

State.WebhookDeviceNameInput = State.WebhookRouteSec:AddInput("Device Name", tostring(CFG.Webhook.DeviceName or ""), function(v)
    CFG.Webhook.DeviceName = tostring(v or "")
    State.SaveRuntimeSettings()
end)

State.WebhookTestSec:AddButton("Test Snipe Webhook", function()
    CFG.Webhook.SnipeUrl = State.SnipeWebhookUrlInput:Get()
    CFG.Webhook.SoldUrl = State.SoldWebhookUrlInput:Get()
    CFG.Webhook.IconUrl = tostring(CFG.Webhook.IconUrl or "")
    CFG.Webhook.DeviceName = State.WebhookDeviceNameInput:Get()
    State.SaveRuntimeSettings()
    local wasEnabled = CFG.Webhook.Enabled
    CFG.Webhook.Enabled = true
    local sample = {
        PetType = "Golden Mimic Octopus",
        Price = 6,
        OwnerName = "sample_seller",
        ListingUUID = "sample-snipe",
        ItemId = "sample-pet",
        Item = {
            PetType = "Golden Mimic Octopus",
            BaseWeight = 1.64,
            PetData = {Level = 19},
            Mutation = "Golden",
        },
    }
    local sent = State.WebhookPost(State.WebhookEmbedForListing("snipe", sample, {User = "sample_seller"}), "snipe")
    CFG.Webhook.Enabled = wasEnabled
    log("Snipe webhook test sent", tostring(sent))
end, "outline")

State.WebhookTestSec:AddButton("Test Sale Webhook", function()
    CFG.Webhook.SnipeUrl = State.SnipeWebhookUrlInput:Get()
    CFG.Webhook.SoldUrl = State.SoldWebhookUrlInput:Get()
    CFG.Webhook.IconUrl = tostring(CFG.Webhook.IconUrl or "")
    CFG.Webhook.DeviceName = State.WebhookDeviceNameInput:Get()
    State.SaveRuntimeSettings()
    local wasEnabled = CFG.Webhook.Enabled
    CFG.Webhook.Enabled = true
    local sample = {
        PetType = "Mimic Octopus",
        Price = 26,
        ListingUUID = "sample-sale",
        ItemId = "sample-pet",
        Item = {
            PetType = "Mimic Octopus",
            BaseWeight = 1.88,
            PetData = {Level = 1},
            Mutation = "Normal",
        },
    }
    local sent = State.WebhookPost(State.WebhookEmbedForListing("sold", sample, {User = "sample_buyer"}), "sold")
    CFG.Webhook.Enabled = wasEnabled
    log("Sale webhook test sent", tostring(sent))
end, "outline")

--// SETTINGS PAGE
State.SetBootStatus("settings ui")
State.SettingsPage = win:CreatePage("Settings")
State.SettingsTopRow = State.SettingsPage:AddRow()
State.SettingPathSec = State.SettingsPage:AddSectionInRow(State.SettingsTopRow, "Paths", 0.36)
State.SettingUiSec = State.SettingsPage:AddSectionInRow(State.SettingsTopRow, "UI", 0.31)
State.SettingActionSec = State.SettingsPage:AddSectionInRow(State.SettingsTopRow, "Actions", 0.33)

State.FilterPathInput = State.SettingPathSec:AddInput("Filter Folder", getConfigFolder(), function(v)
    CFG.Seller.ListingFilterPath = v
    reloadFilters()
end)
State.FindSellerPetInput = State.SettingPathSec:AddInput("Find Seller Pet", "Rainbow Bacon Pig")

State.SettingUiSec:AddToggle("Compact Booth Data", CFG.UI.CompactBoothData ~= false, function(v)
    CFG.UI.CompactBoothData = v
    State.SaveRuntimeSettings()
    log("CompactBoothData", tostring(v))
end)

State.SettingUiSec:AddToggle("Auto Minimized", CFG.UI.AutoMinimized == true, function(v)
    CFG.UI.AutoMinimized = v
    State.SaveRuntimeSettings()
    log("AutoMinimized", tostring(v), "applies on next reload")
end)

State.SettingUiSec:AddToggle("Fruit Listing", CFG.Fruit.Enabled == true, function(v)
    CFG.Fruit.Enabled = v == true
    CFG.Fruit.AutoList = v == true
    State.SaveRuntimeSettings()
    log("FruitListing", tostring(v), "path", State.GetFruitFilterPath())
end)

State.SettingActionSec:AddButton("Reload Pet List", function()
    loadGamePetList()
    log("PetList reloaded", tostring(#State.PetList))
end, "outline")

State.SettingActionSec:AddButton("Diagnose Fruits", function()
    if State.DiagnoseFruits then State.DiagnoseFruits() end
end, "outline")

State.SettingActionSec:AddButton("Find Seller Test", function()
    local petName = State.FindSellerPetInput and trim(State.FindSellerPetInput:Get()) or ""
    log("Find Seller test button", tostring(petName))
    if petName ~= "" then
        State.FindIndexSellerForPet(petName)
    else
        log("Find Seller test blocked", "no sniper pet/watch")
    end
end, "outline")

State.SettingActionSec:AddButton("Rejoin Server", function()
    State.OpenConfirmPopup("Rejoin Server", "Reload this clone in the current trade server?", "Rejoin", function()
        State.Rejoin("settings rejoin")
    end)
end, "outline")

State.SettingPathSec:AddButton("Save / Reload Path", function()
    CFG.Seller.ListingFilterPath = State.FilterPathInput:Get()
    State.SaveRuntimeSettings()
    reloadFilters()
    State.ReloadSniperConfig()
    log("Config path set", tostring(CFG.Seller.ListingFilterPath), "listing", getFilterPath(), "sniper", getSniperFilterPath())
end)

State.SettingPathSec:AddButton("Test Find Seller", function()
    local petName = State.FindSellerPetInput and trim(State.FindSellerPetInput:Get()) or ""
    log("Path Find Seller test", tostring(petName))
    if petName ~= "" then
        State.FindIndexSellerForPet(petName)
    end
end, "outline")

State.SettingActionSec:AddButton("Stop Script", function()
    State.Stop("settings stop")
end, "outline")

State.ActivitySec = State.SettingsPage:AddSection("Activity Log")
State.ActivityLog = State.ActivitySec:AddLog(170)

State.RefreshActivityLog = function(force)
    if not State.ActivityLog then return end
    local now = os.clock()
    if not force and not State.ActivityLogDirty then return end
    if not force and now - (State.LastActivityLogRefreshAt or 0) < 0.75 then return end
    State.LastActivityLogRefreshAt = now
    State.ActivityLogDirty = false
    addLines(State.ActivityLog, State.Logs, true)
end

State.RefreshActivityLog(true)

State.ActivitySec:AddButton("Refresh Activity", function()
    State.RefreshActivityLog(true)
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
State.SetBootStatus("startup")
ensureFolder()
local function bootStep(name, fn)
    log("Boot step", tostring(name))
    local ok, result = pcall(fn)
    if ok then
        log("Boot ok", tostring(name))
        return result
    end
    log("Boot failed", tostring(name), tostring(result))
    return nil
end

bootStep("ListingFilters", reloadFilters)
bootStep("WarnFilter", installWarnFilter)

log("Started", VERSION .. " PRIVATE UI")
State.SetBootStatus("select dashboard")

win:SelectPage("Dashboard")

if State.PendingRuntimeDefaultsSave then
    State.PendingRuntimeDefaultsSave = false
    State.SaveRuntimeSettings()
end
task.defer(function()
    pcall(refreshPills)
end)
log("PetList", #State.PetList, "| ConfigFolder", getConfigFolder(), "| Listing", getFilterPath())
State.SetBootStatus("fruit install")

State.InstallFruitListing = function()
local function normalizeFruitConfigData(data)
    if type(data) ~= "table" then return {Fruit = {}} end
    if type(data.fruit) == "table" then data.Fruit = data.fruit end
    if type(data.Fruits) == "table" then data.Fruit = data.Fruits end
    if type(data.filters) == "table" then data.Fruit = data.filters end
    if type(data.Filters) == "table" then data.Fruit = data.Filters end
    if type(data[1]) == "table" then data.Fruit = data end
    data.Fruit = type(data.Fruit) == "table" and data.Fruit or {}
    return data
end

local function reloadFruitFilters(force)
    local path = State.GetFruitFilterPath()
    local now = os.clock()
    if not force and State.FruitFilterData and State.LastFruitFilterPath == path and now - (State.LastFruitFilterLoadAt or 0) < 5 then
        return State.FruitFilterData
    end

    State.FruitFilterData = normalizeFruitConfigData(readJson(path))
    State.LastFruitFilterPath = path
    State.LastFruitFilterLoadAt = now

    local countNow = #(State.FruitFilterData.Fruit or {})
    if force or State.LastFruitFilterLogCount ~= countNow or State.LastFruitFilterLogPath ~= path then
        State.LastFruitFilterLogCount = countNow
        State.LastFruitFilterLogPath = path
        log("Fruit filters loaded", path, tostring(countNow) .. " filters")
    end
    return State.FruitFilterData
end

State.ReloadFruitFilters = reloadFruitFilters

local getFruitFilters

local function saveFruitFilters()
    State.FruitFilterData = normalizeFruitConfigData(State.FruitFilterData)
    return saveJson(State.GetFruitFilterPath(), {
        version = 1,
        fruit = State.FruitFilterData.Fruit or {},
    })
end

State.AddFruitFilter = function(fruit, price, minKg, maxKg, variant, cap)
    State.FruitFilterData = normalizeFruitConfigData(State.FruitFilterData or readJson(State.GetFruitFilterPath()))
    local row = {
        Enabled = true,
        Fruit = tostring(fruit or ""),
        Price = clampPrice(price) or 1,
        MinWeight = toNumber(minKg) or 0,
        MaxWeight = toNumber(maxKg),
        Variant = tostring(variant or "Any"),
        MaxListedFruit = toInt(cap) or 5,
    }
    local editIndex = toInt(State.EditingFruitFilterRow)
    if editIndex and State.FruitFilterData.Fruit and State.FruitFilterData.Fruit[editIndex] then
        State.FruitFilterData.Fruit[editIndex] = row
        State.EditingFruitFilterRow = nil
        saveFruitFilters()
        log("Updated fruit filter", tostring(fruit), "price", tostring(price), "saved=true")
    else
        State.EditingFruitFilterRow = nil
        table.insert(State.FruitFilterData.Fruit, row)
        saveFruitFilters()
        log("Added fruit filter", tostring(fruit), "price", tostring(price), "saved=true")
    end
end
State.OpenFruitFilterEditPopup = function(index, managerOverlay)
    reloadFruitFilters(true)
    index = toInt(index)
    local row = index and State.FruitFilterData and State.FruitFilterData.Fruit and State.FruitFilterData.Fruit[index]
    if not row then
        log("Edit fruit filter failed", "bad index", tostring(index))
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
        Size = UDim2.fromOffset(420, 230),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ZIndex = 101,
    }, overlay)
    corner(modal, 10); stroke(modal); pad(modal, 12)

    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "Edit Fruit Filter - " .. tostring(row.Fruit or row.fruit or "?"),
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102,
    }, modal)

    local function label(y, text)
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
    local function box(y, value)
        local b = make("TextBox", {
            Size = UDim2.new(1, -130, 0, 26),
            Position = UDim2.fromOffset(130, y),
            BackgroundColor3 = T.Card2,
            Text = tostring(value or ""),
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

    label(50, "Price")
    local priceBox = box(50, row.Price or row.price or "")
    label(90, "Min KG")
    local minBox = box(90, row.MinWeight or row.minWeight or row.MinKG or row.minKG or 0)
    label(130, "Max KG")
    local maxBox = box(130, row.MaxWeight or row.maxWeight or row.MaxKG or row.maxKG or "")

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
        reloadFruitFilters(true)
        local target = State.FruitFilterData and State.FruitFilterData.Fruit and State.FruitFilterData.Fruit[index]
        if target then
            target.Enabled = true
            target.Price = clampPrice(priceBox.Text) or target.Price or 1
            target.MinWeight = toNumber(minBox.Text) or 0
            target.MaxWeight = toNumber(maxBox.Text)
            local ok = saveFruitFilters()
            log("Updated fruit filter", tostring(index), tostring(target.Fruit or "?"), "price", tostring(target.Price), "max", tostring(target.MaxListedFruit), "saved=" .. tostring(ok))
            if State.BuildFruitCandidates then
                local scanOk, scan = pcall(State.BuildFruitCandidates)
                if scanOk and State.RefreshFruitLog then State.RefreshFruitLog(scan) end
            end
        end
        overlay:Destroy()
        if managerOverlay then managerOverlay:Destroy() end
        State.OpenFruitFilterManager()
    end)

    if State.DisableAutoLocalize then State.DisableAutoLocalize(overlay) end
end
State.OpenFruitFilterManager = function()
    reloadFruitFilters(true)
    local filters = getFruitFilters()
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
        Size = UDim2.fromOffset(540, 300),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        ZIndex = 91,
    }, overlay)
    corner(modal, 10); stroke(modal); pad(modal, 10)

    make("TextLabel", {
        Size = UDim2.new(1, -74, 0, 26),
        BackgroundTransparency = 1,
        Text = "Fruit Filters (" .. tostring(#filters) .. ")",
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
        Size = UDim2.new(1, 0, 1, -34),
        Position = UDim2.fromOffset(0, 32),
        BackgroundColor3 = T.Card2,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ZIndex = 92,
    }, modal)
    corner(list, 8); pad(list, 5); vlist(list, 4)
    closeBtn.Activated:Connect(function() overlay:Destroy() end)

    for i, f in ipairs(filters) do
        local row = make("Frame", {
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = T.Card,
            BorderSizePixel = 0,
            ZIndex = 93,
        }, list)
        corner(row, 7); stroke(row)
        make("TextLabel", {
            Size = UDim2.new(1, -116, 0, 20),
            Position = UDim2.fromOffset(8, 5),
            BackgroundTransparency = 1,
            RichText = true,
            Text = string.format('%02d. %s | <font color="#%s">P %s</font> | <font color="#%s">KG %s-%s</font>',
                i,
                tostring(f.Fruit or "?"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"),
                T.Yellow:ToHex(),
                tostring(f.Price or "?"),
                T.Accent:ToHex(),
                tostring(f.MinWeight or 0),
                tostring(f.MaxWeight or "unli")
            ),
            TextColor3 = T.Text,
            Font = Enum.Font.Code,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 94,
        }, row)
        make("TextLabel", {
            Size = UDim2.new(1, -116, 0, 18),
            Position = UDim2.fromOffset(8, 24),
            BackgroundTransparency = 1,
            RichText = true,
            Text = string.format('Var <font color="#%s">%s</font> | <font color="#%s">Cap %s</font>',
                T.Text:ToHex(),
                tostring(f.Variant or "Any"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"),
                T.Green:ToHex(),
                tostring(f.MaxListedFruit or 5)
            ),
            TextColor3 = T.Sub,
            Font = Enum.Font.Code,
            TextSize = 10,
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
            State.OpenFruitFilterEditPopup(f.Row or i, overlay)
        end)
        delBtn.Activated:Connect(function()
            State.OpenConfirmPopup("Delete Fruit Filter", "Remove this fruit filter from config?", "Delete", function()
                reloadFruitFilters(true)
                if State.FruitFilterData and State.FruitFilterData.Fruit then
                    table.remove(State.FruitFilterData.Fruit, f.Row or i)
                    saveFruitFilters()
                    log("Deleted fruit filter", tostring(f.Fruit or "?"))
                end
                overlay:Destroy()
                State.OpenFruitFilterManager()
            end)
        end)
    end

    if State.DisableAutoLocalize then State.DisableAutoLocalize(overlay) end
end
getFruitFilters = function()
    reloadFruitFilters(false)
    local out = {}
    for i, row in ipairs(State.FruitFilterData.Fruit or {}) do
        if type(row) == "table" and row.Enabled ~= false then
            local fruit = row.Fruit or row.fruit or row.Name or row.name or row.ItemName or row.itemName
            if fruit and tostring(fruit) ~= "" then
                table.insert(out, {
                    Row = i,
                    Fruit = tostring(fruit),
                    FruitNorm = norm(fruit),
                    Price = clampPrice(row.Price or row.price or row.Tokens or row.tokens),
                    MinWeight = toNumber(row.MinWeight or row.minWeight or row.MinKG or row.minKG or row.minKg or row.MinSize or row.minSize),
                    MaxWeight = toNumber(row.MaxWeight or row.maxWeight or row.MaxKG or row.maxKG or row.maxKg or row.MaxSize or row.maxSize),
                    Variant = normalizeMutationConfig(row.Variant or row.variant or row.Mutation or row.mutation or "Any"),
                    MaxListedFruit = toInt(row.MaxListedFruit or row.maxListedFruit or row.MaxListedPet or row.maxListedPet or row.MaxListed or row.maxListed) or 0,
                    Raw = row,
                })
            end
        end
    end
    return out
end

local function calculateFruitWeight(itemData)
    if type(itemData) ~= "table" then return nil end
    local seed = itemData.Seed
    local itemName = itemData.ItemName or itemData.Name
    local multiplier = toNumber(itemData.WeightMultiplier) or 1

    if State.FruitWeightCalculator and type(State.FruitWeightCalculator.Calculate_Weight) == "function" then
        local ok, base = pcall(State.FruitWeightCalculator.Calculate_Weight, seed, itemName)
        if ok and tonumber(base) then
            return (tonumber(base) or 0) * multiplier
        end
    elseif type(State.FruitWeightCalculator) == "function" then
        local ok, base = pcall(State.FruitWeightCalculator, seed, itemName)
        if ok and tonumber(base) then
            return (tonumber(base) or 0) * multiplier
        end
    end

    return toNumber(itemData.Weight or itemData.KG or itemData.Kilo or itemData.SizeMulti or itemData.WeightMultiplier)
end

local function getFruitMutationText(itemData)
    if type(itemData) ~= "table" then return "Normal" end
    local mutation = itemData.MutationString or itemData.Mutation or itemData.Mutations or ""
    mutation = tostring(mutation or "")
    if mutation == "" then mutation = "Normal" end
    return mutation
end

local function getOwnFruitsFromInventoryData()
    local okData, data = pcall(function() return DataService:GetData() end)
    if not okData or type(data) ~= "table" then
        log("Fruit inventory data failed", tostring(data))
        return {}
    end

    local listed = {}
    if data.TradeData and type(data.TradeData.Listings) == "table" then
        for _, l in pairs(data.TradeData.Listings) do
            if type(l) == "table" and l.ItemId then listed[tostring(l.ItemId)] = true end
        end
    end

    local out = {}
    local inventory = data.InventoryData
    if type(inventory) ~= "table" then return out end

    for id, item in pairs(inventory) do
        if type(item) == "table" and tostring(item.ItemType or "") == tostring(CFG.Fruit.ItemType or "Holdable") then
            local itemData = item.ItemData or {}
            local name = itemData.ItemName or itemData.Name
            if type(name) == "string" and name ~= "" then
                local tradeLock = data.TradeData and data.TradeData.TradeLocks and data.TradeData.TradeLocks[item.ItemType] and data.TradeData.TradeLocks[item.ItemType][id]
                local variant = tostring(itemData.Variant or "Normal")
                if variant == "" then variant = "Normal" end
                table.insert(out, {
                    UUID = tostring(id),
                    Type = tostring(item.ItemType or "Holdable"),
                    Name = tostring(name),
                    NameNorm = norm(name),
                    Weight = calculateFruitWeight(itemData),
                    Variant = variant,
                    Mutation = getFruitMutationText(itemData),
                    Favorited = itemData.IsFavorite == true,
                    Locked = (tradeLock == true or type(tradeLock) == "table" or type(tradeLock) == "string"),
                    AlreadyListed = listed[tostring(id)] == true,
                    Raw = item,
                    ItemData = itemData,
                })
            end
        end
    end

    table.sort(out, function(a, b)
        if a.NameNorm ~= b.NameNorm then return a.NameNorm < b.NameNorm end
        return (a.Weight or 999999) < (b.Weight or 999999)
    end)
    State.FruitInventoryCache = out
    return out
end
local function fruitMatchesFilter(fruit, f)
    if not fruit or not f then return false, "missing" end
    if fruit.NameNorm ~= f.FruitNorm then return false, "name" end
    if f.MinWeight ~= nil and (fruit.Weight == nil or fruit.Weight < f.MinWeight) then return false, "min kg" end
    if f.MaxWeight ~= nil and (fruit.Weight == nil or fruit.Weight > f.MaxWeight) then return false, "max kg" end
    if not traitWantedAny(f.Variant) and norm(fruit.Variant) ~= norm(f.Variant) then return false, "variant" end
    return true
end

local function listingToPseudoFruit(l)
    local item = l and l.Item or {}
    local name = item.ItemName or item.Name or item.FruitName or item.Fruit or l.PetType or "Unknown"
    return {
        UUID = tostring(l and l.ItemId or ""),
        Name = tostring(name),
        NameNorm = norm(name),
        Weight = toNumber(item.Weight or item.KG or item.Kilo or item.SizeMulti),
        Variant = tostring(item.Variant or item.Mutation or "Normal"),
    }
end

local function findFruitFilterForListing(l, filters, requirePrice)
    if tostring(l and l.ItemType or "") ~= tostring(CFG.Fruit.ItemType or "Holdable") then return nil, nil, "wrong item type" end
    local pseudo = listingToPseudoFruit(l)
    for _, f in ipairs(filters or getFruitFilters()) do
        local ok = fruitMatchesFilter(pseudo, f)
        if ok then
            if requirePrice then
                local listingPrice = clampPrice(l.Price)
                local filterPrice = clampPrice(f.Price)
                if not listingPrice or not filterPrice or listingPrice ~= filterPrice then
                    return nil, pseudo, "wrong price"
                end
            end
            return f, pseudo, nil
        end
    end
    return nil, pseudo, "no filter"
end

local function countMyGoodFruitListingsByFilter(filters, myListings)
    local counts = {}
    for _, l in ipairs(myListings or getMyListings()) do
        local f = findFruitFilterForListing(l, filters, true)
        if f then
            local key = tostring(f.FruitNorm) .. "|" .. tostring(f.Price) .. "|" .. tostring(f.MinWeight) .. "|" .. tostring(f.MaxWeight) .. "|" .. tostring(f.Variant)
            counts[key] = (counts[key] or 0) + 1
        end
    end
    return counts
end

local function buildFruitCandidates()
    local fruits = getOwnFruitsFromInventoryData()
    local filters = getFruitFilters()
    local myListings = getMyListings()
    local alreadyListedByFilter = countMyGoodFruitListingsByFilter(filters, myListings)
    local currentBoothListings = #myListings
    local currentFruitListings = 0
    for _, l in ipairs(myListings) do
        if tostring(l.ItemType or "") == tostring(CFG.Fruit.ItemType or "Holdable") then
            currentFruitListings += 1
        end
    end
    local maxFruitListings = math.max(0, toInt(CFG.Fruit.MaxListed) or 10)
    local chosenFruitTotal = 0
    local chosenFilter = {}
    local candidates, skipped = {}, {}

    for _, fruit in ipairs(fruits) do
        local reason, matched = nil, nil
        if fruit.Favorited then
            reason = "favorited"
        elseif fruit.Locked then
            reason = "trade locked"
        elseif fruit.AlreadyListed then
            reason = "already listed"
        else
            for _, f in ipairs(filters) do
                local ok, why = fruitMatchesFilter(fruit, f)
                if ok then matched = f; break end
                reason = why or "no filter"
            end
            if not matched then reason = "no filter" end
        end

        if matched and not matched.Price then reason = "filter no price" end
        if matched and not reason then
            local boothCap = tonumber(CFG.Seller.BoothCap) or 50
            local remainingBoothSlots = math.max(0, boothCap - currentBoothListings)
            local key = tostring(matched.FruitNorm) .. "|" .. tostring(matched.Price) .. "|" .. tostring(matched.MinWeight) .. "|" .. tostring(matched.MaxWeight) .. "|" .. tostring(matched.Variant)
            local maxListed = tonumber(matched.MaxListedFruit) or 0
            local currentListed = alreadyListedByFilter[key] or 0
            local chosen = chosenFilter[key] or 0

            if remainingBoothSlots <= 0 then
                reason = "booth full"
            elseif maxFruitListings > 0 and currentFruitListings >= maxFruitListings then
                reason = "fruit global cap reached"
            elseif maxFruitListings > 0 and chosenFruitTotal >= math.max(0, maxFruitListings - currentFruitListings) then
                reason = "fruit global cap"
            elseif maxListed > 0 and currentListed >= maxListed then
                reason = "filter cap reached"
            elseif maxListed > 0 and chosen >= math.max(0, maxListed - currentListed) then
                reason = "filter cap"
            else
                chosenFilter[key] = chosen + 1
                chosenFruitTotal += 1
                table.insert(candidates, {Fruit = fruit, Filter = matched})
            end
        end

        if reason then table.insert(skipped, {Fruit = fruit, Reason = reason}) end
    end

    State.LastFruitScan = {Fruits = fruits, Filters = filters, Candidates = candidates, Skipped = skipped}
    return State.LastFruitScan
end

local function verifyFruitListingAfterList(fruit, price, f)
    local targetId = tostring(fruit and fruit.UUID or "")
    local targetPrice = clampPrice(price)
    local attempts = math.max(1, toInt(CFG.Seller.VerifyAfterListAttempts) or 4)
    local delay = tonumber(CFG.Seller.VerifyAfterListDelay) or 0.75

    for attempt = 1, attempts do
        task.wait(delay)
        local listing = findMyListingByItemAndPrice(targetId, targetPrice, true, true)
        if listing then
            local pseudo = listingToPseudoFruit(listing)
            local listingPrice = clampPrice(listing.Price)
            local filterPrice = clampPrice(f and f.Price)
            if tostring(listing.ItemType or "") ~= tostring(CFG.Fruit.ItemType or "Holdable") or pseudo.NameNorm ~= tostring(f and f.FruitNorm or "") or not listingPrice or not filterPrice or listingPrice ~= filterPrice then
                log("UNSAFE fruit listing verified mismatch, removing", tostring(pseudo.Name), "price", tostring(listing.Price), "uuid", tostring(listing.ListingUUID))
                removeListingUUID(listing.ListingUUID)
                clearPendingList(targetId)
                return false, "verified fruit listing failed exact id/name/price check"
            end
            clearPendingList(targetId)
            return true, listing
        end

        local wrongPrice = findMyListingByItem(targetId, true, true)
        if wrongPrice then
            log("UNSAFE fruit listing wrong price, removing", tostring(wrongPrice.PetType), "expected", tostring(targetPrice), "got", tostring(wrongPrice.Price), "uuid", tostring(wrongPrice.ListingUUID))
            removeListingUUID(wrongPrice.ListingUUID)
            clearPendingList(targetId)
            return false, "listed at wrong price"
        end
    end

    return false, "not found in booth data"
end

local function listFruit(fruit, price, boothReady, f)
    if not fruit or not fruit.UUID then return false, "missing fruit id" end
    local fruitId = tostring(fruit.UUID)
    if not f or fruit.NameNorm ~= f.FruitNorm then return false, "fruit safety mismatch" end
    if State.PendingListUUIDs[fruitId] then return false, "pending" end
    if findMyListingByItemAndPrice(fruitId, price, true, true) then return false, "already listed" end
    local canSession, sessionWhy = canListSession()
    if not canSession then return false, sessionWhy end
    if CFG.Seller.RequireBoothBeforeList and not boothReady and not ensureBoothForListing() then return false, "no booth" end

    markPendingList(fruitId)
    local ok, result = pcall(function()
        return CreateListing:InvokeServer(tostring(CFG.Fruit.ItemType or "Holdable"), fruitId, clampPrice(price))
    end)
    if ok and result ~= false then
        State.InvalidateListingCache()
        State.LastListAt = os.clock()
        State.ListedThisSession = (State.ListedThisSession or 0) + 1
        table.insert(State.ListTimes, os.clock())
        local verified, verifyInfo = verifyFruitListingAfterList(fruit, price, f)
        if verified then
            registerCreateSuccess()
            log("Fruit listed OK + verified", fruit.Name, "price", tostring(price), "session", tostring(State.ListedThisSession))
        else
            log("Fruit list sent but NOT verified", fruit.Name, "price", tostring(price), tostring(verifyInfo))
        end
        return true
    end

    if ok and result == false and (os.clock() - (tonumber(State.LastCreateWaitSignal) or 0)) < 1.5 then
        registerCreateWait("CreateListing returned false")
        clearPendingList(fruitId)
        return false, "server wait"
    end

    clearPendingList(fruitId)
    log("Fruit listing failed", tostring(fruit.Name), tostring(result))
    return false, result
end

local function autoListFruits(scan)
    if not CFG.Fruit.Enabled or not CFG.Fruit.AutoList or CFG.Seller.PreviewOnly or not CFG.Seller.AutoList then return end
    scan = scan or buildFruitCandidates()
    if #scan.Filters == 0 or #scan.Candidates == 0 then return end
    local boothReady = ensureBoothForListing()
    if not boothReady then log("Fruit AutoList blocked", "no booth") return end

    local i = 1
    while i <= #scan.Candidates do
        local c = scan.Candidates[i]
        local serverWait = createWaitRemaining()
        if serverWait > 0 then task.wait(math.min(serverWait, 1)); continue end
        local can, why = canListNow()
        if not can then dlog("fruit list wait", why); break end
        local ok, whyList = listFruit(c.Fruit, c.Filter.Price, true, c.Filter)
        if ok then i += 1 elseif whyList == "server wait" then task.wait(math.min(math.max(createWaitRemaining(), 0.15), 1)) else i += 1 end
        local waitTime = tonumber(CFG.Seller.ListCooldown) or 0
        if waitTime > 0 then task.wait(waitTime) else task.wait() end
    end
end

State.BuildFruitCandidates = buildFruitCandidates
State.AutoListFruits = autoListFruits
_G.NOMO_FRUIT_SCAN = buildFruitCandidates
getgenv().NOMO_FRUIT_SCAN = buildFruitCandidates
end
State.InstallFruitListing()
State.SetBootStatus("post fruit")



task.spawn(function()
    task.wait(4)
    if not State.Running then return end

    local okFilters, filterData = pcall(reloadFilters)
    local filterCount = 0
    if okFilters and type(filterData) == "table" and type(filterData.Filters) == "table" then
        filterCount = #filterData.Filters
    end

    local okSniper, sniperResult = pcall(State.ReloadSniperConfig)
    local sniperOk = okSniper and sniperResult == true and type(CFG.Sniper.Watchlist) == "table" and next(CFG.Sniper.Watchlist) ~= nil

    if State.PendingRuntimeDefaultsSave then
        State.PendingRuntimeDefaultsSave = false
        State.SaveRuntimeSettings()
    end

    State.LastSellerScanAt = 0
    State.LastSniperScanAt = 0
    pcall(function() refreshSellerLog(false) end)
    pcall(State.RefreshSniperLog)
    pcall(refreshPills)
    pcall(State.RefreshDashboard)
    log("Startup delayed reload", "folder", getConfigFolder(), "filters", tostring(filterCount), "sniper", tostring(sniperOk))
end)

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

        local pauseUntil = tonumber(State.AutoSmartRebuildPausedUntil) or 0
        if os.clock() < pauseUntil then
            local waitLeft = math.min(8, math.max(1, pauseUntil - os.clock()))
            log("Auto Smart Rebuild paused", "find seller", string.format("%.1fs", waitLeft))
            task.wait(waitLeft)
        end

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
State.SetBootStatus("automation loop")
State.BootComplete = true
win.Pills.Status:Set("Ready", T.Green)
State.ClonePanelDirty = true
pcall(State.RefreshCloneStatus, true)
task.spawn(function()
    while State.Running do
        local now = os.clock()

        if CFG.Booth.AutoClaim and now >= (tonumber(State.AutoClaimOwnedSleepUntil) or 0) and now - (State.LastAutoClaimAt or 0) >= (tonumber(CFG.Booth.ClaimInterval) or 10) then
            State.LastAutoClaimAt = now
            local ok, err = pcall(function()
                local target, status = findBestBooth(true)
                if status ~= "MINE" and status ~= "FREE" then
                    target, status = findBestBooth(true, 999999)
                end
                if status == "MINE" then
                    State.LastBooth = target
                    State.AutoClaimOwnedSleepUntil = now + 60
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
                if State.AutoListFruits then
                    local okFruit, fruitErr = pcall(State.AutoListFruits)
                    if not okFruit then log("Fruit scan error", tostring(fruitErr)) end
                end
            else
                log("Seller scan error", tostring(scan))
            end
        end

        if CFG.Sniper.Enabled and now - State.LastSniperScanAt >= (tonumber(CFG.Sniper.ScanInterval) or 10) then
            State.LastSniperScanAt = now
            local ok, err = pcall(function()
                State.ApplySniperLimits()
                local matches = snipeDryRun()
                if CFG.Sniper.DryRun == false and #matches > 0 then
                    buyFirstMatch()
                end
            end)
            if not ok then log("Sniper scan error", tostring(err)) end
        end

        if CFG.Webhook.Enabled and CFG.Webhook.PetSold and now - (State.LastSoldCheckAt or 0) >= 5 then
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
