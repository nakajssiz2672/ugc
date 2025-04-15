local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local hum = chr:WaitForChild("Humanoid")
local rs = game:GetService("RunService")
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GhostWalkerV2"

-- Draggable frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 160)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Button creation
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

-- Raycast-based block detection
local function isPathClear(from, to)
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {chr}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	local dir = (to - from)
	local result = workspace:Raycast(from, dir, rayParams)
	if result and result.Instance then
		local part = result.Instance
		local name = part.Name:lower()
		if name:find("kill") or part.BrickColor == BrickColor.Red() or part.CanCollide then
			return false
		end
	end
	return true
end

-- Slow walking teleport with obstacle avoidance
local function ghostWalk(target)
	local steps = 100
	local origin = hrp.Position
	local dir = (target - origin).Unit
	local dist = (target - origin).Magnitude
	local stepDist = dist / steps

	for i = 1, steps do
		local nextPos = hrp.Position + dir * stepDist
		if isPathClear(hrp.Position, nextPos) then
			hrp.CFrame = CFrame.new(nextPos)
		else
			-- Try reroute (up, left, right)
			local offsets = {
				Vector3.new(3, 0, 0),
				Vector3.new(-3, 0, 0),
				Vector3.new(0, 3, 0),
				Vector3.new(0, -3, 0),
				Vector3.new(0, 0, 3),
				Vector3.new(0, 0, -3),
			}
			local rerouted = false
			for _, offset in pairs(offsets) do
				local reroutePos = nextPos + offset
				if isPathClear(hrp.Position, reroutePos) then
					hrp.CFrame = CFrame.new(reroutePos)
					rerouted = true
					break
				end
			end
			if not rerouted then
				warn("No clear path, skipping step")
			end
		end
		task.wait(0.08)
	end
end

-- Button action
makeButton("Safe Travel to Point", 10, function()
	local destination = Vector3.new(-339.12, 10, 553.27) -- Replace with your target
	ghostWalk(destination)
end)

-- Live position
local label = Instance.new("TextLabel", frame)
label.Position = UDim2.new(0, 10, 0, 120)
label.Size = UDim2.new(1, -20, 0, 30)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.Gotham
label.TextSize = 14
rs.RenderStepped:Connect(function()
	local p = hrp.Position
	label.Text = ("Position: X %.1f Y %.1f Z %.1f"):format(p.X, p.Y, p.Z)
end)
