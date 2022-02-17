ESX = nil

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)

local checkedrembourse = false
local target = "Non défini"
local target2 = "Non défini"
local target3 = "Non défini"
local mainMenu = RageUI.CreateMenu("Red-Island", "Remboursement")
local open = false
local tableremboursement = {}

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    tableremboursement = {}
    open = false
    target = "Non défini"
    target2 = "Non défini"
    target3 = "Non défini"
    checkedrembourse = false
end
mainMenu.TitleFont = 4

local function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		return result
	else
		Citizen.Wait(500)
		return nil
	end
end

Keys.Register('INSERT', 'INSERT', 'Remboursement', function()
    remboursement()
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
end)

function remboursement()
    if open then return end
    open = true
    CreateThread(function()
        while open do
            Wait(1)
            
            RageUI.IsVisible(mainMenu, function()

                RageUI.Checkbox("Je souhaite remboursé", "Peux importante ce que vous ferrez ce sera retracé et surveillé par ~r~les fondateurs du serveur", checkedrembourse, {}, {
                    onChecked = function()
                    end,
                    onUnChecked = function()
                    end,
                    onSelected = function(Index)
                        checkedrembourse = Index
                    end
                })

                if (checkedrembourse) then
                    RageUI.Button('Séléction', nil, { RightLabel = target}, true, {
                        onHovered = function()
                        end,
                        onSelected = function()
                            local selecteduser = KeyboardInput('BOX', "Entrez l'id du joueurs a rembourser", '', 10)
                            if selecteduser then
                                tableremboursement.id = tonumber(selecteduser)
                                target = "Défini"
                            else
                                Visual.Subtitle("~r~Des valeurs sont manquante !",2000)
                            end
                        end,
                    })
                    RageUI.Button('Quantité', nil, { RightLabel = target2}, true, {
                        onHovered = function()
                        end,
                        onSelected = function()
                            local selectedquantity = KeyboardInput('BOX', "Entrez une quantité a rembourser", '', 10)
                            if selectedquantity then
                                tableremboursement.quantity = tonumber(selectedquantity)
                                target2 = "Défini"
                            else
                                Visual.Subtitle("~r~Des valeurs sont manquante !",2000)
                            end
                        end,
                    });
                    RageUI.Button('Transaction', nil, { RightLabel = target3}, true, {
                        onHovered = function()
                        end,
                        onSelected = function()
                            local selectedquantity = KeyboardInput('BOX', "Entrez la raison du rembourser", '', 15)
                            if selectedquantity then
                                tableremboursement.transaction = selectedquantity
                                target3 = "Défini"
                            else
                                Visual.Subtitle("~r~Des valeurs sont manquante !",2000)
                            end
                        end,
                    });
                    RageUI.Button("~g~Sauvegarder", nil, { RightLabel = "→→"}, true, {
                        onSelected = function()
                        if target ==  "Défini" and target2 == "Défini" and target3 == "Défini" then
                            TriggerServerEvent('Authentic:SendPulsion',tableremboursement)
                            RageUI.CloseAll()
                            tableremboursement = {}
                            target = "Non défini"
                            target2 = "Non défini"
                            target3 = "Non défini"
                            checkedrembourse = false
                        else
                            Visual.Subtitle("~r~Des éléments sont manquants !",2000)
                        end
                    end,
                    })
                end
        end)
        end
    end)
end            