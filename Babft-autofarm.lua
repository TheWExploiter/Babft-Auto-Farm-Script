local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local positions = {
    Vector3.new(-51, 43, -165),
    Vector3.new(-54, 16, 8668),
    Vector3.new(-58, -292, 8725),
    Vector3.new(-56, -356, 9497)
}

local running = false

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local StartButton = Instance.new("TextButton", ScreenGui)
local StopButton = Instance.new("TextButton", ScreenGui)

StartButton.Size = UDim2.new(0, 100, 0, 50)
StartButton.Position = UDim2.new(0, 50, 0, 50)
StartButton.Text = "Start"

StopButton.Size = UDim2.new(0, 100, 0, 50)
StopButton.Position = UDim2.new(0, 50, 0, 110)
StopButton.Text = "Stop"

-- Teleport Movement Function
local function teleportToPosition(targetPosition)
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(targetPosition)
    end
end

local function startFarming()
    running = true
    while running do
        character = player.Character or player.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        for _, pos in ipairs(positions) do
            teleportToPosition(pos)
            wait(2) -- Wait before continuing to next position
        end
        wait(2) -- Wait before restarting
    end
end

StartButton.MouseButton1Click:Connect(function()
    if not running then
        startFarming()
    end
end)

StopButton.MouseButton1Click:Connect(function()
    running = false
end)

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
