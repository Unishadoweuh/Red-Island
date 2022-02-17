---@class Client

local Client = {} or {};



---@type table Content catego ry menu

local category = {} or {};


--@type table Content weapon menu

local selected = nil;



---@type table All items

local items = {} or {};



---@type table History activity

local history = {} or {};



---@type table Selected items

local selected = {} or {};

 

---@type number Current players points

local points = 0;



---@type table Shared object

ESX = {}; 



TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj)

    ESX = obj

end)



Citizen.CreateThread(function()

    while ESX == nil do

        TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj)

            ESX = obj

        end)

        Citizen.Wait(10)

    end

end)



local mainMenu = RageUI.CreateMenu("Boutique", "Achetez des objets")

mainMenu:DisplayGlare(false)

mainMenu.Closed = function()

    items = {} or {};

end


RMenu.Add('tebex', 'weapon', RageUI.CreateSubMenu(mainMenu, "Personnalisation", "Personnalisation d'arme"))
RMenu:Get('tebex', 'weapon'):DisplayGlare(false)
RMenu:Get('tebex', 'weapon').Closed = function()

end


local picture;

RMenu.Add('tebex', 'case', RageUI.CreateMenu("Caisse impulsion", "Caisse"))
RMenu:Get('tebex', 'case'):DisplayGlare(false)
RMenu:Get('tebex', 'case').Closed = function()
    picture = nil
end


local historyMenu = RageUI.CreateSubMenu(mainMenu, "Historique", "Historique de vos achat")

historyMenu:DisplayGlare(false)

historyMenu.Closed = function()

    Client:onRetrievePoints();

end

local caseMenu = RageUI.CreateMenu("Caisse impulsion", "Caisse")

caseMenu:DisplayGlare(false)

caseMenu.Closed = function()

end



local itemMenu = RageUI.CreateSubMenu(mainMenu, "Boutique", "")

itemMenu:DisplayGlare(false)

itemMenu.Closed = function()

    Client:onRetrievePoints();

    selected = {};

end

itemMenu.onIndexChange = function(Index)

    selected = items[Index] or {};

end



---onRetrieveItem

---@public

function Client:onRetrieveItem(categoryId)

    ESX.TriggerServerCallback('tebex:retrieve-items', function(result)

        items = result;

    end, categoryId)

end



---onRetrieveCategory

---@public

function Client:onRetrieveCategory()

    ESX.TriggerServerCallback('tebex:retrieve-category', function(result)

        category = result;

    end)

end



---onRetrievePoints

---@public

function Client:onRetrievePoints()

    ESX.TriggerServerCallback('tebex:retrieve-points', function(result)

        points = result

    end)

end



---onRetrieveHistory

---@public

function Client:onRetrieveHistory()

    ESX.TriggerServerCallback('tebex:retrieve-history', function(result)

        history = result;

    end)

end



function Client:RequestPtfx(assetName)

    RequestNamedPtfxAsset(assetName)

    if not (HasNamedPtfxAssetLoaded(assetName)) then

        while not HasNamedPtfxAssetLoaded(assetName) do

            Citizen.Wait(1.0)

        end

        return assetName;

    else

        return assetName;

    end

end





Citizen.CreateThread(function()

    while (true) do

        Citizen.Wait(1.0)



        if (IsControlJustPressed(1, 288)) then

            Client:onRetrieveCategory();

            Client:onRetrievePoints();

            RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))

        end



        RageUI.IsVisible(mainMenu, function()





            RageUI.Button('Vos pultion boutique', "Les achats sur la boutique vous permet de soutenir le serveur est bien plus encore.", { RightLabel = points }, true, {

            });

            RageUI.Button('Historique', "Historique de vos achats sur la boutique en jeux", { }, true, {

                onSelected = function()

                    Client:onRetrieveHistory()

                end

            }, historyMenu);



            RageUI.Separator("Catalogue");



            if (#category > 0) then

                for i, v in pairs(category) do

                    RageUI.Button(v.name, v.description, { }, true, {

                        onSelected = function()

                            Client:onRetrieveItem(v.id)

                            itemMenu:SetSubtitle(v.name)

                        end,

                    }, itemMenu);

                end

            else

                RageUI.Separator("Aucune category disponible.");

            end
            RageUI.Button("Personnalisation d'armes", nil, { RightLabel = "~y~Nouveauté" }, true, {
                onSelected = function()

                end,
            }, RMenu:Get('tebex', 'weapon'));

            RageUI.Button("Caisse Impulsion", "Les boîtes impulsion sont des boîtes à mystère qui vous permettent d'obtenir un objet parmi une liste d'objets présents dans la boîte.", { }, true, {
                onSelected = function()
                end,
            }, caseMenu);
        end)

        RageUI.IsVisible(caseMenu, function()
            RageUI.Button("Boite impulsion - Limited", "Dans cette case, vous pouvez obtenir différents objet ou autre les voici ci-dessous avec leur niveau de rareté, Diamond, gold, etc.", { RightLabel = string.format("%s", 1500) }, true, {
                onSelected = function()
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                    Citizen.Wait(50)
                    RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
                        RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
                        ESX.ShowAdvancedNotification('Boutique', 'Informations', 'Mdr', 'CHAR_WENDY', 6, 2)
                    if not HasStreamedTextureDictLoaded("case") then
                        RequestStreamedTextureDict("case", true)
                    end
                    TriggerServerEvent('tebex:on-process-checkout-case')
                end
            })
        end, function()
            RageUI.RenderSprite("case", "global")
        end)


        RageUI.IsVisible(itemMenu, function()

            if (#items > 0) then

                for i, v in pairs(items) do



                    RageUI.Button(v.name, v.descriptions, { RightLabel = string.format("%s", v.price) }, true, {

                        onSelected = function()

                            if not (points >= v.price) then

                                Visual.Subtitle("~r~Vous ne possédez pas les points nécessaire", 5000)

                            end

                            if (points >= v.price) then

                                TriggerServerEvent('tebex:on-process-checkout', v.id)

                                local coords = GetEntityCoords(GetPlayerPed(-1))

                                ESX.ShowNotification(string.format("~g~Felicitation vous avez acheté %s", v.name))

                                Client:RequestPtfx('scr_rcbarry1')

                                UseParticleFxAsset('scr_rcbarry1')

                                StartNetworkedParticleFxNonLoopedAtCoord('scr_alien_teleport', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)

                            end

                        end,

                    });



                end

            else

                RageUI.Separator("Aucune contenue disponible.");

            end

        end, function()

            if (selected ~= nil) and (selected.category == 1) or (selected.category == 2) and (selected.action ~= nil) then

                local action = json.decode(selected.action)

                if (action.vehicles ~= nil) then

                    for i, v in pairs(action.vehicles) do

                        RageUI.RenderSprite("vehicles", v.name)

                    end

                end

                if (action.weapons ~= nil) and (#action.weapons == 1) then

                    for i, v in pairs(action.weapons) do

                        RageUI.RenderSprite("vehicles", v.name)

                    end

                end

            end

        end)



        RageUI.IsVisible(historyMenu, function()

            if (#history > 0) then

                for i, v in pairs(history) do

                    local label;

                    if (tonumber(v.price) == 0) then

                        label = string.format("%s", v.points)

                    else

                        label = string.format("%s (%s%s)", v.points, v.price, v.currency);

                    end

                    RageUI.Button(v.transaction, nil, { RightLabel = label }, true, {

                        onSelected = function()



                        end,

                    });



                end

            else

                RageUI.Separator("Aucune transactions effectues.");

            end

        end)



    end

end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1.0)

        RageUI.IsVisible(RMenu:Get('tebex', 'weapon'), function()
            if (selected) then
                if (ESX.Table.SizeOf(selected) > 0) then
                    for i, v in pairs(selected.components) do
                        RageUI.Button(v.label, nil, { RightLabel = v.point }, true, {
                            onSelected = function()
                                TriggerServerEvent('tebex:on-process-checkout-weapon-custom', selected.name, v.hash)
                            end,
                        })
                    end
                else
                    RageUI.Separator("~r~Aucune personnalisation disponible.")
                end
            else
                RageUI.Separator("Vous n'avez pas d'arme dans vos main")
            end
        end, function()

        end)


    end
end)

RMenu:Get('tebex', 'weapon').Closed = function()
    TriggerEvent('::{korioz#0110}::esx:restoreLoadout')
end

RMenu:Get('tebex', 'weapon').onIndexChange = function(index)
    if (selected ~= nil) then
        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(selected.name), selected.components[index].hash)
        if (selected.components[index - 1] ~= nil) and (selected.components[index - 1].hash ~= nil) then
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(selected.name), selected.components[index - 1].hash)
        end
        if (index == 1) then
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(selected.name), selected.components[#selected.components].hash)
        end
    end
end

RegisterNetEvent('tebex:on-open-case')
AddEventHandler('tebex:on-open-case', function(animations, name, message)
    RageUI.Visible(RMenu:Get('tebex', 'case'), true)
    Citizen.CreateThread(function()
        Citizen.Wait(250)
        for k, v in pairs(animations) do
            picture = v.name
            RageUI.PlaySound("HUD_FREEMODE_SOUNDSET", "NAV_UP_DOWN")
            if v.time == 5000 then
                RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
                ESX.ShowAdvancedNotification('Boutique', 'Informations', message, 'CHAR_WENDY', 6, 2)
            end
            Citizen.Wait(v.time)
        end
    end)
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1.0)

        RageUI.IsVisible(RMenu:Get('tebex', 'case'), function()

        end, function()
            if (picture) then
                RageUI.RenderSprite("case", picture)
            end
        end)


    end
end)

