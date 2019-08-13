local STAT_COUNT, STAT_VALUE = "count", "value"

Config = {}

--[[
    BASIC OPTIONS
    Must be configured for the resource to work properly
]]

-- Stats to track, if a stat is not here it won't get tracked. (Unless the whitelist is disabled)
-- Resources can also register stats, so you don't need to add them all manually (unless you disable that)
-- Syntax:
-- {STAT_TYPE, STAT_NAME},
-- Stat types can be: STAT_COUNT or STAT_VALUE
Config.STATS = {
    {STAT_COUNT, "Players Joined"},
    {STAT_COUNT, "Chat Messages Sent"},
    {STAT_VALUE, "Players Online"},
}

-- Put your API key here, you can find it on the StatHat Settings page
Config.EZ_KEY = "CHANGEME"

--[[
    COMPATIBILITY OPTIONS
    Various options that can deny certain elements from working
]]

-- Allow clients to send server events to add stats, required for client-side code to work
-- It's merely a security option
Config.ALLOW_CLIENT_STATS = true

-- Allows stats to be sent using events
Config.ALLOW_EVENT_STATS = true

-- Allows stats to be sent using exports
Config.ALLOW_EXPORT_STATS = true

-- Allow other resources to register stats
Config.ALLOW_EXTERNAL_REGISTER = true

--[[
    LOGGING OPTIONS
    Options to choose what is shown in the console output
]]

-- Shows basic log information
Config.ENABLE_DEBUG = false

-- Shows warnings in the console whenever something isn't right
Config.SHOW_WARNINGS = true

-- Show errors in the console whenever something occurs
Config.SHOW_ERRORS = true

--[[
    ACCOUNT OPTIONS
    Should be changed based on your StatHat account state
]]

-- You should only toggle this if you actually paid for the StatHat premium
-- It literally does nothing good for you if you didn't
-- It won't automatically give you the ability to use more than 10 stats
Config.PAID_FOR_PREMIUM = false

--[[
    BEHAVIOR OPTIONS
    Alters certain behavior when collecting stats
]]

-- Amount of milliseconds to accumulate stats before sending the current bulk
Config.ACCUMULATION_PERIOD = 30000

-- Enable this to allow any stat to be added, regardless of the enabled stats list
-- NOTE: You shouldn't use this if you are limited by 10 stats
-- The intended use is if you don't want to manually add stats, or if you have variable stat names being generated
Config.DISABLE_STAT_WHITELIST = false

-- This automatically adds a stat to the server, one that counts every instance of a stat being added
-- NOTE: This will count towards your 10 stat limit, meaning you only have 9 others to use
Config.ADD_STAT_METRICS = false

-- Enable this to append a convar value, such as server name etc
-- This can be used to differentiate stats between multiple servers
-- This convar's value is appended to each stat's name, meaning "Players Online" turns into "Players Online - My new FXServer!" (given the name of the server is "My New FXServer!")
-- NOTE: It's suggested to have a convar value that's unique to each server, such as "server_id", and give it a short value, such as "Server 2" or "S-2"
-- NOTE: Not recommended if you're not premium, as the number of stats basically multiply by the amount of servers you run
Config.APPEND_CONVAR = false
Config.CONVAR_TO_APPEND = "sv_hostname"

-- Combines Count stats automatically, reduces the payload size.
-- Does not combine Value stats
Config.COMBINE_COUNT_STATS = true

--[[
    MISC OPTIONS
    Whatever doesn't fit anywhere else
]]

-- Automatically check for resource updates
Config.CHECK_UPDATES = true

-- Sends uage metrics to the resource creator, this is only used for statistical purposes
Config.SUBMIT_METRICS = false
