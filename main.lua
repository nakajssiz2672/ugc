-- Wait 1 Year for Free UGC - GUI Script
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "UGCObbyGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", Frame)
title.Text = "UGC Obby Script"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Coordinates Display
local coordLabel = Instance.new("TextLabel", Frame)
coordLabel.Size = UDim2.new(1, -20, 0, 30)
coordLabel.Position = UDim2.new(0, 10, 0, 160)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.new(1, 1, 1)
coordLabel.Font = Enum.Font.Gotham
coordLabel.TextSize = 14
coordLabel.Text = "Coordinates: X: 0 Y: 0 Z: 0"

-- Update the coordinate display in real-time
game:GetService("RunService").RenderStepped:Connect(function()
    local position = hrp.Position
    coordLabel.Text = string.format("Coordinates: X: %.2f Y: %.2f Z: %.2f", position.X, position.Y, position.Z)
end)

-- WalkSpeed Slider
local speedSlider = Instance.new("TextButton", Frame)
speedSlider.Text = "Speed: 16"
speedSlider.Size = UDim2.new(1, -20, 0, 30)
speedSlider.Position = UDim2.new(0, 10, 0, 40)
speedSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
speedSlider.TextColor3 = Color3.new(1, 1, 1)
speedSlider.Font = Enum.Font.Gotham
speedSlider.TextSize = 14

local speed = 16
speedSlider.MouseButton1Click:Connect(function()
    speed = speed + 4
    if speed > 100 then speed = 16 end
    player.Character.Humanoid.WalkSpeed = speed
    speedSlider.Text = "Speed: " .. speed
end)

-- Infinite Jump Toggle
local infJump = false
local infJumpBtn = Instance.new("TextButton", Frame)
infJumpBtn.Text = "Infinite Jump: OFF"
infJumpBtn.Size = UDim2.new(1, -20, 0, 30)
infJumpBtn.Position = UDim2.new(0, 10, 0, 80)
infJumpBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
infJumpBtn.TextColor3 = Color3.new(1, 1, 1)
infJumpBtn.Font = Enum.Font.Gotham
infJumpBtn.TextSize = 14

infJumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    infJumpBtn.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local char = player.Character
        if char then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

-- Teleport to Finish Button
local teleportBtn = Instance.new("TextButton", Frame)
teleportBtn.Text = "Teleport to Finish"
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 120)
teleportBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 14

teleportBtn.MouseButton1Click:Connect(function()
    -- Teleporting to the correct finish line coordinates
    hrp.CFrame = CFrame.new(Vector3.new(-339.12, 50.00, 553.27))
end)
