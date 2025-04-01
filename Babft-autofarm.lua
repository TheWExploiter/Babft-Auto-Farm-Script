local TweenService = game:GetService("TweenService")
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

local tweenSpeed = 150
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

local function isSafePosition(position)
    -- Check if the Y position is above water (adjust the height as needed)
    return position.Y > 0  -- Change this value to better fit your game's safe height
end

local function moveToPosition(targetPosition)
    if humanoidRootPart then
        -- Ensure the position is safe before moving
        if isSafePosition(targetPosition) then
            local tweenInfo = TweenInfo.new((humanoidRootPart.Position - targetPosition).Magnitude / tweenSpeed, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
            tween:Play()

            tween.Completed:Wait()  -- Wait for the tween to complete
        else
            print("Unsafe position detected. Skipping move.")
        end
    end
end

local function startFarming()
    running = true
    while running do
        character = player.Character or player.CharacterAdded:Wait()
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        for _, pos in ipairs(positions) do
            moveToPosition(pos)
            wait(0.2) -- Wait 0.2 seconds at each position before moving to the next
        end
        wait(2) -- Wait 2 seconds before restarting the loop
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
