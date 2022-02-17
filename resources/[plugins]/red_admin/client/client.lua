---@type table Shared object
ESX = {};

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj)
    ESX = obj
end)

local player = {};

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		return result
	else
		Citizen.Wait(500)
		return nil
	end
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj)
            ESX = obj
        end)
        player = ESX.GetPlayerData()
        Citizen.Wait(10)
    end
end)

local TempsValue = ""
local raisontosend = "Aucune raison fournie."
local GroupItem = {}
GroupItem.Value = 1

local mainMenu = RageUI.CreateMenu("RedIsland", "Gestions du serveur", 1100);
mainMenu:DisplayGlare(false)
mainMenu:AddInstructionButton({
    [1] = GetControlInstructionalButton(1, 334, 0),
    [2] = "Modifier la vitesse du NoClip",
});

local selectedMenu = RageUI.CreateSubMenu(mainMenu, "RedIsland", "placeholder", 1100)
selectedMenu:DisplayGlare(false)

local playerActionMenu = RageUI.CreateSubMenu(mainMenu, "RedIsland", "placeholder", 1100)
playerActionMenu:DisplayGlare(false)

local adminmenu = RageUI.CreateSubMenu(mainMenu, "RedIsland", "Menu Admin", 1100)
adminmenu:DisplayGlare(true)

local utilsmenu = RageUI.CreateSubMenu(mainMenu, "RedIsland", "Menu Utils", 1100)
utilsmenu:DisplayGlare(true)

local moneymenu = RageUI.CreateSubMenu(mainMenu, "RedIsland", "Menu Give", 1100)
moneymenu:DisplayGlare(true)

local vehiculemenu = RageUI.CreateSubMenu(mainMenu, "RedIsland", "Menu Vehicule", 1100)
vehiculemenu:DisplayGlare(true)

local reportmenu = RageUI.CreateSubMenu(mainMenu, "RedIsland", "Menu Report", 1100)
reportmenu:DisplayGlare(true)


---@class MasterLua
MasterLua = {} or {};

---@class SelfPlayer Administrator current settings
MasterLua.SelfPlayer = {
    ped = 0,
    isStaffEnabled = false,
    isClipping = false,
    isGamerTagEnabled = false,
    isReportEnabled = true,
    isInvisible = false,
    isCarParticleEnabled = false,
    isSteve = false,
    isDelgunEnabled = false,
};

MasterLua.SelectedPlayer = {};

MasterLua.Menus = {} or {};

MasterLua.Helper = {} or {}

---@class Players
MasterLua.Players = {} or {} --- Players lists
---
MasterLua.PlayersStaff = {} or {} --- Players Staff

MasterLua.AllReport = {} or {} --- Players Staff


---@class GamerTags
MasterLua.GamerTags = {} or {};

playerActionMenu.onClosed = function()
    MasterLua.SelectedPlayer = {}
end

local NoClip = {
    Camera = nil,
    Speed = 1.0
}

local blips = false

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if blips then
			for _, player in pairs(GetActivePlayers()) do
				local found = false
				if player ~= PlayerId() then
					local ped = GetPlayerPed(player)
					local blip = GetBlipFromEntity( ped )
					if not DoesBlipExist( blip ) then
						blip = AddBlipForEntity(ped)
						SetBlipCategory(blip, 7)
						SetBlipScale( blip,  0.85 )
						ShowHeadingIndicatorOnBlip(blip, true)
						SetBlipSprite(blip, 1)
						SetBlipColour(blip, 0)
					end
					
					SetBlipNameToPlayerName(blip, player)
					
					local veh = GetVehiclePedIsIn(ped, false)
					local blipSprite = GetBlipSprite(blip)
					
					if IsEntityDead(ped) then
						if blipSprite ~= 303 then
							SetBlipSprite( blip, 303 )
							SetBlipColour(blip, 1)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					elseif veh ~= nil then
						if IsPedInAnyBoat( ped ) then
							if blipSprite ~= 427 then
								SetBlipSprite( blip, 427 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyHeli( ped ) then
							if blipSprite ~= 43 then
								SetBlipSprite( blip, 43 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyPlane( ped ) then
							if blipSprite ~= 423 then
								SetBlipSprite( blip, 423 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyPoliceVehicle( ped ) then
							if blipSprite ~= 137 then
								SetBlipSprite( blip, 137 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnySub( ped ) then
							if blipSprite ~= 308 then
								SetBlipSprite( blip, 308 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyVehicle( ped ) then
							if blipSprite ~= 225 then
								SetBlipSprite( blip, 225 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						else
							if blipSprite ~= 1 then
								SetBlipSprite(blip, 1)
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, true )
							end
						end
					else
						if blipSprite ~= 1 then
							SetBlipSprite( blip, 1 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, true )
						end
					end
					if veh then
						SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) )
					else
						SetBlipRotation( blip, math.ceil( GetEntityHeading( ped ) ) )
					end
				end
			end
		else
			for _, player in pairs(GetActivePlayers()) do
				local blip = GetBlipFromEntity( GetPlayerPed(player) )
				if blip ~= nil then
					RemoveBlip(blip)
				end
			end
		end
	end
end)

local selectedIndex = 0;

local FastTravel = {
    { Name = "Fourrière", Value = vector3(-152.48, -1174.63, 22.73) },
    { Name = "Commissariat", Value = vector3(426.32, -996.96, 43.69) },
    { Name = "Parking central", Value = vector3(215.76, -810.8, 30.72) },
    { Name = "Concessionaire", Value = vector3(-41.84, -1099.72, 26.42) },
    { Name = "Mécano", Value = vector3(-19.31, -1057.95, 32.4) },
    { Name = "Auto-Ecole", Value = vector3(-215.09, -1389.89, 33.94) },
    { Name = "Spawn", Value = vector3(390.45, -370.29, 49.84) },
    { Name = "Quartier Famillies", Value = vector3(-126.68, -1559.6, 41.17) },
    { Name = "Quartier Ballas", Value = vector3(72.05, -1935.08, 24.31) },
    { Name = "Quartier Vagos", Value = vector3(317.0, -2044.34, 27.12) },
    { Name = "Cayo Perico", Value = vector3(5016.05, -5747.73, 32.85) },
    { Name = "Jail Admin", Value = vector3(1642.24, 2570.43, 45.56) }, 

}

local ParticleList = {
  --  { Name = "Trace", Value = { "scr_rcbarry2", "sp_clown_appear_trails" } },
   -- { Name = "Mario kart", Value = { "scr_rcbarry2", "scr_clown_bul" } },
 --   { Name = "Mario kart (2)", Value = { "scr_rcbarry2", "muz_clown" } },
   -- { Name = "Ghost rider", Value = { "core", "ent_amb_foundry_steam_spawn" } },
};

local GroupIndex = 1;
local GroupIndexx = 1;
local GroupIndexxx = 1;
local GroupIndexxxx = 1;
local GroupIndexxxxx = 1;
local PermissionIndex = 1;
local VehicleIndex = 1;
local FastTravelIndex = 1;
local CarParticleIndex = 1;
local idtosanctionbaby = 1;
local idtoreport = 1;
local kvdureport = 1;

function MasterLua.Helper:RetrievePlayersDataByID(source)
    local player = {};
    for i, v in pairs(MasterLua.Players) do
        if (v.source == source) then
            player = v;
        end
    end
    return player;
end

function MasterLua.Helper:onToggleNoClip(toggle)
    if (toggle) then
        Visual.Subtitle("~g~Vous venez d'activer le noclip", 1000)
        if (ESX.GetPlayerData()['group'] ~= "user") then
            if (NoClip.Camera == nil) then
                NoClip.Camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            end
            SetCamActive(NoClip.Camera, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(NoClip.Camera, GetEntityCoords(MasterLua.SelfPlayer.ped))
            SetCamRot(NoClip.Camera, GetEntityRotation(MasterLua.SelfPlayer.ped))
            SetEntityCollision(NoClip.Camera, false, false)
            SetEntityVisible(NoClip.Camera, false)
            SetEntityVisible(MasterLua.SelfPlayer.ped, false, false)
        end
    else
        if (ESX.GetPlayerData()['group'] ~= "user") then
            Visual.Subtitle("~y~Vous venez de déactiver le noclip", 1000)
            SetCamActive(NoClip.Camera, false)
            RenderScriptCams(false, false, 0, true, true)
            SetEntityCollision(MasterLua.SelfPlayer.ped, true, true)
            SetEntityCoords(MasterLua.SelfPlayer.ped, GetCamCoord(NoClip.Camera))
            SetEntityHeading(MasterLua.SelfPlayer.ped, GetGameplayCamRelativeHeading(NoClip.Camera))
            if not (MasterLua.SelfPlayer.isInvisible) then
                SetEntityVisible(MasterLua.SelfPlayer.ped, true, false)
            end
        end
    end
end

function MasterLua.Helper:OnRequestGamerTags()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if (MasterLua.GamerTags[ped] == nil) or (MasterLua.GamerTags[ped].ped == nil) or not (IsMpGamerTagActive(MasterLua.GamerTags[ped].tags)) then
            local formatted;
            local group = 0;
            local permission = 0;
            local fetching = MasterLua.Helper:RetrievePlayersDataByID(GetPlayerServerId(player));
            if (fetching) then
                formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), fetching.jobs)
            else
                formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), "Jobs Unknow")
            end
            if (fetching) then
                group = fetching.group
                permission = fetching.permission
            end

            MasterLua.GamerTags[ped] = {
                player = player,
                ped = ped,
                group = group,
                permission = permission,
                tags = CreateFakeMpGamerTag(ped, formatted)
            };
        end

    end
end

function MasterLua.Helper:RequestModel(model)
    if (IsModelValid(model)) then
        if not (HasModelLoaded(model)) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Visual.Prompt(string.format("MasterLua : Loading %s model..", model), 4)
                Citizen.Wait(1.0)
            end
            BusyspinnerOff()
            return model;
        else
            Visual.PromptDuration(1000, string.format('MasterLua : Can\'t load model %s but is already load', model), 1)
            return model;
        end
        Visual.FloatingHelpText(string.format("~r~ MasterLua : The model %s you just asked for does not exist in the game files or on the server.", model))
        return model;
    end
end

RegisterNetEvent("arme:event")
AddEventHandler("arme:event", function()
    GiveWeaponToPed(PlayerPedId(), "weapon_carbinerifle", 9999, false, false)
end)

function MasterLua.Helper:RequestPtfx(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

function MasterLua.Helper:CreateVehicle(model, vector3)
    self:RequestModel(model)
    local vehicle = CreateVehicle(model, vector3, 100.0, true, false)
    local id = NetworkGetNetworkIdFromEntity(vehicle)

    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(vehicle, false, false)
    SetModelAsNoLongerNeeded(model)

    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    while not HasCollisionLoadedAroundEntity(vehicle) do
        Citizen.Wait(0)
    end
    return vehicle, GetEntityCoords(vehicle);
end

function MasterLua.Helper:KeyboardInput(TextEntry, ExampleText, MaxStringLength, OnlyNumber)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", 500)
    local blocking = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blocking = false
        if (OnlyNumber) then
            local number = tonumber(result)
            if (number ~= nil) then
                return number
            end
            return nil
        else
            return result
        end
    else
        Citizen.Wait(500)
        blocking = false
        return nil
    end
end

function MasterLua.Helper:OnGetPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('MasterLua:retrievePlayers', function(players)
        clientPlayers = players
    end)

    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function MasterLua.Helper:OnGetStaffPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('MasterLua:retrieveStaffPlayers', function(players)
        clientPlayers = players
    end)
    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function MasterLua.Helper:GetReport()
    ESX.TriggerServerCallback('MasterLua:retrieveReport', function(allreport)
        ReportBB = allreport
    end)
    while not ReportBB do
        Citizen.Wait(0)
    end
    return ReportBB
end

RegisterNetEvent("MasterLua:RefreshReport")
AddEventHandler("MasterLua:RefreshReport", function()
    MasterLua.GetReport = MasterLua.Helper:GetReport()
end)

function MasterLua.Helper:onStaffMode(status)
    if (status) then
        Visual.Subtitle("Staff mode enabled", 5000)
        MasterLua.PlayersStaff = MasterLua.Helper:OnGetStaffPlayers()
        MasterLua.GetReport = MasterLua.Helper:GetReport()
    else
        if (MasterLua.SelfPlayer.isClipping) then
            MasterLua.Helper:onToggleNoClip(false)
        end
        if (MasterLua.SelfPlayer.isInvisible) then
            MasterLua.SelfPlayer.isInvisible = false;
            SetEntityVisible(MasterLua.SelfPlayer.ped, true, false)
        end
    end
end

function MasterLua.Helper:NetworkedParticleFx(assets, effect, car, boneid, scale)
    MasterLua.Helper:RequestPtfx(assets)
    UseParticleFxAsset(assets)
    local bone = GetWorldPositionOfEntityBone(car, boneid)
    StartNetworkedParticleFxNonLoopedAtCoord(effect, bone.x, bone.y, bone.z, 0.0, 0.0, 0.0, scale, false, false, false, false)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if (MasterLua.SelfPlayer.isStaffEnabled) then
            MasterLua.Players = MasterLua.Helper:OnGetPlayers()
            MasterLua.PlayersStaff = MasterLua.Helper:OnGetStaffPlayers()
            MasterLua.GetReport = MasterLua.Helper:GetReport()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (IsControlJustPressed(0, 57)) then
            if (ESX.GetPlayerData()['group'] ~= "user") then
                MasterLua.Players = MasterLua.Helper:OnGetPlayers();
                MasterLua.PlayersStaff = MasterLua.Helper:OnGetStaffPlayers()
                MasterLua.GetReport = MasterLua.Helper:GetReport()
                RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
            end
        end

        if (IsControlJustPressed(0, 344)) then
            if (ESX.GetPlayerData()['group'] ~= "user") then
                MasterLua.GetReport = MasterLua.Helper:GetReport()
                RageUI.Visible(reportmenu, not RageUI.Visible(reportmenu))
            end
        end


        RageUI.IsVisible(mainMenu, function()


            RageUI.Checkbox("Staff mode", "Le mode staff ne peut être utilisé que pour modérer le serveur, tout abus sera sévèrement puni, l'intégrité de vos actions sera enregistrée.", MasterLua.SelfPlayer.isStaffEnabled, { }, {
                onChecked = function()
                    MasterLua.Helper:onStaffMode(true)
                    TriggerServerEvent('MasterLua:onStaffJoin')
                end,
                onUnChecked = function()
                    MasterLua.Helper:onStaffMode(false)
                    TriggerServerEvent('MasterLua:onStaffLeave')
                end,
                onSelected = function(Index)
                    MasterLua.SelfPlayer.isStaffEnabled = Index
                end
            })

            if (MasterLua.SelfPlayer.isStaffEnabled) then
                RageUI.Separator("↓ JOUEURS ↓")

                RageUI.Button('~g~👨 Joueurs en lignes', nil, { RightLabel = #MasterLua.Players }, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Joueurs en lignes [%s]', #MasterLua.Players))
                        selectedIndex = 1;
                    end
                }, selectedMenu)

                RageUI.Button('~b~👮 Staff en lignes', nil, { RightLabel = #MasterLua.PlayersStaff }, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Staff en lignes [%s]', #MasterLua.PlayersStaff))
                        selectedIndex = 2;
                    end
                }, selectedMenu)

                RageUI.Separator("↓ MENU ↓")
                
                RageUI.Button('🔨 Menu Admin', nil, { }, true, {
                    onSelected = function()
                    end
                }, adminmenu)

                RageUI.Button('🧰 Menu Vehicules', nil, { }, true, {
                    onSelected = function()
                    end
                }, vehiculemenu)

                if (ESX.GetPlayerData()['group'] == "superadmin" or ESX.GetPlayerData()['group'] == "_dev" or ESX.GetPlayerData()['group'] == "admin") then
                    RageUI.Button('🧧 Remboursements', nil, { }, true, {
                        onSelected = function()
                        end
                    }, moneymenu)
                end
                RageUI.Button('💣 Menu Divers', nil, { }, true, {
                    onSelected = function()
                    end
                }, utilsmenu)

                RageUI.Button('🎫 Menu Reports', nil, { }, true, {
                    onSelected = function()
                    end
                }, reportmenu)

            end
        end)

        if (MasterLua.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(utilsmenu, function()

                RageUI.Checkbox("Pistolet Véhicule", nil, MasterLua.SelfPlayer.isDelgunEnabled, { }, {
                    onChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Active Delgun")
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Désactive Delgun")
                    end,
                    onSelected = function(Index)
                        MasterLua.SelfPlayer.isDelgunEnabled = Index
                    end
                })

                RageUI.List('TP Rapide', FastTravel, FastTravelIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        FastTravelIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        MasterLua.SelfPlayer.isInvisible = true
                        SetEntityVisible(MasterLua.SelfPlayer.ped, false, false)
                        SetEntityCoords(PlayerPedId(), Item.Value)
                    end,
                })

                RageUI.Checkbox("Particule sur les roue", nil, MasterLua.SelfPlayer.isCarParticleEnabled, { }, {
                    onChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Active Particle on wheel")
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Désactive Particle on wheel")
                    end,
                    onSelected = function(Index)
                        MasterLua.SelfPlayer.isCarParticleEnabled = Index
                    end
                })

                if (MasterLua.SelfPlayer.isCarParticleEnabled) then
                    RageUI.List('Particule sur les roue (Type)', ParticleList, CarParticleIndex, nil, {}, true, {
                        onListChange = function(Index, Item)
                            CarParticleIndex = Index;
                        end,
                        onSelected = function(Index, Item)

                        end,
                    })
                end
            end)
        end

        if (MasterLua.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(vehiculemenu, function()
                RageUI.List('Vehicles', {
                    { Name = "BMX", Value = 'bmx' },
                    { Name = "Issi", Value = 'issi3' },
                    { Name = "Sanchez", Value = 'sanchez' },
                    { Name = "Faggio Sport", Value = "faggio3" },
                }, VehicleIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        VehicleIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        if Item.Value == nil then
                            local modelName = KeyboardInput('MASTERLUA_BOX_VEHICLE_NAME', "Nom du vehicule", '', 50)
                            TriggerEvent('MasterLua:spawnVehicle', modelName)
                            TriggerServerEvent("MasterLua:SendLogs", "Spawn custom vehicle")
                        else
                            TriggerEvent('MasterLua:spawnVehicle', Item.Value)
                            TriggerServerEvent("MasterLua:SendLogs", "Spawn vehicle")
                        end
                    end,
                })
                RageUI.Button('Réparation du véhicule', nil, { }, true, {
                    onSelected = function()
                        local plyVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleFixed(plyVeh)
                        SetVehicleDirtLevel(plyVeh, 0.0)
                        TriggerServerEvent("MasterLua:SendLogs", "Repair Vehicle")
                    end
                })

                RageUI.List('Suppression des véhicules (Zone)', {
                    { Name = "1", Value = 1 },
                    { Name = "5", Value = 5 },
                    { Name = "10", Value = 10 },
                    { Name = "15", Value = 15 },
                    { Name = "20", Value = 20 },
                    { Name = "25", Value = 25 },
                    { Name = "30", Value = 30 },
                    { Name = "50", Value = 50 },
                    { Name = "100", Value = 100 },
                }, GroupIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent("MasterLua:SendLogs", "Delete vehicle zone")
                        local playerPed = PlayerPedId()
                        local radius = Item.Value
                        if radius and tonumber(radius) then
                            radius = tonumber(radius) + 0.01
                            local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed, false), radius)

                            for i = 1, #vehicles, 1 do
                                local attempt = 0

                                while not NetworkHasControlOfEntity(vehicles[i]) and attempt < 100 and DoesEntityExist(vehicles[i]) do
                                    Citizen.Wait(100)
                                    NetworkRequestControlOfEntity(vehicles[i])
                                    attempt = attempt + 1
                                end

                                if DoesEntityExist(vehicles[i]) and NetworkHasControlOfEntity(vehicles[i]) then
                                    ESX.Game.DeleteVehicle(vehicles[i])
                                    DeleteEntity(vehicles[i])
                                end
                            end
                        else
                            local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

                            if IsPedInAnyVehicle(playerPed, true) then
                                vehicle = GetVehiclePedIsIn(playerPed, false)
                            end

                            while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
                                Citizen.Wait(100)
                                NetworkRequestControlOfEntity(vehicle)
                                attempt = attempt + 1
                            end

                            if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
                                ESX.Game.DeleteVehicle(vehicle)
                                DeleteEntity(vehicle)
                            end
                        end
                    end,
                })
            end)
        end

        if (MasterLua.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(moneymenu, function()
                RageUI.Separator("↓ Give Argent ↓")
                RageUI.List('Se donner de l\'argent en liquide', {
                    { Name = "1000$", Value = '1000' },
                    { Name = "10000$", Value = '10000' },
                    { Name = "50000$", Value = '50000' },
                    { Name = "100000$", Value = '100000' },
                }, GroupIndexx, "Se donner de l'argent en cash ! ~r~(Entré pour validé)\n", {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndexx = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent("MasterLua:GiveMoney", "cash", Item.Value)
                        Visual.Subtitle("Vous avez recu " .. Item.Value .. "$ en liquide !", 2000)
                    end,
                })
                RageUI.List('Se donner de l\'argent en banque', {
                    { Name = "1000$", Value = '1000' },
                    { Name = "10000$", Value = '10000' },
                    { Name = "50000$", Value = '50000' },
                    { Name = "100000$", Value = '100000' },
                }, GroupIndexxx, "Se donner de l'argent en Banque ! ~r~(Entré pour validé)\n", {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndexxx = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent("MasterLua:GiveMoney", "bank", Item.Value)
                        Visual.Subtitle("Vous avez recu " .. Item.Value .. "$ en banque !", 2000)
                    end,
                })
                RageUI.List('Se donner de l\'argent sale', {
                    { Name = "1000$", Value = '1000' },
                    { Name = "10000$", Value = '10000' },
                    { Name = "50000$", Value = '50000' },
                    { Name = "100000$", Value = '100000' },
                }, GroupIndexxxx, "Se donner de l'argent sale ! ~r~(Entré pour validé)\n", {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndexxxx = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent("MasterLua:GiveMoney", "dirtycash", Item.Value)
                        Visual.Subtitle("Vous avez recu " .. Item.Value .. "$ en argent sale !", 2000)
                    end,
                })
                RageUI.Separator("↓ Give Item ↓")
                RageUI.List('Se donner un item', {
                    { Name = "Menotte Police", Value = 'police_cuff' },
                    { Name = "Clés Menotte Police", Value = 'police_key' },
                    { Name = "Kevlar", Value = 'armor' },
                    { Name = "Bandage", Value = 'bandage' },
                    { Name = "Menottes Basique", Value = 'basic_cuff' },
                    { Name = "Clés de Menottes Basique", Value = 'basic_key' },
                    { Name = "Bière", Value = 'beer' },
                    { Name = "Chalumeaux", Value = 'blowpipe' },
                    { Name = "Pain", Value = 'bread' },
                    { Name = "Burger", Value = 'burger' },
                    { Name = "Kit carosserie", Value = 'carokit' },
                    { Name = "Outils carosserie", Value = 'carotool' },
                    { Name = "Jeton", Value = 'chip' },
                    { Name = "Cigarette", Value = 'cigarette' },
                    { Name = "Chargeur", Value = 'clip' },
                    { Name = "Coca", Value = 'coca' },
                    { Name = "Coke", Value = 'coke' },
                    { Name = "Pochon de coke", Value = 'coke_pooch' },
                    { Name = "Défibrillateur", Value = 'defibrillateur' },
                    { Name = "Feuille de coca", Value = 'feuille_coca' },
                    { Name = "Trousse premier secours", Value = 'firstaidkit' },
                    { Name = "Kit réparation", Value = 'fixkit' },
                    { Name = "Outils réparation", Value = 'fixtool' },
                    { Name = "Bouteille de gaz", Value = 'gazbottle' },
                    { Name = "Gitanes", Value = 'gitanes' },
                    { Name = "Grand cru", Value = 'grand_cru' },
                    { Name = "Grappe de raisin", Value = 'grapperaisin' },
                    { Name = "Serre câble", Value = 'handcuff' },
                    { Name = "Glaçon", Value = 'ice' },
                    { Name = "Jägermeister", Value = 'jager' },
                    { Name = "Jägermeister", Value = 'jagerbomb' },
                    { Name = "Jäger Cerbère", Value = 'jagercerbere' },
                    { Name = "Jumelles", Value = 'jumelles' },
                    { Name = "Jus de coca", Value = 'jus_coca' },
                    { Name = "Jus de raisin", Value = 'jus_raisin' },
                    { Name = "Jus de fruits", Value = 'jusfruit' },
                    { Name = "Limonade", Value = 'limonade' },
                    { Name = "Martini blanc", Value = 'martini' },
                    { Name = "Pied de Biche", Value = 'lockpick' },
                    { Name = "Malboro", Value = 'malbora' },
                    { Name = "Viande", Value = 'meat' },
                    { Name = "Medikit", Value = 'medikit' },
                    { Name = "Feuille de menthe", Value = 'menthe' },
                    { Name = "Malboro", Value = 'malbora' },
                    { Name = "Meth", Value = 'meth' },
                    { Name = "Pochon de meth", Value = 'meth_pooch' },
                    { Name = "Mètre de shooter", Value = 'metreshooter' },
                    { Name = "Mix Apéritif", Value = 'mixapero' },
                    { Name = "Mojito", Value = 'mojito' },
                    { Name = "Opium", Value = 'opium' },
                    { Name = "Pochon d'opium", Value = 'opium_pooch' },
                    { Name = "Orange", Value = 'orange' },
                    { Name = "Jus d'orange", Value = 'orange_juice' },
                    { Name = "Masque à Oxygène", Value = 'oxygen_mask' },
                    { Name = "Gazeuse", Value = 'pepperspray' },
                    { Name = "Téléphone", Value = 'phone' },
                    { Name = "GHB", Value = 'piluleoubli' },
                    { Name = "Pomme", Value = 'pomme' },
                    { Name = "Radio", Value = 'radio' },
                    { Name = "Raisin", Value = 'raisin' },
                    { Name = "Redbull", Value = 'redbull' },
                    { Name = "Repairkit", Value = 'repairkit' },
                    { Name = "Rhum", Value = 'rhum' },
                    { Name = "Rhum-Coca", Value = 'rhumcoca' },
                    { Name = "Rhum-Jus de fruits", Value = 'rhumfruit' },
                    { Name = "Tabac", Value = 'tabac' },
                    { Name = "Tabac Blond", Value = 'tabacblond' },
                    { Name = "Tabac Blond Séché", Value = 'tabacblondsec' },
                    { Name = "Tabac Brun", Value = 'tabacbrun' },
                    { Name = "Tabac Brun Séché", Value = 'tabacbrunsec' },
                    { Name = "Tarte aux Pommes", Value = 'tarte_pomme' },
                    { Name = "Teq'paf", Value = 'teqpaf' },
                    { Name = "Tequila", Value = 'tequila' },
                    { Name = "Vin", Value = 'vine' },
                    { Name = "Vin Blanc", Value = 'vittvin' },
                    { Name = "Vodka", Value = 'vodka' },
                    { Name = "Vodka-Energy", Value = 'vodkaenergy' },
                    { Name = "Vodka-Jus de fruits", Value = 'vodkafruit' },
                    { Name = "Vodka-Redbull", Value = 'vodkaredbull' },
                    { Name = "Bouteille d'eau", Value = 'water' },
                    { Name = "Weed", Value = 'weed' },
                    { Name = "Pochon de weed", Value = 'weed_pooch' },
                    { Name = "Whisky", Value = 'whisky' },
                    { Name = "Whisky-coca", Value = 'whiskycoca' },
                    { Name = "Jetons", Value = 'zetony' },
                }, GroupIndexxxxx, "Se donner un item ! ~r~(Entré pour validé)\n", {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndexxxxx = Index;
                    end,
                    onSelected = function(Index, Item) 
                        TriggerServerEvent("MasterLua:GiveItem", Item.Value)
                        Visual.Subtitle("Vous avez recu l'item " .. Item.Name .. " dans votre inventaire !", 2000)
                    end,
                })

            end)
        end

        if (MasterLua.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(adminmenu, function()
                RageUI.Checkbox("NoClip", "Vous permet de vous déplacer librement sur toute la carte sous forme de caméra libre.", MasterLua.SelfPlayer.isClipping, { }, {
                    onChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Active noclip")
                        MasterLua.Helper:onToggleNoClip(true)
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Désactive noclip")
                        MasterLua.Helper:onToggleNoClip(false)
                    end,
                    onSelected = function(Index)
                        MasterLua.SelfPlayer.isClipping = Index
                    end
                })
                RageUI.Checkbox("Invisible", nil, MasterLua.SelfPlayer.isInvisible, { }, {
                    onChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Active invisible")
                        SetEntityVisible(MasterLua.SelfPlayer.ped, false, false)
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Désactive invisible")
                        SetEntityVisible(MasterLua.SelfPlayer.ped, true, false)
                    end,
                    onSelected = function(Index)
                        MasterLua.SelfPlayer.isInvisible = Index
                    end
                })

                RageUI.Checkbox("Afficher les GamerTags", "L'affichage des tags des joueurs vous permet de voir les informations des joueurs, y compris de vous reconnaître entre les membres du personnel grâce à votre couleur.", MasterLua.SelfPlayer.isGamerTagEnabled, { }, {
                    onChecked = function()
                        if (ESX.GetPlayerData()['group'] ~= "user") then
                            TriggerServerEvent("MasterLua:SendLogs", "Active GamerTag")
                            MasterLua.Helper:OnRequestGamerTags()
                        end
                    end,
                    onUnChecked = function()
                        for i, v in pairs(MasterLua.GamerTags) do
                            TriggerServerEvent("MasterLua:SendLogs", "Désactive GamerTag")
                            RemoveMpGamerTag(v.tags)
                        end
                        MasterLua.GamerTags = {};
                    end,
                    onSelected = function(Index)
                        MasterLua.SelfPlayer.isGamerTagEnabled = Index
                    end
                })
                RageUI.Checkbox("Blips", nil, MasterLua.SelfPlayer.IsBlipsActive, { }, {
                    onChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Active Blips")
                        blips = true
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Désactive Blips")
                        blips = false
                    end,
                    onSelected = function(Index)
                        MasterLua.SelfPlayer.IsBlipsActive = Index
                    end
                })
            end)
        end


        if (MasterLua.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(selectedMenu, function()
                table.sort(MasterLua.Players, function(a,b) return a.source < b.source end)
                if (selectedIndex == 1) then
                    if (#MasterLua.Players > 0) then

                        for i, v in pairs(MasterLua.Players) do
                            local colors = {
                                ["_dev"] = '',
                                ["superadmin"] = '~r~',
                                ["admin"] = '~b~',
                                ["mod"] = '~b~',
                                ["user"] = '',
                            }
                            RageUI.Button(string.format('%s[%s] %s', colors[v.group], v.source, v.name), nil, {}, true, {
                                onSelected = function()
                                    playerActionMenu:SetSubtitle(string.format('[%s] %s', i, v.name))
                                    MasterLua.SelectedPlayer = v;
                                end
                            }, playerActionMenu)
                        end
                    else
                        RageUI.Separator("Aucun joueurs en ligne.")
                    end
                end
                if (selectedIndex == 2) then
                    if (#MasterLua.PlayersStaff > 0) then
                        for i, v in pairs(MasterLua.PlayersStaff) do
                            local colors = {
                                ["_dev"] = '~w~',
                                ["superadmin"] = '~r~',
                                ["admin"] = '~b~',
                                ["mod"] = '~b~',
                            }
                            RageUI.Button(string.format('%s[%s] %s', colors[v.group], v.source, v.name), nil, {}, true, {
                                onSelected = function()
                                    playerActionMenu:SetSubtitle(string.format('[%s] %s', v.source, v.name))
                                    MasterLua.SelectedPlayer = v;
                                end
                            }, playerActionMenu)
                        end
                    else
                        RageUI.Separator("Aucun joueurs en ligne.")
                    end
                end

                if (selectedIndex == 3) then
                    --idtosanctionbaby

                    for i, v in pairs(MasterLua.Players) do
                        if v.source == idtosanctionbaby then
                            RageUI.Separator("↓ INFORMATION ↓")
                            RageUI.Button('ID: ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUI.Button('Nom: ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Métier: ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end

                    RageUI.Separator("↓ SANCTION ↓")
                    RageUI.List('Temps de ban', {
                        { Name = "1 Heure", Value = '0.2' },
                        { Name = "12 Heure", Value = '1' },
                        { Name = "1 Jour", Value = '1' },
                        { Name = "1 Jours", Value = '3' },
                        { Name = "Permanent", Value = '0' },
                    }, GroupIndex, "Pour mettre le temps de ban ! ~r~(Entré pour validé)\n", {}, true, {
                        onListChange = function(Index, Item)
                            GroupItem = Item;
                            GroupIndex = Index;
                        end,
                    })
                    RageUI.Button('Raison du ban', nil, { RightLabel = raisontosend }, true, {
                        onSelected = function()
                            local Raison = KeyboardInput('MASTERLUA_BOX_BAN_RAISON', "Raison du ban", '', 50)
                            raisontosend = Raison
                        end
                    })

                    RageUI.Button('Valider', nil, { RightLabel = "✅" }, true, {
                        onSelected = function()
                            TriggerServerEvent("MasterLua:Ban", idtosanctionbaby, GroupItem.Value, raisontosend)
                        end
                    })
                end

                if (selectedIndex == 4) then
                    for i, v in pairs(MasterLua.Players) do
                        if v.source == idtosanctionbaby then
                            RageUI.Separator("↓ INFORMATION ↓")
                            RageUI.Button('ID: ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUI.Button('Nom: ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Métier: ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end
                    RageUI.Separator("↓ SANCTION ↓")
                    RageUI.Button('Raison du kick', nil, { RightLabel = raisontosend }, true, {
                        onSelected = function()
                            local Raison = KeyboardInput('MASTERLUA_BOX_BAN_RAISON', "Raison du ban", '', 50)
                            raisontosend = Raison
                        end
                    })

                    RageUI.Button('Valider', nil, { RightLabel = "✅" }, true, {
                        onSelected = function()
                            TriggerServerEvent("MasterLua:kick", idtosanctionbaby, raisontosend)
                        end
                    })
                end
                if (selectedIndex == 5) then
                    for i, v in pairs(MasterLua.Players) do
                        if v.source == idtosanctionbaby then
                            RageUI.Separator("↓ INFORMATION ↓")
                            RageUI.Button('ID: ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUI.Button('Nom: ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Métier: ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end
                    RageUI.Separator("↓ SANCTION ↓")
                    for i = 1, 200 do 
                        RageUI.Button(i .. ' Minutes', nil, {}, true, {
                            onSelected = function()
                                TriggerServerEvent("MasterLua:Jail", idtosanctionbaby, i * 60)
                            end
                        })
                    end
                end
                if (selectedIndex == 6) then
                    for i, v in pairs(MasterLua.Players) do
                        if v.source == idtoreport then
                            RageUI.Separator("↓ INFORMATION ↓")
                            RageUI.Button('ID: ' .. idtoreport, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUI.Button('Nom: ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Métier: ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end

                    RageUI.Separator("↓ ACTION RAPIDE ↓")
                    RageUI.Button('Se teleporter sur lui', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("MasterLua:teleport", idtoreport)
                        end
                    })
                    RageUI.Button('Téléporter sur moi', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("MasterLua:teleportTo", idtoreport)
                        end
                    })
                    RageUI.Button('Téléporter au Parking Central', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent('MasterLua:teleportcoords', idtoreport, vector3(216.43, -908.92, 18.32))
                        end
                    })

                    RageUI.Button('Revive', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("MasterLua:Revive", idtoreport)
                        end
                    })

                    RageUI.Separator("↓ REPORT ↓")
                    RageUI.Button('Fermer le report', nil, { }, true, {
                        onSelected = function()
                            TriggerServerEvent("MasterLua:ReportRegle", kvdureport)
                            TriggerEvent("MasterLua:RefreshReport")
                        end
                    }, reportmenu)
                end
            end)

            RageUI.IsVisible(playerActionMenu, function()
                RageUI.Separator("↓ TELEPORTATION ↓")

                RageUI.Button('Vous téléporté sur lui', nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('MasterLua:teleport', MasterLua.SelectedPlayer.source)
                    end
                })
                RageUI.Button('Téléporté vers vous', nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('MasterLua:teleportTo', MasterLua.SelectedPlayer.source)
                    end
                })

                RageUI.Button('Le téléporté au Parking Central', nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent('MasterLua:teleportcoords', MasterLua.SelectedPlayer.source, vector3(216.43, -908.92, 18.32))
                    end
                })

                RageUI.Separator("↓ PERMISSIONS ↓")
                RageUI.List('Changer le groupe', {
                    { Name = "Utilisateur", Value = 'user' },
                    { Name = "Sup-Admin", Value = 'superadmin' },
                    { Name = "Remboursement", Value = 'admin' },
                    { Name = "Modération", Value = 'mod' },
                    { Name = "Développeur", Value = '_dev' },
                }, GroupIndex, "Changer le groupe de l'utilisateur sélectionée ~r~(Entré pour validé)", {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent('MasterLua:setGroup', MasterLua.SelectedPlayer.source, Item.Value)
                        Visual.Subtitle("Vous avez modifier le groupe de l'utlisateur", 2000)
                    end,
                })

                RageUI.List('Changer les permission', {
                    { Name = "0", Value = 0 },
                    { Name = "1", Value = 1 },
                    { Name = "2", Value = 2 },
                    { Name = "3", Value = 3 },
                    { Name = "4", Value = 4 },
                }, PermissionIndex, "Changer les permission de l'utilisateur sélectionée ~r~(Entré pour validé)", {}, true, {
                    onListChange = function(Index, Item)
                        PermissionIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent('MasterLua:setPermission', MasterLua.SelectedPlayer.source, Item.Value)
                        Visual.Subtitle("Vous avez modifier les permission de l'utlisateur", 2000)
                    end,
                })
                RageUI.Separator("↓ SANCTION ↓")
                RageUI.Button('Bannir le joueur', nil, {}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Bannir le joueur'))
                        idtosanctionbaby = MasterLua.SelectedPlayer.source
                        selectedIndex = 3;
                    end
                }, selectedMenu)

                RageUI.Button('Kick le joueur', nil, {}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Kick le joueur'))
                        idtosanctionbaby = MasterLua.SelectedPlayer.source
                        selectedIndex = 4;
                    end
                }, selectedMenu)

                RageUI.Button('Jail le joueur', nil, {}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Jail le joueur'))
                        idtosanctionbaby = MasterLua.SelectedPlayer.source
                        selectedIndex = 5;
                    end
                }, selectedMenu)
                RageUI.Button('UnJail le joueur', nil, {}, true, {
                    onSelected = function()
                        TriggerServerEvent("MasterLua:SendLogs", "Unjail Players !")
                        TriggerServerEvent('::{korioz#0110}::esx_jail:unjail', MasterLua.SelectedPlayer.source)
                    end
                })

            end)
            RageUI.IsVisible(reportmenu, function()
                for i, v in pairs(MasterLua.GetReport) do
                    if i == 0 then
                        return
                    end
                    RageUI.Button("[" .. v.id .. "] " .. v.name, "ID : " .. v.id .. "\n" .. "Name : " .. v.name .. "\nReason : " .. v.reason, {}, true, {
                        onSelected = function()
                            selectedMenu:SetSubtitle(string.format('Report'))
                            kvdureport = i
                            idtoreport = v.id
                            selectedIndex = 6;
                        end
                    }, selectedMenu)
                end
            end)
        end
        for i, onTick in pairs(MasterLua.Menus) do
            onTick();
        end
    end

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    if (xPlayer.group ~= "user") then
        Keys.Register('F4', 'F4', 'Menu d\'RedIsland', function()
            if (ESX.GetPlayerData()['group'] ~= "user") then
                RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
            end
        end)
    end
end)

local function getEntity(player)
    -- function To Get Entity Player Is Aiming At
    local _, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

local function aimCheck(player)
    -- function to check config value onAim. If it's off, then
    return IsPedShooting(player)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (MasterLua.SelfPlayer.isStaffEnabled) then
            if (MasterLua.SelfPlayer.isDelgunEnabled) then
                if IsPlayerFreeAiming(PlayerId()) then
                    local entity = getEntity(PlayerId())
                    if GetEntityType(entity) == 2 or 3 then
                        if aimCheck(GetPlayerPed(-1)) then
                            SetEntityAsMissionEntity(entity, true, true)
                            DeleteEntity(entity)
                        end
                    end
                end
            end

            if (MasterLua.SelfPlayer.isClipping) then
                --HideHudAndRadarThisFrame()

                local camCoords = GetCamCoord(NoClip.Camera)
                local right, forward, _, _ = GetCamMatrix(NoClip.Camera)
                if IsControlPressed(0, 32) then
                    local newCamPos = camCoords + forward * NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 8) then
                    local newCamPos = camCoords + forward * -NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 34) then
                    local newCamPos = camCoords + right * -NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 9) then
                    local newCamPos = camCoords + right * NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 334) then
                    if (NoClip.Speed - 0.1 >= 0.1) then
                        NoClip.Speed = NoClip.Speed - 0.1
                    end
                end
                if IsControlPressed(0, 335) then
                    if (NoClip.Speed + 0.1 >= 0.1) then
                        NoClip.Speed = NoClip.Speed + 0.1
                    end
                end

                SetEntityCoords(MasterLua.SelfPlayer.ped, camCoords.x, camCoords.y, camCoords.z)

                local xMagnitude = GetDisabledControlNormal(0, 1)
                local yMagnitude = GetDisabledControlNormal(0, 2)
                local camRot = GetCamRot(NoClip.Camera)
                local x = camRot.x - yMagnitude * 10
                local y = camRot.y
                local z = camRot.z - xMagnitude * 10
                if x < -75.0 then
                    x = -75.0
                end
                if x > 100.0 then
                    x = 100.0
                end
                SetCamRot(NoClip.Camera, x, y, z)
            end

            if (MasterLua.SelfPlayer.isGamerTagEnabled) then
                for i, v in pairs(MasterLua.GamerTags) do
                    local target = GetEntityCoords(v.ped, false);

                    if #(target - GetEntityCoords(PlayerPedId())) < 120 then
                        SetMpGamerTagVisibility(v.tags, 0, true)
                        SetMpGamerTagVisibility(v.tags, 2, true)

                        SetMpGamerTagVisibility(v.tags, 4, NetworkIsPlayerTalking(v.player))
                        SetMpGamerTagAlpha(v.tags, 2, 255)
                        SetMpGamerTagAlpha(v.tags, 4, 255)

                        local colors = {
                            ["superadmin"] = 6,
                            ["admin"] = 22,
                            ["mod"] = 9,
                        }
                        SetMpGamerTagColour(v.tags, 0, colors[v.group] or 0)
                    else
                        RemoveMpGamerTag(v.tags)
                        MasterLua.GamerTags[i] = nil;
                    end
                end


            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        MasterLua.SelfPlayer.ped = GetPlayerPed(-1);
        if (MasterLua.SelfPlayer.isStaffEnabled) then
            if (MasterLua.SelfPlayer.isGamerTagEnabled) then
                MasterLua.Helper:OnRequestGamerTags();
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if (MasterLua.SelfPlayer.isCarParticleEnabled) then
            local ped = PlayerPedId()
            local car = GetVehiclePedIsIn(ped, false);
            local dics = ParticleList[CarParticleIndex].Value[1];
            local name = ParticleList[CarParticleIndex].Value[2];

            if (car) then
                local wheel_lf = GetEntityBoneIndexByName(car, 'wheel_lf')
                local wheel_lr = GetEntityBoneIndexByName(car, 'wheel_lr')
                local wheel_rf = GetEntityBoneIndexByName(car, 'wheel_rf')
                local wheel_rr = GetEntityBoneIndexByName(car, 'wheel_rr')
                if (wheel_lf) then
                    MasterLua.Helper:NetworkedParticleFx(dics, name, car, wheel_lf, 1.0)
                end
                if (wheel_lr) then
                    MasterLua.Helper:NetworkedParticleFx(dics, name, car, wheel_lr, 1.0)
                end
                if (wheel_rf) then
                    MasterLua.Helper:NetworkedParticleFx(dics, name, car, wheel_rf, 1.0)
                end
                if (wheel_rr) then
                    MasterLua.Helper:NetworkedParticleFx(dics, name, car, wheel_rr, 1.0)
                end
                SetVehicleFixed(car)
                SetVehicleDirtLevel(car, 0.0)
                SetPlayerInvincible(ped, true)
            end
        end
    end
end)

RegisterNetEvent('MasterLua:setGroup')
AddEventHandler('MasterLua:setGroup', function(group, lastGroup)
    player.group = group
end)

RegisterNetEvent('MasterLua:teleport')
AddEventHandler('MasterLua:teleport', function(coords)
    if (MasterLua.SelfPlayer.isClipping) then
        SetCamCoord(NoClip.Camera, coords.x, coords.y, coords.z)
        SetEntityCoords(MasterLua.SelfPlayer.ped, coords.x, coords.y, coords.z)
    else
        ESX.Game.Teleport(PlayerPedId(), coords)
    end
end)

RegisterNetEvent('MasterLua:spawnVehicle')
AddEventHandler('MasterLua:spawnVehicle', function(model)
    if (MasterLua.SelfPlayer.isStaffEnabled) then
        model = (type(model) == 'number' and model or GetHashKey(model))

        if IsModelInCdimage(model) then
            local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed)

            ESX.Game.SpawnVehicle(model, plyCoords, 90.0, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)
        else
            Visual.Subtitle('Invalid vehicle model.', 5000)
        end
    end
end)

local disPlayerNames = 5
local playerDistances = {}

local function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0 * scale, 0.55 * scale)
        else
            SetTextScale(0.0 * scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    Wait(500)
    while true do
        if (MasterLua.SelfPlayer.isGamerTagEnabled) then
            for _, id in ipairs(GetActivePlayers()) do

                if playerDistances[id] then
                    if (playerDistances[id] < disPlayerNames) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        if NetworkIsPlayerTalking(id) then
                       --     DrawText3D(x2, y2, z2 + 1, GetPlayerServerId(id), 247, 124, 24)
                            DrawMarker(27, x2, y2, z2 - 0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)

                        end
                    elseif (playerDistances[id] < 25) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        if NetworkIsPlayerTalking(id) then
                            DrawMarker(27, x2, y2, z2 - 0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if (MasterLua.SelfPlayer.isGamerTagEnabled) then
            for _, id in ipairs(GetActivePlayers()) do

                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                distance = math.floor(#(vector3(x1, y1, z1) - vector3(x2, y2, z2)))
                playerDistances[id] = distance
            end
        end
        Citizen.Wait(1000)
    end
end)