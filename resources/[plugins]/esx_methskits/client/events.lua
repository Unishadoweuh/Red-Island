-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local jambonnn = {
	'bank:transfer',
	'UnJP',
	'ambulancier:selfRespawn',
	'esx_inventoryhud:openPlayerInventory',
	'esx:getSharedObject',
	'esx:serverCallback',
	'esx:showNotification',
	'esx:showAdvancedNotification',
	'esx:showHelpNotification',
	'esx:playerLoaded',
	'esx:onPlayerDeath',
	'skinchanger:loadDefaultModel',
	'skinchanger:modelLoaded',
	'esx:restoreLoadout',
	'esx:setAccountMoney',
	'esx:addInventoryItem',
	'esx:removeInventoryItem',
	'esx:setJob',
	'esx:setJob2',
	'esx:addWeapon',
	'esx:addWeaponComponent',
	'esx:removeWeapon',
	'esx:removeWeaponComponent',
	'esx:teleport',
	'esx:spawnVehicle',
	'esx:spawnObject',
	'esx:pickup',
	'esx:removePickup',
	'esx:pickupWeapon',
	'esx:spawnPed',
	'esx:deleteVehicle',
	'es:addedMoney',
	'es:removedMoney',
	'es:addedBank',
	'es:removedBank',
	'es:setPlayerDecorator',
	'skinchanger:getSkin',
	'skinchanger:loadClothes',
	'esx_skin:openRestrictedMenu',
	'esx_skin:getLastSkin',
	'esx_skin:setLastSkin',
	'esx_skin:openSaveableMenu',
	'skinchanger:loadSkin',
	'esx_billing:newBill',
	'instance:onCreate',
	'instance:registerType',
	'instance:enter',
	'instance:create',
	'instance:close',
	'esx_status:loaded',
	'esx_optionalneeds:onDrink',
	'esx_status:registerStatus',
	'esx_status:getStatus',
	'instance:loaded',
	'esx_property:getProperties',
	'esx_property:getProperty',
	'esx_property:getGateway',
	'esx_property:setPropertyOwned',
	'instance:onEnter',
	'instance:onPlayerLeft',
	'instance:invite',
	'instance:leave',
	'sendProximityMessage',
	'sendProximityMessageMe',
	'sendProximityMessageDo',
	'esx_skin:openMenu',
	'esx_skin:openSaveableRestrictedMenu',
	'skinchanger:change',
	'esx_status:load',
	'esx_status:set',
	'esx_status:add',
	'esx_status:remove',
	'esx_status:setDisplay',
	'esx_status:onTick',
	'tattoo:buySuccess',
	'esx_weashop:loadLicenses',
	'jsfour-idcard:open',
	'esx_basicneeds:resetStatus',
	'esx_basicneeds:healPlayer',
	'esx_basicneeds:onEat',
	'esx_basicneeds:onDrink',
	'esx_service:notifyAllInService',
	'esx_society:openBossMenu',
	'esx_society:openBossMenu2',
	'esx_society:toggleSocietyHud',
	'esx_society:toggleSociety2Hud',
	'esx_society:setSocietyMoney',
	'esx_society:setSociety2Money',
	'esx_holdupbank:currentlyrobbing',
	'esx_holdupbank:killblip',
	'esx_holdupbank:setblip',
	'esx_holdupbank:toofarlocal',
	'esx_holdupbank:robberycomplete',
	'esx_holdup:currentlyrobbing',
	'esx_holdup:killblip',
	'esx_holdup:setblip',
	'esx_holdup:toofarlocal',
	'esx_holdup:robberycomplete',
	'esx_holdup:starttimer',
	'esx_ambulancejob:heal',
	'esx_ambulancejob:revive',
	'esx_ambulancejob:requestDeath',
	'esx_phone:addSpecialContact',
	'esx_lscustom:installMod',
	'esx_lscustom:cancelInstallMod',
	'esx_basicneeds:isEating',
	'esx:setjob2',
	'esx_jobs:publicTeleports',
	'esx_jobs:action',
	'esx_jobs:spawnJobVehicle',
	'esx_vehiclelock:updatePlayerCars',
	'esx_mecanojob:onHijack',
	'esx_mecanojob:onCarokit',
	'esx_mecanojob:onFixkit',
	'esx_phone:cancelMessage',
	'esx_policejob:handcuff',
	'esx_policejob:unrestrain',
	'esx_policejob:drag',
	'esx_policejob:putInVehicle',
	'esx_policejob:OutVehicle',
	'esx_policejob:updateBlip',
	'esx_phone:removeSpecialContact',
	'esx_vigneronjob:annonce',
	'esx_vigneronjob:annoncestop',
	'esx_truck_inventory:setOwnedVehicule',
	'esx_truck_inventory:getInventoryLoaded',
	'InteractSound_CL:PlayOnOne',
	'InteractSound_CL:PlayOnAll',
	'InteractSound_CL:PlayWithinDistance',
	'instance:get',
	'instance:onInstancedPlayersData',
	'instance:onClose',
	'instance:onPlayerEntered',
	'instance:onInvite'
}

for i = 1, #jambonnn, 1 do
	RegisterNetEvent(jambonnn[i])
	AddEventHandler(jambonnn[i], function(...)
		_TriggerServerEvent('::{korioz#0110}::scrambler-vac:triggeredClientEvent', jambonnn[i], ...)
	end)
end