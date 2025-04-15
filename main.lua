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

-- Move GUI with drag
local dragging = false
local dragInput, startPos, startSize

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        startPos = input.Position
        startSize = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - startPos
        Frame.Position = startSize + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
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

-- Teleport to Finish Button with Random Delay to Avoid Detection
local teleportBtn = Instance.new("TextButton", Frame)
teleportBtn.Text = "Teleport to Finish"
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 120)
teleportBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 14

teleportBtn.MouseButton1Click:Connect(function()
    -- Add random delay to avoid detection
    wait(math.random(1, 3))  -- Random delay between 1 to 3 seconds before teleporting
    -- Coordinates for finish line
    hrp.CFrame = CFrame.new(Vector3.new(-339.12, 10.00, 553.27))  -- Adjusted Y to 10
end)

-- Resize GUI
local resizeBtn = Instance.new("TextButton", Frame)
resizeBtn.Text = "Resize"
resizeBtn.Size = UDim2.new(1, -20, 0, 30)
resizeBtn.Position = UDim2.new(0, 10, 0, 160)
resizeBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
resizeBtn.TextColor3 = Color3.new(1, 1, 1)
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.TextSize = 14

resizeBtn.MouseButton1Click:Connect(function()
    -- Resize GUI
    Frame.Size = UDim2.new(0, math.random(150, 300), 0, math.random(150, 250))
end)

-- Add random delay to reset detection behavior
wait(math.random(5, 10))  -- Wait before resetting the script or before taking any further actions
