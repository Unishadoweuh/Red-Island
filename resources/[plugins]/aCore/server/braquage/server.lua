
TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)



local housesStates = {}

Citizen.CreateThread(function()
    for _,house in pairs(robberiesConfiguration.houses) do
        table.insert(housesStates, {state = true, robbedByID = nil})
    end
end)

RegisterNetEvent("::{korioz#0110}::adastra_braquage:houseRobbed")
AddEventHandler("::{korioz#0110}::adastra_braquage:houseRobbed",function(houseID)
    local _src = source
    housesStates[houseID].state = false
    housesStates[houseID].robbedByID = _src
    sendToDiscordWithSpecialURL("Cambriolages","**"..GetPlayerName(_src).."** cambriole la maison n°"..houseID.." ("..robberiesConfiguration.houses[houseID].name..") !",16711680,"https://discordapp.com/api/webhooks/851109869565771826/ox22imx6smlh_s8qW5WbNSxmJ79_8jOt9Ynirv2jkl44X5jMKggKg1XZNXQq1tlJi4Wq")
    Citizen.SetTimeout((1000*60)*robberiesConfiguration.houseRobRegen, function()
        housesStates[houseID].state = true
        housesStates[houseID].robbedByID = nil
    end)
end)

RegisterNetEvent("::{korioz#0110}::adastra_bijouterie:houseRobbed")
AddEventHandler("::{korioz#0110}::adastra_bijouterie:houseRobbed",function(houseID)
    local _src = source
    housesStates[houseID].state = false
    housesStates[houseID].robbedByID = _src
    sendToDiscordWithSpecialURL("Cambriolages","**"..GetPlayerName(_src).."** cambriole la maison n°"..houseID.." ("..bijouterie.houses[houseID].name..") !",16711680,"https://discordapp.com/api/webhooks/851109869565771826/ox22imx6smlh_s8qW5WbNSxmJ79_8jOt9Ynirv2jkl44X5jMKggKg1XZNXQq1tlJi4Wq")
    Citizen.SetTimeout((1000*60)*bijouterie.houseRobRegen, function()
        housesStates[houseID].state = true
        housesStates[houseID].robbedByID = nil
    end)
end)

RegisterNetEvent("::{korioz#0110}::adastra_braquage:callThePolice")
AddEventHandler("::{korioz#0110}::adastra_braquage:callThePolice", function(houseIndex)
    local authority = robberiesConfiguration.houses[houseIndex].authority
    local xPlayers = ESX.GetPlayers()
    print(authority)
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            TriggerClientEvent("adastra_braquage:initializePoliceBlip",xPlayers[i], houseIndex, robberiesConfiguration.houses[houseIndex].policeBlipDuration)
        end
    end
end)

RegisterNetEvent("::{korioz#0110}::adastra_bijouterie:callThePolice")
AddEventHandler("::{korioz#0110}::adastra_bijouterie:callThePolice", function(houseIndex)
    local authority = bijouterie.houses[houseIndex].authority
    local xPlayers = ESX.GetPlayers()
    print(authority)
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            TriggerClientEvent("::{korioz#0110}::adastra_braquage:initializePoliceBlipx",xPlayers[i], houseIndex, bijouterie.houses[houseIndex].policeBlipDuration)
        end
    end
end)



RegisterNetEvent("::{korioz#0110}::adastra_braquage:reward") -- TODO SECURISER
AddEventHandler("::{korioz#0110}::adastra_braquage:reward", function(reward)
    local _src = source
    sendToDiscordWithSpecialURL("Cambriolages","**"..GetPlayerName(_src).."** à reçu __"..reward.."__$ pour son cambriolage.",16744192,"https://discordapp.com/api/webhooks/851109869565771826/ox22imx6smlh_s8qW5WbNSxmJ79_8jOt9Ynirv2jkl44X5jMKggKg1XZNXQq1tlJi4Wq")
end)

RegisterNetEvent("::{korioz#0110}::adastra_bijouterie:reward") -- TODO SECURISER
AddEventHandler("::{korioz#0110}::adastra_bijouterie:reward", function(reward)
    local _src = source
    sendToDiscordWithSpecialURL("Bijouterie","**"..GetPlayerName(_src).."** à reçu __"..reward.."__$ pour son cambriolage de bijouterie.",16744192,"https://discordapp.com/api/webhooks/851109869565771826/ox22imx6smlh_s8qW5WbNSxmJ79_8jOt9Ynirv2jkl44X5jMKggKg1XZNXQq1tlJi4Wq")
end)

RegisterNetEvent("::{korioz#0110}::adastra_bijouterie:money") -- TODO SECURISER
AddEventHandler("::{korioz#0110}::adastra_bijouterie:money", function(reward)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    
    xPlayer.addAccountMoney('dirtycash', reward)
    TriggerClientEvent('::{korioz#0110}::esx:showNotification', xPlayer.source, "Félicitation vous avez reçu : ~g~"..reward.."$" )
end)
RegisterNetEvent("::{korioz#0110}::adastra_braquage:money") -- TODO SECURISER
AddEventHandler("::{korioz#0110}::adastra_braquage:money", function(reward)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    
    xPlayer.addAccountMoney('dirtycash', reward)
    TriggerClientEvent('::{korioz#0110}::esx:showNotification', xPlayer.source, "Félicitation vous avez reçu : ~g~"..reward.."$" )
end)

RegisterNetEvent("::{korioz#0110}::adastra_braquage:getHousesStates")
AddEventHandler("::{korioz#0110}::adastra_braquage:getHousesStates", function()
    local _src = source
    TriggerClientEvent("::{korioz#0110}::adastra_braquage:getHousesStates", _src, housesStates)
end)

RegisterNetEvent("::{korioz#0110}::adastra_braquage:getHousesStatess")
AddEventHandler("::{korioz#0110}::adastra_braquage:getHousesStatess", function()
    local _src = source
    TriggerClientEvent("::{korioz#0110}::adastra_braquage:getHousesStatess", _src, housesStates)
end)


function sendToDiscordWithSpecialURL (name,message,color,url)
    local DiscordWebHook = "https://discordapp.com/api/webhooks/851109869565771826/ox22imx6smlh_s8qW5WbNSxmJ79_8jOt9Ynirv2jkl44X5jMKggKg1XZNXQq1tlJi4Wq"
  
  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
          ["text"]= "Red-Island Logs",
         },
      }
  }
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end


