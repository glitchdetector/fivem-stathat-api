if Config.CHECK_UPDATES then
    log("Checking for updates...")
    Citizen.CreateThread( function()
        local updatePath = "/glitchdetector/fivem-stathat-api" -- your git user/repo path
        local resourceName = "FiveM StatHat Integration ("..GetCurrentResourceName()..")" -- the resource name
        function checkVersion(err, responseText, headers)
            local curVersion = LoadResourceFile(GetCurrentResourceName(), "version") -- make sure the "version" file actually exists in your resource root!
            if not responseText then
                warn("Update check failed, where did the remote repository go?")
            elseif curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
                warn("###############################")
                warn(""..resourceName.." is outdated.")
                warn("Available version: " .. responseText)
                warn("Current Version: " .. curVersion)
                warn("Please update it from https://github.com"..updatePath.."")
                warn("###############################")
                warn("Or do /" .. GetCurrentResourceName() .. " autoupdate")
                warn("This will not replace your config.lua")
                warn("###############################")

            elseif tonumber(curVersion) > tonumber(responseText) then
                warn("You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online i advise you to update ( or downgrade? )")
            else
                log(""..resourceName.." is up to date, have fun!")
            end
        end
        PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/chat_commands/version", checkVersion, "GET")
    end)
end

RegisterCommand(GetCurrentResourceName(), function(_, args)
    if args[1] == "autoupdate" then
        warn("###############################")
        warn("Updating resource")
        warn("###############################")
        local updatePath = "/glitchdetector/fivem-stathat-api" -- your git user/repo path
        PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/autoupdate", function(err, responseText, headers)
            local function updateFile(fileName)
                local ok = false
                local _l = false
                PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/stathat/" .. fileName, function(err, responseText, headers)
                    if err ~= 200 then
                        warn("Failed to download file " .. fileName .. ": " .. err)
                    else
                        if LoadResourceFile(GetCurrentResourceName(), fileName) ~= responseText then
                            warn("Downloading file " .. fileName)
                            SaveResourceFile(GetCurrentResourceName(), fileName, responseText, -1)

                            if not LoadResourceFile(GetCurrentResourceName(), fileName) then
                                warn("Failed to save file " .. fileName.. ". Does the directory exist?")
                            else
                                ok = true
                            end
                        end
                    end
                    _l = true
                end)
                while not _l do Wait(0) end
                return ok
            end
            local files = 0
            for fileName in string.gmatch(responseText, "%S+") do
                if updateFile(fileName) then
                    files = files + 1
                end
            end
            if files > 0 then
                warn("###############################")
                warn("Updated " .. files .. " files")
            else
                warn("No changes were made")
            end
            warn("###############################")
            warn("Please /refresh then /restart " .. GetCurrentResourceName())
            warn("###############################")
        end, "GET")
    else
        warn("Did you mean to do /" .. GetCurrentResourceName() .. " autoupdate?")
    end
end, true)
