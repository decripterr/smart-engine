-- smart-engine-exit/client.lua

CreateThread(function()
    while true do
        Wait(0)

        if IsControlJustPressed(0, 75) then  -- G key
            local ped = PlayerPedId()

            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)

                -- Only the driver
                if GetPedInVehicleSeat(veh, -1) == ped then
                    -- Make sure vehicle engine is running
                    if GetIsVehicleEngineRunning(veh) then
                        -- OPTIONAL: check for keys using qb-vehiclekeys
                        if exports['qb-vehiclekeys']:HasKeys(veh) then
                            -- Only shut off if LEFT SHIFT is NOT held
                            if not IsControlPressed(0, 21) then
                                SetVehicleEngineOn(veh, false, false, true)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ✅ Print your dev tag to the console
print("^3[smart-engine-exit]^0 by ^2Zixja^0 has started.")
