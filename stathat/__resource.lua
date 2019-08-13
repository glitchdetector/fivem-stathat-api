name "StatHat Integration"
author "glitchdetector"
contact "glitchdetector@gmail.com"
version "1.0"

description "Allows tracking of stats using StatHat"
details [[
    Allows sending stats to StatHat, StatHat offers alerts, trends etc. for those stats.
    StatHat is a freemium service with 10 free stats, and a premium subscription for "unlimited" stats.

    Stat types:
     - Count
     - Value

    Count should be used for incremental values or events, such as "Money Spent", "Drugs Harvested" or "Players Connected"
    Value should be used for values that change over time, such as "Number of players online"

    More details can be found in StatHat's Documentation

    Alerts are shown by default when a stat isn't registered

    This resource sends the data with a minimum delay, this is to reduce strain on StatHat and on your server
    It automatially bulks all Count stats together, but leaves Value stats separate
    This means that timestamp accuracy is kept on Value stats, but is lost on Count stats
    This doesn't matter in the long run, and the timestamp inaccuracy will only be whatever the delay is
]]
usage [[
    Setup:
     - Register an account on https://www.stathat.com/
     - Find and/or change your EZ Key under Settings ( https://www.stathat.com/settings )
     - Put your EZ Key in the config.lua
     - Set up the different stats you want to track in the config.lua (10 max)
     - If you wish to use more than 10 stats, you need the StatHat premium subscription

    Client Code (Events):
    TriggerServerEvent("stathat:count", STAT_NAME, STAT_COUNT)
    TriggerServerEvent("stathat:value", STAT_NAME, STAT_VALUE)

    Client Code (Exports):
    exports['stathat']:count(STAT_NAME, STAT_COUNT)
    exports['stathat']:value(STAT_NAME, STAT_VALUE)

    Server Code (Events):
    TriggerEvent("stathat:count", STAT_NAME, STAT_COUNT)
    TriggerEvent("stathat:value", STAT_NAME, STAT_VALUE)
    TriggerEvent("stathat:register", STAT_NAME, STAT_TYPE)

    Server Code (Exports):
    exports['stathat']:count(STAT_NAME, STAT_COUNT)
    exports['stathat']:value(STAT_NAME, STAT_VALUE)
    exports['stathat']:register(STAT_NAME, STAT_TYPE)

    Advanded use:
    You can also replace STAT_NAME with a table containing a list of the stats
    This allows you to more easily add the same value to multiple stats at once
    For example:
        exports['stathat']:count({
            "Police Tickets Issued",
            "Police Actions",
            "Resolved Offenses"
        }, 1)
    Instead of:
        exports['stathat']:count("Police Tickets Issued", 1)
        exports['stathat']:count("Police Actions", 1)
        exports['stathat']:count("Resolved Offenses", 1)

    Resources can "register" a stat, which means that stat is added to the whitelist
    This can only be done from the server side
]]

shared_script 'config.lua'
shared_script 'shared/sh_logging.lua'
server_script 'server/sv_stathat.lua'
client_script 'client/cl_stathat.lua'

server_script 'autoupdater/sv_autoupdate.lua'

export 'count'
export 'value'

server_export 'count'
server_export 'value'
server_export 'register'
