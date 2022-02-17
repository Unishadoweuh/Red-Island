--[[ Peds ]]--
local areaCleared = {
	{coords = vector3(1620.0, 1115.0, 80.0), radius = 100.0},
	{coords = vector3(-2480.0, -210.0, 20.0), radius = 100.0}
}

-- Change some GTA Stuff --
Citizen.CreateThread(function()
	SetGarbageTrucks(0)
	SetRandomBoats(0)
	SetRandomTrains(0)
	SetRelationshipBetweenGroups(1, `COP`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `MEDIC`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `FIREMAN`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `GANG_1`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `GANG_2`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `GANG_9`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `GANG_10`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_LOST`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MEXICAN`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_FAMILY`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_BALLAS`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_MARABUNTE`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_CULT`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_SALVA`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_WEICHENG`, `PLAYER`)
	SetRelationshipBetweenGroups(1, `AMBIENT_GANG_HILLBILLY`, `PLAYER`)

	for i = 1, 15 do
		EnableDispatchService(i, false)
	end
end)

AddEventHandler('korioz:init', function()
	Citizen.CreateThread(function()
		local disablePopulation = exports['serverdata']:GetData('disablePopulation')

		while true do
			local PlayerCoords = LocalPlayer().Coords

			if disablePopulation then
				SetPedDensityMultiplierThisFrame(1.0)
				SetParkedVehicleDensityMultiplierThisFrame(1.0)
				SetRandomVehicleDensityMultiplierThisFrame(0.3)
				SetAmbientVehicleRangeMultiplierThisFrame(0.5)
				SetVehicleDensityMultiplierThisFrame(0.5)
				SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- set random npc/ai peds or scenario peds to 0
				SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
				SetRandomBoats(false) -- Stop random boats from spawning in the water.
				SetCreateRandomCops(false) -- disable random cops walking/driving around.
				SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
				SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
			else
				SetPedDensityMultiplierThisFrame(1.0)
				SetParkedVehicleDensityMultiplierThisFrame(1.0)
				SetRandomVehicleDensityMultiplierThisFrame(0.3)
				SetAmbientVehicleRangeMultiplierThisFrame(0.5)
				SetVehicleDensityMultiplierThisFrame(0.5)
				SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) -- set random npc/ai peds or scenario peds to 0
				SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
				SetRandomBoats(false) -- Stop random boats from spawning in the water.
				SetCreateRandomCops(false) -- disable random cops walking/driving around.
				SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
				SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
		
				
				ClearAreaOfCops(PlayerCoords, 500.0, 1000)

				for i = 1, #areaCleared, 1 do
					if #(PlayerCoords - areaCleared[i].coords) < 100 then
						ClearAreaOfVehicles(areaCleared[i].coords, areaCleared[i].radius, false, false, false, false, false)
						ClearAreaOfPeds(areaCleared[i].coords, areaCleared[i].radius, 1)
					end
				end
			end

			RemoveVehiclesFromGeneratorsInArea(PlayerCoords - 5000.0, PlayerCoords + 5000.0)

			Citizen.Wait(0)
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		for ped in KRZ.Game.EnumeratePeds() do
			if not IsEntityDead(ped) then
				SetPedDropsWeaponsWhenDead(ped, false)
			end
		end

		Citizen.Wait(500)
	end
end)