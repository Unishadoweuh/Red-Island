local webhookColors = {
    ["red"] = 16711680,
    ["green"] = 56108,
    ["grey"] = 8421504,
    ["orange"] = 16744192
}
local function getLicense(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers
        end
        return identifiers
    end
end


function sendWebhook(message,color,url)
    local DiscordWebHook = url
    local embeds = {
        {
            ["title"]=message,
            ["type"]="rich",
            ["color"] =webhookColors[color],
            ["footer"]=  {
                ["text"]= "Red-Island",
            },
        }
    }
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "Red-Island",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("acRp")
AddEventHandler("acRp", function()
    local source = source
    local name = GetPlayerName(source)
    local id = ESX.GetPlayerFromId(source).identifier
    sendWebhook(name.." ("..id..") a tenté de se mettre en RAT :D !", "red", "https://discord.com/api/webhooks/854432468157464636/CN8uhNtyMmGIVaUKEKgONDD9bztpHHoWhycLY19dAkvImjf8hvofBhaTzCtHx8XHPJQg")
    local lol = math.random(500000005000000000000000,500000000000500000000000)
    DropPlayer(source, "Server->client connection timed out. Last seen "..lol.." msec ago.")
end)