local ConfigSystem = {}
local HttpService = game:GetService("HttpService")

-- Default config
local defaultConfig = {
    selectedDungeon = "GoblinCave",
    selectedDifficulty = "Normal", 
    autoJoinDungeon = false,
    autoFarm = false,
    autoStartDungeon = false,
    autoLeaveDungeon = false,
    farmHeight = 8
}

-- Save state
local saveEnabled = false

function ConfigSystem:Load()
    if not isfile("dungeon_config.lua") then
        return defaultConfig
    end

    local success, data = pcall(function()
        local content = readfile("dungeon_config.lua")
        return loadstring(content)()
    end)

    if success then
        print("[CONFIG] Loaded saved settings")
        return data
    end
    
    return defaultConfig
end

function ConfigSystem:Save()
    -- Only save if enabled
    if not saveEnabled then return end

    local config = {
        selectedDungeon = _G.selectedDungeon,
        selectedDifficulty = _G.selectedDifficulty,
        autoJoinDungeon = _G.autoJoinDungeon,
        autoFarm = _G.autoFarming,
        autoStartDungeon = _G.AutoStart,
        autoLeaveDungeon = _G.DungeonEnded,
        farmHeight = _G.Height
    }

    -- Format as Lua table
    local saveString = "return {\n"
    for key, value in pairs(config) do
        if type(value) == "string" then
            saveString = saveString .. string.format('    ["%s"] = "%s",\n', key, value)
        else
            saveString = saveString .. string.format('    ["%s"] = %s,\n', key, tostring(value))
        end
    end
    saveString = saveString .. "}"

    pcall(function()
        writefile("dungeon_config.lua", saveString)
        print("[CONFIG] Settings saved")
    end)
end

function ConfigSystem:SetAutoSave(enabled)
    saveEnabled = enabled
    if not enabled then
        if isfile("dungeon_config.lua") then
            delfile("dungeon_config.lua")
            print("[CONFIG] Auto save disabled, config file deleted")
        end
    end
end

return ConfigSystem
