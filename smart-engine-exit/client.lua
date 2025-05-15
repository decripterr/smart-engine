-- smart-engine-exit/client.lua

local lastToggle = 0
local lastVehicle = nil
local lastEngineState = false
local QBCore, ESX = nil, nil

-- Auto-detect framework if needed
CreateThread(function()
    if Config.Framework == "qbcore" or Config.Framework == "auto" then
        local ok, core = pcall(function() return exports['qb-core']:GetCoreObject() end)
        if ok then QBCore = core end
    end
    if not QBCore and (Config.Framework == "esx" or Config.Framework == "auto") then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

-- Utility: Check if vehicle is locked (for framework-aware behavior)
local function isVehicleLocked(vehicle)
    if QBCore and QBCore.Functions then
        return GetVehicleDoorLockStatus(vehicle) > 1
    elseif ESX then
        return GetVehicleDoorLockStatus(vehicle) > 1
    end
    return false
end

-- Utility: Play animation
local function playExitAnimation(ped)
    RequestAnimDict("anim@veh@std@ds@exit")
    while not HasAnimDictLoaded("anim@veh@std@ds@exit") do
        Wait(10)
    end
    TaskPlayAnim(ped, "anim@veh@std@ds@exit", "d_exit", 8.0, -8, 1000, 1, 0, false, false, false)
end

-- Utility: Play sound (uses native horn/engine sounds)
local function playSound()
    PlaySoundFrontend(-1, "ENGINE_STOP", "0", true)
end

-- Main loop
CreateThread(function()
    local wasInVehicle = false
    local exitingVehicle = false

    while true do
        Wait(250)

        local ped = PlayerPedId()
        local inVehicle = IsPedInAnyVehicle(ped, false)

        if inVehicle then
            wasInVehicle = true
            exitingVehicle = false
        elseif wasInVehicle then
            -- Just exited
            wasInVehicle = false
            exitingVehicle = true
        end

        if exitingVehicle then
            exitingVehicle = false
            Wait(100)

            local veh = GetVehiclePedIsIn(ped, true)
            if veh and DoesEntityExist(veh) and GetPedInVehicleSeat(veh, -1) ~= ped then

                -- Cooldown check
                local now = GetGameTimer()
                if now - lastToggle < Config.EngineToggleCooldown then return end
                lastToggle = now

                -- Framework-aware lock check
                if isVehicleLocked(veh) then return end

                -- Skip if LEFT SHIFT is held
                if IsControlPressed(0, 21) then return end

                -- Immersion mode
                if Config.EnableImmersionMode then
                    SetVehicleLights(veh, 2) -- Keep lights on temporarily
                    Wait(500)
                end

                -- Play animation
                if Config.EnableExitAnimation then
                    playExitAnimation(ped)
                end

                -- Turn off engine
                SetVehicleEngineOn(veh, false, false, true)
                if Config.EnableSound then playSound() end

                -- Store engine state
                if Config.PersistentEngine then
                    lastVehicle = veh
                    lastEngineState = false
                end
            end
        end
    end
end)

-- Restore engine state on re-entry
CreateThread(function()
    while true do
        Wait(500)
        if not Config.PersistentEngine then return end

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if veh == lastVehicle and GetPedInVehicleSeat(veh, -1) == ped then
                SetVehicleEngineOn(veh, lastEngineState, false, true)
                lastVehicle = nil
            end
        end
    end
end)

print("^3[smart-engine-exit]^0 v2.0 by ^2Decripterr^0 loaded.")
