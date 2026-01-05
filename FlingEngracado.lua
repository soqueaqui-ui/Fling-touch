        local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingExpulsionGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 45)
button.Position = UDim2.new(0.5, -75, 0.05, 0)
button.Text = "FLING: DESLIGADO"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16
button.Parent = screenGui
Instance.new("UICorner", button)

local ativado = false

local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "FlingExtremo"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(4, 4, 4) -- Área de toque boa para não precisar "colar" no player
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Massless = true 
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= character then
            -- VELOCIDADE DE EXPULSÃO (Joga para fora do mapa)
            local direcao = (targetRoot.Position - character.HumanoidRootPart.Position).Unit
            
            -- Aplica uma força absurda para garantir que ele saia do mapa
            targetRoot.Velocity = (direcao * 10000) + Vector3.new(0, 5000, 0) 
            
            -- Giro violento para desestabilizar a física do alvo
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bav.AngularVelocity = Vector3.new(10000, 10000, 10000)
            bav.Parent = targetRoot
            
            -- Remove a força logo em seguida (O alvo já vai estar longe)
            game.Debris:AddItem(bav, 0.05)
        end
    end)
    return t
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "FLING: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        local tool = criarTool()
        tool.Parent = player.Backpack
    else
        button.Text = "FLING: DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        local t = player.Backpack:FindFirstChild("FlingExtremo") or character:FindFirstChild("FlingExtremo")
        if t then t:Destroy() end
    end
end)
