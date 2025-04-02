local Players = game:GetService("Players") local player = Players.LocalPlayer local character = player.Character or player.CharacterAdded:Wait() local humanoidRootPart = character:WaitForChild("HumanoidRootPart") local humanoid = character:WaitForChild("Humanoid") local workspace = game:GetService("Workspace")

local positions = { Vector3.new(-33, 78, 1369), Vector3.new(-28, 75, 2141), Vector3.new(-44, 93, 2908), Vector3.new(-42, 67, 3676), Vector3.new(-32, 63, 4452), Vector3.new(-18, 61, 5223), Vector3.new(-55, 73, 5986), Vector3.new(-55, -356, 9498) }

local running = false

local function teleportToPosition(targetPosition) if humanoidRootPart then humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 2, 0)) wait(0.2) humanoidRootPart.CFrame = CFrame.new(targetPosition) end end

local function spawnBlockBelow(position) local block = Instance.new("Part") block.Size = Vector3.new(4, 1, 4) block.Position = position - Vector3.new(0, 2, 0) block.Anchored = true block.CanCollide = true block.Parent = workspace end

local function startFarming() running = true while running do if humanoid.Health <= 0 then repeat wait(1) character = player.Character or player.CharacterAdded:Wait() humanoidRootPart = character:WaitForChild("HumanoidRootPart") humanoid = character:WaitForChild("Humanoid") until humanoid.Health > 0 end

for i, pos in ipairs(positions) do if i < #positions then spawnBlockBelow(pos) end teleportToPosition(pos) wait(0.2) end end 

end

local endChest = Instance.new("Part") endChest.Size = Vector3.new(4, 1, 4) endChest.Position = Vector3.new(-55, -356, 9498) endChest.Anchored = true endChest.CanCollide = true endChest.Parent = workspace

endChest.Touched:Connect(function(hit) if hit.Parent == character then humanoid.Health = 0 end end)

local VirtualUser = game:GetService("VirtualUser") game:GetService("Players").LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)

startFarming()

