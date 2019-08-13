local LOG_PREFIX = "[StatHat EZ]"

log = function() end
if Config.ENABLE_DEBUG then
    log = function(text)
        print(LOG_PREFIX .. " " .. text)
    end
end

err = function() end
if Config.SHOW_ERRORS then
    err = function(text)
        print("^1" .. LOG_PREFIX .. " ERROR: " .. text .. "^7")
        error("Terminated due to error")
    end
end

warn = function() end
if Config.SHOW_WARNINGS then
    warn = function(text)
        print("^3" .. LOG_PREFIX .. " WARNING: " .. text .. "^7")
    end
end
