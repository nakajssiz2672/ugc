local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local hum = chr:WaitForChild("Humanoid")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ws = game:GetService("Workspace")
local camera = workspace.CurrentCamera

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UltraStealthGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 250)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- DRAGGABLE GUI

-- Function to create buttons
local function makeButton(txt, y, func)
    local btn = Instance.new("TextButton", frame)
    btn.Text = txt
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(func)
    return btn
end

-- Anti-Anti-Cheat WalkSpeed Spoof
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = function(t, k)
    if t == hum and (k == "WalkSpeed" or k == "JumpPower") then
        return 16
    end
    return oldIndex(t, k)
end

-- Flags
local stealthSpeed = 16
local speedEnabled = false
local infJump = false
local godmode = false

-- Kill Part Check
local function isKillPart(part)
    if not part then return false end
    return part.Name:lower():find("kill") or part.BrickColor == BrickColor.Red()
end

-- Smart Step Teleport
local function smartTeleport(target)
    local steps = 20
    local origin = hrp.Position
    local direction = (target - origin).Unit
    local stepSize = (target - origin).Magnitude / steps

    for i = 1, steps do
        local point = origin + direction * (stepSize * i)
        local ray = Ray.new(hrp.Position, (point - hrp.Position).Unit * 5)
        local hit = ws:FindPartOnRay(ray, chr)
        if isKillPart(hit) then
            warn("KillPart Detected! Stopping teleport.")
            return
        end
        hrp.CFrame = CFrame.new(point)
        task.wait(0.03)
    end
end

-- GUI Buttons
makeButton("Stealth Speed: OFF", 10, function(btn)
    speedEnabled = not speedEnabled
    btn.Text = "Stealth Speed: " .. (speedEnabled and "ON" or "OFF")
end)

makeButton("Infinite Jump: OFF", 50, function(btn)
    infJump = not infJump
    btn.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")
end)

makeButton("Godmode: OFF", 90, function(btn)
    godmode = not godmode
    btn.Text = "Godmode: " .. (godmode and "ON" or "OFF")
end)

makeButton("Smart Teleport", 130, function()
    local point = Vector3.new(-339.12, 10, 553.27) -- Custom destination
    smartTeleport(point)
end)

-- Coordinate Display
local coordLabel = Instance.new("TextLabel", frame)
coordLabel.Position = UDim2.new(0, 10, 0, 180)
coordLabel.Size = UDim2.new(1, -20, 0, 30)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.new(1, 1, 1)
coordLabel.Font = Enum.Font.Gotham
coordLabel.TextSize = 14
coordLabel.Text = "Coords: X: 0 Y: 0 Z: 0"

-- Runtime Behavior
rs.Heartbeat:Connect(function()
    local pos = hrp.Position
    coordLabel.Text = string.format("Coords: X: %.1f Y: %.1f Z: %.1f", pos.X, pos.Y, pos.Z)

    if speedEnabled and hum.MoveDirection.Magnitude > 0 then
        hrp.Velocity = hum.MoveDirection * stealthSpeed
    end

    if godmode and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
end)

uis.JumpRequest:Connect(function()
    if infJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
