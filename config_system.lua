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

function ConfigSystem:GetConfigFileName()
    local player = Players.LocalPlayer
    return string.format("%s-config.json", player.UserId)
end

function ConfigSystem:LoadConfig()
    local fileName = self:GetConfigFileName()
    
    if isfile(fileName) then
        local success, result = pcall(function()
            local json = readfile(fileName)
            return HttpService:JSONDecode(json)
        end)
        
        if success then
            print("Successfully loaded saved configuration")
            return result
        else
            warn("Failed to load configuration:", result)
            return defaultConfig
        end
    else
        print("No config file found, using default settings")
        return defaultConfig
    end
end

function ConfigSystem:SaveConfig()
    if not self.lastSavedConfig then
        self.lastSavedConfig = {}
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

    -- Compare with last saved config
    local hasChanges = false
    for key, value in pairs(currentConfig) do
        if self.lastSavedConfig[key] ~= value then
            hasChanges = true
            break
        end
    end

    if hasChanges then
        local success, err = pcall(function()
            local json = HttpService:JSONEncode(currentConfig)
            writefile(self:GetConfigFileName(), json)
            self.lastSavedConfig = table.clone(currentConfig)
            print("Configuration saved - values changed")
        end)
        
        if not success then
            warn("Failed to save configuration:", err)
        end
    end
end

return ConfigSystem
