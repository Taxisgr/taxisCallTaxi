ESX = nil 
ESX = exports["es_extended"]:getSharedObject()
discordWebhook = "WEBHOOK" --Change this to your own discord webhook

RegisterNetEvent('taxisCallTaxi:pay')
AddEventHandler('taxisCallTaxi:pay', function()
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
end)

function SendDiscordLog(message)

    local logData = {
        ["content"] = message
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode(logData), { ['Content-Type'] = 'application/json' })
end
