local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local positions = {
    Vector3.new(-51, 43, -165),   -- Start (teleport here first)
    Vector3.new(-54, 16, 8668),   -- End of All Stages (tween here)
    Vector3.new(-56, -356, 9497)  -- End Chest (teleport here)
}

local tweenSpeed = 150
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

-- Function to move to the target position with tween
local function moveToPosition(targetPosition)
    if humanoidRootPart then
        local tweenInfo = TweenInfo.new((humanoidRootPart.Position - targetPosition).Magnitude / tweenSpeed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
        tween:Play()

        tween.Completed:Wait()  -- Wait for the tween to complete
    end
end

-- Function to start the farming and tweening sequence
local function startFarming()
    running = true
    while running do
        -- Teleport to the start position
        character = player.Character or player.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        humanoidRootPart.CFrame = CFrame.new(positions[1])  -- Teleport to start position
        
        wait(0.5)  -- Small delay after teleport

        -- Tween through the stages
        for i = 2, #positions - 1 do
            moveToPosition(positions[i])
            wait(0.2)  -- Wait 0.2 seconds at each position before moving to the next
        end

        -- Teleport to the end chest
        humanoidRootPart.CFrame = CFrame.new(positions[#positions])  -- Teleport to end chest

        wait(2)  -- Wait 2 seconds before restarting the loop
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
