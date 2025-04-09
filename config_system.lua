local ConfigSystem = {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Default settings
ConfigSystem.defaults = {
    selectedDungeon = "GoblinCave",
    selectedDifficulty = "Normal",
    autoJoinDungeon = false,
    autoFarm = false,
    autoStartDungeon = false,
    autoLeaveDungeon = false,
    farmHeight = 8
}

-- Get config file path
function ConfigSystem:GetConfigPath()
    return string.format("%s_settings.json", Players.LocalPlayer.UserId)
end

-- Load saved config
function ConfigSystem:Load()
    local path = self:GetConfigPath()
    
    if isfile(path) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        
        if success then
            warn("[CONFIG] Loaded settings from", path)
            return result
        end
    end
    
    warn("[CONFIG] Using default settings")
    return self.defaults
end

-- Save current config
function ConfigSystem:Save()
    local data = {
        selectedDungeon = _G.selectedDungeon,
        selectedDifficulty = _G.selectedDifficulty,
        autoJoinDungeon = _G.autoJoinDungeon,
        autoFarm = _G.autoFarming,
        autoStartDungeon = _G.AutoStart,
        autoLeaveDungeon = _G.DungeonEnded,
        farmHeight = _G.Height
    }
    
    local success, err = pcall(function()
        writefile(self:GetConfigPath(), HttpService:JSONEncode(data))
    end)
    
    if success then
        warn("[CONFIG] Settings saved successfully")
    else
        warn("[CONFIG] Failed to save:", err)
    end
end

return ConfigSystem
