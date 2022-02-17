ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end) 

		Citizen.Wait(0) 
	end
end)

RegisterNetEvent('::{korioz#0110}::esx:playerLoaded')
AddEventHandler('::{korioz#0110}::esx:playerLoaded', function(xPlayer)
  	ESX.PlayerData = xPlayer
  	PlayerLoaded = true
end)

RegisterNetEvent('::{korioz#0110}::esx:setJob')
AddEventHandler('::{korioz#0110}::esx:setJob', function(job)
  	ESX.PlayerData.job = job
end)

-- Player status
Citizen.CreateThread(function()
	while true do
		local playerStatus 
		local showPlayerStatus = 0

		playerStatus = { action = 'setStatus', status = {} }

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end
		
		TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj)
			ESX = obj
		end)

		if ESX.PlayerData.job then
			local job
			local blackMoney
			local bank
			local money

			if ESX.PlayerData.job.label == ESX.PlayerData.job.grade_label then
			job = ESX.PlayerData.job.grade_label
			else
			job = ESX.PlayerData.job.label .. ' - ' .. ESX.PlayerData.job.grade_label
			end


			for i=1, #ESX.PlayerData.accounts, 1 do
				if ESX.PlayerData.accounts[i].name == 'dirtycash' then
					blackMoney = ESX.PlayerData.accounts[i].money
				elseif ESX.PlayerData.accounts[i].name == 'bank' then
					bank = ESX.PlayerData.accounts[i].money
				elseif ESX.PlayerData.accounts[i].name == 'cash' then
					money = ESX.PlayerData.accounts[i].money
				end
			end

			SendNUIMessage({ action = 'setText', id = 'job', value = job })
			SendNUIMessage({ action = 'setMoney', id = 'wallet', value = money })
			SendNUIMessage({ action = 'setMoney', id = 'bank', value = bank })
			SendNUIMessage({ action = 'setMoney', id = 'blackMoney', value = blackMoney })

			if ESX.PlayerData.job.grade_name ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
				if (Config.ui.showSocietyMoney == true) then
					SendNUIMessage({ action = 'element', task = 'enable', value = 'society' })
				end
				ESX.TriggerServerCallback('::{korioz#0110}::esx_society:getSocietyMoney', function(money)
					SendNUIMessage({ action = 'setMoney', id = 'society', value = money })
				end, ESX.PlayerData.job.name)
			else
				SendNUIMessage({ action = 'element', task = 'disable', value = 'society' })
			end

		end

		local playerStatus 
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end

		Citizen.Wait(1000)
	end
end)


AddEventHandler('::{korioz#0110}::esx:onPlayerSpawn', function()
	SendNUIMessage({ action = 'ui', config = Config.ui })
	SendNUIMessage({ action = 'setFont', url = Config.font.url, name = Config.font.name })
end)

AddEventHandler('playerSpawned', function()
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(13)
end)

exports('createStatus', function(args)
	local statusCreation = { action = 'createStatus', status = args['status'], color = args['color'], icon = args['icon'] }
	SendNUIMessage(statusCreation)
end)

exports('setStatus', function(args)
	local playerStatus = { action = 'setStatus', status = {
		{ name = args['name'], value = args['value'] }
	}}
	SendNUIMessage(playerStatus)
end)