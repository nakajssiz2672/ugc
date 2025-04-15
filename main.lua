-- Anti-Cheat Bypass Script (Movement + Auto-Teleportation)

local teleportLocation = Vector3.new(-339.12, 10, 553.27)  -- Your teleport coordinates
local teleportDelay = 2  -- Time in seconds before teleportation occurs
local teleportDuration = 2  -- Duration of the smooth teleportation (seconds)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Function to detect and avoid environmental hazards like kill parts
local function avoidKillParts()
    local function checkKillParts()
        local region = Region3.new(character.HumanoidRootPart.Position - Vector3.new(2, 2, 2), character.HumanoidRootPart.Position + Vector3.new(2, 2, 2))
        local partsInRegion = workspace:FindPartsInRegion3(region, character, math.huge)

        for _, part in ipairs(partsInRegion) do
            if part:IsA("BasePart") and part.Name:match("Kill") then
                -- Avoid kill part by stopping movement or teleporting
                humanoid:MoveTo(character.HumanoidRootPart.Position + Vector3.new(5, 0, 0))  -- Move away from the danger
                break
            end
        end
    end

    while true do
        checkKillParts()
        wait(0.1)  -- Check every 0.1 second
    end
end

-- Function to smoothly move to the destination over time
local function moveSmoothly(targetPosition)
    local startPos = rootPart.Position
    local startTime = tick()
    local endTime = startTime + teleportDuration

    while tick() < endTime do
        local alpha = (tick() - startTime) / teleportDuration
        rootPart.CFrame = CFrame.new(startPos:Lerp(targetPosition, alpha))  -- Smoothly move using Lerp
        wait(0.03)  -- Small delay to make the movement smooth
    end

    rootPart.CFrame = CFrame.new(targetPosition)  -- Ensure final position is exact
end

-- Function to initiate teleportation after the delay
local function teleportToDestination()
    wait(teleportDelay)  -- Wait for the initial delay before teleporting
    moveSmoothly(teleportLocation)  -- Move smoothly to the target location
end

-- Main script to handle teleportation and environmental detection
local function main()
    -- Start environmental hazard detection
    spawn(avoidKillParts)

    -- Teleport the player after the specified delay
    teleportToDestination()
end

main()
