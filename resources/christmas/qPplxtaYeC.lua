Citizen.CreateThread(function()
    while true 
        do
        
    SetWeatherTypePersist("EXTRASUNNY")
        SetWeatherTypeNowPersist("EXTRASUNNY")
        SetWeatherTypeNow("EXTRASUNNY")
        SetOverrideWeather("EXTRASUNNY")
        SetForcePedFootstepsTracks(true)
	SetForceVehicleTrails(true)
        Citizen.Wait(1)
    end
end)