local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingLegacyGui"
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

local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "EmpurraoLegal"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(4, 4, 4) -- Área de toque maior para "vencer" a distância do player
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Parent = t
    
    -- O SEGREDO: Faz a ferramenta girar invisivelmente na sua mão
    local bv = Instance.new("AngularVelocity", handle)
    bv.MaxTorque = math.huge
    bv.AngularVelocity = Vector3.new(0, 9999, 0) -- Giro invisível que causa o impacto
    local att = Instance.new("Attachment", handle)
    bv.Attachment0 = att

    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= player.Character then
            -- Aplica uma velocidade direta para vencer a resistência do player
            local direcao = (targetRoot.Position - player.Character.HumanoidRootPart.Position).Unit
            targetRoot.Velocity = (direcao * 100) + Vector3.new(0, 40, 0)
            
            -- Adiciona um pequeno giro no alvo para o efeito engraçado
            targetRoot.RotVelocity = Vector3.new(0, 50, 0)
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
