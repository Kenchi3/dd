local ConfigSystem = {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Default configuration
local defaultConfig = {
    selectedDungeon = "GoblinCave",
    selectedDifficulty = "Normal",
    autoJoinDungeon = false,
    autoFarm = false,
    autoStartDungeon = false,
    autoLeaveDungeon = false,
    farmHeight = 8
}

-- Keep track of initial load
local isFirstLoad = true

function ConfigSystem:GetConfigFileName()
    local player = Players.LocalPlayer
    return string.format("%s-config.json", player.UserId)
end

function ConfigSystem:LoadConfig()
    local fileName = self:GetConfigFileName()
    
    if isfile(fileName) then
        local success, result = pcall(function()
            local json = readfile(fileName)
            local data = HttpService:JSONDecode(json)
            print("[Config] Loaded existing configuration")
            isFirstLoad = false
            return data
        end)
        
        if success then
            return result
        else
            warn("[Config] Failed to load configuration:", result)
            return defaultConfig
        end
    else
        print("[Config] No config file found, using default settings")
        return defaultConfig
    end
end

function ConfigSystem:SaveConfig()
    -- Skip saving on first load
    if isFirstLoad then
        isFirstLoad = false
        return
    end

    local currentConfig = {
        selectedDungeon = _G.selectedDungeon,
        selectedDifficulty = _G.selectedDifficulty,
        autoJoinDungeon = _G.autoJoinDungeon,
        autoFarm = _G.autoFarming,
        autoStartDungeon = _G.AutoStart,
        autoLeaveDungeon = _G.DungeonEnded,
        farmHeight = _G.Height
    }

    local success, err = pcall(function()
        local json = HttpService:JSONEncode(currentConfig)
        writefile(self:GetConfigFileName(), json)
        print("[Config] Configuration saved successfully")
    end)
    
    if not success then
        warn("[Config] Failed to save configuration:", err)
    end
end

return ConfigSystem
