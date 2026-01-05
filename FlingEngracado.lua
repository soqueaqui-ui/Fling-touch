local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingWallGui"
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
    t.Name = "FlingAtravessa"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(3, 3, 3)
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Massless = true -- Impede que você seja arrastado
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= character then
            -- VELOCIDADE EXTREMA: O segredo para atravessar paredes
            local direcao = (targetRoot.Position - character.HumanoidRootPart.Position).Unit
            
            -- Aplicando força massiva instantânea
            targetRoot.Velocity = direcao * 5000 + Vector3.new(0, 1000, 0) 
            
            -- Giro ultra-rápido para garantir o bug de colisão
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bav.AngularVelocity = Vector3.new(0, 99999, 0)
            bav.Parent = targetRoot
            
            game.Debris:AddItem(bav, 0.1)
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
        local t = player.Backpack:FindFirstChild("FlingAtravessa") or character:FindFirstChild("FlingAtravessa")
        if t then t:Destroy() end
    end
end)
