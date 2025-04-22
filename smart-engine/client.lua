-- smart-engine-exit/client.lua

CreateThread(function()
    while true do
        Wait(0)

        if IsControlJustPressed(0, 75) then  -- G key
            local ped = PlayerPedId()

            -- Make sure the player is in a vehicle
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)

                -- Ensure the player is the driver of the vehicle
                if GetPedInVehicleSeat(veh, -1) == ped then
                    -- Check if the engine is running before attempting to turn it off
                    if GetIsVehicleEngineRunning(veh) then
                        -- Turn off the engine only if LEFT SHIFT is NOT pressed
                        if not IsControlPressed(0, 21) then  -- 21 = LEFT SHIFT
                            SetVehicleEngineOn(veh, false, false, true)
                            print("Vehicle engine has been turned off.")  -- Debugging line
                        end
                    end
                end
            end
        end
    end
end)

-- Debug message to confirm script is loaded
print("^3[smart-engine-exit]^0 by ^2Zixja^0 has started.")
