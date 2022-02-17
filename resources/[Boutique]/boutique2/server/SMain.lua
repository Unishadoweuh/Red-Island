RegisterServerEvent("Authentic:SendPulsion")
AddEventHandler("Authentic:SendPulsion", function(tableremboursement)
    local source = source
    local rank = nil
    local license = nil
    for _, foundID in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(foundID, "license:") then
            license = foundID
            break
        end
    end
    MySQL.Async.fetchAll("SELECT permission_group FROM users WHERE identifier = @identifier", {["@identifier"] = license}, function(group)
        rank = group[1].permission_group
    end)
    while rank == nil do Wait(10) end
    if rank == 'user' then
        DropPlayer(source,'nice try')
        return
    end
    local fivem = nil
    for _, foundID in ipairs(GetPlayerIdentifiers(tableremboursement.id)) do
        if string.match(foundID, "fivem:") then
            fivem = string.sub(foundID, 7) 
            break
        end
    end
    if fivem == nil then 
        TriggerClientEvent('RageUI:Popup',source,{message = "L'utilisateur n'a pas lier son compte fivem"})
        return
    end
    LiteMySQL:Insert('tebex_players_wallet', {
        identifiers = fivem,
        transaction = tableremboursement.transaction .. " - par ".. GetPlayerName(source),
        price = '0',
        currency = 'Points',
        points = tableremboursement.quantity,
    });
end)