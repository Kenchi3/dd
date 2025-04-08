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

-- Track previous values
local previousConfig = {}

function ConfigSystem:GetConfigFileName()
    local player = Players.LocalPlayer
    return string.format("%s-config.json", player.UserId)
end

function ConfigSystem:SaveConfig()
    local currentConfig = {
        selectedDungeon = _G.selectedDungeon,
        selectedDifficulty = _G.selectedDifficulty,
        autoJoinDungeon = _G.autoJoinDungeon,
        autoFarm = _G.autoFarming,
        autoStartDungeon = _G.AutoStart,
        autoLeaveDungeon = _G.DungeonEnded,
        farmHeight = _G.Height
    }
    
    -- Check if values actually changed
    local hasChanges = false
    for key, value in pairs(currentConfig) do
        if previousConfig[key] ~= value then
            hasChanges = true
            break
        end
    end
    
    -- Only save if there are actual changes
    if hasChanges then
        local success, err = pcall(function()
            local json = HttpService:JSONEncode(currentConfig)
            writefile(self:GetConfigFileName(), json)
            -- Update previous values
            previousConfig = table.clone(currentConfig)
            print("Configuration saved - values changed")
        end)
        
        if not success then
            warn("Failed to save configuration:", err)
        end
    else
        print("No changes detected, skipping save")
    end
end

function ConfigSystem:LoadConfig()
    local fileName = self:GetConfigFileName()
    
    if isfile(fileName) then
        local success, result = pcall(function()
            local json = readfile(fileName)
            return HttpService:JSONDecode(json)
        end)
        
        if success then
            -- Store initial values
            previousConfig = table.clone(result)
            return result
        else
            warn("Failed to load configuration:", result)
            previousConfig = table.clone(defaultConfig)
            return defaultConfig
        end
    else
        print("No existing config found, using default settings")
        previousConfig = table.clone(defaultConfig)
        return defaultConfig
    end
end

return ConfigSystem
