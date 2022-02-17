--[[ Main ]]--
local textscreens = {
	{
		coords = vector3(392.41, -355.85, 47.96),
		text = "~o~Bienvenue~s~ sur ~r~".. GetConvar("servername", "Magic Collective") .."~s~ !\nPassez un ~g~agréable~s~ moment parmi nous !",
		size = 0.7,
		font = 0,
		maxDistance = 10
	},
	{
		coords = vector3(389.91, -356.1, 49.02),
		text = "Votre personnage n'as pas été créer correctement ?\nAlors faites ~b~/register~s~ dans le chat ~b~[T]~s~",
		size = 0.7,
		font = 0,
		maxDistance = 10
	},
	{
		coords = vector3(398.6, -106.81, 28.99),
		text = "Noublie pas de rejoindre notre discord !\n~b~".. GetConvar("discordinvite", "Magic Collective") .."~s~",
		size = 0.7,
		font = 0,
		maxDistance = 10
	},
	{
		coords = vector3(396.88, -370.33, 47.77),
		text = "~b~RECRUTEMENT ~b~STAFF ~b~ON\ndiscord.gg/redisland",
		size = 0.7,
		font = 0,
		maxDistance = 10

	}
}

AddEventHandler('korioz:init', function()
	Citizen.CreateThread(function()
		while true do
			local PlayerCoords = LocalPlayer().Coords

			for i = 1, #textscreens, 1 do
				if #(PlayerCoords - textscreens[i].coords) < textscreens[i].maxDistance then
					ESX.Game.Utils.DrawText3D(textscreens[i].coords, textscreens[i].text, textscreens[i].size, textscreens[i].font)
				end
			end

			Citizen.Wait(0)
		end
	end)
end)