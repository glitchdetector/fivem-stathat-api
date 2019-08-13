if Config.EZ_KEY == "CHANGEME" then
    err("EZ_KEY must be configured")
end

-- Set up actual stats to check (to prevent > 10 if dumb dumb configure)
local ACTUAL_STATS_TO_CHECK = {}
local PREMIUM_UNLOCKED = Config.PAID_FOR_PREMIUM
local REGISTERED_STATS = 0

local function registerStat(stat_name, stat_type)
    if type(stat_name) == 'table' then
        local failed = false
        local registered = 0
        for _, _stat_name in next, stat_name do
            if not registerStat(_stat_name, stat_type) then
                failed = true
            else
                registered = registered + 1
            end
        end
        return not failed, "Registered " .. registered .. "/" .. #stat_name .. " stats"
    end
    if (not stat_type) or (stat_type ~= "count" and stat_type ~= "value") then err("Invalid stat type '" .. tostring(stat_type) .. "'") end
    if not stat_name then err("Invalid Stat Name") end
    if ACTUAL_STATS_TO_CHECK[stat_name] ~= nil then
        warn("Tried to register already registered stat '" .. stat_name .. "'")
        return false, "Stat already registered"
    end
    if REGISTERED_STATS < 10 or PREMIUM_UNLOCKED then
        REGISTERED_STATS = REGISTERED_STATS + 1
        ACTUAL_STATS_TO_CHECK[stat_name] = stat_type
        log("Registered stat '" .. stat_name .. "' as " .. stat_type)
        return true, "OK"
    else
        warn("Could not register stat '" .. stat_name .. "': No stat slots")
        return false, "No stat slots"
    end
end

-- Built-in stat for request counting
if Config.ADD_STAT_METRICS then
    registerStat("Stat Queries", "count")
end

-- Populate lookup table for stat check if whitelist is enabled
if not Config.DISABLE_STAT_WHITELIST then
    for _, stat in next, Config.STATS do
        if type(stat) ~= 'table' then
            err("Invalid Stat Syntax")
        end
        local stat_type, stat_name = stat[1], stat[2]
        registerStat(stat_name, stat_type)
    end
elseif not PREMIUM_UNLOCKED then
    warn("Whitelist is disabled with non-premium account")
end

local STAT_QUEUE = {}
local STAT_COUNT_QUEUE = {}
local STAT_WAITING = false
local REQUEST_URI = "http://api.stathat.com/ez"

local function statHatEZ()
    if Config.ADD_STAT_METRICS then
        STAT_COUNT_QUEUE["Stat Queries"] = (STAT_COUNT_QUEUE["Stat Queries"] or 0) + 1
    end
    if not STAT_WAITING then
        STAT_WAITING = true
        Citizen.CreateThread(function()
            local loaded = false
            local data = nil
            Wait(Config.ACCUMULATION_PERIOD)
            for statname, statcount in next, STAT_COUNT_QUEUE do
                table.insert(STAT_QUEUE, {
                    ["stat"] = statname,
                    ["count"] = statcount,
                })
            end
            log("StatHat EZ " .. json.encode(STAT_QUEUE))
            PerformHttpRequest(REQUEST_URI, function(errorCode, resultData, resultHeaders)
                loaded = true
                data = {data=resultData, code=errorCode, headers=resultHeaders}
            end, "POST", json.encode({
                ["ezkey"] = Config.EZ_KEY,
                ["data"] = STAT_QUEUE,
            }), {["Content-Type"] = "application/json"})
            STAT_QUEUE = {}
            STAT_COUNT_QUEUE = {}
            STAT_WAITING = false
            while not loaded do Wait(0) end
            log("StatHat EZ Response: " .. json.encode(data))
        end)
    end
end

local function isAllowedStat(stat_name, stat_type)
    return Config.DISABLE_STAT_WHITELIST or (ACTUAL_STATS_TO_CHECK[stat_name] == stat_type)
end

function statValue(stat, value)
    if not value then
        warn("Tried to stat without specifying value!")
        if type(stat) == 'table' then
            stat, value = stat[1], stat[2]
        else
            warn("Invalid syntax!")
            return false
        end
    end
    local actualstat = ""
    if type(stat) == 'table' then
        for _, stat_name in next, stat do
            if not isAllowedStat(stat_name, "value") then
                warn("Non-whitelisted value stat '" .. stat_name .. "' attempted to be tracked")
                return
            end
        end
        actualstat = "~" .. table.concat(stat, ",")
    else
        if not isAllowedStat(stat, "value") then
            warn("Non-whitelisted value stat '" .. stat .. "' attempted to be tracked")
            return
        end
        actualstat = stat
    end
    table.insert(STAT_QUEUE, {
        ["stat"] = actualstat,
        ["value"] = value,
        ["t"] = os.time(),
    })
    statHatEZ()
end

value = function(stat, value)
    statValue(stat, value)
end

function statCount(stat, count)
    if not count then
        warn("Tried to stat without specifying count!")
        if type(stat) == 'table' then
            stat, count = stat[1], stat[2]
        else
            warn("Invalid syntax!")
            return false
        end
    end
    local actualstat = ""
    if type(stat) == 'table' then
        for _, statname in next, stat do
            if not isAllowedStat(statname, "count") then
                warn("Non-whitelisted count stat '" .. statname .. "' attempted to be tracked")
            else
                STAT_COUNT_QUEUE[statname] = (STAT_COUNT_QUEUE[statname] or 0) + count
            end
        end
    else
        if not isAllowedStat(stat, "count") then
            warn("Non-whitelisted count stat '" .. stat .. "' attempted to be tracked")
            return
        end
        STAT_COUNT_QUEUE[stat] = (STAT_COUNT_QUEUE[stat] or 0) + count
    end
    statHatEZ()
end

count = function(stat, value)
    statCount(stat, value)
end

if not Config.ALLOW_EXPORT_STATS then
    value = function()
        warn("Attempted to use export stats while export stats are disabled")
    end
    count = value
end

if Config.ALLOW_EVENT_STATS then
    if Config.ALLOW_CLIENT_STATS then
        RegisterServerEvent("stathat:count")
        RegisterServerEvent("stathat:value")
    end
    AddEventHandler("stathat:value", function(stat, value)
        statValue(stat, value)
    end)
    AddEventHandler("stathat:count", function(stat, value)
        statCount(stat, value)
    end)
end

register = function(stat, value)
    warn("Attempted to register stat while registering stats is disabled")
end

if Config.ALLOW_EXTERNAL_REGISTER then
    AddEventHandler("stathat:register", function(stat, value, cb)
        registerStat(stat, value)
    end)
    register = function()
        registerStat(stat, value)
    end
end
