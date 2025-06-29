local player = Players.LocalPlayerAdd commentMore actions
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")
local spawnedEntities = workspace:WaitForChild("SpawnedEntities")

-- CONFIGURAÇÕES
local orbitSpeed = math.rad(180) -- 180 graus/s
local minDistance, maxDistance = 5, 30
local minHeight, maxHeight = 5, 30
local oscillationChangeTime = 1.5
local running = true
_G.orbitalEnabled = false

local scriptEnabled = false
local angle = 0
local timeElapsed = 0
local currentRadius = math.random(5, 30)
local currentHeight = math.random(5, 30)
local lastOscillationChange = 0
local currentRadius = math.random(minDistance, maxDistance)
local currentHeight = math.random(minHeight, maxHeight)

-- Plataforma (será criada e destruída dinamicamente)
local timeElapsed = 0
local platform = nil

-- GUI
-- GUI idêntico ao ZHRMenu
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyControlGui"
screenGui.Name = "OrbitalMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local buttonToggle = Instance.new("TextButton")
buttonToggle.Size = UDim2.new(0, 200, 0, 40)
buttonToggle.Position = UDim2.new(0, 20, 0, 20)
buttonToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
buttonToggle.TextColor3 = Color3.new(1, 1, 1)
buttonToggle.Font = Enum.Font.SourceSansBold
buttonToggle.TextSize = 20
buttonToggle.Text = "SCRIPT: DESLIGADO"
buttonToggle.Parent = screenGui

-- Verifica se há algum HumanoidRootPart válido
local function getClosestAnimalHRP()
    local closestHRP = nil
    local shortestDistance = math.huge
    for _, entity in pairs(spawnedEntities:GetChildren()) do
        local entityHRP = entity:FindFirstChild("HumanoidRootPart")
        if entityHRP then
            local dist = (entityHRP.Position - hrp.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestHRP = entityHRP
            end
        end
    end
    return closestHRP
end

-- Cria plataforma embaixo do jogador
local function createPlatform()
    if not platform then
        platform = Instance.new("Part")
        platform.Size = Vector3.new(10, 1, 10)
        platform.Anchored = true
        platform.CanCollide = true
        platform.BrickColor = BrickColor.new("Really black")
        platform.Transparency = 0.3
        platform.Name = "OrbitalPlatform"
        platform.Position = hrp.Position - Vector3.new(0, hrp.Size.Y / 2 + 5, 0)
        platform.Parent = workspace
    end
end

-- Remove a plataforma se ela existir
local function removePlatform()
    if platform then
        platform:Destroy()
        platform = nil
    end
end

-- Loop principal
RunService.Heartbeat:Connect(function(dt)
    timeElapsed += dt

    local target = getClosestAnimalHRP()
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

    -- Se NÃO houver animal com HRP, criar plataforma
    if not target then
        createPlatform()
    else
        removePlatform()
    end
-- Destruir
btnDestroy.MouseButton1Click:Connect(function()
    running = false
    screenGui:Destroy()
end)

    if scriptEnabled and target then
        if timeElapsed - lastOscillationChange >= oscillationChangeTime then
            currentRadius = math.random(minDistance, maxDistance)
            currentHeight = math.random(minHeight, maxHeight)
            lastOscillationChange = timeElapsed
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

        angle += orbitSpeed * dt
        if angle > math.pi * 2 then angle -= math.pi * 2 end

        local center = target.Position
        local x = center.X + currentRadius * math.cos(angle)
        local z = center.Z + currentRadius * math.sin(angle)
        local y = center.Y + currentHeight

        hrp.CFrame = CFrame.new(Vector3.new(x, y, z))
    end
end)
        if _G.orbitalEnabled and closest then
            if timeElapsed - lastOscillationChange >= 1.5 then
                currentRadius = math.random(5, 30)
                currentHeight = math.random(5, 30)
                lastOscillationChange = timeElapsed
            end

-- Botão ligar/desligar
buttonToggle.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    if scriptEnabled then
        buttonToggle.Text = "SCRIPT: LIGADO"
        buttonToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        buttonToggle.Text = "SCRIPT: DESLIGADO"
        buttonToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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
                platform = nilAdd commentMore actions
            end
        end
    end
end)
