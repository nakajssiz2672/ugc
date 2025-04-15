local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local hum = chr:WaitForChild("Humanoid")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ws = game:GetService("Workspace")

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PathfinderGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 250)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

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

-- Region3 Kill Detection
local function hasKillInRegion(pos)
    local region = Region3.new(pos - Vector3.new(3, 3, 3), pos + Vector3.new(3, 3, 3))
    local parts = ws:FindPartsInRegion3(region, chr, math.huge)
    for _, part in pairs(parts) do
        if part:IsA("BasePart") then
            local name = part.Name:lower()
            if name:find("kill") or part.BrickColor == BrickColor.Red() or part.Material == Enum.Material.Neon then
                return true
            end
        end
    end
    return false
end

-- Safe Stepping Teleport System
local function smartTeleport(targetPos)
    local steps = 40
    local origin = hrp.Position
    local pathDir = (targetPos - origin).Unit
    local totalDist = (targetPos - origin).Magnitude
    local stepSize = totalDist / steps

    for i = 1, steps do
        local nextPoint = origin + pathDir * (stepSize * i)
        if not hasKillInRegion(nextPoint) then
            hrp.CFrame = CFrame.new(nextPoint)
            task.wait(0.035)
        else
            warn("Kill part detected near step " .. i .. ". Rerouting...")
            local detour = Vector3.new(
                math.random(-10, 10),
                math.random(4, 10),
                math.random(-10, 10)
            )
            local newPoint = nextPoint + detour
            if not hasKillInRegion(newPoint) then
                hrp.CFrame = CFrame.new(newPoint)
                task.wait(0.05)
            else
                warn("Still dangerous, skipping this step.")
            end
        end
    end
end

-- GUI Buttons
makeButton("Teleport Safely", 10, function()
    local target = Vector3.new(-339.12, 10, 553.27) -- Customize this target
    smartTeleport(target)
end)

local coordLabel = Instance.new("TextLabel", frame)
coordLabel.Position = UDim2.new(0, 10, 0, 50)
coordLabel.Size = UDim2.new(1, -20, 0, 30)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.new(1, 1, 1)
coordLabel.Font = Enum.Font.Gotham
coordLabel.TextSize = 14
coordLabel.Text = "Position: X: 0 Y: 0 Z: 0"

rs.Heartbeat:Connect(function()
    local pos = hrp.Position
    coordLabel.Text = string.format("Position: X: %.1f Y: %.1f Z: %.1f", pos.X, pos.Y, pos.Z)
end)
