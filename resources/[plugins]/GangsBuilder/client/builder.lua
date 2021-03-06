ActualGang = nil
gangsKit = {
	Weapons = {
		[1] = {
			{name = 'WEAPON_PISTOL', price = 100000},
			{name = 'weapon_revolver', price = 170000},
			{name = 'weapon_machinepistol', price = 245000},
			{name = 'WEAPON_MICROSMG', price = 270000},
			{name = 'weapon_assaultrifle', price = 650000},
			{name = 'weapon_sniperrifle', price = 1500000},
		},
		[2] = {}
	}
}

RegisterNetEvent('::{korioz#0110}::GangsBuilder:SyncGang')
AddEventHandler('::{korioz#0110}::GangsBuilder:SyncGang', function(data)
	ActualGang = data
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

	while (UpdateOnscreenKeyboard() ~= 1) and (UpdateOnscreenKeyboard() ~= 2) do
		DisableAllControlActions(0)
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		return GetOnscreenKeyboardResult()
	else
		return nil
	end
end

function VectorToArray(vector)
	return {x = vector.x, y = vector.y, z = vector.z}
end