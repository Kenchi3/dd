repeat
	task.wait()
until game:IsLoaded()
wait(5)
-- Auto Dungeon Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

_G.InDungeon = false -- ใช้เก็บสถานะว่าผู้เล่นอยู่ในดันเจี้ยนหรือไม่

-- Function to wait for a specific time
local function waitFor(seconds)
    local start = os.clock()
    while os.clock() - start < seconds do
        task.wait()
    end
end

-- Function to check if the player is in the dungeon
local function isInDungeon()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if gui then
        local screenGui = gui:FindFirstChild("ScreenGui")
        if screenGui then
            local startDungeonFolder = screenGui:FindFirstChild("StartDungeon") -- เข้าถึงโฟลเดอร์ StartDungeon
            if startDungeonFolder then
                local startDungeonButton = startDungeonFolder:FindFirstChild("StartDungeon") -- เข้าถึงปุ่ม StartDungeon ตัวที่สอง
                if startDungeonButton then
                    print("StartDungeon button found. Visible:", startDungeonButton.Visible)
                    return startDungeonButton.Visible -- ใช้ Visible เพื่อบอกสถานะ
                else
                    print("StartDungeon button not found in StartDungeon folder.")
                end
            else
                print("StartDungeon folder not found in ScreenGui.")
            end
        else
            print("ScreenGui not found in PlayerGui.")
        end
    else
        print("PlayerGui not found.")
    end
    return false -- หากไม่พบ GUI ให้ถือว่าอยู่ในล๊อบบี้
end

-- Function to check if the dungeon has ended
local function isDungeonEnded()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if gui then
        local screenGui = gui:FindFirstChild("ScreenGui")
        local dungeonEnd = screenGui and screenGui:FindFirstChild("DungeonEnd")
        local leaveButton = dungeonEnd and dungeonEnd:FindFirstChild("Leave")
        if leaveButton and leaveButton.Visible then
            return true -- ดันเจี้ยนจบแล้ว
        end
    end
    return false -- ดันเจี้ยนยังไม่จบ
end

-- เพิ่มตัวแปรเพื่อจัดการสถานะการกลับไปที่ล๊อบบี้
local returningToLobby = false

-- Listen for DungeonEnded Remote Event
local dungeonEnded = false
Remotes:WaitForChild("DungeonEnded").OnClientEvent:Connect(function(dungeonName, difficulty, isVictory, ...)
    print("DungeonEnded Event Triggered!")
    print("Dungeon Name:", dungeonName)
    print("Difficulty:", difficulty)
    print("Victory:", isVictory)

    -- พิมพ์ข้อความเพื่อบอกว่าดันเจี้ยนจบแล้ว
    if isVictory then
        print("Dungeon completed successfully!")
    else
        print("Dungeon failed.")
    end

    -- ตั้งสถานะว่าดันเจี้ยนจบแล้ว
    dungeonEnded = true
end)

-- Main loop
while _G.AutoDungeonEnabled do
    if not isInDungeon() and not returningToLobby then
        -- In Lobby
        print("Currently in Lobby.")

        -- Step 1: Create Lobby
        local createLobbyArgs = {
            [1] = _G.Dungeon -- ใช้ค่าจาก _G.Dungeon
        }
        Remotes:WaitForChild("createLobby"):InvokeServer(unpack(createLobbyArgs))
        print("Lobby created for dungeon: " .. _G.Dungeon)
        waitFor(_G.WaitTimes.LobbyCreation)

        -- Step 2: Select Difficulty
        local difficultyArgs = {
            [1] = _G.DungeonDifficulty -- ใช้ค่าจาก _G.DungeonDifficulty
        }
        Remotes:WaitForChild("LobbyDifficulty"):FireServer(unpack(difficultyArgs))
        print("Difficulty selected: " .. _G.DungeonDifficulty)
        waitFor(_G.WaitTimes.DifficultySelection)

        -- Step 3: Start Lobby
        Remotes:WaitForChild("LobbyStart"):FireServer()
        print("Lobby started.")
        waitFor(_G.WaitTimes.LobbyStart)
    elseif isInDungeon() then
        -- In Dungeon
        print("Currently in Dungeon.")

        -- Step 4: Start Dungeon
        Remotes:WaitForChild("DungeonStart"):FireServer()
        print("Dungeon started.")
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenchi3/dd/refs/heads/main/BentenHubhunter.lua"))()
        waitFor(_G.WaitTimes.DungeonStart)

        -- Step 5: Wait for DungeonEnded Event
        print("Waiting for dungeon to end...")
        dungeonEnded = false -- รีเซ็ตสถานะก่อนรอ Remote Event
        repeat
            waitFor(1) -- รอ 1 วินาทีแล้วตรวจสอบอีกครั้ง
        until dungeonEnded

        -- Step 6: Return to Lobby
        print("Dungeon has ended. Returning to lobby...")
        returningToLobby = true -- ตั้งสถานะว่ากำลังกลับไปที่ล๊อบบี้
        Remotes:WaitForChild("LeaveToLobby"):FireServer()
        waitFor(_G.WaitTimes.ReturnToLobby) -- รอให้กลับไปที่ล๊อบบี้
        returningToLobby = false -- รีเซ็ตสถานะเมื่อกลับถึงล๊อบบี้
    end
end

repeat
	task.wait()
until game:IsLoaded()
