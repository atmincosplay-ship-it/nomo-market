--//====================================================--
--// NOMO MARKET SELLER LITE V3.0
--// Blue Rose Full UI + Exact Booth/Listings Data Core
--// Seller focused. Sniper dry-run only by default.
--//====================================================--

local VERSION = "V7.0 SNIPER SAFETY"
print("[NOMO] Booting " .. VERSION)

local NOMO_MODE = tostring(getgenv().NOMO_MODE or getgenv().mode or "full"):lower()
if NOMO_MODE == "no_ui" or NOMO_MODE == "none" or NOMO_MODE == "headless" then
    NOMO_MODE = "noui"
end
if NOMO_MODE ~= "full" and NOMO_MODE ~= "status" and NOMO_MODE ~= "noui" then
    NOMO_MODE = "full"
end
getgenv().NOMO_MODE = NOMO_MODE
print("[NOMO] Mode:", NOMO_MODE)

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
    ListingFilterPath = "Nomo/listing_filter.json",
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
    MaxMatchesPerOwner = 2,    -- prevent one seller filling the list

    Watchlist = {},
}

CFG.Debug = CFG.Debug or false
if CFG.Booth.MaxMiddleDistance == nil or tonumber(CFG.Booth.MaxMiddleDistance) == 200 then
    CFG.Booth.MaxMiddleDistance = 85
end
CFG.Booth.ClaimInterval = CFG.Booth.ClaimInterval or 10
CFG.Booth.DataCacheSeconds = CFG.Booth.DataCacheSeconds or 0.25
CFG.Booth.ClaimVerifyAttempts = CFG.Booth.ClaimVerifyAttempts or 6
CFG.Booth.ClaimVerifyDelay = CFG.Booth.ClaimVerifyDelay or 0.35
CFG.Seller.BoothCap = CFG.Seller.BoothCap or 50
CFG.Seller.WeightMode = CFG.Seller.WeightMode or "Base"
CFG.Seller.ShowSkipReasons = CFG.Seller.ShowSkipReasons ~= false
CFG.Seller.RequireBoothBeforeList = CFG.Seller.RequireBoothBeforeList ~= false
CFG.Seller.ScanInterval = tonumber(CFG.Seller.ScanInterval) or 0.25
if CFG.Seller.ScanInterval > 1 then CFG.Seller.ScanInterval = 0.25 end
CFG.Seller.ListCooldown = tonumber(CFG.Seller.ListCooldown) or 0
if CFG.Seller.ListCooldown > 1 then CFG.Seller.ListCooldown = 0 end
CFG.Seller.ListOnceMax = CFG.Seller.ListOnceMax or 50
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
CFG.Seller.AdaptiveCreateWait = CFG.Seller.AdaptiveCreateWait ~= false
CFG.Seller.CreateWaitMin = math.max(5, tonumber(CFG.Seller.CreateWaitMin) or 5)
CFG.Seller.CreateWaitMax = math.max(CFG.Seller.CreateWaitMin, tonumber(CFG.Seller.CreateWaitMax) or 10)
CFG.Seller.CreateWaitBackoff = math.clamp(tonumber(CFG.Seller.CreateWaitBackoff) or 5, CFG.Seller.CreateWaitMin, CFG.Seller.CreateWaitMax)
CFG.Seller.MinPetCountKeep = 0
CFG.Seller.MaxListPerMinute = 999
CFG.Seller.MaxAutoListSession = CFG.Seller.BoothCap
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
CFG.Sniper.BuyCooldown = tonumber(CFG.Sniper.BuyCooldown) or 0
if CFG.Sniper.BuyCooldown > 1 then CFG.Sniper.BuyCooldown = 0 end
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
    LastAutoClaimAt = 0,
    LastUIRefreshAt = 0,
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

local function getFilterPath()
    return CFG.Seller.ListingFilterPath or "Nomo/listing_filter.json"
end

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

local function autoClaimTick(reason)
    if not CFG.Booth.AutoClaim then
        return false
    end

    local target, status = findBestBooth(true)
    log("AutoClaim check", tostring(reason or "loop"), tostring(status), target and target.Id or "none")

    if status == "MINE" then
        State.LastBooth = target
        return true
    end

    return claimBestFreeBooth()
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

saveFilters = function()
    return saveJson(getFilterPath(), State.FilterData)
end

local function traitWantedAny(v)
    v = norm(v or "Any")
    return v == "" or v == "any" or v == "all" or v == "off" or v == "none" or v == "normal"
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
                    Mutation = row.Mutation or row.mutation or "Any",
                    -- Hatch types like GIANT/Rainbow-hatched pets appear as different Pet names in the game API.
                    -- Keep Variant fields only for backward compatibility, but do not require them by default.
                    Variant = "Any",
                    ExcludeMutations = splitList(row.ExcludeMutations or row.excludeMutations),
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

local function verifyListingAfterList(pet, price)
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
            clearPendingList(targetId)
            return true, listing
        end
    end

    return false, "not found in booth data"
end

local function listPet(pet, price, boothReady)
    if not pet or not pet.UUID then
        return false, "missing pet uuid"
    end

    local petUUID = tostring(pet.UUID)
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

        local verified, verifyInfo = verifyListingAfterList(pet, price)
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
        local ok, whyList = listPet(c.Pet, c.Filter.Price, true)
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

        local ok, whyList = listPet(c.Pet, c.Filter.Price, true)
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
    CFG.Sniper.Watchlist[tostring(exactPet or pet)] = {MaxPrice = price or 0}
    log("Added sniper watch", tostring(exactPet or pet), "max", tostring(price or 0))
    return true
end

local function clearWatch()
    CFG.Sniper.Watchlist = {}
    log("Cleared sniper watchlist")
end

local function removeWatch(name)
    CFG.Sniper.Watchlist = CFG.Sniper.Watchlist or {}
    local target = norm(name)
    for watchName in pairs(CFG.Sniper.Watchlist) do
        if norm(watchName) == target then
            CFG.Sniper.Watchlist[watchName] = nil
            log("Removed sniper watch", tostring(watchName))
            return true
        end
    end
    log("Sniper watch not found", tostring(name))
    return false
end

local function snipeDryRun(force)
    local myId = tostring(getPlayerId())
    local watchNorm = {}

    for name, cfg in pairs(CFG.Sniper.Watchlist or {}) do
        watchNorm[norm(name)] = {
            Name = name,
            MaxPrice = tonumber(type(cfg) == "table" and cfg.MaxPrice or cfg) or 0,
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
                    table.insert(raw, {
                        Listing = l,
                        Watch = w,
                    })
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
    local maxPerPet = tonumber(CFG.Sniper.MaxMatchesPerPet) or 5
    local maxPerOwner = tonumber(CFG.Sniper.MaxMatchesPerOwner) or 2

    local petCounts = {}
    local ownerCounts = {}
    local filtered = {}

    for _, m in ipairs(raw) do
        local petKey = norm(m.Listing.PetType)
        local ownerKey = tostring(m.Listing.OwnerId)

        petCounts[petKey] = petCounts[petKey] or 0
        ownerCounts[ownerKey] = ownerCounts[ownerKey] or 0

        local petOk = maxPerPet <= 0 or petCounts[petKey] < maxPerPet
        local ownerOk = maxPerOwner <= 0 or ownerCounts[ownerKey] < maxPerOwner

        if petOk and ownerOk then
            table.insert(filtered, m)
            petCounts[petKey] += 1
            ownerCounts[ownerKey] += 1
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

local function validateSniperMatch(m)
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
        return a, b
    end
    log("Buy failed", tostring(a))
    return false
end



-- ============================================================
--  NOMO MARKET  |  Holy PRO style  |  Blue #6366F1 accent
--  Obsidian library (deividcomsono/Obsidian)
-- ============================================================

local refreshSellerLog = function() end
local refreshMyListingsLog = function() end
local refreshMarketSample = function() end
local refreshSniperLog = function() end
local applySniperLimits = function() end
local NOMO_NOTIFY = function() end

if NOMO_MODE == "full" then
print("[NOMO UI] Loading Obsidian...")

local REPO_URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local HttpSvc  = game:GetService("HttpService")

local ok1, Library = pcall(function() return loadstring(game:HttpGet(REPO_URL.."Library.lua"))() end)
if not ok1 or not Library then warn("[NOMO UI] Library failed:", tostring(Library)); NOMO_MODE = "noui" else
print("[NOMO UI] Library OK")
NOMO_NOTIFY = function(opts)
    pcall(function()
        Library:Notify(opts)
    end)
end

local ok2, ThemeManager = pcall(function() return loadstring(game:HttpGet(REPO_URL.."addons/ThemeManager.lua"))() end)
local ok3, SaveManager  = pcall(function() return loadstring(game:HttpGet(REPO_URL.."addons/SaveManager.lua"))() end)

-- ── UI Settings ──────────────────────────────────────────────
local UIState = { ShowUIOnLoad = true }
pcall(function()
    if type(isfile)=="function" and isfile("Nomo/UISettings.json") then
        local d = HttpSvc:JSONDecode(readfile("Nomo/UISettings.json"))
        if type(d.ShowUIOnLoad)=="boolean" then UIState.ShowUIOnLoad = d.ShowUIOnLoad end
    end
end)

-- ── Accent / color constants (blue #6366F1) ──────────────────
local ACCENT   = "rgb(99,102,241)"
local ACCENT_G = "rgb(129,140,248)"   -- lighter
local DIM      = "rgb(100,100,120)"
local WHITE    = "rgb(232,230,240)"
local GREEN    = "rgb(74,222,128)"
local RED_C    = "rgb(248,113,113)"
local YELLOW   = "rgb(250,204,21)"

local function C(text, color, bold)
    if bold then return '<font color="'..color..'"><b>'..text..'</b></font>' end
    return '<font color="'..color..'">'..text..'</font>'
end

-- ── Window ───────────────────────────────────────────────────
local Window = Library:CreateWindow({
    Title      = C("NOMO", WHITE).." "..C("MARKET", ACCENT, true),
    Footer     = C("nomo market", DIM).." · "..C(tostring(VERSION or ""), ACCENT_G),
    Center     = true,
    AutoShow   = UIState.ShowUIOnLoad,
    Resizable  = true,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Size = UDim2.fromOffset(860, 560),
})

print("[NOMO UI] Window OK, adding tabs...")

-- ── Tabs ─────────────────────────────────────────────────────
local Tabs = {
    Home     = Window:AddTab("Home"),
    Seller   = Window:AddTab("Seller"),
    Market   = Window:AddTab("Market"),
    Sniper   = Window:AddTab("Sniper"),
    Settings = Window:AddTab("Settings"),
}

-- ── Safe helpers ─────────────────────────────────────────────
local function SetText(ctrl, text)
    if not ctrl then return end
    pcall(function()
        if type(ctrl.SetText)=="function" then ctrl:SetText(tostring(text or ""))
        else ctrl.Text = tostring(text or "") end
    end)
end

local function Opt(name, default)
    local pools = {
        rawget(getgenv(), "Options"),
        rawget(_G, "Options"),
        Library and Library.Options,
    }

    for _, pool in ipairs(pools) do
        local item = type(pool) == "table" and pool[name]
        if type(item) == "table" and item.Value ~= nil then
            return item.Value
        end
    end

    return default
end

local function linesToStr(lines, max)
    max = max or 50
    local out = {}
    for i, l in ipairs(lines) do
        if i > max then table.insert(out, C("... +"..( #lines-max).." more", DIM)) break end
        table.insert(out, tostring(l))
    end
    return table.concat(out, "\n")
end

-- ── Exotic-style pet list popup ──────────────────────────────
-- Creates a ScreenGui overlay with a scrollable searchable list.
-- callback(selectedName) is called when user clicks an item.

local function ShowPetPickerPopup(title, itemList, callback)
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    -- destroy any existing popup
    local old = PlayerGui:FindFirstChild("NomoPetPicker")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NomoPetPicker"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999999
    gui.Parent = PlayerGui

    -- dim overlay
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.fromScale(1,1)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = gui

    -- modal card
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(480, 400)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(99, 102, 241)
    stroke.Thickness = 1.5
    stroke.Parent = card

    -- title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 14, 28)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 3
    titleBar.Parent = card

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -50, 1, 0)
    titleLbl.Position = UDim2.fromOffset(14, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "🔍  "..tostring(title or "Select")
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = Color3.fromRGB(232, 230, 240)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 4
    titleLbl.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(32, 32)
    closeBtn.Position = UDim2.new(1, -40, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 28, 50)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 4
    closeBtn.Parent = titleBar
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
    overlay.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then gui:Destroy() end
    end)

    -- search box
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -24, 0, 34)
    searchBox.Position = UDim2.fromOffset(12, 46)
    searchBox.BackgroundColor3 = Color3.fromRGB(20, 18, 35)
    searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "Search items..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(100, 96, 130)
    searchBox.Text = ""
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextSize = 13
    searchBox.TextColor3 = Color3.fromRGB(232, 230, 240)
    searchBox.ClearTextOnFocus = false
    searchBox.ZIndex = 3
    searchBox.Parent = card
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,7)
    local sStroke = Instance.new("UIStroke", searchBox)
    sStroke.Color = Color3.fromRGB(60,60,100)
    sStroke.Thickness = 1

    -- scroll frame
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -24, 1, -96)
    scroll.Position = UDim2.fromOffset(12, 86)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(99,102,241)
    scroll.CanvasSize = UDim2.fromScale(1, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 3
    scroll.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = scroll

    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingBottom = UDim.new(0, 6)

    -- row builder
    local function BuildRows(filter)
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local count = 0
        for _, item in ipairs(itemList) do
            local name = tostring(item)
            if filter=="" or name:lower():find(filter:lower(), 1, true) then
                count = count + 1
                local row = Instance.new("TextButton")
                row.Size = UDim2.new(1, 0, 0, 34)
                row.BackgroundColor3 = Color3.fromRGB(16, 14, 30)
                row.BackgroundTransparency = 0.3
                row.BorderSizePixel = 0
                row.Text = name
                row.Font = Enum.Font.GothamMedium
                row.TextSize = 13
                row.TextColor3 = Color3.fromRGB(210, 210, 230)
                row.TextXAlignment = Enum.TextXAlignment.Left
                row.ZIndex = 4
                row.LayoutOrder = count
                row.Parent = scroll
                local rp = Instance.new("UIPadding", row)
                rp.PaddingLeft = UDim.new(0, 12)
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
                row.MouseEnter:Connect(function()
                    row.BackgroundColor3 = Color3.fromRGB(99,102,241)
                    row.BackgroundTransparency = 0
                    row.TextColor3 = Color3.fromRGB(255,255,255)
                end)
                row.MouseLeave:Connect(function()
                    row.BackgroundColor3 = Color3.fromRGB(16, 14, 30)
                    row.BackgroundTransparency = 0.3
                    row.TextColor3 = Color3.fromRGB(210, 210, 230)
                end)
                row.MouseButton1Click:Connect(function()
                    gui:Destroy()
                    if type(callback)=="function" then callback(name) end
                end)
            end
        end
    end

    BuildRows("")
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        BuildRows(searchBox.Text)
    end)

    print("[NOMO UI] Pet picker shown: "..tostring(title))
end

-- ── Shared state for pet picker selections ────────────────────
local PickerState = {
    SellerPet      = "Ankylosaurus",
    SellerMutation = "Any",
    SniperPet      = "Red Fox",
}

-- ═══════════════════════════════════════════════════════════
--  HOME TAB  (was Booth)
--  Left = Runtime Controls | Right = Automation
-- ═══════════════════════════════════════════════════════════
local HL = Tabs.Home:AddLeftGroupbox("Runtime Controls")
local HR = Tabs.Home:AddRightGroupbox("Automation")

-- live status
local homeStatusLbl = HL:AddLabel(C("Booth: —", DIM).."  |  "..C("Tokens: —", DIM))
task.spawn(function()
    while true do task.wait(2)
        local bt = "—"
        pcall(function()
            local best, status = findBestBooth()
            bt = status or "—"
        end)
        local tok = "0"
        pcall(function() tok = commaNumber(getTokenBalance()) end)
        SetText(homeStatusLbl,
            C("Booth: ", DIM)..C(bt, ACCENT_G).."  |  "..
            C("Tokens: ", DIM)..C(tok, WHITE))
    end
end)

HL:AddToggle("BAutoList", {
    Text    = C("AUTO LIST", GREEN, true),
    Default = CFG.Seller.AutoList,
    Tooltip = "Automatically list pets based on active filters.",
}):OnChanged(function(v) CFG.Seller.AutoList=v; CFG.Seller.PreviewOnly=not v; log("AutoList",tostring(v)) end)

HL:AddToggle("BPreviewOnly", {
    Text    = "Preview Only (no list)",
    Default = CFG.Seller.PreviewOnly,
}):OnChanged(function(v) CFG.Seller.PreviewOnly=v; if v then CFG.Seller.AutoList=false end end)

HL:AddToggle("BSkipFav",    { Text="Skip Favorited", Default=CFG.Seller.SkipFavorited  }):OnChanged(function(v) CFG.Seller.SkipFavorited=v end)
HL:AddToggle("BSkipLocked", { Text="Skip Locked",    Default=CFG.Seller.SkipLocked     }):OnChanged(function(v) CFG.Seller.SkipLocked=v end)
HL:AddDivider()
HL:AddInput("BScanInterval", { Text="Scan Interval",  Default=tostring(CFG.Seller.ScanInterval),       Numeric=true, Finished=true }):OnChanged(function(v) CFG.Seller.ScanInterval=tonumber(v) or CFG.Seller.ScanInterval end)
HL:AddInput("BListCooldown", { Text="List Cooldown",   Default=tostring(CFG.Seller.ListCooldown),       Numeric=true, Finished=true }):OnChanged(function(v) CFG.Seller.ListCooldown=tonumber(v) or CFG.Seller.ListCooldown end)
HL:AddInput("BBoothCap",     { Text="Booth Cap",       Default=tostring(CFG.Seller.BoothCap or 50),    Numeric=true, Finished=true }):OnChanged(function(v) CFG.Seller.BoothCap=tonumber(v) or 50; CFG.Seller.MaxAutoListSession=CFG.Seller.BoothCap end)
HL:AddDropdown("BWeightMode",{ Text="Weight Filter",   Default=CFG.Seller.WeightMode or "Base",        Values={"Base","Visual"} }):OnChanged(function(v) CFG.Seller.WeightMode=tostring(v or "Base") end)
HL:AddInput("BListMax",      { Text="List Max (once)", Default=tostring(CFG.Seller.ListOnceMax or 50), Numeric=true, Finished=true }):OnChanged(function(v) CFG.Seller.ListOnceMax=tonumber(v) or 50 end)

-- Automation
HR:AddToggle("BAutoClaim",   { Text=C("AUTO CLAIM BOOTH",GREEN,true), Default=CFG.Booth.AutoClaim            }):OnChanged(function(v) CFG.Booth.AutoClaim=v; log("AutoClaim",tostring(v)) end)
HR:AddToggle("BSmartReclaim",{ Text="Smart Reclaim",                  Default=CFG.Booth.SmartReclaim         }):OnChanged(function(v) CFG.Booth.SmartReclaim=v end)
HR:AddToggle("BAutoRebuild", { Text="Auto Smart Rebuild On Start",    Default=CFG.Seller.AutoSmartRebuildOnStart }):OnChanged(function(v) CFG.Seller.AutoSmartRebuildOnStart=v end)
HR:AddToggle("BRemoteCfg",   { Text="Remote Config",                  Default=CFG.Seller.RemoteConfigEnabled }):OnChanged(function(v) CFG.Seller.RemoteConfigEnabled=v end)
HR:AddDivider()
HR:AddInput("BMaxDist",      { Text="Max Middle Distance", Default=tostring(CFG.Booth.MaxMiddleDistance),    Numeric=true, Finished=true }):OnChanged(function(v) CFG.Booth.MaxMiddleDistance=tonumber(v) or CFG.Booth.MaxMiddleDistance end)
HR:AddInput("BBoothSkin",    { Text="Booth Skin",          Default=tostring(CFG.Booth.BoothSkin or "Default"), Finished=true }):OnChanged(function(v) CFG.Booth.BoothSkin=trim(v)~="" and trim(v) or "Default" end)
HR:AddInput("BClaimInterval",{ Text="Claim Interval (s)",  Default=tostring(CFG.Booth.ClaimInterval or 10), Numeric=true, Finished=true }):OnChanged(function(v) CFG.Booth.ClaimInterval=tonumber(v) or 10 end)
HR:AddDivider()
HR:AddButton("LIST UNTIL BOOTH FULL",    function() CFG.Seller.ListOnceMax=tonumber(Opt("BListMax", CFG.Seller.ListOnceMax or 50)) or 50; task.spawn(function() listOnce(CFG.Seller.ListOnceMax) end) end)
HR:AddButton("REMOVE ALL MY LISTINGS",   function() task.spawn(function() removeAllMyListings(CFG.Listings.RemoveAllMax or 50); task.wait(0.6) end) end)
HR:AddButton("REBUILD BOOTH",            function() task.spawn(function() rebuildBooth();      task.wait(0.6) end) end)
HR:AddButton("SMART REBUILD",            function() task.spawn(function() smartRebuildBooth(); task.wait(0.6) end) end)
HR:AddButton("CLAIM BEST FREE",          function() claimBestFreeBooth() end)
HR:AddButton("EQUIP SKIN",               function() local skin = tostring(Opt("BBoothSkin", CFG.Booth.BoothSkin or "Default")); CFG.Booth.BoothSkin=trim(skin)~="" and trim(skin) or "Default"; equipSkin() end)
HR:AddButton("RELOAD REMOTE CONFIG",     function() task.spawn(reloadFilters) end)

-- ═══════════════════════════════════════════════════════════
--  SELLER TAB
--  Left = Filter Builder | Right = Active Filters/Candidates
-- ═══════════════════════════════════════════════════════════
local SLL = Tabs.Seller:AddLeftGroupbox("Filter Builder")
local SLR = Tabs.Seller:AddRightGroupbox("Active Filters / Candidates")

-- pet picker button (Exotic style)
local sellerPetLbl = SLL:AddLabel(C("Pet: ", DIM)..C(PickerState.SellerPet, ACCENT_G))

SLL:AddButton("🔍  Select Pet", function()
    ShowPetPickerPopup("Select Pet", getPetList(), function(name)
        PickerState.SellerPet = name
        SetText(sellerPetLbl, C("Pet: ", DIM)..C(name, ACCENT_G))
    end)
end)

local sellerMutLbl = SLL:AddLabel(C("Mutation: ", DIM)..C("Any", ACCENT_G))

SLL:AddButton("🔍  Select Mutation", function()
    local mutList = getMutationList()
    table.insert(mutList, 1, "Any")
    ShowPetPickerPopup("Select Mutation", mutList, function(name)
        PickerState.SellerMutation = name
        SetText(sellerMutLbl, C("Mutation: ", DIM)..C(name, ACCENT_G))
    end)
end)

SLL:AddDivider()
SLL:AddInput("SFilterPrice",  { Text="Price",         Default="111",  Numeric=true, Finished=false })
SLL:AddInput("SFilterMinKg",  { Text="Min Base KG",   Default="1",    Numeric=true, Finished=false })
SLL:AddInput("SFilterMaxKg",  { Text="Max Base KG",   Default="3",    Numeric=true, Finished=false })
SLL:AddInput("SFilterMinAge", { Text="Min Age",       Default="1",    Numeric=true, Finished=false })
SLL:AddInput("SFilterMaxAge", { Text="Max Age",       Default="100",  Numeric=true, Finished=false })
SLL:AddInput("SFilterCap",    { Text="Per Filter Cap",Default="5",    Numeric=true, Finished=false })
SLL:AddDivider()

SLL:AddButton("+ ADD FILTER", function()
    local ok = addFilter(PickerState.SellerPet, Opt("SFilterPrice", "111"), Opt("SFilterMinKg", "1"),
              Opt("SFilterMaxKg", "3"), Opt("SFilterMinAge", "1"), Opt("SFilterMaxAge", "100"),
              PickerState.SellerMutation, Opt("SFilterCap", "5"), "Any")
    if not ok then log("Add filter UI failed", tostring(PickerState.SellerPet)) end
    refreshSellerLog(true)
end)
SLL:AddButton("Preview Candidates",    function() refreshSellerLog(true) end)
SLL:AddInput("SDelNum", { Text="Remove Filter #", Default="1", Numeric=true, Finished=false })
SLL:AddButton("Remove Selected Filter",function() deleteFilter(Opt("SDelNum", 1)); refreshSellerLog(true) end)
SLL:AddButton("Clear All Filters",     function() clearFilters(); refreshSellerLog(false) end)
SLL:AddButton("Diagnose This Pet",     function()
    if diagnosePetFilter then
        local lines = diagnosePetFilter(PickerState.SellerPet)
        SetText(sellerLogLbl, linesToStr(lines))
    end
end)

local sellerLogLbl = SLR:AddLabel(C("Press Preview Candidates", DIM))

refreshSellerLog = function(showCandidates)
    local filters    = getFilters()
    local myListings = getMyListings()
    local lines = {
        C("Filters: ", DIM)..C(tostring(#filters), WHITE),
        C("Booth: ",   DIM)..C(#myListings.." / "..(CFG.Seller.BoothCap or 50), WHITE),
        C("Listed: ",  DIM)..C(tostring(State.ListedThisSession or 0), WHITE),
        C("Weight: ",  DIM)..C(CFG.Seller.WeightMode or "Base", ACCENT_G),
        "------------------------------",
    }
    for i, f in ipairs(filters) do
        if i > 12 then table.insert(lines, C("... +"..(#filters-12).." more", DIM)) break end
        table.insert(lines, string.format("%02d. "..C("%s","rgb(129,140,248)").." | "..C("%s",WHITE).." | BKG "..C("%s-%s","rgb(74,222,128)").." | Age %s-%s | Mut "..C("%s","rgb(250,204,21)").." | Cap %s",
            i, f.Pet, tostring(f.Price), fmtKg(f.MinWeight), fmtKg(f.MaxWeight),
            tostring(f.MinLevel), tostring(f.MaxLevel), tostring(f.Mutation or "Any"), tostring(f.MaxListedPet or 0)))
    end
    if showCandidates then
        local ok, scan = pcall(buildCandidates)
        if ok and scan then
            table.insert(lines, "------------------------------")
            table.insert(lines, C("Pets "..#scan.Pets, ACCENT_G).." | "..C("Cand "..#scan.Candidates, GREEN).." | "..C("Skip "..#scan.Skipped, DIM))
            for i, c in ipairs(scan.Candidates) do
                if i > 10 then table.insert(lines, C("... +"..(#scan.Candidates-10).." more", DIM)) break end
                table.insert(lines, string.format("%02d. "..C("%s",ACCENT_G).." | B%s V%s | Age %s | Mut "..C("%s",YELLOW).." | "..C("%s",GREEN),
                    i, c.Pet.Name, fmtKg(c.Pet.BaseWeight), fmtKg(c.Pet.VisualWeight),
                    tostring(c.Pet.Age or "?"), tostring(c.Pet.Mutation or "Normal"), tostring(c.Filter.Price)))
            end
        end
    end
    SetText(sellerLogLbl, linesToStr(lines))
end

-- ═══════════════════════════════════════════════════════════
--  MARKET TAB
--  Left = My Listings | Right = Market Sample
-- ═══════════════════════════════════════════════════════════
local ML = Tabs.Market:AddLeftGroupbox("My Listings")
local MR = Tabs.Market:AddRightGroupbox("Market Sample")

ML:AddButton("Refresh My Listings",    function() refreshMyListingsLog() end)
ML:AddButton("REMOVE ALL MY LISTINGS", function()
    task.spawn(function() removeAllMyListings(CFG.Listings.RemoveAllMax or 50); task.wait(0.6); refreshMyListingsLog() end)
end)
ML:AddInput("MRemoveUUID", { Text="Remove by UUID (short ok)", Default="", Finished=false })
ML:AddButton("Remove That Listing", function()
    local uuid = tostring(Opt("MRemoveUUID", ""))
    if uuid=="" then return end
    for _, l in ipairs(getMyListings()) do
        if tostring(l.ListingUUID or ""):sub(1,#uuid)==uuid then
            removeListingUUID(l.ListingUUID); task.wait(0.4); refreshMyListingsLog()
            NOMO_NOTIFY({ Title="Market", Content="Removed!", Duration=2 }); return
        end
    end
    NOMO_NOTIFY({ Title="Market", Content="UUID not found", Duration=2 })
end)
local myListingsLbl = ML:AddLabel(C("Press Refresh", DIM))

MR:AddButton("Refresh Market Sample", function() refreshMarketSample() end)
local marketLbl = MR:AddLabel(C("—", DIM))

refreshMyListingsLog = function()
    local my = getMyListings()
    local lines = {
        C("My listings: "..#my, WHITE),
        "------------------------------",
    }
    for i, l in ipairs(my) do
        if i > 50 then table.insert(lines, C("... +"..(#my-50).." more", DIM)) break end
        table.insert(lines, string.format("%02d. "..C("%s",ACCENT_G).." | "..C("%s tok",GREEN).." | %s",
            i, tostring(l.PetType or "?"), commaNumber(l.Price), tostring(l.ListingUUID or ""):sub(1,8)))
    end
    SetText(myListingsLbl, linesToStr(lines))
end

refreshMarketSample = function()
    local ok, all = pcall(getAllListings)
    if not ok or type(all) ~= "table" then
        SetText(marketLbl, C("Failed to fetch listings", RED_C))
        return
    end
    local CAP = 6
    local lines = { C("All listings: "..#all, WHITE) }
    for i, l in ipairs(all) do
        if i > CAP then table.insert(lines, C("... +"..(#all-CAP).." more", DIM)) break end
        table.insert(lines, string.format("%02d. "..C("%s",ACCENT_G).." | "..C("%s",GREEN).." | %s",
            i, l.PetType, tostring(l.Price), l.OwnerName))
    end
    SetText(marketLbl, linesToStr(lines))
end

-- ═══════════════════════════════════════════════════════════
--  SNIPER TAB
--  Left = Sniper Control | Right = Matches / Watchlist
-- ═══════════════════════════════════════════════════════════
local SNL = Tabs.Sniper:AddLeftGroupbox("Sniper Control")
local SNR = Tabs.Sniper:AddRightGroupbox("Matches / Watchlist")

SNL:AddToggle("SnEnabled", { Text=C("ENABLE SNIPER",GREEN,true),  Default=CFG.Sniper.Enabled }):OnChanged(function(v) CFG.Sniper.Enabled=v; log("Sniper",tostring(v)) end)
SNL:AddToggle("SnDryRun",  { Text="Dry Run (no buy)",             Default=CFG.Sniper.DryRun  }):OnChanged(function(v) CFG.Sniper.DryRun=v end)
SNL:AddToggle("SnRescan",  { Text="Rescan Before Buy",            Default=CFG.Sniper.RescanBeforeBuy }):OnChanged(function(v) CFG.Sniper.RescanBeforeBuy=v end)
SNL:AddDivider()

-- sniper pet picker
local sniperPetLbl = SNL:AddLabel(C("Pet: ", DIM)..C(PickerState.SniperPet, ACCENT_G))
SNL:AddButton("🔍  Select Pet", function()
    ShowPetPickerPopup("Sniper Target Pet", getPetList(), function(name)
        PickerState.SniperPet = name
        SetText(sniperPetLbl, C("Pet: ", DIM)..C(name, ACCENT_G))
    end)
end)

SNL:AddInput("SnMaxPrice",    { Text="Max Price",    Default="6",                                         Numeric=true, Finished=false })
SNL:AddInput("SnBuyCooldown", { Text="Buy Cooldown", Default=tostring(CFG.Sniper.BuyCooldown or 0),       Numeric=true, Finished=true  }):OnChanged(function(v) CFG.Sniper.BuyCooldown        =tonumber(v) or 0  end)
SNL:AddInput("SnShow",        { Text="Show Max",     Default=tostring(CFG.Sniper.MaxMatchesShown or 20),  Numeric=true, Finished=true  }):OnChanged(function(v) CFG.Sniper.MaxMatchesShown     =tonumber(v) or 20 end)
SNL:AddInput("SnPerPet",      { Text="Per Pet",      Default=tostring(CFG.Sniper.MaxMatchesPerPet or 5),  Numeric=true, Finished=true  }):OnChanged(function(v) CFG.Sniper.MaxMatchesPerPet    =tonumber(v) or 5  end)
SNL:AddInput("SnPerOwner",    { Text="Per Owner",    Default=tostring(CFG.Sniper.MaxMatchesPerOwner or 2),Numeric=true, Finished=true  }):OnChanged(function(v) CFG.Sniper.MaxMatchesPerOwner  =tonumber(v) or 2  end)
SNL:AddDivider()

local sniperLogLbl = SNR:AddLabel(C("Press Dry Run Scan", DIM))

applySniperLimits = function()
    CFG.Sniper.BuyCooldown        = tonumber(Opt("SnBuyCooldown", CFG.Sniper.BuyCooldown or 0)) or 0
    CFG.Sniper.MaxMatchesShown    = tonumber(Opt("SnShow", CFG.Sniper.MaxMatchesShown or 20)) or 20
    CFG.Sniper.MaxMatchesPerPet   = tonumber(Opt("SnPerPet", CFG.Sniper.MaxMatchesPerPet or 5)) or 5
    CFG.Sniper.MaxMatchesPerOwner = tonumber(Opt("SnPerOwner", CFG.Sniper.MaxMatchesPerOwner or 2)) or 2
end

refreshSniperLog = function()
    local lines = {
        C("DryRun=",DIM)..C(tostring(CFG.Sniper.DryRun),CFG.Sniper.DryRun and YELLOW or GREEN).." | "..
        C("Rescan=",DIM)..C(tostring(CFG.Sniper.RescanBeforeBuy), WHITE),
        "------------------------------",
        C("Watchlist:",DIM),
    }
    for name, cfg2 in pairs(CFG.Sniper.Watchlist or {}) do
        table.insert(lines, "  "..C("- ",DIM)..C(tostring(name),ACCENT_G).." "..C("<=",DIM).." "..C(tostring(type(cfg2)=="table" and cfg2.MaxPrice or cfg2),GREEN))
    end
    table.insert(lines, "------------------------------")
    table.insert(lines, C("Matches: "..#State.LastSniperMatches, WHITE))
    for i, m in ipairs(State.LastSniperMatches) do
        if i > 18 then table.insert(lines, C("... +"..(#State.LastSniperMatches-18).." more", DIM)) break end
        local l = m.Listing
        table.insert(lines, string.format("%02d. "..C("%s",ACCENT_G).." | "..C("%s",GREEN).." | %s",
            i, l.PetType, tostring(l.Price), l.OwnerName))
    end
    SetText(sniperLogLbl, linesToStr(lines))
end

SNL:AddButton("ADD WATCH",               function() applySniperLimits(); addWatch(PickerState.SniperPet, Opt("SnMaxPrice", 0)); refreshSniperLog() end)
SNL:AddButton("DRY RUN SCAN",            function() applySniperLimits(); snipeDryRun(); refreshSniperLog() end)
SNL:AddButton("Clear Watchlist",         function() clearWatch(); State.LastSniperMatches={}; State.LastSniperRawCount=0; refreshSniperLog() end)
SNL:AddButton("BUY FIRST (blocked if DryRun)", function() buyFirstMatch(); refreshSniperLog() end)

-- ═══════════════════════════════════════════════════════════
--  SETTINGS TAB
-- ═══════════════════════════════════════════════════════════
local SETL = Tabs.Settings:AddLeftGroupbox("Interface")
local SETR = Tabs.Settings:AddRightGroupbox("Activity Log")

SETL:AddToggle("ShowUIOnLoad", {
    Text    = "Show UI On Load",
    Default = UIState.ShowUIOnLoad,
    Tooltip = "Show NOMO Market automatically when the script executes.",
}):OnChanged(function(v)
    UIState.ShowUIOnLoad = v
    pcall(function()
        if not (type(isfolder)=="function" and isfolder("Nomo")) then
            if type(makefolder)=="function" then makefolder("Nomo") end
        end
        writefile("Nomo/UISettings.json", HttpSvc:JSONEncode({ ShowUIOnLoad=v }))
    end)
end)

SETL:AddToggle("SetCompact",    { Text="Compact Booth Data",    Default=CFG.UI.CompactBoothData ~= false }):OnChanged(function(v) CFG.UI.CompactBoothData=v end)
SETL:AddToggle("SetFilterSpam", { Text="Filter Game Warn Spam", Default=CFG.UI.FilterGameSpam ~= false   }):OnChanged(function(v) CFG.UI.FilterGameSpam=v; if v then pcall(installWarnFilter) end end)
SETL:AddInput("SetFilterPath",  { Text="Filter Path", Default=getFilterPath(), Finished=true }):OnChanged(function(v) CFG.Seller.ListingFilterPath=v end)
SETL:AddButton("Save / Reload Filter Path", function() CFG.Seller.ListingFilterPath=tostring(Opt("SetFilterPath", getFilterPath())); reloadFilters(); log("Filter path",CFG.Seller.ListingFilterPath) end)
SETL:AddButton("Reload Pet API List",       function() loadGamePetList(); log("PetList",tostring(#State.PetList)) end)
SETL:AddButton("Stop Script",               function() State.Stop("settings stop"); NOMO_NOTIFY({ Title="NOMO", Content="Script stopped", Duration=3 }) end)

local actLogLbl = SETR:AddLabel(C("Press Refresh Activity", DIM))
SETR:AddButton("Refresh Activity", function() SetText(actLogLbl, linesToStr(State.Logs, 50)) end)

-- ═══════════════════════════════════════════════════════════
--  CONFIG TAB
-- ═══════════════════════════════════════════════════════════
local CfgTab  = Window:AddTab("Config")
local MenuGrp = CfgTab:AddLeftGroupbox("Keybind")
MenuGrp:AddLabel("Toggle"):AddKeyPicker("MenuKeybind", { Default="RightShift", NoUI=true, Text="Menu keybind" })
Library.ToggleKeybind = Opt("MenuKeybind", rawget(rawget(getgenv(), "Options") or {}, "MenuKeybind"))

if ok2 and ThemeManager then
    ThemeManager:SetLibrary(Library)
    ThemeManager:AttachToGroupbox(CfgTab:AddRightGroupbox("Theme"))
end
if ok3 and SaveManager then
    SaveManager:SetLibrary(Library)
    SaveManager:SetIgnoreIndexes({})
    SaveManager:SetFolder("NomoMarket")
    SaveManager:AttachToGroupbox(CfgTab:AddLeftGroupbox("Config"))
    pcall(function() SaveManager:LoadAutoloadConfig() end)
end

end -- successful Obsidian library load
end -- NOMO_MODE == "full"

local statusGui
local statusText
local updateStatusOverlay = function() end

local function createStatusOverlay()
    if NOMO_MODE ~= "status" then return end

    local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local old = pg:FindFirstChild("NOMO_MARKET_STATUS")
    if old then old:Destroy() end

    statusGui = Instance.new("ScreenGui")
    statusGui.Name = "NOMO_MARKET_STATUS"
    statusGui.ResetOnSpawn = false
    statusGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    statusGui.Parent = pg

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(360, 190)
    frame.Position = UDim2.fromOffset(20, 80)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.18
    frame.BorderSizePixel = 0
    frame.Parent = statusGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(99, 102, 241)
    stroke.Thickness = 1
    stroke.Parent = frame

    statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -18, 1, -18)
    statusText.Position = UDim2.fromOffset(9, 9)
    statusText.BackgroundTransparency = 1
    statusText.RichText = true
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextYAlignment = Enum.TextYAlignment.Top
    statusText.Font = Enum.Font.GothamBold
    statusText.TextSize = 18
    statusText.TextColor3 = Color3.fromRGB(245, 245, 245)
    statusText.Text = "NOMO MARKET\nLoading..."
    statusText.Parent = frame

    updateStatusOverlay = function()
        if not statusText then return end
        local ok, text = pcall(function()
            local booth = select(2, findBestBooth()) or "?"
            local mine = getMyListings()
            local filters = getFilters()
            local matches = State.LastSniperMatches or {}
            return table.concat({
                '<font color="rgb(99,255,99)">NOMO MARKET</font>',
                'Mode: <font color="rgb(129,140,248)">' .. tostring(NOMO_MODE) .. '</font>',
                'Booth: <font color="rgb(99,255,99)">' .. tostring(booth) .. '</font>',
                'Listings: ' .. tostring(#mine) .. ' / ' .. tostring(CFG.Seller.BoothCap or 50),
                'Filters: ' .. tostring(#filters),
                'Auto List: ' .. tostring(CFG.Seller.AutoList == true),
                'Sniper: ' .. tostring(CFG.Sniper.Enabled == true) .. ' | Matches: ' .. tostring(#matches),
                'Tokens: <font color="rgb(99,255,99)">' .. commaNumber(getTokenBalance()) .. '</font>',
                'Session: ' .. tostring(math.floor(os.clock())) .. 's',
            }, '\n')
        end)
        statusText.Text = ok and text or ("NOMO MARKET\nStatus error: " .. tostring(text))
    end

    updateStatusOverlay()
end

-- ═══════════════════════════════════════════════════════════
--  Startup init
-- ═══════════════════════════════════════════════════════════
print("[NOMO UI] Running startup init...")
ensureFolder()
loadGamePetList()
loadGameMutationList()
reloadFilters()
installWarnFilter()
log("Started", tostring(VERSION or "").." mode="..tostring(NOMO_MODE))
log("PetList", #State.PetList, "| FilterPath", getFilterPath())
createStatusOverlay()
refreshSellerLog(false)
refreshMyListingsLog()
refreshMarketSample()
refreshSniperLog()
NOMO_NOTIFY({ Title="NOMO Market", Content=(VERSION or "").." loaded - mode "..tostring(NOMO_MODE), Duration=4 })
print("[NOMO UI] Done!")

task.spawn(function()
    task.wait(1.5)
    local ok, err = pcall(function() autoClaimTick("startup") end)
    if not ok then log("AutoClaim startup error", tostring(err)) end
end)

-- ── Public helpers ────────────────────────────────────────
getgenv().NOMO_V32_REFRESH_SELLER    = function() refreshSellerLog(true) end
getgenv().NOMO_V32_REFRESH_LISTINGS  = function() refreshMyListingsLog(); refreshMarketSample() end
getgenv().NOMO_V39_REMOVE_ALL_MY_LISTINGS = removeAllMyListings
getgenv().NOMO_V40_LIST_ONCE              = listOnce
getgenv().NOMO_V42_LIST_UNTIL_BOOTH_FULL  = listOnce
getgenv().NOMO_V49_REBUILD_BOOTH          = rebuildBooth
getgenv().NOMO_V50_SMART_REBUILD_BOOTH    = smartRebuildBooth
getgenv().NOMO_V32_REFRESH_SNIPER         = refreshSniperLog
getgenv().NOMO_V32_STOP                   = function() State.Stop("manual") end

-- ── Main background loop ──────────────────────────────────
task.spawn(function()
    while State.Running do
        local now = os.clock()
        if CFG.Booth.AutoClaim and now-(State.LastAutoClaimAt or 0) >= (tonumber(CFG.Booth.ClaimInterval) or 10) then
            State.LastAutoClaimAt = now
            local ok, err = pcall(function() autoClaimTick("loop") end)
            if not ok then log("AutoClaim error", tostring(err)) end
        end
        if CFG.Seller.Enabled and CFG.Seller.AutoList and now-State.LastSellerScanAt >= (tonumber(CFG.Seller.ScanInterval) or 15) then
            State.LastSellerScanAt = now
            local ok, scan = pcall(buildCandidates)
            if ok then autoList(scan) else log("Seller scan error", tostring(scan)) end
        end
        if CFG.Sniper.Enabled and now-State.LastSniperScanAt >= (tonumber(CFG.Sniper.ScanInterval) or 10) then
            State.LastSniperScanAt = now
            pcall(function() applySniperLimits(); snipeDryRun() end)
        end
        if now-(State.LastUIRefreshAt or 0) >= 3 then
            State.LastUIRefreshAt = now
            pcall(refreshMyListingsLog)
            pcall(refreshMarketSample)
            pcall(function() refreshSellerLog(false) end)
            pcall(refreshSniperLog)
        end
        updateStatusOverlay()
        task.wait(1)
    end
end)
