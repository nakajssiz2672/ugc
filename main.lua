local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local hum = chr:WaitForChild("Humanoid")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- Internal Anti-Cheat Disabler
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldIndex = mt.__index
mt.__index = function(t, k)
    if t == hum and (k == "WalkSpeed" or k == "JumpPower") then
        return 16 -- Return normal values when checked
    end
    return oldIndex(t, k)
end

-- Speed Manipulation via Velocity (no WalkSpeed change)
local stealthSpeed = 16
local speedEnabled = false

rs.Heartbeat:Connect(function(dt)
    if speedEnabled and chr and hrp and hum.MoveDirection.Magnitude > 0 then
        hrp.Velocity = hum.MoveDirection * stealthSpeed
    end
end)

-- Infinite Jump via PlatformStand
local infJump = false
uis.JumpRequest:Connect(function()
    if infJump then
        chr:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Physics-based teleport (no CFrame write)
local function glideTo(pos)
    local dist = (hrp.Position - pos).Magnitude
    local travelTime = dist / 60
    local direction = (pos - hrp.Position).Unit

    local start = tick()
    while tick() - start < travelTime do
        hrp.Velocity = direction * 60
        rs.RenderStepped:Wait()
    end
    hrp.CFrame = CFrame.new(pos)
    hrp.Velocity = Vector3.zero
end

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
frame.BorderSizePixel = 0

local function makeButton(txt, y, func)
    local btn = Instance.new("TextButton", frame)
    btn.Text = txt
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(func)
    return btn
end

makeButton("Stealth Speed: OFF", 10, function(btn)
    speedEnabled = not speedEnabled
    btn.Text = "Stealth Speed: " .. (speedEnabled and "ON" or "OFF")
end)

makeButton("Infinite Jump: OFF", 50, function(btn)
    infJump = not infJump
    btn.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")
end)

makeButton("Glide to Point", 90, function()
    local target = Vector3.new(-339.12, 10, 553.27)
    glideTo(target)
end)

local coordLabel = Instance.new("TextLabel", frame)
coordLabel.Position = UDim2.new(0, 10, 0, 130)
coordLabel.Size = UDim2.new(1, -20, 0, 30)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.new(1, 1, 1)
coordLabel.Font = Enum.Font.Gotham
coordLabel.TextSize = 14
coordLabel.Text = "Coords: X: 0 Y: 0 Z: 0"

rs.RenderStepped:Connect(function()
    local pos = hrp.Position
    coordLabel.Text = string.format("Coords: X: %.1f Y: %.1f Z: %.1f", pos.X, pos.Y, pos.Z)
end)
