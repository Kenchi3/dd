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
    return string.format("%s-config.json", player.UserId) -- ใช้ UserId แทน Name เพื่อความเสถียร
end

function ConfigSystem:SaveConfig()
    local config = {
        selectedDungeon = _G.selectedDungeon or defaultConfig.selectedDungeon,
        selectedDifficulty = _G.selectedDifficulty or defaultConfig.selectedDifficulty,
        autoJoinDungeon = _G.autoJoinDungeon or defaultConfig.autoJoinDungeon,
        autoFarm = _G.autoFarming or defaultConfig.autoFarm,
        autoStartDungeon = _G.AutoStart or defaultConfig.autoStartDungeon,
        autoLeaveDungeon = _G.DungeonEnded or defaultConfig.autoLeaveDungeon,
        farmHeight = _G.Height or defaultConfig.farmHeight
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

function ConfigSystem:LoadConfig()
    local fileName = self:GetConfigFileName()
    
    if isfile(fileName) then
        local success, result = pcall(function()
            local json = readfile(fileName)
            return HttpService:JSONDecode(json)
        end)
        
        if success then
            -- Set global variables
            _G.selectedDungeon = result.selectedDungeon
            _G.selectedDifficulty = result.selectedDifficulty
            _G.autoJoinDungeon = result.autoJoinDungeon
            _G.autoFarming = result.autoFarm
            _G.AutoStart = result.autoStartDungeon
            _G.DungeonEnded = result.autoLeaveDungeon
            _G.Height = result.farmHeight
            
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
