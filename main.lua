-- Anti-detection setup
local function antiDetection()
    -- Simple environment check
    if game:GetService("CoreGui"):FindFirstChild("UGCObbyGui") then
        game:GetService("CoreGui"):FindFirstChild("UGCObbyGui"):Destroy()
    end
end

-- Wait 1 Year for Free UGC - GUI Script
local P = game.Players.LocalPlayer
local C = P.Character or P.CharacterAdded:Wait()
local H = C:WaitForChild("HumanoidRootPart")

-- UI Setup
local SG = Instance.new("ScreenGui", game.CoreGui)
SG.Name = "UGCObbyGui"

local F = Instance.new("Frame", SG)
F.Size = UDim2.new(0, 250, 0, 200)
F.Position = UDim2.new(0, 10, 0, 10)
F.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
F.BorderSizePixel = 0

local UIC = Instance.new("UICorner", F)
UIC.CornerRadius = UDim.new(0, 10)

local T = Instance.new("TextLabel", F)
T.Text = "UGC Obby Script"
T.Size = UDim2.new(1, 0, 0, 30)
T.BackgroundTransparency = 1
T.TextColor3 = Color3.new(1, 1, 1)
T.Font = Enum.Font.GothamBold
T.TextSize = 18

-- WalkSpeed Slider
local SS = Instance.new("TextButton", F)
SS.Text = "Speed: 16"
SS.Size = UDim2.new(1, -20, 0, 30)
SS.Position = UDim2.new(0, 10, 0, 40)
SS.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SS.TextColor3 = Color3.new(1, 1, 1)
SS.Font = Enum.Font.Gotham
SS.TextSize = 14

local S = 16
SS.MouseButton1Click:Connect(function()
    S = S + 4
    if S > 100 then S = 16 end
    P.Character.Humanoid.WalkSpeed = S
    SS.Text = "Speed: " .. S
end)

-- Infinite Jump Toggle
local IJ = false
local IJB = Instance.new("TextButton", F)
IJB.Text = "Infinite Jump: OFF"
IJB.Size = UDim2.new(1, -20, 0, 30)
IJB.Position = UDim2.new(0, 10, 0, 80)
IJB.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
IJB.TextColor3 = Color3.new(1, 1, 1)
IJB.Font = Enum.Font.Gotham
IJB.TextSize = 14

IJB.MouseButton1Click:Connect(function()
    IJ = not IJ
    IJB.Text = "Infinite Jump: " .. (IJ and "ON" or "OFF")
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if IJ then
        local C = P.Character
        if C then
            C:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

-- Teleport to Finish Button
local TPB = Instance.new("TextButton", F)
TPB.Text = "Teleport to Finish"
TPB.Size = UDim2.new(1, -20, 0, 30)
TPB.Position = UDim2.new(0, 10, 0, 120)
TPB.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
TPB.TextColor3 = Color3.new(1, 1, 1)
TPB.Font = Enum.Font.GothamBold
TPB.TextSize = 14

TPB.MouseButton1Click:Connect(function()
    -- Replace these with actual finish coordinates
    H.CFrame = CFrame.new(Vector3.new(1000, 20, 1000))
end)

-- Call anti-detection function periodically
while true do
    antiDetection()
    wait(1)
end
