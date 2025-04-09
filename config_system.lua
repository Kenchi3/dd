local ConfigSystem = {}
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Add debug flag
ConfigSystem.DEBUG = true

function ConfigSystem:Log(...)
    if self.DEBUG then
        warn("[CONFIG]", ...)
    end
end

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

function ConfigSystem:GetFileName()
    local filename = string.format("%s_dungeon.json", Players.LocalPlayer.UserId)
    self:Log("Using config file:", filename)
    return filename
end

function ConfigSystem:Load()
    local filename = self:GetFileName()
    
    -- Check if file exists
    if not isfile(filename) then
        self:Log("No config file found - Using defaults")
        return self.defaults
    end
    
    -- Try to load config
    local success, data = pcall(function()
        local content = readfile(filename)
        self:Log("Reading file content:", content)
        return HttpService:JSONDecode(content)
    end)
    
    if success then
        self:Log("Successfully loaded config")
        return data
    else
        self:Log("Failed to load config:", data)
        return self.defaults
    end
end

function ConfigSystem:Save()
    local currentConfig = {
        selectedDungeon = _G.selectedDungeon,
        selectedDifficulty = _G.selectedDifficulty,
        autoJoinDungeon = _G.autoJoinDungeon,
        autoFarm = _G.autoFarming,
        autoStartDungeon = _G.AutoStart,
        autoLeaveDungeon = _G.DungeonEnded,
        farmHeight = _G.Height
    }
    
    self:Log("Saving config:", HttpService:JSONEncode(currentConfig))
    
    local success, err = pcall(function()
        writefile(self:GetFileName(), HttpService:JSONEncode(currentConfig))
    end)
    
    if success then
        self:Log("Config saved successfully")
    else
        self:Log("Failed to save config:", err)
    end
end

return ConfigSystem
