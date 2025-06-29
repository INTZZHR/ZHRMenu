-- ServiçosAdd commentMore actions
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")
local spawnedEntities = workspace:FindFirstChild("SpawnedEntities")

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UnifiedMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
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
title.Text = "BlueHeater Unified Scripts"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- Helper de botão
local function createButton(text, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = mainFrame
    return btn
end

-- Estados dos scripts
local golfEnabled, obbyEnabled, parkourEnabled = false, false, false
local healthEnabled, orbitalEnabled = false, false
local running = true

-- Botões
local btnGolf = createButton("Golf Script", 35)
local btnObby = createButton("Obby Script", 80)
local btnParkour = createButton("Parkour Script", 125)
local btnHealth = createButton("Health Check", 170)
local btnOrbital = createButton("Orbital Kill", 215)

-- Botão destruir
local btnDestroy = Instance.new("TextButton")
btnDestroy.Size = UDim2.new(1, -20, 0, 40)
btnDestroy.Position = UDim2.new(0, 10, 0, 260)
btnDestroy.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
btnDestroy.Text = "Destruir Menu & Parar Tudo"
btnDestroy.TextColor3 = Color3.new(1,1,1)
btnDestroy.TextScaled = true
btnDestroy.Font = Enum.Font.SourceSansBold
btnDestroy.Parent = mainFrame

-- Toggle genérico
local function toggle(btn, flag)
    _G[flag] = not _G[flag]
    local state = _G[flag]
    btn.Text = btn.Text:split(":")[1] .. ": " .. (state and "ON" or "OFF")
    btn.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
end

btnGolf.MouseButton1Click:Connect(function() toggle(btnGolf, "golfEnabled") end)
btnObby.MouseButton1Click:Connect(function() toggle(btnObby, "obbyEnabled") end)
btnParkour.MouseButton1Click:Connect(function() toggle(btnParkour, "parkourEnabled") end)
btnHealth.MouseButton1Click:Connect(function() toggle(btnHealth, "healthEnabled") end)
btnOrbital.MouseButton1Click:Connect(function() toggle(btnOrbital, "orbitalEnabled") end)

btnDestroy.MouseButton1Click:Connect(function()
    running = false
    screenGui:Destroy()
end)

-- Inicializa globais
_G.golfEnabled = golfEnabled
_G.obbyEnabled = obbyEnabled
_G.parkourEnabled = parkourEnabled
_G.healthEnabled = healthEnabled
_G.orbitalEnabled = orbitalEnabled

-----------------------------
-- Scripts específicos
-----------------------------

-- Golf, Obby, Parkour
spawn(function()
    while running do
        if _G.golfEnabled then
            local towerFloors = workspace:FindFirstChild("TowerFloors")
            if towerFloors then
                local golf = towerFloors:FindFirstChild("Golf")
                if golf then
                    for _, mg in ipairs(golf:GetChildren()) do
                        local objs = mg:FindFirstChild("Objects")
                        if objs then
                            local golfBall = objs:FindFirstChild("Golf Ball")
                            local clearPart = objs:FindFirstChild("Clear Part")
                            if golfBall and clearPart and golfBall:IsA("BasePart") and not golfBall.Anchored then
                                for _, c in ipairs(clearPart:GetChildren()) do
                                    if c:IsA("TouchTransmitter") or c:IsA("TouchInterest") then
                                        golfBall.CFrame = CFrame.new(clearPart.Position)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if _G.obbyEnabled then
            local towerFloors = workspace:FindFirstChild("TowerFloors")
            local obby = towerFloors and towerFloors:FindFirstChild("Panel Glass Obby")
            if obby then
                for _, stage in ipairs(obby:GetChildren()) do
                    local objs = stage:FindFirstChild("Objects")
                    local target = objs and objs:FindFirstChild("PlayerCompletedToucher")
                    if target and target:IsA("BasePart") then
                        for _, c in ipairs(target:GetChildren()) do
                            if c:IsA("TouchTransmitter") or c:IsA("TouchInterest") then
                                local root = character:FindFirstChild("HumanoidRootPart")
                                if root then root.CFrame = CFrame.new(target.Position + Vector3.new(0,3,0)) end
                                break
                            end
                        end
                    end
                end
            end
        end

        if _G.parkourEnabled then
            local towerFloors = workspace:FindFirstChild("TowerFloors")
            local parkour = towerFloors and towerFloors:FindFirstChild("Parkour Lava Rise")
            if parkour then
                for _, stage in ipairs(parkour:GetChildren()) do
                    local objs = stage:FindFirstChild("Objects")
                    local target = objs and objs:FindFirstChild("PlayerCompletedToucher")
                    if target and target:IsA("BasePart") then
                        for _, c in ipairs(target:GetChildren()) do
                            if c:IsA("TouchTransmitter") or c:IsA("TouchInterest") then
                                local root = character:FindFirstChild("HumanoidRootPart")
                                if root then root.CFrame = CFrame.new(target.Position + Vector3.new(0,3,0)) end
                                break
                            end
                        end
                    end
                end
            end
        end

        wait(1)
    end
end)

-- Health Check
spawn(function()
    while running do
        wait(0.5)
        if _G.healthEnabled and humanoid and humanoid.Health < humanoid.MaxHealth then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
            end)
        end
    end
end)

-- Orbital Kill
local orbitAngle, orbitTime, lastChange = 0, 0, 0
local currentRadius, currentHeight = 10, 10
local platform = nil
spawn(function()
    while running do
        wait()
        local dt = RunService.RenderStepped:Wait()
        orbitTime += dt

        if _G.orbitalEnabled and spawnedEntities then
            if orbitTime - lastChange >= 1.5 then
                currentRadius = math.random(5,30)
                currentHeight = math.random(5,30)
                lastChange = orbitTime
            end
            orbitAngle += math.rad(180) * dt
            if orbitAngle > math.pi*2 then orbitAngle -= math.pi*2 end

            local closest = nil
            local minDist = math.huge
            for _, e in ipairs(spawnedEntities:GetChildren()) do
                local ehrp = e:FindFirstChild("HumanoidRootPart")
                if ehrp then
                    local dist = (ehrp.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = ehrp
                    end
                end
            end

            if closest then
                if platform then platform:Destroy() platform=nil end
                local center = closest.Position
                local x = center.X + currentRadius * math.cos(orbitAngle)
                local z = center.Z + currentRadius * math.sin(orbitAngle)
                local y = center.Y + currentHeight
                hrp.CFrame = CFrame.new(Vector3.new(x,y,z))
            else
                if not platform then
                    platform = Instance.new("Part")
                    platform.Size = Vector3.new(10,1,10)
                    platform.Anchored = true
                    platform.CanCollide = true
                    platform.BrickColor = BrickColor.new("Really black")
                    platform.Transparency = 0.3
                    platform.Position = hrp.Position - Vector3.new(0,5,0)
                    platform.Parent = workspace
                end
            end
        else
            if platform then platform:Destroy() platform=nil endAdd commentMore actions
        end
    end
end)
