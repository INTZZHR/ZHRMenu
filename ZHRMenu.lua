-- Serviços
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
mainFrame.Size = UDim2.new(0, 250, 0, 260)
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
local healthEnabled = false
local running = true

-- Botões
local btnGolf = createButton("Golf Script", 35)
local btnObby = createButton("Obby Script", 80)
local btnParkour = createButton("Parkour Script", 125)
local btnHealth = createButton("Health Check", 170)

-- Botão destruir
local btnDestroy = Instance.new("TextButton")
btnDestroy.Size = UDim2.new(1, -20, 0, 40)
btnDestroy.Position = UDim2.new(0, 10, 0, 215)
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

btnDestroy.MouseButton1Click:Connect(function()
    running = false
    screenGui:Destroy()
end)

-- Inicializa globais
_G.golfEnabled = golfEnabled
_G.obbyEnabled = obbyEnabled
_G.parkourEnabled = parkourEnabled
_G.healthEnabled = healthEnabled

-- Scripts específicos
spawn(function()
    while running do
        if _G.golfEnabled then
            -- conteúdo igual ao original para o Golf
        end

        if _G.obbyEnabled then
            -- conteúdo igual ao original para o Obby
        end

        if _G.parkourEnabled then
            -- conteúdo igual ao original para o Parkour
        end

        wait(1)
    end
end)

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
