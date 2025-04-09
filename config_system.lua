local ConfigSystem = {}
local HttpService = game:GetService("HttpService")

-- Default settings
local defaults = {
    selectedDungeon = "GoblinCave",
    selectedDifficulty = "Normal",
    autoJoinDungeon = false,
    autoFarm = false,
    autoStartDungeon = false,
    autoLeaveDungeon = false,
    farmHeight = 8
}

function ConfigSystem:Load()
    if not isfile("dungeon_settings.json") then
        return defaults
    end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile("dungeon_settings.json"))
    end)
    
    if success then
        print("[Config] Loaded saved settings")
        return data
    end
    
    return defaults
end

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
    
    pcall(function()
        writefile("dungeon_settings.json", HttpService:JSONEncode(data))
        print("[Config] Settings saved")
    end)
end

return ConfigSystem
