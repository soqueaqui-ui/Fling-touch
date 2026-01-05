local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- --- INTERFACE MODERNA ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PainelEmpurrao"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Você pode arrastar o painel
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "CONTROLE DE FÍSICA"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = mainFrame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.45, 0)
button.Text = "ESTADO: DESLIGADO"
button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16
button.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

-- --- LÓGICA DO EMPURRÃO LENTO ---
local ativado = false

local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "ToqueSuave"
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
            -- Força de empurrão bem equilibrada (Suave)
            local direcao = (targetRoot.Position - character.HumanoidRootPart.Position).Unit
            
            -- BodyVelocity cria um movimento mais fluido e menos "bugado"
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(100000, 100000, 100000)
            bv.Velocity = (direcao * 45) + Vector3.new(0, 15, 0) -- Força 45 é bem lenta
            bv.Parent = targetRoot
            
            -- Pequeno giro para tombar o player
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(5000, 5000, 5000)
            bav.AngularVelocity = Vector3.new(0, 10, 0)
            bav.Parent = targetRoot
            
            -- Remove as forças após meio segundo para o player cair naturalmente
            game.Debris:AddItem(bv, 0.5)
            game.Debris:AddItem(bav, 0.5)
        end
    end)
    return t
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "ESTADO: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        local tool = criarTool()
        tool.Parent = player.Backpack
    else
        button.Text = "ESTADO: DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        local t = player.Backpack:FindFirstChild("ToqueSuave") or character:FindFirstChild("ToqueSuave")
        if t then t:Destroy() end
    end
end)
