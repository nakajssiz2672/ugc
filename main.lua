-- Anti-Cheat Bypass Script (Flying + Environmental Detection + Noclip)

local teleportLocation = Vector3.new(-339.12, 10, 553.27)  -- Your teleport coordinates
local flySpeed = 50  -- Flying speed
local teleportDelay = 2  -- Time before flying starts
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

-- Function to fly smoothly through walls using BodyPosition
local function flyToDestination()
    -- Create a BodyPosition object to simulate flying
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(500000, 500000, 500000)  -- Ensure enough force to move the character
    bodyPosition.D = 500  -- Damping to smooth out the movement
    bodyPosition.P = 10000  -- Strength of the force applied
    bodyPosition.Parent = rootPart

    -- Function to smoothly fly to the destination
    local function moveSmoothly(targetPosition)
        while (rootPart.Position - targetPosition).Magnitude > 1 do
            bodyPosition.Position = targetPosition  -- Set the target position for smooth flying
            wait(0.03)  -- Update movement every 0.03 seconds
        end
        bodyPosition:Destroy()  -- Stop flying once the target is reached
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
