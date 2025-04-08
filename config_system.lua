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

-- Get config file name based on player's account
function ConfigSystem:GetConfigFileName()
    local player = Players.LocalPlayer
    return string.format("%s-config.json", player.Name)
end

-- Save configuration
function ConfigSystem:SaveConfig()
    local config = {
        selectedDungeon = selectedDungeon,
        selectedDifficulty = selectedDifficulty,
        autoJoinDungeon = autoJoinDungeon,
        autoFarm = autoFarming,
        autoStartDungeon = AutoStart,
        autoLeaveDungeon = DungeonEnded,
        farmHeight = Height
    }
    
    local success, err = pcall(function()
        local json = HttpService:JSONEncode(config)
        writefile(self:GetConfigFileName(), json)
    end)
    
    if success then
        print("Configuration saved successfully!")
    else
        warn("Failed to save configuration:", err)
    end
end

-- Load configuration
function ConfigSystem:LoadConfig()
    local fileName = self:GetConfigFileName()
    
    if isfile(fileName) then
        local success, result = pcall(function()
            local json = readfile(fileName)
            return HttpService:JSONDecode(json)
        end)
        
        if success then
            return result
        else
            warn("Failed to load configuration:", result)
            return defaultConfig
        end
    else
        print("No existing config found, using default settings")
        return defaultConfig
    end
end

return ConfigSystem
