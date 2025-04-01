local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local workspace = game:GetService("Workspace")

-- Coordinates of the stages and end chest
local positions = {
    Vector3.new(-33, 78, 1369),  -- Stage 1
    Vector3.new(-28, 75, 2141),  -- Stage 2
    Vector3.new(-44, 93, 2908),  -- Stage 3
    Vector3.new(-42, 67, 3676),  -- Stage 4
    Vector3.new(-32, 63, 4452),  -- Stage 5
    Vector3.new(-18, 61, 5223),  -- Stage 6
    Vector3.new(-55, 73, 5986),  -- Stage 7
    Vector3.new(-54, 43, 8724)   -- End Chest (unchanged)
}

local running = false

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local StartButton = Instance.new("TextButton", ScreenGui)
local StopButton = Instance.new("TextButton", ScreenGui)

StartButton.Size = UDim2.new(0, 100, 0, 50)
StartButton.Position = UDim2.new(0, 50, 0, 50)
StartButton.Text = "Start"

StopButton.Size = UDim2.new(0, 100, 0, 50)
StopButton.Position = UDim2.new(0, 50, 0, 110)
StopButton.Text = "Stop"

-- Function to teleport the player to a position and make them float
local function teleportToPosition(targetPosition)
    if humanoidRootPart then
        -- Make the player float by slightly raising the HumanoidRootPart
        humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 2, 0))  -- Teleport 2 studs higher for float effect
        wait(0.2)  -- Wait for 0.2 seconds to allow the teleport to happen
        humanoidRootPart.CFrame = CFrame.new(targetPosition)  -- Then move to the actual target position
    end
end

-- Function to spawn a block under the position (except for the end chest)
local function spawnBlockBelow(position)
    local block = Instance.new("Part")
    block.Size = Vector3.new(4, 1, 4)  -- Size of the block
    block.Position = position - Vector3.new(0, 2, 0)  -- Position it 2 studs lower than the target position
    block.Anchored = true
    block.CanCollide = true
    block.Color = Color3.fromRGB(255, 0, 0)  -- Color for visibility (you can change it)
    block.Parent = workspace
end

-- Function to start the teleporting and block spawning sequence
local function startFarming()
    running = true
    while running do
        -- Teleport through the stages
        for i, pos in ipairs(positions) do
            -- Spawn a block below the position, but not for the end chest
            if i < #positions then
                spawnBlockBelow(pos)
            end
            
            teleportToPosition(pos)
            wait(0.2)  -- Wait 0.2 seconds at each position before moving to the next
        end
        wait(2)  -- Wait 2 seconds before restarting the loop after reaching the end chest
    end
end

-- Start and stop buttons for the GUI
StartButton.MouseButton1Click:Connect(function()
    if not running then
        startFarming()
    end
end)

StopButton.MouseButton1Click:Connect(function()
    running = false
end)

-- Anti-AFK script to prevent the player from being idle
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
