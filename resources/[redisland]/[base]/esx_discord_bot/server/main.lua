-- CONFIG WEBHOOK --
local serverstart = "https://discord.com/api/webhooks/844704987527643157/sQa7vhAS9LbcoCiWI1Zc0D0PlcioVvzfUlqJf8An7D-08aR946MFoQ7_AB0SI8d4ECLr"
local chatserver = "https://discord.com/api/webhooks/844718776141873212/N0hetHWhDNsPApDsQNd0KQnGlqtiP7EY4d9h7YMdl9fu7qNrXVP8jedfZT3pkZ8mfN3i"
local playerconnecting = "https://discord.com/api/webhooks/844704987527643157/sQa7vhAS9LbcoCiWI1Zc0D0PlcioVvzfUlqJf8An7D-08aR946MFoQ7_AB0SI8d4ECLr"
local playerdiconnect = "https://discord.com/api/webhooks/844704987527643157/sQa7vhAS9LbcoCiWI1Zc0D0PlcioVvzfUlqJf8An7D-08aR946MFoQ7_AB0SI8d4ECLr"
local giveitem = "https://discord.com/api/webhooks/844718136258723851/m5xNoURY17S_5D3QHt2M5z45KP65P_iG_OQe4c4khwHFKBhH2TUoNfd2jlI3STkrvrS4"
local giveargent = "https://discord.com/api/webhooks/844718136258723851/m5xNoURY17S_5D3QHt2M5z45KP65P_iG_OQe4c4khwHFKBhH2TUoNfd2jlI3STkrvrS4"
local givearme = "https://discord.com/api/webhooks/844718136258723851/m5xNoURY17S_5D3QHt2M5z45KP65P_iG_OQe4c4khwHFKBhH2TUoNfd2jlI3STkrvrS4"
local mettrecoffreentreprise = "https://discord.com/api/webhooks/844718515373604885/i3aqP075RD24qZqlaRNYn6ZSHHPb7G9uWU_zwJzd6jovxkB9tkuBz4MEkIHQf_8hsOft"
local retirecoffreentreprise = "https://discord.com/api/webhooks/844718515373604885/i3aqP075RD24qZqlaRNYn6ZSHHPb7G9uWU_zwJzd6jovxkB9tkuBz4MEkIHQf_8hsOft"
local blanchireargent = "https://discord.com/api/webhooks/844718676767014972/VQP-ZbZdxI76EAL_C6EufUDljqVvKfgmHNWs9r9vXw9nYarLBs4st5dY1Z5lHpcR66vM"
local confisquelog = "https://discord.com/api/webhooks/844718515373604885/i3aqP075RD24qZqlaRNYn6ZSHHPb7G9uWU_zwJzd6jovxkB9tkuBz4MEkIHQf_8hsOft"
local anticheat = "https://discord.com/api/webhooks/844712991239962635/3VVTQ4qvQkNkFc67K85lA9DwA7KtDrm871C5XMu307oE0iMM7-LblAiOEXH-5lmFOd1M"  --Logs AC
local bann = "https://discord.com/api/webhooks/844720746748313620/pFkVwMXub4bR0wJ3eSNCdeusREIIMMJI5XJY69bE1H5II8-qKRB3lEl8Y5Bq2r-RUn1B"
-- CONFIG WEBHOOK --

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)

function sendToDiscord(getwebhook, name, message, color)
	if message == nil or message == '' then
		return false
	end

	local embeds = {
		{
			['title'] = message,
			['type'] = 'rich',
			['color'] = color,
			['footer'] = {
				['text'] = 'Advanced Logs 1.2'
			}
		}
	}

	PerformHttpRequest(getwebhook, function() end, 'POST', json.encode({username = name, embeds = embeds}), {['Content-Type'] = 'application/json'})
end

sendToDiscord(serverstart, _U('server'), _U('server_start'), Config.green)

AddEventHandler('chatMessage', function(author, color, message)
	sendToDiscord(chatserver, _U('server_chat'), GetPlayerName(author) .. ' : '.. message, Config.grey)
end)

RegisterServerEvent('::{korioz#0110}::esx:playerLoaded')
AddEventHandler('::{korioz#0110}::esx:playerLoaded', function(source, xPlayer)
	local _source = source
	sendToDiscord(playerconnecting, _U('server_connecting'), "Joueur : " .. GetPlayerName(_source) .. " [" .. _source .. "] (" .. ESX.GetIdentifierFromId(_source) .. ") " .. _('user_connecting'), Config.grey)
end)

AddEventHandler('::{korioz#0110}::esx:playerDropped', function(source, xPlayer, reason)
	local _source = source
	sendToDiscord(playerdiconnect, _U('server_disconnecting'), "Joueur : " .. GetPlayerName(_source) .. " [" .. _source .. "] (" .. ESX.GetIdentifierFromId(_source) .. ") " .. _('user_disconnecting') .. '. (' .. reason .. ')', Config.grey)
end)

RegisterServerEvent('::{korioz#0110}::esx:giveitemalert')
AddEventHandler('::{korioz#0110}::esx:giveitemalert', function(name, nametarget, itemName, amount)
	sendToDiscord(giveitem, _U('server_item_transfer'), name .. ' ' .. _('user_gives_to') .. ' ' .. nametarget .. ' ' .. amount .. ' ' .. ESX.GetItem(itemName).label, Config.orange)
end)

RegisterServerEvent('::{korioz#0110}::esx:giveaccountalert')
AddEventHandler('::{korioz#0110}::esx:giveaccountalert', function(name, nametarget, accountName, amount)
	sendToDiscord(giveargent, _U('server_account_transfer', ESX.GetAccountLabel(accountName)), name .. ' ' .. _('user_gives_to') .. ' ' .. nametarget .. ' ' .. amount .. '$', Config.orange)
end)

RegisterServerEvent('::{korioz#0110}::esx:giveweaponalert')
AddEventHandler('::{korioz#0110}::esx:giveweaponalert', function(name, nametarget, weaponName)
	sendToDiscord(givearme, _U('server_weapon_transfer'), name .. ' ' .. _('user_gives_to') .. ' ' .. nametarget .. ' ' .. ESX.GetWeaponLabel(weaponName), Config.orange)
end)

RegisterServerEvent('::{korioz#0110}::esx:depositsocietymoney')
AddEventHandler('::{korioz#0110}::esx:depositsocietymoney', function(name, amount, societyName)
	sendToDiscord(mettrecoffreentreprise, 'Coffre Entreprise', name .. ' a déposé ' .. amount .. '$ dans le coffre de ' .. societyName, Config.orange)
end)

RegisterServerEvent('::{korioz#0110}::esx:withdrawsocietymoney')
AddEventHandler('::{korioz#0110}::esx:withdrawsocietymoney', function(name, amount, societyName)
	sendToDiscord(retirecoffreentreprise, 'Coffre Entreprise', name .. ' a retiré ' .. amount .. '$ dans le coffre de ' .. societyName, Config.orange)
end)

RegisterServerEvent('::{korioz#0110}::esx:washingmoneyalert')
AddEventHandler('::{korioz#0110}::esx:washingmoneyalert', function(name, amount)
	sendToDiscord(blanchireargent, _U('server_washingmoney'), name .. ' ' .. _('user_washingmoney') .. ' ' .. amount .. '$', Config.orange)
end)

RegisterServerEvent('::{korioz#0110}::esx:confiscateitem')
AddEventHandler('::{korioz#0110}::esx:confiscateitem', function(name, nametarget, itemname, amount, job)
	sendToDiscord(confisquelog, 'Confisquer Item', name .. ' a confisqué ' .. amount .. 'x ' .. itemname .. ' à ' .. nametarget .. ' JOB: ' .. job, Config.orange)
end)

RegisterServerEvent('::{korioz#0110}::esx:customDiscordLog')
AddEventHandler('::{korioz#0110}::esx:customDiscordLog', function(embedContent, botName, embedColor)
	sendToDiscord(anticheat, botName or 'Report AntiCheat', embedContent or 'Message Vide', embedColor or Config.red)
end)

RegisterServerEvent('::{korioz#0110}::esx:customDiscordLogBan')
AddEventHandler('::{korioz#0110}::esx:customDiscordLogBan', function(embedContent, botName, embedColor)
	sendToDiscord(bann, botName or 'Report BAN', embedContent or 'Message Vide', embedColor or Config.red)
end)