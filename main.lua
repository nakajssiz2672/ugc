-- Sneaky Bypass GUI Script

local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local hum = chr:WaitForChild("Humanoid")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Bypass flag
local _bypass = true

-- Sneaky WalkSpeed Setter
local function setSpeed(val)
    if _bypass then
        -- Stealthily set WalkSpeed using delay
        task.spawn(function()
            hum:SetAttribute("FakeSpeed", val)
            wait(0.1)
            hum.WalkSpeed = val
        end)
    else
        hum.WalkSpeed = val
    end
end

-- Teleport Spoofing
local function safeTP(pos)
    if _bypass then
        local fake = Instance.new("Part")
        fake.Anchored = true
        fake.Transparency = 1
        fake.Size = Vector3.new(2,2,2)
        fake.CFrame = CFrame.new(pos)
        fake.Parent = workspace

        task.wait(0.1)
        hrp.CFrame = fake.CFrame
        task.wait(0.1)
        fake:Destroy()
    else
        hrp.CFrame = CFrame.new(pos)
    end
end

-- Infinite Jump using State change
local infJump = false
uis.JumpRequest:Connect(function()
    if infJump and chr:FindFirstChildOfClass("Humanoid") then
        chr:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "StealthGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Text = "Bypass Test GUI"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local coordLabel = Instance.new("TextLabel", frame)
coordLabel.Size = UDim2.new(1, -20, 0, 30)
coordLabel.Position = UDim2.new(0, 10, 0, 160)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.new(1, 1, 1)
coordLabel.Font = Enum.Font.Gotham
coordLabel.TextSize = 14
coordLabel.Text = "Coordinates: X: 0 Y: 0 Z: 0"

rs.RenderStepped:Connect(function()
    local p = hrp.Position
    coordLabel.Text = string.format("Coordinates: X: %.2f Y: %.2f Z: %.2f", p.X, p.Y, p.Z)
end)

-- Speed Button
local spdBtn = Instance.new("TextButton", frame)
spdBtn.Text = "Speed: 16"
spdBtn.Size = UDim2.new(1, -20, 0, 30)
spdBtn.Position = UDim2.new(0, 10, 0, 40)
spdBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
spdBtn.TextColor3 = Color3.new(1, 1, 1)
spdBtn.Font = Enum.Font.Gotham
spdBtn.TextSize = 14

local speed = 16
spdBtn.MouseButton1Click:Connect(function()
    speed = speed + 4
    if speed > 100 then speed = 16 end
    setSpeed(speed)
    spdBtn.Text = "Speed: " .. speed
end)

-- Infinite Jump Toggle
local jmpBtn = Instance.new("TextButton", frame)
jmpBtn.Text = "Infinite Jump: OFF"
jmpBtn.Size = UDim2.new(1, -20, 0, 30)
jmpBtn.Position = UDim2.new(0, 10, 0, 80)
jmpBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
jmpBtn.TextColor3 = Color3.new(1, 1, 1)
jmpBtn.Font = Enum.Font.Gotham
jmpBtn.TextSize = 14

jmpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    jmpBtn.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")
end)

-- Teleport Button
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Text = "Teleport to Point"
tpBtn.Size = UDim2.new(1, -20, 0, 30)
tpBtn.Position = UDim2.new(0, 10, 0, 120)
tpBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 14

tpBtn.MouseButton1Click:Connect(function()
    local destination = Vector3.new(-339.12, 10.00, 553.27)
    safeTP(destination)
end)
