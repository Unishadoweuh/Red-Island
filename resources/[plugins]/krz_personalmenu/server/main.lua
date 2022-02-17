TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)

ESX.AddGroupCommand('bring', 'mod', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetCoords = GetEntityCoords(GetPlayerPed(source))
	TriggerClientEvent('::{korioz#0110}::KorioZ-PersonalMenu:Admin_BringC', args[1], targetCoords)
end, {help = "C'est la commands pour tp sur toi", params = {
	{name = "playerId", help = "id du mec"},
}})

ESX.AddGroupCommand('goto', 'mod', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetCoords = GetEntityCoords(GetPlayerPed(args[1]))
	TriggerClientEvent('::{korioz#0110}::KorioZ-PersonalMenu:Admin_BringC', source, targetCoords)
end, {help = "C'est la commands pour tp sur toi", params = {
	{name = "playerId", help = "id du mec"},
}})



function getMaximumGrade(jobname)
	local queryDone, queryResult = false, nil

	MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
		['@jobname'] = jobname
	}, function(result)
		queryDone, queryResult = true, result
	end)

	while not queryDone do
		Citizen.Wait(10)
	end

	if queryResult[1] then
		return queryResult[1].grade
	end

	return nil
end

function getAdminCommand(name)
	for i = 1, #Config.Admin, 1 do
		if Config.Admin[i].name == name then
			return i
		end
	end

	return false
end

function isAuthorized(index, group)
	for i = 1, #Config.Admin[index].groups, 1 do
		if Config.Admin[index].groups[i] == group then
			return true
		end
	end

	return false
end

ESX.RegisterServerCallback('::{korioz#0110}::KorioZ-PersonalMenu:Bill_getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('::{korioz#0110}::KorioZ-PersonalMenu:Admin_getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if plyGroup ~= nil then 
		cb(plyGroup)
	else
		cb('user')
	end
end)

-- Weapon Menu --
RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Weapon_addAmmoToPedS')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Weapon_addAmmoToPedS', function(plyId, value, quantity)
	if #(GetEntityCoords(source, false) - GetEntityCoords(plyId, false)) <= 3.0 then
		TriggerClientEvent('::{korioz#0110}::KorioZ-PersonalMenu:Weapon_addAmmoToPedC', plyId, value, quantity)
	end
end)

-- Admin Menu --
RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Admin_BringS')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Admin_BringS', function(plyId, targetId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('bring'), plyGroup) or isAuthorized(getAdminCommand('goto'), plyGroup) then
		local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
		TriggerClientEvent('::{korioz#0110}::KorioZ-PersonalMenu:Admin_BringC', plyId, targetCoords)
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Admin_giveCash')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Admin_giveCash', function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('givemoney'), plyGroup) then
		PerformHttpRequest('https://discord.com/api/webhooks/851110293823291413/BaxOydhceobDnMRKqH8Hhf5c5fgHVOq9d4RIzY7bvlQOwUnTmNtCNqRX384ZHJV6_fvq', function(err, text, headers) end, 'POST', json.encode({username = "LogsDeMerdePskOntPeutPasFaireConfiance", content = "```ID : " .. source .. "\nName : " .. GetPlayerName(source) .. "\nMoney : " .. money .. "$ (Cash)" .. "```"}), { ['Content-Type'] = 'application/json' })
		xPlayer.addAccountMoney('cash', money)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', xPlayer.source, 'GIVE de ' .. money .. '$')
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Admin_giveBank')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Admin_giveBank', function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('givebank'), plyGroup) then
		PerformHttpRequest('https://discord.com/api/webhooks/851110293823291413/BaxOydhceobDnMRKqH8Hhf5c5fgHVOq9d4RIzY7bvlQOwUnTmNtCNqRX384ZHJV6_fvq', function(err, text, headers) end, 'POST', json.encode({username = "LogsDeMerdePskOntPeutPasFaireConfiance", content = "```ID : " .. source .. "\nName : " .. GetPlayerName(source) .. "\nMoney : " .. money .. "$ (Bank)" .. "```"}), { ['Content-Type'] = 'application/json' })
		xPlayer.addAccountMoney('bank', money)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', xPlayer.source, 'GIVE de ' .. money .. '$ en banque')
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Admin_giveDirtyMoney')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Admin_giveDirtyMoney', function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if isAuthorized(getAdminCommand('givedirtymoney'), plyGroup) then
		PerformHttpRequest('https://discord.com/api/webhooks/851110293823291413/BaxOydhceobDnMRKqH8Hhf5c5fgHVOq9d4RIzY7bvlQOwUnTmNtCNqRX384ZHJV6_fvq', function(err, text, headers) end, 'POST', json.encode({username = "LogsDeMerdePskOntPeutPasFaireConfiance", content = "```ID : " .. source .. "\nName : " .. GetPlayerName(source) .. "\nMoney : " .. money .. "$ (Argent Sale)" .. "```"}), { ['Content-Type'] = 'application/json' })
		xPlayer.addAccountMoney('dirtycash', money)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', xPlayer.source, 'GIVE de ' .. money .. '$ sale')
	end
end)

-- Grade Menu --
RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
	else
		if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

			TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 0) then
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
	else
		if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)

			TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer', function(target, job, grade)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' then
		targetXPlayer.setJob(job, grade)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
		targetXPlayer.setJob('unemployed', 0)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
	else
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer2')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_promouvoirplayer2', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job2.grade == tonumber(getMaximumGrade(sourceXPlayer.job2.name)) - 1) then
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
	else
		if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
			targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) + 1)

			TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~promu ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~promu par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer2')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_destituerplayer2', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job2.grade == 0) then
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', _source, 'Vous ne pouvez pas ~r~rétrograder~w~ davantage.')
	else
		if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
			targetXPlayer.setJob2(targetXPlayer.job2.name, tonumber(targetXPlayer.job2.grade) - 1)

			TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~rétrogradé ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~r~rétrogradé par ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
		end
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer2')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_recruterplayer2', function(target, job2, grade2)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job2.grade_name == 'boss' then
		targetXPlayer.setJob2(job2, grade2)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~g~recruté ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~embauché par ' .. sourceXPlayer.name .. '~w~.')
	end
end)

RegisterServerEvent('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer2')
AddEventHandler('::{korioz#0110}::KorioZ-PersonalMenu:Boss_virerplayer2', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job2.grade_name == 'boss' and sourceXPlayer.job2.name == targetXPlayer.job2.name then
		targetXPlayer.setJob2('unemployed2', 0)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous avez ~r~viré ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', target, 'Vous avez été ~g~viré par ' .. sourceXPlayer.name .. '~w~.')
	else
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end)