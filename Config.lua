Config = {}

Config.USEESX = true -- If false, then it will use qbcore framework instead of esx framework!

Config.CarSpawnName = `taxi` --Select the spawn name of the car that spawns when you call a taxi
Config.NPCModel = `a_m_y_stlat_01` -- Select the drivers ped model from here : https://docs.fivem.net/docs/game-references/ped-models/
Config.MaxDistance = 200 --The taxi is spawned in random distance from the user, here you can set the maximum distance from the player that the taxi will spawn when called. Dont type values lower than 1 and higher than 200. The greater the value , the more farther the taxi will spawn.
Config.WaitTime = 2 --The amount of time in seconds to wait before taxi spawns and starts driving to user's location. You can also set this to 0 to make ta taxi spawn immediately.
Config.CanCallInsideVehicle = false -- If true, any player can call taxi inside any vehicle. Recommended: false.
Config.CommandName = "calltaxi" -- The name of the command
Config.CommandCooldownTime = 5 -- The ammount of cooldown between using the command in seconds, you can also set this to 0 to disable cooldown.
Config.DeleteTaxi = true -- If true the taxi will be deleted after X seconds the user exits the vehicle. (the time is setted in Config.DeleteTaxiAfterTime) Recommended: true.
Config.DeleteTaxiAfterTime = 10 -- The time that is needed to delete the taxi after user exits the vehicle, in seconds.
Config.Price = 1000 -- The money that is needed in order to call a taxi , set to 0 in ordet to be free.
Config.PriceType = 'bank' -- The type of money that is needed in order to call a taxi. ('money' or 'bank' or  'black_money')
Config.DiscordLogs = true -- If true the script will send logs to discord every time a user calls a taxi in the WEBHOOK setted at the top of Server.lua (for security reasons).
