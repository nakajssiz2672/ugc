-- Anti-Cheat Bypass Script (Movement + Auto-Teleportation)

local teleportLocation = Vector3.new(-339.12, 10, 553.27)  -- Your teleport coordinates
local teleportDelay = 2  -- Time in seconds before teleportation occurs

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

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

-- Function to teleport to the designated location with smooth animation
local function teleportToDestination()
    local distance = (teleportLocation - character.HumanoidRootPart.Position).magnitude
    local direction = (teleportLocation - character.HumanoidRootPart.Position).unit
    local speed = 50  -- Speed at which teleport occurs (higher = faster)

    for i = 1, distance, speed do
        character:TranslateBy(direction * speed)
        wait(0.05)
    end
end

-- Main script to handle teleportation and environmental detection
local function main()
    -- Start environmental hazard detection
    spawn(avoidKillParts)

    -- Wait for the delay before teleportation happens
    wait(teleportDelay)
    
    -- Teleport player smoothly to the desired position
    teleportToDestination()
end

main()
