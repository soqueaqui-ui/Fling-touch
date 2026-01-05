local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingModernoGui"
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
local tool = nil

-- SEGURANÇA MÁXIMA: Mantém você estável 
runService.Heartbeat:Connect(function()
    if ativado and character:FindFirstChild("HumanoidRootPart") then
        local root = character.HumanoidRootPart
        -- Mantém sua velocidade angular em 0 para você nunca girar
        root.RotVelocity = Vector3.new(0, 0, 0)
        -- Impede que forças externas te joguem longe
        if root.Velocity.Magnitude > 50 then
            root.Velocity = root.Velocity.Unit * 10
        end
    end
end)

local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "BugFisica"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(5, 5, 5) -- Área maior para tocar antes de ser repelido
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= character then
            -- Aplica a velocidade de "Empurrão Legal"
            local direcao = (targetRoot.Position - character.HumanoidRootPart.Position).Unit
            
            -- O "Soco" de física
            targetRoot.Velocity = (direcao * 110) + Vector3.new(0, 40, 0)
            
            -- Cria o efeito de giro engraçado no alvo
            local bv = Instance.new("BodyAngularVelocity")
            bv.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bv.AngularVelocity = Vector3.new(0, 80, 0) -- Giro suave e engraçado
            bv.Parent = targetRoot
            game.Debris:AddItem(bv, 0.1)
        end
    end)
    return t
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "FLING: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        tool = criarTool()
        tool.Parent = player.Backpack
    else
        button.Text = "FLING: DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if tool then tool:Destroy() end
    end
end)        
