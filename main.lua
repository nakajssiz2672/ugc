-- Generic GUI Script with Bypassable Anti-Cheat

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Bypass Toggle (set this to true to skip anti-cheat detection)
local bypassAntiCheat = true

-- Anti-Cheat Monitor
if not bypassAntiCheat then
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed > 32 then
            player:Kick("Speed hack detected!")
        end
    end)

    local lastPos = hrp.Position
    game:GetService("RunService").Heartbeat:Connect(function()
        local distance = (hrp.Position - lastPos).Magnitude
        if distance > 50 then
            player:Kick("Teleport hack detected!")
        end
        lastPos = hrp.Position
    end)
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "CustomGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", Frame)
title.Text = "Custom Script Controls"
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

-- Teleport to Custom Point Button
local teleportBtn = Instance.new("TextButton", Frame)
teleportBtn.Text = "Teleport to Point"
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 120)
teleportBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 14

teleportBtn.MouseButton1Click:Connect(function()
    local customPoint = Vector3.new(-339.12, 10.00, 553.27)
    hrp.CFrame = CFrame.new(customPoint)
end)

-- GUI Resizer Buttons
local smallerBtn = Instance.new("TextButton", Frame)
smallerBtn.Text = "-"
smallerBtn.Size = UDim2.new(0, 30, 0, 30)
smallerBtn.Position = UDim2.new(0, 10, 0, 10)
smallerBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
smallerBtn.TextColor3 = Color3.new(1, 1, 1)
smallerBtn.Font = Enum.Font.Gotham
smallerBtn.TextSize = 18

local largerBtn = Instance.new("TextButton", Frame)
largerBtn.Text = "+"
largerBtn.Size = UDim2.new(0, 30, 0, 30)
largerBtn.Position = UDim2.new(0, 50, 0, 10)
largerBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
largerBtn.TextColor3 = Color3.new(1, 1, 1)
largerBtn.Font = Enum.Font.Gotham
largerBtn.TextSize = 18

local function resizeGui(factor)
    local currentWidth = Frame.Size.X.Offset
    local currentHeight = Frame.Size.Y.Offset
    local newWidth = currentWidth + factor
    local newHeight = currentHeight + factor
    if newWidth >= 150 and newWidth <= 400 then
        Frame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end

smallerBtn.MouseButton1Click:Connect(function()
    resizeGui(-20)
end)

largerBtn.MouseButton1Click:Connect(function()
    resizeGui(20)
end)
 
