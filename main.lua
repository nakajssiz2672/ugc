-- Anti-Cheat Bypass Script (Flying + Environmental Detection)

local teleportLocation = Vector3.new(-339.12, 10, 553.27)  -- Your teleport coordinates
local flySpeed = 50  -- Speed at which the player flies (adjust as needed)
local flyHeight = 50  -- Height to fly at (you can adjust this)
local teleportDelay = 2  -- Time in seconds before teleportation starts
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
                -- Avoid kill part by moving away
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

-- Function to fly smoothly to the destination without falling
local function flyToDestination()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)  -- Allow movement in all directions
    bodyVelocity.Velocity = Vector3.new(0, flyHeight, 0)  -- Keep a constant height while flying
    bodyVelocity.Parent = rootPart

    -- Fly towards the target location
    local direction = (teleportLocation - rootPart.Position).unit
    bodyVelocity.Velocity = direction * flySpeed  -- Adjust the speed of flying towards the target

    wait(teleportDelay)  -- Wait before starting the fly movement
    
    -- Smooth flight to the target location
    while (rootPart.Position - teleportLocation).Magnitude > 1 do
        bodyVelocity.Velocity = direction * flySpeed
        wait(0.05)  -- Small delay to keep movement smooth
    end
    
    bodyVelocity:Destroy()  -- Remove the BodyVelocity once the destination is reached
end

-- Main function to initiate the flying and hazard detection
local function main()
    -- Start environmental hazard detection
    spawn(avoidKillParts)

    -- Start flying after the delay
    flyToDestination()
end

main()
