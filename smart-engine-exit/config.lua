-- config.lua

Config = {}

-- Key to detect vehicle exit (default: G)
Config.ExitKey = 75 -- G

-- Cooldown (in milliseconds) before another engine toggle can happen
Config.EngineToggleCooldown = 2000

-- Enable exit animation
Config.EnableExitAnimation = true

-- Enable engine-off sound
Config.EnableSound = true

-- Enable persistent engine state (restores state if re-entering)
Config.PersistentEngine = true

-- Immersion Mode: adds delay and lights stay briefly after shutdown
Config.EnableImmersionMode = true

-- Framework auto-detect (QBCore or ESX)
Config.Framework = "auto" -- options: "auto", "qbcore", "esx", "none"
