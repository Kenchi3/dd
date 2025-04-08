repeat
	task.wait()
until game:IsLoaded()

--—————— Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Char =  Player.Character or Player.CharacterAdded:Wait()
local rootpart : BasePart = Char:FindFirstChild("HumanoidRootPart")
local hum : Humanoid = Char:FindFirstChild("Humanoid")






local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
	Title = "Fluent " .. Fluent.Version,
	SubTitle = "by dawid",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

local inDungeon = false -- ตัวแปรสถานะว่าผู้เล่นอยู่ในดันเจี้ยนหรือไม่

local function isInDungeon()
    if inDungeon then
        print("Player is already marked as in Dungeon.") -- Debug
        return true
    end

    local gui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if gui then
        local screenGui = gui:FindFirstChild("ScreenGui")
        if screenGui then
            local startDungeonFolder = screenGui:FindFirstChild("StartDungeon")
            if startDungeonFolder then
                local startDungeonButton = startDungeonFolder:FindFirstChild("StartDungeon")
                if startDungeonButton and startDungeonButton.Visible then
                    print("StartDungeon button found. Visible:", startDungeonButton.Visible) -- Debug
                    inDungeon = true -- ตั้งสถานะว่าผู้เล่นอยู่ในดันเจี้ยน
                    return true
                end
            end
        end
    end
    print("Player is not in Dungeon.") -- Debug
    return false -- หากไม่พบ GUI หรือปุ่ม ให้ถือว่าไม่ได้อยู่ในดันเจี้ยน
end

local function isDungeonEnded()
    -- Add your logic to determine if the dungeon has ended
    -- This is a placeholder function, you need to implement the actual logic
    return false
end

local test = 15
local test1 = false
do
	task.spawn(function()
		while true do

			if test1 then
				local Combat_upvr = game:GetService("ReplicatedStorage").Remotes.Combat

				Combat_upvr:FireServer()

				for _,v in workspace:FindFirstChild("Mobs"):GetDescendants() do
					if v:IsA("Humanoid") and v.Parent:FindFirstChild("HumanoidRootPart") and v.Parent.Name ~= Char.Name then
						rootpart.CFrame = v.Parent:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,test,0) * CFrame.Angles(math.rad(-90),0,0)
					end
				end
			end

			task.wait()
		end

	end)
end

do



	local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Toggle", Default = false })

	Toggle:OnChanged(function()
		test1 = Options.MyToggle.Value
	end)

	Options.MyToggle:SetValue(false)



	local Slider = Tabs.Main:AddSlider("Slider", {
		Title = "Slider",
		Description = "This is a slider",
		Default = 8,
		Min = 0,
		Max = 20,
		Rounding = 1,
		Callback = function(Value)
			test = Value
		end
	})

end

-- เพิ่ม Dropdown สำหรับเลือกดันเจี้ยน
local DungeonDropdown = Tabs.Main:AddDropdown("SelectDungeon", {
    Title = "Select Dungeon",
    Description = "Choose a dungeon to run",
    Values = { "DoubleDungeonD", "GoblinCave", "SpiderCavern" }, -- รายชื่อดันเจี้ยน
    Default = nil, -- ค่าเริ่มต้น (index ของรายการ)
    Multi = false, -- ไม่อนุญาตให้เลือกหลายค่า
    Callback = function(selected)
        selectedDungeon = selected 
        print("Selected Dungeon:", selected)
    end
})

-- ตั้งค่าเริ่มต้นให้ selectedDungeon
local DefaultDungeon = DungeonDropdown.Value

-- เพิ่ม Dropdown สำหรับเลือกความยาก
local DifficultyDropdown = Tabs.Main:AddDropdown("SelectDifficulty", {
    Title = "Select Difficulty",
    Description = "Choose the difficulty level",
    Values = { "Regular", "Hard", "Nightmare" }, -- รายชื่อระดับความยาก
    Default = nil, -- ค่าเริ่มต้น (index ของรายการ)
    Multi = false, -- ไม่อนุญาตให้เลือกหลายค่า
    Callback = function(selected)
        selectedDifficulty = selected -- อัปเดตค่าของ selectedDifficulty
        print("Selected Difficulty:", selected)
    end
})

local DefaultDifficulty = DifficultyDropdown.Value -- ตั้งค่าเริ่มต้นให้ selectedDifficulty

-- เพิ่ม Toggle สำหรับ Auto Dungeon
local AutoDungeonToggle = Tabs.Main:AddToggle("AutoDungeonToggle", {
    Title = "Enable Auto Dungeon",
    Default = false
})

-- ตัวแปรสำหรับสถานะ Auto Dungeon
local autoDungeonEnabled = false

AutoDungeonToggle:OnChanged(function()
    autoDungeonEnabled = Options.AutoDungeonToggle.Value
    print("Auto Dungeon Toggle Changed:", autoDungeonEnabled) -- Debug

    if autoDungeonEnabled then
        print("Auto Dungeon Enabled")
        task.spawn(function()
            while autoDungeonEnabled do
                print("Auto Dungeon Loop Running...") -- Debug

                if not isInDungeon() and not dungeonEnded then
                    print("Currently in Lobby. Starting dungeon...")

                    if not selectedDungeon or not selectedDifficulty then
                        print("Please select a dungeon and difficulty.")
                        break
                    end

                    -- Step 1: Create Lobby
                    local createLobbyArgs = {
                        [1] = selectedDungeon
                    }
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("createLobby"):InvokeServer(unpack(createLobbyArgs))
                    end)
                    if success then
                        print("Lobby created successfully.", createLobbyArgs[1])
                    else
                        print("Error creating lobby:", err)
                    end
                    task.wait(3)

                    -- Step 2: Select Difficulty
                    local difficultyArgs = {
                        [1] = selectedDifficulty
                    }
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LobbyDifficulty"):FireServer(unpack(difficultyArgs))
                    end)
                    if success then
                        print("Difficulty selected successfully.", difficultyArgs[1])
                    else
                        print("Error selecting difficulty:", err)
                    end
                    task.wait(2)

                    -- Step 3: Start Lobby
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LobbyStart"):FireServer()
                    print("Lobby started.")
                    task.wait(1)
                elseif isInDungeon() then
                    print("Currently in Dungeon. Waiting for dungeon to end...")
                end

                task.wait(1)
            end
        end)
    else
        print("Auto Dungeon Disabled")
    end
end)

-- เพิ่ม Toggle สำหรับ Auto Start Dungeon
local AutoStartDungeonToggle = Tabs.Main:AddToggle("AutoStartDungeonToggle", {
    Title = "Enable Auto Start",
    Default = false
})

-- ตัวแปรสำหรับสถานะ Auto Start Dungeon
local autoStartDungeonEnabled = false

AutoStartDungeonToggle:OnChanged(function()
    autoStartDungeonEnabled = Options.AutoStartDungeonToggle.Value
    if autoStartDungeonEnabled then
        print("Auto Start Dungeon Enabled")
        task.spawn(function()
            while autoStartDungeonEnabled do
                -- ตรวจสอบว่าผู้เล่นอยู่ในดันเจี้ยนหรือไม่
                if isInDungeon() then
                    print("Currently in Dungeon. Starting dungeon...")

                    -- เรียกใช้ Remote DungeonStart
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DungeonStart"):FireServer()
                    print("Dungeon started.")
                else
                    print("Not in Dungeon. Waiting...")
                end

                task.wait(1) -- รอ 1 วินาทีในแต่ละรอบ
            end
        end)
    else
        print("Auto Start Dungeon Disabled")
    end
end)

-- เพิ่ม Toggle สำหรับ Auto Leave
local AutoLeaveToggle = Tabs.Main:AddToggle("AutoLeaveToggle", {
    Title = "Enable Auto Leave",
    Default = false
})

-- ตัวแปรสำหรับสถานะ Auto Leave
local autoLeaveEnabled = false

-- ตัวแปรสำหรับสถานะดันเจี้ยนจบ
local dungeonEnded = false

-- ฟังก์ชันตรวจสอบ Remote DungeonEnded
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DungeonEnded").OnClientEvent:Connect(function(dungeonName, difficulty, isVictory, ...)
    print("DungeonEnded Event Triggered!")
    print("Dungeon Name:", dungeonName)
    print("Difficulty:", difficulty)
    print("Victory:", isVictory)

    dungeonEnded = true -- ตั้งสถานะว่าดันเจี้ยนจบแล้ว
end)

AutoLeaveToggle:OnChanged(function()
    autoLeaveEnabled = Options.AutoLeaveToggle.Value
    if autoLeaveEnabled then
        print("Auto Leave Enabled")
        task.spawn(function()
            while autoLeaveEnabled do
                -- ตรวจสอบว่าดันเจี้ยนจบแล้วหรือไม่
                if dungeonEnded then
                    print("Dungeon has ended. Leaving dungeon...")

                    -- เรียกใช้ Remote LeaveToLobby
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LeaveToLobby"):FireServer()
                    print("Left the dungeon.")

                    -- รีเซ็ตสถานะดันเจี้ยนจบและสถานะผู้เล่น
                    dungeonEnded = false
                    inDungeon = false -- เปลี่ยนสถานะว่าผู้เล่นไม่ได้อยู่ในดันเจี้ยน
                else
                    print("Dungeon not ended yet. Waiting...")
                end

                task.wait(1) -- รอ 1 วินาทีในแต่ละรอบ
            end
        end)
    else
        print("Auto Leave Disabled")
    end
end)

-- สร้างโฟลเดอร์สำหรับเก็บคอนฟิก
local folderPath = "BentenHub"
if not isfolder(folderPath) then
    makefolder(folderPath)
end

-- ฟังก์ชันสำหรับเซฟคอนฟิก
local function SaveConfig(fileName, data)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
    print("Config saved to:", filePath)
end

-- ฟังก์ชันสำหรับโหลดคอนฟิก
local function LoadConfig(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        print("Config loaded from:", filePath)
        return HttpService:JSONDecode(jsonData)
    end
    return nil
end

-- ฟังก์ชันสำหรับอัปเดตคอนฟิกอัตโนมัติ
local function AutoSaveConfig()
    local configData = {
        MyToggle = Options.MyToggle.Value,
        Slider = Options.Slider.Value,
        SelectDungeon = selectedDungeon,
        SelectDifficulty = selectedDifficulty,
        AutoDungeonToggle = Options.AutoDungeonToggle.Value,
        AutoStartDungeonToggle = Options.AutoStartDungeonToggle.Value,
        AutoLeaveToggle = Options.AutoLeaveToggle.Value
    }
    SaveConfig(Players.LocalPlayer.Name .. "Config", configData)
end

-- โหลดคอนฟิกเมื่อเริ่มต้น
local loadedConfig = LoadConfig(Players.LocalPlayer.Name .. "Config")
if loadedConfig then
    Options.MyToggle:SetValue(loadedConfig.MyToggle)
    Options.Slider:SetValue(loadedConfig.Slider)
    selectedDungeon = loadedConfig.SelectDungeon
    selectedDifficulty = loadedConfig.SelectDifficulty
    Options.AutoDungeonToggle:SetValue(loadedConfig.AutoDungeonToggle)
    Options.AutoStartDungeonToggle:SetValue(loadedConfig.AutoStartDungeonToggle)
    Options.AutoLeaveToggle:SetValue(loadedConfig.AutoLeaveToggle)
end

-- ตั้งค่าให้ Auto Save เมื่อมีการเปลี่ยนแปลง
Options.MyToggle:OnChanged(AutoSaveConfig)
Options.Slider:OnChanged(AutoSaveConfig)
Options.AutoDungeonToggle:OnChanged(AutoSaveConfig)
Options.AutoStartDungeonToggle:OnChanged(AutoSaveConfig)
Options.AutoLeaveToggle:OnChanged(AutoSaveConfig)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
	Title = "Fluent",
	Content = "The script has been loaded.",
	Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()