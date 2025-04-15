-- Anti-detection setup with randomness
local function antiDetection()
    if game:GetService("CoreGui"):FindFirstChild("UGCObbyGui") then
        game:GetService("CoreGui"):FindFirstChild("UGCObbyGui"):Destroy()
    end
end

local function randomDelay()
    wait(math.random(1, 3)) -- Random delay between 1 and 3 seconds
end

-- Wait 1 Year for Free UGC - GUI Script with obfuscation and randomness
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- UI Setup with randomized name
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "UGCObbyGui_" .. math.random(1000, 9999)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 200)
Frame.Position = UDim2.new(0, math.random(5, 20), 0, math.random(5, 20))
Frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, math.random(5, 15))

local title = Instance.new("TextLabel", Frame)
title.Text = "UGC Obby Script"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- WalkSpeed Slider with randomized position
local speedSlider = Instance.new("TextButton", Frame)
speedSlider.Text = "Speed: 16"
speedSlider.Size = UDim2.new(1, -20, 0, 30)
speedSlider.Position = UDim2.new(0, math.random(5, 15), 0, math.random(40, 60))
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
    randomDelay() -- Random delay after action
end)

-- Infinite Jump Toggle with random placement
local infJump = false
local infJumpBtn = Instance.new("TextButton", Frame)
infJumpBtn.Text = "Infinite Jump: OFF"
infJumpBtn.Size = UDim2.new(1, -20, 0, 30)
infJumpBtn.Position = UDim2.new(0, math.random(5, 15), 0, math.random(80, 100))
infJumpBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
infJumpBtn.TextColor3 = Color3.new(1, 1, 1)
infJumpBtn.Font = Enum.Font.Gotham
infJumpBtn.TextSize = 14

infJumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    infJumpBtn.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")
    randomDelay() -- Random delay after action
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local char = player.Character
        if char then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

-- Teleport to Finish Button with randomization
local teleportBtn = Instance.new("TextButton", Frame)
teleportBtn.Text = "Teleport to Finish"
teleportBtn.Size = UDim2.new(1, -20, 0, 30)
teleportBtn.Position = UDim2.new(0, math.random(5, 15), 0, math.random(120, 140))
teleportBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 14

teleportBtn.MouseButton1Click:Connect(function()
    -- Replace these with actual finish coordinates
    hrp.CFrame = CFrame.new(Vector3.new(1000, 20, 1000))
    randomDelay() -- Random delay after action
end)

-- Anti-detection loop
while true do
    antiDetection()
    randomDelay() -- Random delay in loop
end
