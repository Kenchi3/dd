local ConfigSystem = {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Default configuration
ConfigSystem.defaults = {
    selectedDungeon = "GoblinCave",
    selectedDifficulty = "Normal",
    autoJoinDungeon = false,
    autoFarm = false,
    autoStartDungeon = false,
    autoLeaveDungeon = false,
    farmHeight = 8
}

-- Get config file name based on player ID
function ConfigSystem:GetFileName()
    return string.format("dungeon_config_%s.json", Players.LocalPlayer.UserId)
end

-- Load config
function ConfigSystem:Load()
    local filename = self:GetFileName()
    
    if not isfile(filename) then
        return self.defaults
    end
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(filename))
    end)
    
    if success then
        warn("[CONFIG] Loaded existing settings")
        return result
    end
    
    return self.defaults
end

-- Save config
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
        writefile(self:GetFileName(), HttpService:JSONEncode(data))
    end)
    
    if success then
        warn("[CONFIG] Settings saved")
    else
        warn("[CONFIG] Failed to save:", err)
    end
end

return ConfigSystem
