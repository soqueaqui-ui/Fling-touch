local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PainelColisao"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "BUG DE COLISÃO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = mainFrame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.45, 0)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = mainFrame

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

-- --- LÓGICA DO "TROPEÇO" ---
local ativado = false

local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "BugColisao"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(4, 4, 4)
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        local humanoid = target:FindFirstChildOfClass("Humanoid")
        
        if targetRoot and humanoid and target ~= character then
            -- 1. FAZ CAIR: Forçar o estado de queda (Tripping)
            humanoid.PlatformStand = true -- Isso faz ele ficar mole e deitar
            
            -- 2. EMPURRÃO: Direção + Força de elevação
            local direcao = (targetRoot.Position - character.HumanoidRootPart.Position).Unit
            targetRoot.Velocity = (direcao * 50) + Vector3.new(0, 30, 0)
            
            -- 3. GIRO DE COLISÃO: Faz ele girar "torto" para deitar no chão
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            -- O segredo está no eixo X e Z para ele capotar
            bav.AngularVelocity = Vector3.new(20, 10, 20) 
            bav.Parent = targetRoot
            
            -- 4. LIMPEZA: Devolve o controle ao player depois de um tempo
            task.delay(0.8, function()
                if humanoid then humanoid.PlatformStand = false end
            end)
            
            game.Debris:AddItem(bav, 0.3)
        end
    end)
    return t
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        local tool = criarTool()
        tool.Parent = player.Backpack
    else
        button.Text = "OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        local t = player.Backpack:FindFirstChild("BugColisao") or character:FindFirstChild("BugColisao")
        if t then t:Destroy() end
    end
end)
