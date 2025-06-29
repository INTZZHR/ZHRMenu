local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local spawnedEntities = workspace:WaitForChild("SpawnedEntities")

-- CONFIGURAÇÕES
local orbitSpeed = math.rad(180) -- 180 graus/s
local minDistance, maxDistance = 5, 30
local minHeight, maxHeight = 5, 30
local oscillationChangeTime = 1.5

local scriptEnabled = false
local angle = 0
local timeElapsed = 0
local lastOscillationChange = 0
local currentRadius = math.random(minDistance, maxDistance)
local currentHeight = math.random(minHeight, maxHeight)

-- Plataforma (será criada e destruída dinamicamente)
local platform = nil

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyControlGui"
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

    -- Se NÃO houver animal com HRP, criar plataforma
    if not target then
        createPlatform()
    else
        removePlatform()
    end

    if scriptEnabled and target then
        if timeElapsed - lastOscillationChange >= oscillationChangeTime then
            currentRadius = math.random(minDistance, maxDistance)
            currentHeight = math.random(minHeight, maxHeight)
            lastOscillationChange = timeElapsed
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

-- Botão ligar/desligar
buttonToggle.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    if scriptEnabled then
        buttonToggle.Text = "SCRIPT: LIGADO"
        buttonToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        buttonToggle.Text = "SCRIPT: DESLIGADO"
        buttonToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)
