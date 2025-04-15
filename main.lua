-- Anti-Cheat Bypass Script (Flying + Environmental Detection + Noclip)

local teleportLocation = Vector3.new(-339.12, 10, 553.27)  -- Your teleport coordinates
local flySpeed = 30  -- Flying speed
local teleportDelay = q  -- Time before flying starts
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local primaryPart = character:WaitForChild("PrimaryPart")

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

-- Function to disable collision and make the player noclip through walls
local function enableNoclip()
    -- Disable collision for the character's parts to allow noclip
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Fly to the target location using BodyVelocity
local function flyToDestination()
    -- Create a BodyVelocity to simulate flying
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(500000, 500000, 500000)  -- Ensure it has enough force to move
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)  -- Start with no movement
    bodyVelocity.Parent = rootPart

    -- Function to smoothly fly to the destination
    local function moveSmoothly(targetPosition)
        local direction = (targetPosition - rootPart.Position).unit
        while (rootPart.Position - targetPosition).Magnitude > 1 do
            bodyVelocity.Velocity = direction * flySpeed  -- Fly towards the target with the given speed
            wait(0.03)  -- Smooth flight update
        end
        bodyVelocity:Destroy()  -- Stop flying once the target is reached
    end

    -- Wait before starting to fly
    wait(teleportDelay)

    -- Start flying to the target location
    moveSmoothly(teleportLocation)
end

-- Main function to initiate flying, noclip, and hazard detection
local function main()
    -- Enable noclip so the player can go through walls
    enableNoclip()

    -- Start environmental hazard detection
    spawn(avoidKillParts)

    -- Start flying after the delay
    flyToDestination()
end

main()
