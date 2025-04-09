local ConfigSystem = {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Default config
local defaultConfig = {
    selectedDungeon = "GoblinCave",
    selectedDifficulty = "Normal",
    autoJoinDungeon = false,
    autoFarm = false,
    autoStartDungeon = false,
    autoLeaveDungeon = false,
    farmHeight = 8
}

-- Config state
local configLoaded = false
local currentConfig = {}

function ConfigSystem:Init()
    local filename = Players.LocalPlayer.UserId .. "_config.json"
    
    if isfile(filename) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filename))
        end)
        
        if success then
            currentConfig = data
            configLoaded = true
            warn("[CONFIG] Loaded from:", filename)
            return data
        end
    end
    
    currentConfig = defaultConfig
    configLoaded = true
    warn("[CONFIG] Using default settings")
    return defaultConfig
end

function ConfigSystem:Save()
    if not configLoaded then return end
    
    local data = {
        selectedDungeon = _G.selectedDungeon,
        selectedDifficulty = _G.selectedDifficulty,
        autoJoinDungeon = _G.autoJoinDungeon,
        autoFarm = _G.autoFarming,
        autoStartDungeon = _G.AutoStart,
        autoLeaveDungeon = _G.DungeonEnded,
        farmHeight = _G.Height
    }
    
    local filename = Players.LocalPlayer.UserId .. "_config.json"
    
    local success = pcall(function()
        writefile(filename, HttpService:JSONEncode(data))
        warn("[CONFIG] Saved to:", filename)
    end)
    
    if not success then
        warn("[CONFIG] Failed to save config")
    end
end

return ConfigSystem
