-- Script Fling Touch com Ferramenta Invisível (Ajustado)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingToolGui"
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

-- Função para criar a ferramenta que funcionou nos NPCs
local function criarTool()
    local t = Instance.new("Tool")
    t.Name = " " -- Nome invisível
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(3, 3, 3)
    handle.Transparency = 1 -- Totalmente invisível
    handle.CanCollide = false
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        -- Verifica se é um alvo válido e NÃO é você
        if targetRoot and target ~= player.Character then
            -- Aplica a força apenas no alvo
            local pos = targetRoot.Position
            
            -- Cria o efeito "engraçado" de girar sem atravessar paredes
            local bf = Instance.new("BodyVelocity")
            bf.MaxForce = Vector3.new(1, 1, 1) * 500000
            bf.Velocity = (targetRoot.Position - player.Character.HumanoidRootPart.Position).Unit * 100 + Vector3.new(0, 50, 0)
            bf.Parent = targetRoot
            
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(1, 1, 1) * 500000
            bav.AngularVelocity = Vector3.new(math.random(-100, 100), 500, math.random(-100, 100)) -- Giro engraçado
            bav.Parent = targetRoot
            
            -- Remove a força rápido para evitar o bug de atravessar paredes
            game.Debris:AddItem(bf, 0.2)
            game.Debris:AddItem(bav, 0.2)
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
