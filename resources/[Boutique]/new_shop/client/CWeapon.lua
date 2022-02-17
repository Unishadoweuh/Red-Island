local selected = nil;

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1000)
        local weapon = GetSelectedPedWeapon(PlayerPedId());
        if (weapon ~= GetHashKey("weapon_unarmed")) and (weapon ~= 966099553) and (weapon ~= 0) then
            if (selected ~= nil) and (weapon == GetHashKey("weapon_unarmed")) and (weapon == 966099553) and (weapon == 0) then
                selected = nil;
            end
            for i, v in pairs(ESX.GetWeaponList()) do
                if (GetHashKey(v.name) == weapon) then
                    selected = v
                end
            end
        else
            selected = nil;
        end

    end
end)
