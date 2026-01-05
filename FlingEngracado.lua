local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingMedioGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.4, 0)
button.Text = "FLING: OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = mainFrame

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

-- --- LÓGICA DO FLING CONTROLADO ---
local ativado = false

local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "FlingControlado"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(4, 4, 4)
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Massless = true 
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= character then
            -- O SEGREDO DO FLING: Rotação absurda + Velocidade média
            local direcao = (targetRoot.Position - character.HumanoidRootPart.Position).Unit
            
            -- 1. Velocidade de Arremesso (Ajustada para não atravessar o mapa)
            targetRoot.Velocity = (direcao * 150) + Vector3.new(0, 50, 0)
            
            -- 2. Velocidade Angular (Isso é o que faz o efeito "Fling" de bugar a colisão)
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            -- Girando muito rápido em todos os eixos para o jogo "se confundir"
            bav.AngularVelocity = Vector3.new(5000, 5000, 5000) 
            bav.Parent = targetRoot
            
            -- Deixa o efeito agir por pouco tempo para o cara não sumir
            game.Debris:AddItem(bav, 0.15) 
        end
    end)
    return t
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "FLING: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        local tool = criarTool()
        tool.Parent = player.Backpack
    else
        button.Text = "FLING: OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        local t = player.Backpack:FindFirstChild("FlingControlado") or character:FindFirstChild("FlingControlado")
        if t then t:Destroy() end
    end
end)            
