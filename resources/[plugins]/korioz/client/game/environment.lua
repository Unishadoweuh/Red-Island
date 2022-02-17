--[[ Environment ]]--
-- Time Sync --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local plyPed = PlayerPedId()

		for vehicle in KRZ.Game.EnumerateVehicles() do
			if not IsVehicleSeatFree(vehicle, -1) then
				SetEntityNoCollisionEntity(plyPed, vehicle, true)
				SetEntityNoCollisionEntity(vehicle, plyPed, true)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local _, _, _, hour, minute = GetUtcTime()
		NetworkOverrideClockTime(hour, minute, 0)
		Citizen.Wait(60000)
	end
end)

-- Weather Sync --
--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(1000)
--		SetWeatherTypeNowPersist('EXTRASUNNY')
--	end
--end)

local safeZones = {
	vector3(389.74, -356.19, 48.02), -- spawn
	vector3(213.3, -906.95, 18.32), -- pc
	vector3(429.54, -981.86, 30.71),
	vector3(-38.22, -1100.84, 26.42),
	vector3(295.68, -586.45, 43.14),
	vector3(-211.34, -1322.06, 30.89),
	vector3(234.42, -863.06, 29.86),
	vector3(16.58, -1116.03, 29.79),
	vector3(1642.27, 2570.55, 45.56)
}

local disabledSafeZonesKeys = {
	{group = 2, key = 37, message = '~r~Vous ne pouvez pas sortir d\'arme en SafeZone'},
	{group = 0, key = 24, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 69, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 92, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 106, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 168, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 160, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'},
	{group = 0, key = 160, message = '~r~Vous ne pouvez pas faire ceci en SafeZone'}
}

local notifIn, notifOut = false, false
local closestZone = 1

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local minDistance = 100000

		for i = 1, #safeZones, 1 do
			local dist = #(safeZones[i] - plyCoords)

			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end

		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		local plyPed = PlayerPedId()
		local plyCoords = GetEntityCoords(plyPed, false)
		local dist = #(safeZones[closestZone] - plyCoords)

		if dist <= 50 then
			if not notifIn then
				NetworkSetFriendlyFireOption(false)
				SetCurrentPedWeapon(plyPed, `WEAPON_UNARMED`, true)
				--ESX.ShowNotification('~g~Vous êtes en SafeZone')
				ESX.ShowAdvancedNotification('Red-Island', '~y~Notification', '~g~Vous entrez en safezone ', 'CHAR_CALIFORNIA', 7)

				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
			--	ESX.ShowNotification('~r~Vous sortez de la SafeZone')
			ESX.ShowAdvancedNotification('Red-Island', '~y~Notification', '~r~Vous sortez de safezone ', 'CHAR_CALIFORNIA', 7)


				notifOut = true
				notifIn = false
			end
		end

		if notifIn then
			for vehicle in KRZ.Game.EnumerateVehicles() do
				if not IsVehicleSeatFree(vehicle, -1) then
					SetEntityNoCollisionEntity(plyPed, vehicle, true)
					SetEntityNoCollisionEntity(vehicle, plyPed, true)
				end
			end

			DisablePlayerFiring(player, true)

			for i = 1, #disabledSafeZonesKeys, 1 do
				DisableControlAction(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key, true)

				if IsDisabledControlJustPressed(disabledSafeZonesKeys[i].group, disabledSafeZonesKeys[i].key) then
					SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)

					if disabledSafeZonesKeys[i].message then
						ESX.ShowNotification(disabledSafeZonesKeys[i].message)
					end
				end
			end
		end
	end
end)