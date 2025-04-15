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
        if distance > 50 then -- suspicious teleport?
            player:Kick("Teleport hack detected!")
        end
        lastPos = hrp.Position
    end)
end

-- UI Setup (unchanged, continue your script here...)
