local ConfigSystem = {}
local HttpService = game:GetService("HttpService")

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

function ConfigSystem:Load()
    warn("[CONFIG] Loading settings...")
    
    local success, result = pcall(function()
        if isfile("dungeon_config.json") then
            warn("[CONFIG] Found existing config file")
            return HttpService:JSONDecode(readfile("dungeon_config.json"))
        else
            warn("[CONFIG] No config file found, using defaults")
            return defaultConfig
        end
    end)

    if success then
        warn("[CONFIG] Settings loaded successfully")
        return result
    else
        warn("[CONFIG] Error loading config:", result)
        return defaultConfig
    end
end

function ConfigSystem:SaveConfig()
    warn("[CONFIG] Saving settings...")
    
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
        writefile("dungeon_config.json", HttpService:JSONEncode(data))
    end)
    
    if success then
        warn("[CONFIG] Settings saved successfully")
    else
        warn("[CONFIG] Error saving config:", err)
    end
end

return ConfigSystem
