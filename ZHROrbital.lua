local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")
local spawnedEntities = workspace:WaitForChild("SpawnedEntities")

local running = true
_G.orbitalEnabled = false

local angle = 0
local currentRadius = math.random(5, 30)
local currentHeight = math.random(5, 30)
local lastOscillationChange = 0
local timeElapsed = 0
local platform = nil

-- GUI idêntico ao ZHRMenu
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OrbitalMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 130)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "ZHR Orbital Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local btnOrbital = Instance.new("TextButton")
btnOrbital.Size = UDim2.new(1, -20, 0, 40)
btnOrbital.Position = UDim2.new(0, 10, 0, 35)
btnOrbital.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btnOrbital.Text = "Orbital Script: OFF"
btnOrbital.TextColor3 = Color3.new(1, 1, 1)
btnOrbital.TextScaled = true
btnOrbital.Font = Enum.Font.SourceSansBold
btnOrbital.Parent = mainFrame

local btnDestroy = Instance.new("TextButton")
btnDestroy.Size = UDim2.new(1, -20, 0, 40)
btnDestroy.Position = UDim2.new(0, 10, 0, 80)
btnDestroy.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
btnDestroy.Text = "Destruir Menu & Parar Tudo"
btnDestroy.TextColor3 = Color3.new(1, 1, 1)
btnDestroy.TextScaled = true
btnDestroy.Font = Enum.Font.SourceSansBold
btnDestroy.Parent = mainFrame

-- Toggle orbital
btnOrbital.MouseButton1Click:Connect(function()
    _G.orbitalEnabled = not _G.orbitalEnabled
    btnOrbital.Text = "Orbital Script: " .. (_G.orbitalEnabled and "ON" or "OFF")
    btnOrbital.BackgroundColor3 = _G.orbitalEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
end)

-- Destruir
btnDestroy.MouseButton1Click:Connect(function()
    running = false
    screenGui:Destroy()
end)

-- Loop orbital
spawn(function()
    while running do
        local dt = RunService.RenderStepped:Wait()
        timeElapsed += dt

        local closest = nil
        local minDist = math.huge
        for _, entity in ipairs(spawnedEntities:GetChildren()) do
            local ehrp = entity:FindFirstChild("HumanoidRootPart")
            if ehrp then
                local dist = (ehrp.Position - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = ehrp
                end
            end
        end

        if _G.orbitalEnabled and closest then
            if timeElapsed - lastOscillationChange >= 1.5 then
                currentRadius = math.random(5, 30)
                currentHeight = math.random(5, 30)
                lastOscillationChange = timeElapsed
            end

            angle += math.rad(180) * dt
            if angle > math.pi * 2 then angle -= math.pi * 2 end

            local x = closest.Position.X + currentRadius * math.cos(angle)
            local z = closest.Position.Z + currentRadius * math.sin(angle)
            local y = closest.Position.Y + currentHeight
            hrp.CFrame = CFrame.new(Vector3.new(x, y, z))

            if platform then platform:Destroy() platform = nil end
        else
            if not closest and not platform then
                platform = Instance.new("Part")
                platform.Size = Vector3.new(10, 1, 10)
                platform.Anchored = true
                platform.CanCollide = true
                platform.BrickColor = BrickColor.new("Really black")
                platform.Transparency = 0.3
                platform.Position = hrp.Position - Vector3.new(0, 5, 0)
                platform.Name = "OrbitalPlatform"
                platform.Parent = workspace
            elseif closest and platform then
                platform:Destroy()
                platform = nil
            end
        end
    end
end)
