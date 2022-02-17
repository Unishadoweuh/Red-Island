Citizen.CreateThread(function()
    while true do
        -- Replace the functions below with your own ID and asset-names
        -- This is the Application ID (Replace this with you own)
		-- Get from here https://discord.com/developers/applications
		SetDiscordAppId(849750105384026142)

        -- Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('c')

        -- Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('rdl')
       
        -- Here you will have to put the image name for the "small" icon.
        --SetDiscordRichPresenceAssetSmall('logo_name')

        -- Here you can add hover text for the "small" icon.
        --SetDiscordRichPresenceAssetSmallText('This is a lsmall icon with text')
        
        
        -- Amount of online players (Don't touch)
        local playerCount = #GetActivePlayers()

        -- Check for player or players
        if playerCount == 1 then
            player = "Player"
        else
            player = "Players"
        end
        
        -- Your own playername (Don't touch)
        local playerName = GetPlayerName(PlayerId())

        -- Set here the amount of slots you have (Edit if needed)
        local maxPlayerSlots = GetConvarInt('sv_maxclients', 64)

        -- Sets the string with variables as RichPresence (Don't touch)
        SetRichPresence(string.format("%s - %s %s", playerName, playerCount, player))
        
        -- It updates every 30 seconds.
		Citizen.Wait(30000)
	end
end)