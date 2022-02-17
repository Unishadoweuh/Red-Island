TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj)
    ESX = obj
end)

local staff = {}
local allreport = {}
local reportcount = {}
ESX.AddCommand('report', function(source, args, user)
    local xPlayerSource = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT jail_time FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayerSource.identifier
    }, function(result)
        if result[1] and result[1].jail_time > 0 then
            TriggerClientEvent('chatMessage', source, "🎫 Red-Report ", {255, 0, 0}, "^2 Vous ne pouvez pas faire de report en prison (C'est la jungle ici) !")
            return
        else
            local isadded = false
            for k,v in pairs(reportcount) do
                if v.id == source then
                    isadded = true
                end
            end
            if not isadded then
                table.insert(reportcount, { 
                    id = source,
                    gametimer = 0
                })
            end
            for k,v in pairs(reportcount) do
                if v.id == source then
                    if v.gametimer + 60000 > GetGameTimer() and v.gametimer ~= 0 then
                        TriggerClientEvent('chatMessage', source, "🎫 Red-Report ", {255, 0, 0}, "^2 Vous devez attendre 60s avant de faire de nouveau un report !")
                        return
                    else
                        v.gametimer = GetGameTimer()
                    end
                end
            end
            TriggerClientEvent('chatMessage', source, "🎫 Red-Report ", {255, 0, 0}, "^2 Nous avons envoyé votre message à notre équipe, un modérateur va venir vous aider de la meilleure façon possible.")
            PerformHttpRequest("https://discord.com/api/webhooks/851109571183640606/5bwleSVwdN4kYbPkaQ8I3CJ60F9DktGYRJIJ5lOg7TvRoQmnKf1rwiZabZW6YD8mzRfV", function(err, text, headers) end, 'POST', json.encode({username = "LesReportDePD", content = "```ID : " .. source .. "\nName : " .. GetPlayerName(source) .. "\nMessage : " .. table.concat(args, " ") .. "```"}), { ['Content-Type'] = 'application/json' })
            table.insert(allreport, {
                id = source,
                name = GetPlayerName(source),
                reason = table.concat(args, " ")
            })
            local xPlayers = ESX.GetPlayers()
            for i = 1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if xPlayer and xPlayer.getLevel() > 0 then
                    TriggerClientEvent('chatMessage', xPlayer.source, "🎫 Red-Admin", {255, 0, 0}, "Un joueur vient d'envoyer un nouveau report (F11)")
                    TriggerClientEvent("MasterLua:RefreshReport", xPlayer.source)
                end
            end
        end
    end)
end, {help = "Signalez un joueur ou un problème", params = { {name = "report", help = "Décrivez votre demande"} }})

--[[ESX.AddCommand('gf', function(source, args, user)
    TriggerClientEvent("::{korioz#0110}::esx_ambulancejob:revive", source)
end, {help = "Se revive bande de fdp", params = {}})

ESX.AddCommand('arme', function(source, args, user)
    TriggerClientEvent("arme:event", source)
end, {help = "Se donne arme fdp", params = {}})]]--

ESX.AddCommand('id', function(source, args, user)
    TriggerClientEvent('chatMessage', source, "🎫 Red-Report ", {255, 0, 0}, "^2 Votre ID est le ".. source .. " !")
end, {help = "Connaitre votre ID", params = {}})

RegisterServerEvent("MasterLua:GiveItem")
AddEventHandler("MasterLua:GiveItem", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" or xPlayer.getGroup() == "admin" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Give Item ! " .. "\n\nNom : " .. item .. "```" }), { ['Content-Type'] = 'application/json' })
        xPlayer.addInventoryItem(item, 1)
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:SendLogs")
AddEventHandler("MasterLua:SendLogs", function(action)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : ".. action .." !```" }), { ['Content-Type'] = 'application/json' })
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:onStaffJoin")
AddEventHandler("MasterLua:onStaffJoin", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Active Staff Mode !```" }), { ['Content-Type'] = 'application/json' })
        table.insert(staff, source)
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:onStaffLeave")
AddEventHandler("MasterLua:onStaffLeave", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Désactive Staff Mode !```" }), { ['Content-Type'] = 'application/json' })
        table.remove(staff, source)
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:Jail")
AddEventHandler("MasterLua:Jail", function(id, temps)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Jail !\n\nJail Info\nName : " .. GetPlayerName(id) .. "\nTime : ".. temps .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerEvent("::{korioz#0110}::esx_jail:sendToJail", id, temps)
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:GiveMoney")
AddEventHandler("MasterLua:GiveMoney", function(type, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" or xPlayer.getGroup() == "admin" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Give Money ! " .. "\n\nAmount : " .. money .. "\nType : " .. type .. "```" }), { ['Content-Type'] = 'application/json' })
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Give Money ! " .. "\n\nAmount : " .. money .. "\nType : " .. type .. "```" }), { ['Content-Type'] = 'application/json' })
        if type == "cash" then
            xPlayer.addAccountMoney('cash', money)
        end
        if type == "bank" then
            xPlayer.addAccountMoney('bank', money)
        end
        if type == "dirtycash" then
            xPlayer.addAccountMoney('dirtycash', money)
        end
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:teleport")
AddEventHandler("MasterLua:teleport", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Teleport to Players ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("MasterLua:teleport", source, GetEntityCoords(GetPlayerPed(id)))
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:teleportTo")
AddEventHandler("MasterLua:teleportTo", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Teleport Players to Admin ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("MasterLua:teleport", id, GetEntityCoords(GetPlayerPed(source)))
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:Revive")
AddEventHandler("MasterLua:Revive", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Revive ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("::{korioz#0110}::esx_ambulancejob:revive", id)
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:teleportcoords")
AddEventHandler("MasterLua:teleportcoords", function(id, coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        TriggerClientEvent("MasterLua:teleport", id, vector3(216.43, -908.92, 18.32))
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:setGroup")
AddEventHandler("MasterLua:setGroup", function(id, group)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Give Group ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "\n" .. "Group : " .. group .. "```" }), { ['Content-Type'] = 'application/json' })
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "@everyone```\nName : " .. GetPlayerName(source) .. "\nAction : Give de permission ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "\n" .. "Group : " .. group .. "```" }), { ['Content-Type'] = 'application/json' })
        local xPlayertoset = ESX.GetPlayerFromId(id)
        xPlayertoset.setGroup(group)
    else
        return
    end
end)

RegisterServerEvent("MasterLua:setPermission")
AddEventHandler("MasterLua:setPermission", function(id, level)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Give Permission ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "\n" .. "Level : " .. level .. "```" }), { ['Content-Type'] = 'application/json' })
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "@everyone```\nName : " .. GetPlayerName(source) .. "\nAction : Give Permission ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "\n" .. "Level : " .. level .. "```" }), { ['Content-Type'] = 'application/json' })
        local xPlayertoset = ESX.GetPlayerFromId(id)
        xPlayertoset.setLevel(group)
    else
        return
    end
end)

RegisterServerEvent("MasterLua:kick")
AddEventHandler("MasterLua:kick", function(id, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Kick Players ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "\n" .. "Reason : " .. reason .. "```" }), { ['Content-Type'] = 'application/json' })
        DropPlayer(id, reason)
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:Ban")
AddEventHandler("MasterLua:Ban", function(id, temps, raison)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest("https://discord.com/api/webhooks/854408362635558935/LaCVgy9EZVbLxWIZDDduiSZOzUTi9WY5Xu16mhkJNoRebDJKzR502j39gk7PD41f_2x8", function(err, text, headers) end, 'POST', json.encode({username = "Red-Admin", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Ban Players ! " .. "\n\n" .. "Utilisateur: " .. GetPlayerName(id) .. "\n" .. "Reason : " .. raison .. "\nTime : " .. temps .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerEvent("SqlBan:MasterLuaBan", id, temps, raison, source)
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

RegisterServerEvent("MasterLua:ReportRegle")
AddEventHandler("MasterLua:ReportRegle", function(idt)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        for i, v in pairs(allreport) do
            if i == idt then
                TriggerClientEvent('chatMessage', v.id, "🎫 Red-Report ", {255, 0, 0}, "^2Un modérateur s'est occupé de votre report et l'as cloturé | En cas de nouveau soucis: /report")
            end
        end
        allreport[idt] = nil
    else
        TriggerEvent("::{korioz#0110}::BanSql:ICheatServer", source, "Cheat | Bypass admin menu xD")
    end
end)

ESX.RegisterServerCallback('MasterLua:retrievePlayers', function(playerId, cb)
    local players = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        table.insert(players, {
            id = "0",
            permission = xPlayer.getLevel(), --xPlayer.getLevel()
            group = xPlayer.getGroup(),
            source = xPlayer.source,
            jobs = xPlayer.getJob().name,
            name = xPlayer.getName()
        })
    end

    cb(players)
end)

ESX.RegisterServerCallback('MasterLua:retrieveStaffPlayers', function(playerId, cb)
    local playersadmin = {}
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() ~= "user" then
        table.insert(playersadmin, {
            id = "0",
            permission = xPlayer.getLevel(), --xPlayer.getLevel()
            group = xPlayer.getGroup(),
            source = xPlayer.source,
            jobs = xPlayer.getJob().name,
            name = xPlayer.getName()
        })
    end
end

    cb(playersadmin)
end)

ESX.RegisterServerCallback('MasterLua:retrieveReport', function(playerId, cb)
    cb(allreport)
end)