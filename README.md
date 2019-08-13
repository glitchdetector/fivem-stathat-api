![Resource Preview](https://i.imgur.com/xMpwfTP.png)
# [StatHat EZ](https://www.stathat.com) Intergration for FiveM
Collect all sorts of statistics from your server.
This is a dependency resource, meaning it does nothing by itself.
It is aimed at developers who want an easy to use API for sending stats.
A lightweight simple version for inclusion in resources is also available in the repository.

**If you are here because another resource requires you to download this, please follow the installation instructions below**

## Forum Thread
https://forum.fivem.net/t/release-stathat-api-easy-server-statistics-api/715477

## Installation and Setup
 1. Register an account on https://www.stathat.com/
 2. Find and/or change your `EZ Key` under Settings ( https://www.stathat.com/settings )
 3. Put your `EZ Key` in the `config.lua` under `EZ_KEY`
 4. Set up the different stats you want to track in the `config.lua` (10 max)
 5. Configure the rest of the `config.lua`, comments are provided

If you wish to use more than 10 stats, you need the StatHat premium subscription.

## Tips & Suggestions
 - Keep stat names human readable, as that is what's shown on the website and in embedded graphs

## Details
Statistics are accumulated for a period of time before being sent as a payload to StatHat's API
More information on how StatHat works can be found in their documentation ( https://www.stathat.com/manual )

There are two kinds of statistics, "counter" and "value".
The difference and their use can be read in the FAQ ( https://www.stathat.com/manual/faq )

Counter statistics are bundled together to reduce payload size, this reduces timestamp accuracy (for counters) down to the length of the accumulation period.
For counter stats it doesn't really matter overall anyways.

This resource utilizes an auto-updater, so you don't have to manually re-download any updates.

Extra details and some other information can be found in the resource manifest (`__resource.lua`) file.

## Developer instructions
`STAT_NAME` being the value of the stat to submit
`STAT_COUNT` and `STAT_VALUE` being their respective numerical values

### Client Code (Events):
```lua
TriggerServerEvent("stathat:count", STAT_NAME, STAT_COUNT)
TriggerServerEvent("stathat:value", STAT_NAME, STAT_VALUE)
```

### Client Code (Exports):
```lua
exports['stathat']:count(STAT_NAME, STAT_COUNT)
exports['stathat']:value(STAT_NAME, STAT_VALUE)
```

### Server Code (Events):
```lua
TriggerEvent("stathat:count", STAT_NAME, STAT_COUNT)
TriggerEvent("stathat:value", STAT_NAME, STAT_VALUE)
```

### Server Code (Exports):
```lua
exports['stathat']:count(STAT_NAME, STAT_COUNT)
exports['stathat']:value(STAT_NAME, STAT_VALUE)
```

### Advanded use:
You can also replace `STAT_NAME` with a table containing a list of the stats
This allows you to more easily add the same value to multiple stats at once
#### For example:
```lua
exports['stathat']:count({
    "Police Tickets Issued",
    "Police Actions",
    "Resolved Offenses"
}, 1)
```
#### Instead of:
```lua
exports['stathat']:count("Police Tickets Issued", 1)
exports['stathat']:count("Police Actions", 1)
exports['stathat']:count("Resolved Offenses", 1)
```

## The Service
[StatHat](https://www.stathat.com/) is a freemium service that can collect and analyze your statistics.
They allow up to 10 stats to be hosted for free, and an unlimited amount for premium users (monthly subscription).
Built-in tools allow you to easily present and compare stats, also for the public (through embedding or direct links).
Premium users are also given automatic trend calculations and other quality of life features.

## Credits
Version check system by [BlueTheFurry](https://github.com/Bluethefurry/)
https://github.com/Bluethefurry/FiveM-Resource-Version-Check-Thing

## Disclaimer
I am in no way affiliated with StatHat, all issues with the service itself should be directed to their support team.

## License
Do not re-upload as a standalone resource.
You may include this as part of a resource bundle, as long as it is unaltered.
Do not remix this resource, provide PR's to its origin repository for improvements and changes.
Donut steel
