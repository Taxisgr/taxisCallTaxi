if Config.USEESX then
    ESX = exports["es_extended"]:getSharedObject()
else
   QBCore = exports['qb-core']:GetCoreObject()
end
discordWebhook = "WEBHOOK" --Change this to your own discord webhook

RegisterNetEvent('taxisCallTaxi:pay')
AddEventHandler('taxisCallTaxi:pay', function()
    if Config.USEESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        local price = Config.Price
        local done = false

            if xPlayer.getAccount(Config.PriceType).money >= price then
                xPlayer.removeAccountMoney(Config.PriceType, price)
                done = true
                if Config.DiscordLogs == true then
                steam = GetPlayerName(source)
                msg = "Id: " .. source .. " with steam name: " ..steam.. " paied " .. Config.Price.. "$ from his " .. Config.PriceType .. " account for calling a taxi."
                SendDiscordLog(msg)
                end
            end
    
        TriggerClientEvent('taxisCallTaxi:isok', source, done)
    else
        local player = QBCore.Functions.GetPlayer(source)
        local price = Config.Price
        local done = false

        if Player.Functions.RemoveMoney(Config.PriceType, price) then 
            done = true
            if Config.DiscordLogs == true then
                steam = GetPlayerName(source)
                msg = "Id: " .. source .. " with steam name: " ..steam.. " paied " .. Config.Price.. "$ from his " .. Config.PriceType .. " account for calling a taxi."
                SendDiscordLog(msg)
            end
        end

        TriggerClientEvent('taxisCallTaxi:isok', source, done)
    end
end)

function SendDiscordLog(message)

    local logData = {
        ["content"] = message
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode(logData), { ['Content-Type'] = 'application/json' })
end
