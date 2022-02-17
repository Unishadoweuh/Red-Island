
ESX = nil

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)

local votes = 0
local votesNeeded = 2
local timeToVerdict = false
local isJailedG = false
local jailTimeG = 0

local courtOngoing = false

RegisterServerEvent("wayn:goprison")
AddEventHandler("wayn:goprison", function(targetPedId, jailTime)
  local _source = source
  local jailTime = jailArray[1]
  local xPlayer = ESX.GetPlayerFromId(_source)
end)

RegisterServerEvent("wayn:godehors")
AddEventHandler("wayn:godehors", function(targetPedId)
  local _source = source
  if not GetPlayerName(targetPedId) then
    TriggerClientEvent("chatMessage", _source, "^2" .. targetPedId .. " ^1l'id du joueur est invalide")
  elseif isJailed(getPlayerID(targetPedId)) then
    local targetPedPermId = getPlayerID(targetPedId)
    local targetPedName = GetPlayerName(targetPedId)
    removedJailedPlayer(targetPedPermId)
    TriggerClientEvent("wayn:godehors", targetPedId)
  else
    TriggerClientEvent("chatMessage", _source, "^2" .. GetPlayerName(targetPedId) .. " ^1est pas en prison")
  end
end)

RegisterServerEvent("wayn:ChangeTemps")
AddEventHandler("wayn:ChangeTemps", function(newJailTime)
  local _source = source
  local targetPedPermId = getPlayerID(_source)
  updateJailTime(targetPedPermId, newJailTime)
end)

RegisterServerEvent("wayn:RetourPrison")
AddEventHandler("wayn:RetourPrison", function(newJailTime)
  local _source = source
  local targetPedPermId = getPlayerID(_source)
  local isJailedInfo = isJailed(targetPedPermId)
  if isJailedInfo then
    local jailTime = isJailedInfo[2]
    TriggerClientEvent("wayn:goprison", _source, {jailTime})
    TriggerClientEvent("chatMessage", _source, "^1Ah te revoila ! Tu as repris ta peine de ^2" .. isJailedInfo[2] .. " ^1Secondes.")
  end
end)

ESX.AddGroupCommand('jail', 'mod', function(source, args, user)
  local _source = source
  local targetPedId = tonumber(args[1])
  local jailTime = tonumber(args[2] * 60) or 0
  if targetPedId == nil then
    return TriggerEvent("chatMessage", "^1L'id que tu as essayé d'introduire est invalide.")
  elseif jailTime <= 0 then
    return TriggerEvent("chatMessage", "^1Temps invalide, tu dois mettre un montant supérieur à 0.")
  elseif not GetPlayerName(targetPedId) then
    TriggerClientEvent("chatMessage", _source, "^2" .. targetPedId .. " ^1l'id est incorrect.")
  elseif isJailed(getPlayerID(targetPedId)) then
    local targetPedName = GetPlayerName(targetPedId)
    TriggerClientEvent("chatMessage", _source, "^2" .. targetPedName .. " ^1est déja en prison.")
  else
    local officerName = GetPlayerName(_source)
    local targetPedName = GetPlayerName(targetPedId)
    local targetPedPermId = getPlayerID(targetPedId)
    table.insert(jailedPlayers, {targetPedPermId, jailTime, false})
    TriggerClientEvent("wayn:goprison", targetPedId, {jailTime, false})
  end

	TriggerClientEvent('wayn:goprison', targetPedId, jailTime)
end, {help = "Mettre en prison les gens pas tres gentils", params = { {name = "id", help = "The ID of the player"}, {name = "minutes", help = "Temps de prison"} }})

ESX.AddGroupCommand('unjail', 'mod', function(source, args, user)
  local _source = source
  local targetPedId = tonumber(args[1])
  if not GetPlayerName(targetPedId) then
    TriggerClientEvent("chatMessage", _source, "^2" .. targetPedId .. " ^1l'id du joueur est invalide")
  elseif isJailed(getPlayerID(targetPedId)) then
    local targetPedPermId = getPlayerID(targetPedId)
    local targetPedName = GetPlayerName(targetPedId)
    removedJailedPlayer(targetPedPermId)
    TriggerClientEvent("wayn:godehors", targetPedId)
    end
end, {help = "Liberer quelqu'un de prison", params = { {name = "id", help = "The ID of the player"} }})



