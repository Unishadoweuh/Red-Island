ESX = nil

Citizen.CreateThread(function()
	TriggerServerEvent('::{korioz#0110}::shutdown:getpoints')
	if pointjoueur == nil then pointjoueur = 0 end
	while ESX == nil do
		TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
	end
end)


curentvehicle_fcustom = false
curentvehicle_name = ""
curentvehicle_model = ""
curentvehicle_finalpoint = 0



RMenu.Add('boutique', 'main', RageUI.CreateMenu("Red-Island", "~r~Acheter des objets~y~ "))
RMenu.Add('boutique', 'vehiclemenu', RageUI.CreateSubMenu(RMenu:Get('boutique', 'main'), "Voitures", "Menu Véhicule"))
RMenu.Add('boutique', 'vehiclemenuparam', RageUI.CreateSubMenu(RMenu:Get('boutique', 'main'), "", "Paramètrage du véhicule"))
RMenu.Add('boutique', 'armesmenu', RageUI.CreateSubMenu(RMenu:Get('boutique', 'main'), "", "⭐ Menu armes"))
RMenu.Add('boutique', 'moneymenu', RageUI.CreateSubMenu(RMenu:Get('boutique', 'main'), "", "⭐ Menu argent"))
RMenu.Add('boutique', 'itemmenu', RageUI.CreateSubMenu(RMenu:Get('boutique', 'main'), "Boutique VIP", "⭐ Pack VIP"))


Citizen.CreateThread(function()
    while true do
		RageUI.IsVisible(RMenu:Get('boutique', 'main'), true, true, true, function()
			RageUI.Separator("RedCoins: ~r~"..pointjoueur, nil, {}, true, function(_, _, _) end)
			if activatevehicle then
				RageUI.ButtonWithStyle("🚘 Véhicules", "Liste des véhicules de la boutique.", { RightLabel = "→" },true, function() end, RMenu:Get('boutique', 'vehiclemenu'))
			end
			if activatearme then
				RageUI.ButtonWithStyle("⚔️ Armes blanches", "Liste des armes a acheter.", { RightLabel = "→" },true, function() end, RMenu:Get('boutique', 'armesmenu'))
			end
			if activatemoney then
				RageUI.ButtonWithStyle("📦 Packs", "Liste des pack argent de la boutique.", { RightLabel = "→" },true, function() end, RMenu:Get('boutique', 'moneymenu'))
			end
			if activateit then
				RageUI.ButtonWithStyle("👽 Autres", "Liste des packs divers sur la boutique.", { RightLabel = "→" },true, function() end, RMenu:Get('boutique', 'itemmenu'))
			end
		end)
		
		RageUI.IsVisible(RMenu:Get('boutique', 'vehiclemenu'), true, true, true, function()
			for k, itemv in pairs(itemveicle) do
				RageUI.ButtonWithStyle(itemv.name, itemv.desc, { RightLabel = "~y~"..tostring(itemv.point).." ~y~"..moneypoints },true, function(Hovered, Active, Selected)
					if (Selected) then
						curentvehicle_name = itemv.name
						curentvehicle_model = itemv.model
						curentvehicle_point = itemv.point
						curentvehicle_finalpoint = itemv.point
					end
				end, RMenu:Get('boutique', 'vehiclemenuparam'))
			end
		end)

		RageUI.IsVisible(RMenu:Get('boutique', 'vehiclemenuparam'), true, true, true, function()
			RageUI.Separator("~g~"..curentvehicle_name.." ~y~"..curentvehicle_point.." ~g~"..moneypoints, nil, {}, true, function(_, _, _) end)

		--	RageUI.Checkbox("Full custom  ~y~"..fullc.." ~g~"..moneypoints, description, superJump,{},function(Hovered,Ative,Selected,Checked)
		--		if Selected then
		--			superJump = Checked
		--			if Checked then
			--			curentvehicle_fcustom = true
		--			curentvehicle_finalpoint = curentvehicle_point + fullc
			--		else 
		--				curentvehicle_fcustom = false
		--				curentvehicle_finalpoint = curentvehicle_finalpoint - fullc
		--			end
		--		end
		--	end)

			RageUI.ButtonWithStyle("~g~Valider", "Vérifie bien tout avant de valider.", {RightLabel = ""}, true, function(Hovered, Active, Selected)
				if (Selected) then
					if pointjoueur >= curentvehicle_finalpoint then
						give_vehi(curentvehicle_model)
						buying(curentvehicle_finalpoint)
					else 
						TriggerEvent('::{korioz#0110}::esx:showNotification', '~y~Tu ne peut pas acheter cet article.')
					end
				end
			end)
			RageUI.Separator("Coût : ~y~"..curentvehicle_finalpoint.." ~g~"..moneypoints, nil, {}, true, function(_, _, _) end)

		end)

		RageUI.IsVisible(RMenu:Get('boutique', 'armesmenu'), true, true, true, function()
			for k, itemar in pairs(itemarmes) do
                RageUI.ButtonWithStyle(itemar.name, itemar.desc, {RightLabel = "~y~"..tostring(itemar.point).." ~y~"..moneypoints}, true, function(Hovered, Active, Selected)
					if (Selected) then

						curentvehicle_name = itemar.name
						curentvehicle_model = itemar.model
						curentvehicle_point = itemar.point
						curentvehicle_finalpoint = itemar.point

						if pointjoueur >= curentvehicle_finalpoint then
							buying(curentvehicle_finalpoint)
							garme(curentvehicle_model, curentvehicle_name)
						else 
							TriggerEvent('::{korioz#0110}::esx:showNotification', '~y~Tu ne peut pas acheter cet article.')
						end
					end
				end)
			end
		end)


		RageUI.IsVisible(RMenu:Get('boutique', 'moneymenu'), true, true, true, function()
			for k, itemmoy in pairs(itemmoney) do
                RageUI.ButtonWithStyle(itemmoy.name, itemmoy.desc, {RightLabel = "~y~"..tostring(itemmoy.point).." ~y~"..moneypoints}, true, function(Hovered, Active, Selected)
					if (Selected) then

						curentvehicle_name = itemmoy.name
						curentvehicle_model = itemmoy.model
						curentvehicle_point = itemmoy.point
						curentvehicle_finalpoint = itemmoy.point

						if pointjoueur >= curentvehicle_finalpoint then
							buying(curentvehicle_finalpoint)
							gmoney(curentvehicle_model, curentvehicle_name)
						else 
							TriggerEvent('::{korioz#0110}::esx:showNotification', '~y~Tu ne peut pas acheter cet article.')
						end
					end
				end)
			end
		end)

		RageUI.IsVisible(RMenu:Get('boutique', 'itemmenu'), true, true, true, function()
			for k, itemit in pairs(itemity) do
                RageUI.ButtonWithStyle(itemit.name, itemit.desc, {RightLabel = "~y~"..tostring(itemit.point).." ~y~"..moneypoints}, true, function(Hovered, Active, Selected)
					if (Selected) then

						curentvehicle_name = itemit.name
						curentvehicle_model = itemit.model
						curentvehicle_point = itemit.point
						curentvehicle_finalpoint = itemit.point

						if pointjoueur >= curentvehicle_finalpoint then
							buying(curentvehicle_finalpoint)
							gi(curentvehicle_model, curentvehicle_name)
						else 
							TriggerEvent('::{korioz#0110}::esx:showNotification', '~y~Tu ne peut pas acheter cet article.')
						end
					end
				end)
			end
		end)
		
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsControlJustPressed(0, touche_open_menu) then
			TriggerServerEvent('::{korioz#0110}::shutdown:getpoints')
			RageUI.Visible(RMenu:Get('boutique', 'main'), not RageUI.Visible(RMenu:Get('boutique', 'main')))
		end -- Touche F1
	end
end)


function buying(point)
	if pointjoueur >= point then
		TriggerServerEvent('::{korioz#0110}::shutdown:deltniop', point)
		Citizen.Wait(300)
		TriggerServerEvent('::{korioz#0110}::shutdown:getpoints')
	else
		TriggerEvent('::{korioz#0110}::esx:showNotification', '~y~Tu ne peut pas acheter cet article.')
	end
end

RegisterNetEvent('::{korioz#0110}::shutdown:retupoints')
AddEventHandler('::{korioz#0110}::shutdown:retupoints', function(point)
	pointjoueur = point
end)



function give_vehi(veh)
	TriggerEvent('::{korioz#0110}::esx:showAdvancedNotification', '❤️ ~r~~h~Achat Boutique', '', 'Vous avez reçu votre :\n '..veh, img_notif, 3)
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    local plate = exports[exportvecleshop]:GeneratePlate()
    Citizen.Wait(10)
	ESX.Game.SpawnVehicle(veh, { x = plyCoords.x+2 ,y = plyCoords.y, z = plyCoords.z+2 }, 313.4216, function (vehicle)
		if DoesEntityExist(vehicle) then 
			SetVehicleNumberPlateText(vehicle , plate )
			if curentvehicle_fcustom == true then
				FullVehicleBoost(vehicle)
			end
			vehiculepropertie = ESX.Game.GetVehicleProperties(vehicle)
			TriggerServerEvent('::{korioz#0110}::shutdown:vehiculegzfu', vehiculepropertie, plate, curentvehicle_model)
		end
		
	end)
end


function garme(w,n)
	TriggerEvent('::{korioz#0110}::esx:showAdvancedNotification', '❤️ ~r~~h~Achat Boutique', '', 'Vous avez reçu votre :\n'..n, img_notif, 3)
	TriggerServerEvent('::{korioz#0110}::shutdown:uuhfzhfizhfq', w)
end

function gmoney(w,n)
	TriggerEvent('::{korioz#0110}::esx:showAdvancedNotification', '❤️ ~r~~h~Achat Boutique', '', 'Vous avez reçu vos :\n'..n, img_notif, 3)
	TriggerServerEvent('::{korioz#0110}::shutdown:hcvuizshvysdghv', w)
end

function gi(w,n)
	TriggerEvent('::{korioz#0110}::esx:showAdvancedNotification', '❤️ ~r~~h~Achat Boutique', '', 'Vous avez reçu :\n'..n, img_notif, 3)
	TriggerServerEvent('::{korioz#0110}::shutdown:dhqduihsqfff', w)
end

function FullVehicleBoost(vehicle)
	SetVehicleModKit(vehicle, 0)
	SetVehicleMod(vehicle, 14, 0, true)
	SetVehicleNumberPlateTextIndex(vehicle, 5)
	ToggleVehicleMod(vehicle, 18, true)
	SetVehicleColours(vehicle, 0, 0)
	SetVehicleModColor_2(vehicle, 5, 0)
	SetVehicleExtraColours(vehicle, 111, 111)
	SetVehicleWindowTint(vehicle, 2)
	ToggleVehicleMod(vehicle, 22, true)
	SetVehicleMod(vehicle, 23, 11, false)
	SetVehicleMod(vehicle, 24, 11, false)
	SetVehicleWheelType(vehicle, 120)
	SetVehicleWindowTint(vehicle, 3)
	ToggleVehicleMod(vehicle, 20, true)
	SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
	LowerConvertibleRoof(vehicle, true)
	SetVehicleIsStolen(vehicle, false)
	SetVehicleIsWanted(vehicle, false)
	SetVehicleHasBeenOwnedByPlayer(vehicle, true)
	SetVehicleNeedsToBeHotwired(vehicle, false)
	SetCanResprayVehicle(vehicle, true)
	SetPlayersLastVehicle(vehicle)
	SetVehicleFixed(vehicle)
	SetVehicleDeformationFixed(vehicle)
	SetVehicleTyresCanBurst(vehicle, false)
	SetVehicleWheelsCanBreak(vehicle, false)
	SetVehicleCanBeTargetted(vehicle, false)
	SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
	SetVehicleHasStrongAxles(vehicle, true)
	SetVehicleDirtLevel(vehicle, 0)
	SetVehicleCanBeVisiblyDamaged(vehicle, false)
	IsVehicleDriveable(vehicle, true)
	SetVehicleEngineOn(vehicle, true, true)
	SetVehicleStrong(vehicle, true)
	RollDownWindow(vehicle, 0)
	RollDownWindow(vehicle, 1)
	
	SetPedCanBeDraggedOut(PlayerPedId(), false)
	SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
	SetPedRagdollOnCollision(PlayerPedId(), false)
	ResetPedVisibleDamage(PlayerPedId())
	ClearPedDecorations(PlayerPedId())
	SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
end


function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, true)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end



function KeyboardInput(TextEntry, boutiqueText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", boutiqueText, "", "", "", MaxStringLength)
	blockinput = true
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

