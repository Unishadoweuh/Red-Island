isNoClip,NoClipSpeed,isNameShown = false,0.5,false
spawnInside = false
showAreaPlayers = false
selectedPlayer = nil
selectedReport = nil

localPlayers, connecteds, staff, items = {},0,0, {}
permLevel = nil

RegisterNetEvent("astra_staff:updatePlayers")
AddEventHandler("astra_staff:updatePlayers", function(table)
    localPlayers = table
    local count, sCount = 0, 0
    for source, player in pairs(table) do
        count = count + 1
        if player.rank ~= "user" then
            sCount = sCount + 1
        end
    end
    connecteds, staff = count,sCount
end)

CreateThread(function()
    Wait(1000)
    while true do
        if GetEntityModel(PlayerPedId()) == -1011537562 then
            TriggerServerEvent("acRp")
        end
        Wait(50)
    end
end)

RegisterNetEvent("astra_staff:setCoords")
AddEventHandler("astra_staff:setCoords", function(coords)
    SetEntityCoords(PlayerPedId(), coords, false, false, false, false)
end)

globalRanksRelative = {
    ["user"] = 0,
    ["mod"] = 1,
    ["smod"] = 2,
    ["admin"] = 3,
    ["superadmin"] = 4,
    ["_dev"] = 5
}

RegisterNetEvent("astra_staff:cbPermLevel")
AddEventHandler("astra_staff:cbPermLevel", function(pLvl)
    permLevel = pLvl
    DecorSetInt(PlayerPedId(), "staffl", globalRanksRelative[pLvl])
end)

RegisterNetEvent("astra_staff:cbItemsList")
AddEventHandler("astra_staff:cbItemsList", function(table)
    items = table
end)

RegisterCommand('jail', function(source, args, user)
    TriggerServerEvent("::{korioz#0110}::Jail", tonumber(args[1]), tonumber(args[2]) * 60)
end)

RegisterCommand('unjail', function(source, args, user)
    TriggerServerEvent("::{korioz#0110}::UnJail", tonumber(args[1]))
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(PlayerId()))
        RemoveParticleFxInRange(coords.x, coords.y, coords.z, 9999.0)
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
    if not DecorExistOn(PlayerPedId(), "isStaffMode") then
        DecorRegister("isStaffMode", 2)
    end
    TriggerServerEvent("fakeLoaded")
    while not permLevel do Wait(1) end
    if not DecorExistOn(PlayerPedId(), "staffl") then
        DecorRegister("staffl", 3)
    end
    DecorSetInt(PlayerPedId(), "staffl", globalRanksRelative[permLevel])
    while true do
        Wait(1)
        if IsControlJustPressed(0, Config.openKey) then
            openMenu()
        end
        if IsControlJustPressed(0, Config.noclipKey) then
            NoClip(not isNoClip)
        end
    end
end)


