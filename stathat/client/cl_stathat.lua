count = function(stat, value)
    TriggerServerEvent("stathat:count", stat_name, stat_value)
end

value = function(stat, value)
    TriggerServerEvent("stathat:value", stat_name, stat_value)
end

-- Prevent events from firing if the server blocks client stats anyways
if (not Config.ALLOW_CLIENT_STATS) or (not Config.ALLOW_EXPORT_STATS) then
    count = function()
        warn("Attempted to use client stats while client stats are disabled")
    end
    value = count
end
