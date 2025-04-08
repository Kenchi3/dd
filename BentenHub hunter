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

	Options.MyToggle:SetValue(true)



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
