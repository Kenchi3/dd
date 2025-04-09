repeat
	task.wait()
until game:IsLoaded()


for _,v in workspace:GetDescendants() do
	if v:IsA("BasePart") and v.Name == "Body" then
		v:Destroy()
	end
end


for _,v in game.CoreGui:GetDescendants() do
	if v:IsA("ScreenGui") and v.Name == "ScreenGui" then
		v:Destroy()
	end
end

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


local Player = Players.LocalPlayer
local Char =  Player.Character or Player.CharacterAdded:Wait()

local hum : Humanoid = Char:FindFirstChild("Humanoid")


function test33()
	local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
	local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
	local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

	local Window = Fluent:CreateWindow({
		Title = "BenTenHub-Hunters V1 ",
		SubTitle = "by BenTenDev",
		TabWidth = 160,
		Size = UDim2.fromOffset(580, 460),
		Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
	})

	--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
	local Tabs = {
		Main = Window:AddTab({ Title = "Main", Icon = "toggle-right" }),
		Setup = Window:AddTab({ Title = "Setup", Icon = "save" }),

		Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
	}




	local Save = {}

	Save.test0 = 8
	Save.test1 = false
	Save.test2 = false
	Save.test3 = ""
	Save.test4 = ""
	Save.test5 = false
	Save.test6 = false
	Save.test7 = false



	local Options = Fluent.Options

	if isfile("Kuy.lua") then



		local reload = loadstring(readfile("Kuy.lua"))
		local loadedTable = reload()  

		for key, v in pairs(loadedTable) do
			Save[key] = v
		end
	end				




	local famer 
	repeat
		famer = game:FindFirstChild("CoreGui"):FindFirstChild("ScreenGui")
		task.wait()
	until famer


	local Stop = false
	local test2 = 0
	do
		task.spawn(function()
			local screenGui = Player.PlayerGui:FindFirstChild("ScreenGui")
			if screenGui then
				local startDungeonFolder = screenGui:FindFirstChild("StartDungeon")
				if startDungeonFolder then
					local startDungeonButton = startDungeonFolder:FindFirstChild("StartDungeon")
					if startDungeonButton and startDungeonButton.Visible then
						game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DungeonStart"):FireServer()
						Stop = true
						
						repeat
							task.wait()
						until startDungeonButton
					end
				end
			end

			local connection
			connection = RunService.Heartbeat:Connect(function()
				if not famer.Parent  then
					connection:Disconnect() 
				end


				if screenGui:FindFirstChild("DungeonEnd") and  screenGui:FindFirstChild("DungeonEnd").Visible then
					if Save.test6 then
						game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LeaveToLobby"):FireServer()
					end
				end
		
				if Save.test7 then
					local saveString = "return {\n"
					for key, value in pairs(Save) do
						if typeof(value) == "string" then
							saveString = saveString .. string.format('    ["%s"] = "%s",\n', key, value)
						elseif typeof(value) == "boolean" or typeof(value) == "number" then
							saveString = saveString .. string.format('    ["%s"] = %s,\n', key, tostring(value))
						end
					end
					saveString = saveString .. "}"

					writefile("Kuy.lua", saveString)
				else
					delfile("Kuy.lua")
				end

				if Save.test2 and Save.test3 and Save.test4 and not Stop then
					local args = {
						[1] = Save.test3
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("createLobby"):InvokeServer(unpack(args))

					local args2 = {
						[1] = Save.test4
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LobbyDifficulty"):FireServer(unpack(args2))

					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LobbyStart"):FireServer()
				end
				
				
				
				if Save.test1 then
					
				
					local Combat_upvr = game:GetService("ReplicatedStorage").Remotes.Combat
					Combat_upvr:FireServer()

					local mobsFolder = workspace:FindFirstChild("Mobs")
					if mobsFolder then
						
						for _, v in ipairs(mobsFolder:GetDescendants()) do
							if v:IsA("Humanoid") and v.Parent:FindFirstChild("HumanoidRootPart") and v.Parent.Name ~= Char.Name then
								local targetHRP = v.Parent:FindFirstChild("HumanoidRootPart")
								local rootpart = Char and Char:FindFirstChild("HumanoidRootPart")

								if rootpart and targetHRP then
									rootpart.CFrame = targetHRP.CFrame * CFrame.new(0, Save.test0, 0) * CFrame.Angles(math.rad(-90), 0, 0)
								end
							end
						end
					end
				end
			end)

		end)

	end

	do

		local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Auto Farm", Default = false })
		Options.MyToggle:SetValue(Save.test1)
		Toggle:OnChanged(function()
			Save.test1  = Options.MyToggle.Value
		end)





		local Slider = Tabs.Main:AddSlider("Slider", {
			Title = "Distance",
			Description = "",
			Default = 0,
			Min = 8,
			Max = 20,
			Rounding = 1,
			Callback = function(Value)
				Save.test0 = Value
			end
		})
		Slider:SetValue(Save.test0)


	end

	do
		local DungeonDropdown = Tabs.Main:AddDropdown("SelectDungeon", {
			Title = "Select Dungeon",
			Description = "",
			Values = { "DoubleDungeonD", "GoblinCave", "SpiderCavern" }, -- รายชื่อดันเจี้ยน
			Default = nil, -- ค่าเริ่มต้น (index ของรายการ)
			Multi = false, -- ไม่อนุญาตให้เลือกหลายค่า
			Callback = function(selected) 
				Save.test3 = selected
			end
		})
		DungeonDropdown:SetValue(Save.test3)


		local DungeonDropdown2 = Tabs.Main:AddDropdown("SelectDungeon2", {
			Title = "Slelect Difficulty",
			Description = "",
			Values = { "Regular", "Hard", "Nightmare" }, 
			Default = nil, -- ค่าเริ่มต้น (index ของรายการ)
			Multi = false, -- ไม่อนุญาตให้เลือกหลายค่า
			Callback = function(selected) 
				Save.test4 = selected
			end
		})
		DungeonDropdown2:SetValue(Save.test4)


		local Toggle = Tabs.Main:AddToggle("MyToggle2", {Title = "Auto Join Dungeon", Default = false })

		Options.MyToggle2:SetValue(Save.test2)

		Toggle:OnChanged(function()

			Save.test2  = Options.MyToggle2.Value
		end)











		local Toggle = Tabs.Main:AddToggle("MyToggle3", {Title = "Auto Start", Default = false })

		Options.MyToggle3:SetValue(Save.test5)

		Toggle:OnChanged(function()
			Save.test5 = Options.MyToggle3.Value
		end)




		local Toggle = Tabs.Main:AddToggle("MyToggle4", {Title = "Auto leave", Default = false })

		Options.MyToggle4:SetValue(Save.test6)

		Toggle:OnChanged(function()
			Save.test6 = Options.MyToggle4.Value
		end)


	end


	local Toggle5 = Tabs.Setup:AddToggle("MyToggle6", {Title = "Auto Save", Default = false })


	Options.MyToggle6:SetValue(Save.test7)

	Toggle5:OnChanged(function()
		Save.test7  = Options.MyToggle6.Value
	end)







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
end

test33()
