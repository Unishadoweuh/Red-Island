Citizen.CreateThread(function()
    while true do
    local plyPed = PlayerPedId()
    if IsPedSittingInAnyVehicle(plyPed) then
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
    if CarSpeed <= 300.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 300 km/h
    if IsControlJustReleased(0, 157) then -- conducteur : 1
    SetPedIntoVehicle(plyPed, plyVehicle, -1)
    Citizen.Wait(10)
    end
    if IsControlJustReleased(0, 158) then -- avant droit : 2
    SetPedIntoVehicle(plyPed, plyVehicle, 0)
    Citizen.Wait(10)
    end
    if IsControlJustReleased(0, 160) then -- arriere gauche : 3
    SetPedIntoVehicle(plyPed, plyVehicle, 1)
    Citizen.Wait(10)
    end
    if IsControlJustReleased(0, 164) then -- arriere droite : 4
    SetPedIntoVehicle(plyPed, plyVehicle, 2)
    Citizen.Wait(10)
    end
    end
    end
    Citizen.Wait(10) -- anti crash
    end
   end)