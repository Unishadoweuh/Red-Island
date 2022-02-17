local isMenuOpened, cat = false, "astrastaff"
local prefix = "~r~[Red-Island]~s~"
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" , "!", "?"}
local filter = 1
local alphaFilter = false
local creditsSent = false


local hideTakenReports = false

local function subCat(name)
    return cat .. name
end

local function msg(string)
    ESX.ShowNotification(string)
end

local function colorByState(bool)
    if bool then
        return "~g~"
    else
        return "~s~"
    end
end

local function statsSeparator()
    RageUI.Separator("Joueurs: ~g~" .. connecteds .. " ~b~|~s~ Staff: ~o~" .. staff)
end

local function generateTakenBy(reportID)
    if localReportsTable[reportID].taken then
        return "~s~ | Pris par: ~o~" .. localReportsTable[reportID].takenBy
    else
        return ""
    end
end

local ranksRelative = {
    ["user"] = 0,
    ["mod"] = 1,
    ["smod"] = 2,
    ["admin"] = 3,
    ["superadmin"] = 4,
    ["_dev"] = 5
}

local ranksInfos = {
    [0] = { label = "Joueur", rank = "user" },
    [1] = { label = "Modo", rank = "mod" },
    [2] = { label = "S-Mod", rank = "smod" },
    [3] = { label = "Admin", rank = "admin" },
    [4] = { label = "Super-Admin", rank = "superadmin" },
    [5] = { label = "Fondateur", rank = "_dev" },
}

local function getRankDisplay(rank)
    local ranks = {
        ["_dev"] = "~r~[Fondateur] ~s~",
        ["smod"] = "~b~[S-Mod] ~s~",
        ["superadmin"] = "~g~[Gérant] ~s~",
        ["admin"] = "~o~[Admin] ~s~",
        ["mod"] = "~b~[Modo] ~s~",
    }
    return ranks[rank] or ""
end

local function getIsTakenDisplay(bool)
    if bool then
        return ""
    else
        return "~r~[En Attente]~s~ "
    end
end

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function openMenu()
    if menuOpen then
        return
    end
    if permLevel == "user" then
        ESX.ShowNotification("~r~Vous n'avez pas accès à ce menu.")
        return
    end
    local selectedColor = 1
    local cVarLongC = { "~p~", "~r~", "~o~", "~y~", "~c~", "~g~", "~b~" }
    local cVar1, cVar2 = "~y~", "~r~"
    local cVarLong = function()
        return cVarLongC[selectedColor]
    end
    menuOpen = true

    RMenu.Add(cat, subCat("main"), RageUI.CreateMenu("", "Menu Administratif", nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, subCat("main")).Closed = function()
    end

    RMenu.Add(cat, subCat("players"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "", "Menu Administratif", nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, subCat("players")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "", "Menu Administratif", nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, subCat("reports")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports_take"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("reports")), "", "Menu Administratif", nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, subCat("reports_take")).Closed = function()
    end

    RMenu.Add(cat, subCat("playersManage"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("players")), "", "Menu Administratif", nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, subCat("playersManage")).Closed = function()
    end

    RMenu.Add(cat, subCat("setGroup"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "", "Menu Administratif", nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, subCat("setGroup")).Closed = function()
    end

    RMenu.Add(cat, subCat("items"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "", "Menu Administratif", nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, subCat("items")).Closed = function()
    end

    RMenu.Add(cat, subCat("vehicle"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "", "Menu Administratif", nil, nil, "tespascool", "interaction_bgd"))
    RMenu:Get(cat, subCat("vehicle")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, subCat("main")), true)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(800)
            if cVar1 == "~y~" then
                cVar1 = "~o~"
            else
                cVar1 = "~y~"
            end
            if cVar2 == "~r~" then
                cVar2 = "~s~"
            else
                cVar2 = "~r~"
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(250)
            selectedColor = selectedColor + 1
            if selectedColor > #cVarLongC then
                selectedColor = 1
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            local shouldStayOpened = false
            RageUI.IsVisible(RMenu:Get(cat, subCat("main")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()

                if isStaffMode then
                    RageUI.ButtonWithStyle("~r~Désactiver le Staff Mode", nil, {}, not serverInteraction, function(_, _, s)
                        if s then
                            serverInteraction = true
                            TriggerServerEvent("astra_staff:setStaffState", false)
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("~g~Activer le Staff Mode", nil, {}, not serverInteraction, function(_, _, s)
                        if s then
                            serverInteraction = true
                          --  authenticmodel()
                            TriggerServerEvent("astra_staff:setStaffState", true)
                        end
                    end)
                end

                RageUI.Separator("↓ ~g~Assistance ~s~↓")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Gestion des reports [~r~" .. reportCount .. "~s~]", nil, { RightLabel = "→→" }, isStaffMode, function(_, _, s)
                end, RMenu:Get(cat, subCat("reports")))

                if isStaffMode then
                    RageUI.Separator("↓ ~y~Modération ~s~↓")

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Gestion joueurs", nil, { RightLabel = "→→" }, true, function()
                    end, RMenu:Get(cat, subCat("players")))
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Gestion véhicules", nil, { RightLabel = "→→" }, true, function()
                    end, RMenu:Get(cat, subCat("vehicle")))
                    RageUI.Separator("↓ ~o~Personnel ~s~↓")
                    RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(isNoClip) .. "NoClip", nil, isNoClip, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        isNoClip = Checked;
                    end, function()
                        NoClip(true)
                    end, function()
                        NoClip(false)
                    end)

                    -- TODO -> Faire avec les DecorSetInt le grade du joueur et faire les couleurs avec les mpGamerTag
                    RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(isNameShown) .. "Affichage des noms", nil, isNameShown, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                        isNameShown = Checked;
                    end, function()
                        showNames(true)
                    end, function()
                        showNames(false)
                    end)

                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("players")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(showAreaPlayers) .. "Restreindre à ma zone", nil, showAreaPlayers, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    showAreaPlayers = Checked;
                end, function()
                end, function()
                end)


                RageUI.Checkbox(cVarLong() .. "→ " .. colorByState(showAreaPlayers) .. "Filtre alphabétique", nil, alphaFilter, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    alphaFilter = Checked;
                end, function()
                end, function()
                end)

                if alphaFilter then
                    RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                        filter = i
                    end)
                end

                RageUI.Separator("↓ ~g~Joueurs ~s~↓")
                if not showAreaPlayers then
                    for source, player in pairs(localPlayers) do
                        if alphaFilter then
                            if starts(player.name:lower(), filterArray[filter]:lower()) then
                                RageUI.ButtonWithStyle(getRankDisplay(player.rank) .. "~s~[~o~" .. source .. "~s~] " .. cVarLong() .. "→ ~s~" .. player.name or "<Pseudo invalide>" .. " (~b~" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[player.rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                    if s then
                                        selectedPlayer = source
                                    end
                                end, RMenu:Get(cat, subCat("playersManage")))
                            end
                        else
                            RageUI.ButtonWithStyle(getRankDisplay(player.rank) .. "~s~[~o~" .. source .. "~s~] " .. cVarLong() .. "→ ~s~" .. player.name or "<Pseudo invalide>" .. " (~b~" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[player.rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                if s then
                                    selectedPlayer = source
                                end
                            end, RMenu:Get(cat, subCat("playersManage")))
                        end
                    end
                else
                    for _, player in ipairs(GetActivePlayers()) do
                        local sID = GetPlayerServerId(player)
                        if localPlayers[sID] ~= nil then
                            if alphaFilter then
                                if starts(localPlayers[sID].name:lower(), filterArray[filter]:lower()) then
                                    RageUI.ButtonWithStyle(getRankDisplay(localPlayers[sID].rank) .. "~s~[~o~" .. sID .. "~s~] " .. cVarLong() .. "→ ~s~" .. localPlayers[sID].name or "<Pseudo invalide>" .. " (~b~" .. localPlayers[sID].timePlayed[2] .. "h " .. localPlayers[sID].timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[localPlayers[sID].rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                        if s then
                                            selectedPlayer = sID
                                        end
                                    end, RMenu:Get(cat, subCat("playersManage")))
                                end
                            else
                                RageUI.ButtonWithStyle(getRankDisplay(localPlayers[sID].rank) .. "~s~[~o~" .. sID .. "~s~] " .. cVarLong() .. "→ ~s~" .. localPlayers[sID].name or "<Pseudo invalide>" .. " (~b~" .. localPlayers[sID].timePlayed[2] .. "h " .. localPlayers[sID].timePlayed[1] .. "min~s~)", nil, { RightLabel = "→→" }, ranksRelative[permLevel] >= ranksRelative[localPlayers[sID].rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                    if s then
                                        selectedPlayer = sID
                                    end
                                end, RMenu:Get(cat, subCat("playersManage")))
                            end
                        end
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("↓ ~g~Paramètres ~s~↓")
                RageUI.Checkbox(colorByState(hideTakenReports) .. "Cacher les pris en charge", nil, hideTakenReports, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    hideTakenReports = Checked;
                end, function()
                end, function()
                end)
                RageUI.Separator("↓ ~y~Reports ~s~↓")
                for sender, infos in pairs(localReportsTable) do
                    if infos.taken then
                        if hideTakenReports == false then
                            RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. cVarLong() .. "→ ~s~" .. infos.name, "~g~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason .. "~n~~o~Pris en charge par~s~: " .. infos.takenBy, { RightLabel = "→→" }, true, function(_, _, s)
                                if s then
                                    selectedReport = sender
                                end
                            end, RMenu:Get(cat, subCat("reports_take")))
                        end
                    else
                        RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. cVarLong() .. "→ ~s~" .. infos.name, "~g~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                selectedReport = sender
                            end
                        end, RMenu:Get(cat, subCat("reports_take")))
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports_take")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                if localReportsTable[selectedReport] ~= nil then
                    RageUI.Separator("ID du Report: ~b~#" .. localReportsTable[selectedReport].uniqueId .. " ~s~| ID de l'auteur: ~y~" .. selectedReport .. generateTakenBy(selectedReport))
                    RageUI.Separator("↓ ~g~Actions sur le report ~s~↓")
                    local infos = localReportsTable[selectedReport]
                    if not localReportsTable[selectedReport].taken then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Prendre en charge ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                            if s then
                                TriggerServerEvent("astra_staff:takeReport", selectedReport)
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Cloturer ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:closeReport", selectedReport)
                        end
                    end)
                    RageUI.Separator("↓ ~y~Actions rapides ~s~↓")
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Revive", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:revive", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Soigner", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:heal", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP sur lui", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:goto", selectedReport)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP sur moi", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:bring", selectedReport, GetEntityCoords(PlayerPedId()))
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~TP Parking Central", "~y~Description~s~: " .. infos.reason, { RightLabel = "→→" }, canUse("tppc", permLevel), function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:tppc", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~y~Actions avancées", "~y~Description~s~: " .. infos.reason.."~n~~r~Attention~s~: Cette action vous fera changer de menu", { RightLabel = "→→" }, GetPlayerServerId(PlayerId()) ~= selectedReport, function(_, _, s)
                        if s then
                            selectedPlayer = selectedReport
                        end
                    end,RMenu:Get(cat,subCat("playersManage")))
                else
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce report n'est plus valide")
                    RageUI.Separator("")
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("playersManage")), true, true, true, function()
                shouldStayOpened = true
                if not localPlayers[selectedPlayer] then
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce joueur n'est plus connecté !")
                    RageUI.Separator("")
                else
                    statsSeparator()
                    RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                    RageUI.Separator("↓ ~g~Téléportation ~s~↓")
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~S'y téléporter", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:goto", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Téléporter sur moi", nil, { RightLabel = "→→" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("astra_staff:bring", selectedPlayer, GetEntityCoords(PlayerPedId()))
                        end
                    end)
                    RageUI.Separator("↓ ~y~Modération ~s~↓")
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Message", nil, { RightLabel = "→→" }, canUse("mess", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Message", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Envoie du message en cours...")
                                TriggerServerEvent("astra_staff:message", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Kick", nil, { RightLabel = "→→" }, canUse("kick", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Raison", "", 80, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Application de la sanction en cours...")
                                TriggerServerEvent("astra_staff:kick", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Bannir", nil, { RightLabel = "→→" }, canUse("ban", permLevel), function(_, _, s)
                        if s then
                            local days = input("Durée du banissement (en heures)", "", 20, true)
                            if days ~= nil then
                                local reason = input("Raison", "", 80, false)
                                if reason ~= nil then
                                    ESX.ShowNotification("~y~Application de la sanction en cours...")
                                    ExecuteCommand(("ban %s %s %s"):format(selectedPlayer, days, reason))
                                end
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Changer le groupe", nil, { RightLabel = "→→" }, canUse("setGroup", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("setGroup")))
                    RageUI.Separator("↓ ~o~Personnage ~s~↓")

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Revive", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("astra_staff:revive", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Soigner", nil, { RightLabel = "→→" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("astra_staff:heal", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Donner un véhicule", nil, { RightLabel = "→→" }, canUse("vehicles", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            local veh = CustomString()
                            if veh ~= nil then
                                local model = GetHashKey(veh)
                                if IsModelValid(model) then
                                    RequestModel(model)
                                    while not HasModelLoaded(model) do
                                        Wait(1)
                                    end
                                    TriggerServerEvent("astra_staff:spawnVehicle", model, selectedPlayer)
                                else
                                    msg("Ce modèle n'existe pas")
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Clear inventaire", nil, { RightLabel = "→→" }, canUse("clearInventory", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Clear de l'inventaire du joueur en cours...")
                            TriggerServerEvent("astra_staff:clearInv", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Clear armes", nil, { RightLabel = "→→" }, canUse("clearLoadout", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Clear des armes du joueur en cours...")
                            TriggerServerEvent("astra_staff:clearLoadout", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Give un item", nil, { RightLabel = "→→" }, canUse("give", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("items")))

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Give de l'argent (~g~liquide~s~)", nil, { RightLabel = "→→" }, canUse("giveMoney", permLevel), function(_, _, s)
                        if s then
                            local qty = input("Quantité", "", 20, true)
                            if qty ~= nil then
                                ESX.ShowNotification("~y~Don de l'argent au joueur...")
                                TriggerServerEvent("astra_staff:addMoney", selectedPlayer, qty)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Give de l'argent (~g~Bank~s~)", nil, { RightLabel = "→→" }, canUse("giveMoney", permLevel), function(_, _, s)
                        if s then
                            local qty = input("Quantité", "", 20, true)
                            if qty ~= nil then
                                ESX.ShowNotification("~y~Don de l'argent au joueur...")
                                TriggerServerEvent("astra_staff:addMoneybank", selectedPlayer, qty)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Give de l'argent (~g~Sale~s~)", nil, { RightLabel = "→→" }, canUse("giveMoney", permLevel), function(_, _, s)
                        if s then
                            local qty = input("Quantité", "", 20, true)
                            if qty ~= nil then
                                ESX.ShowNotification("~y~Don de l'argent au joueur...")
                                TriggerServerEvent("astra_staff:addMoneysale", selectedPlayer, qty)
                            end
                        end
                    end)

                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("items")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                    filter = i
                end)
                RageUI.Separator("↓ ~g~Items disponibles ~s~↓")
                for id, itemInfos in pairs(items) do
                    if starts(itemInfos.label:lower(), filterArray[filter]:lower()) then
                        RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~" .. itemInfos.label, nil, { RightLabel = "~b~Donner ~s~→→" }, true, function(_, _, s)
                            if s then
                                local qty = input("Quantité", "", 20, true)
                                if qty ~= nil then
                                    ESX.ShowNotification("~y~Give de l'item...")
                                    TriggerServerEvent("astra_staff:give", selectedPlayer, itemInfos.name, qty)
                                end
                            end
                        end)
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("setGroup")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~o~" .. selectedPlayer .. "~s~)")
                RageUI.Separator("↓ ~g~Rangs disponibles ~s~↓")
                for i = 1, #ranksInfos do
                    RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~" .. ranksInfos[i].label, nil, { RightLabel = "~b~Attribuer ~s~→→" }, ranksRelative[permLevel] > i, function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Application du rang...")
                            TriggerServerEvent("astra_staff:setGroup", selectedPlayer, ranksInfos[i].rank)
                        end
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("vehicle")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("↓ ~g~Apparition ~s~↓")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Spawn un véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local veh = CustomString()
                        if veh ~= nil then
                            local model = GetHashKey(veh)
                            if IsModelValid(model) then
                                RequestModel(model)
                                while not HasModelLoaded(model) do
                                    Wait(1)
                                end
                                TriggerServerEvent("astra_staff:spawnVehicle", model)
                            else
                                msg("Ce modèle n'existe pas")
                            end
                        end
                    end
                end)
                RageUI.Separator("↓ ~y~Gestion ~s~↓")
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Supprimer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        Citizen.CreateThread(function()
                            local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end
                            DeleteEntity(veh)
                            ESX.ShowNotification("~g~Véhicule supprimé")
                        end)
                    end
                end)
                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Réparer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                        NetworkRequestControlOfEntity(veh)
                        while not NetworkHasControlOfEntity(veh) do
                            Wait(1)
                        end
                        SetVehicleFixed(veh)
                        SetVehicleDeformationFixed(veh)
                        SetVehicleDirtLevel(veh, 0.0)
                        SetVehicleEngineHealth(veh, 1000.0)
                        ESX.ShowNotification("~g~Véhicule réparé")
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "→ ~s~Upgrade le véhicule au max", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then

                        ESX.ShowNotification("~w~Non mdr")
                    end
                end)
            end, function()
            end, 1)

            if not shouldStayOpened and menuOpen then
                menuOpen = false
                RMenu:Delete(RMenu:Get(cat, subCat("main")))
                RMenu:Delete(RMenu:Get(cat, subCat("players")))
                RMenu:Delete(RMenu:Get(cat, subCat("reports")))
                RMenu:Delete(RMenu:Get(cat, subCat("reports_take")))
                RMenu:Delete(RMenu:Get(cat, subCat("vehicle")))
                RMenu:Delete(RMenu:Get(cat, subCat("setGroup")))
                RMenu:Delete(RMenu:Get(cat, subCat("items")))
                RMenu:Delete(RMenu:Get(cat, subCat("playersManage")))
            end
            Wait(0)
        end
    end)
end

function authenticmodel(model)
	ESX.TriggerServerCallback('::{korioz#0110}::KorioZ-PersonalMenu:Admin_getUsergroup', function(Group)            
    clothesSkin = {}

    local couleur = nil
    
    if Group ~= nil and (Group == '_dev') then
        couleur = 5
    end

    if Group ~= nil and (Group == 'superadmin') then
        couleur = 3
    end

    if Group ~= nil and (Group == 'admin') then
        couleur = 0
    end

    if Group ~= nil and (Group == 'mod') then
        couleur = 0
    end

    if Group ~= nil and (Group == 'smod') then
        couleur = 0
    end

    if model == GetHashKey("mp_m_freemode_01") then
        clothesSkin = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 361, ['torso_2'] = couleur,
            ['arms'] = 7,
            ['pants_1'] = 140, ['pants_2'] = couleur,
            ['shoes_1'] = 98, ['shoes_2'] = couleur,
            ['mask_1'] = 189, ['mask_2'] = couleur,
        }
    else
        clothesSkin = {
           --[[ ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 178, ['torso_2'] = couleur,
            ['arms'] = 31, ['arms_2'] = 0,
            ['pants_1'] = 79, ['pants_2'] = couleur,
            ['shoes_1'] = 58, ['shoes_2'] = couleur,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bproof_1'] = 0,
            ['chain_1'] = 0,
            ['helmet_1'] = 90, ['helmet_2'] = couleur,--]]

            ['tshirt_1'] = 15,  ['tshirt_2'] = couleur,
            ['torso_1'] = 178,   ['torso_2'] = couleur,
            ['decals_1'] = 0,   ['decals_2'] = couleur,
            ['arms'] = 31,
            ['pants_1'] = 77,   ['pants_2'] = couleur,
            ['shoes_1'] = 55,   ['shoes_2'] = couleur,
            ['helmet_1'] = 91,  ['helmet_2'] = couleur,
            ['chain_1'] = 1,    ['chain_2'] = couleur,
            ['mask_1'] = -1,  ['mask_2'] = couleur,
            ['ears_1'] = 2,     ['ears_2'] = couleur
        }
    end

		for k,v in pairs(clothesSkin) do
			TriggerEvent("::{korioz#0110}::skinchanger:change", k, v)
		end
	end)
end
