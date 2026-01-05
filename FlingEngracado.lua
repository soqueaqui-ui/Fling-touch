    local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingTouchSuave"
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

-- Função para criar a ferramenta invisível de empurrão
local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "Empurrao"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2, 2, 2)
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        -- Garante que atinja players e NPCs, mas não você
        if targetRoot and target ~= player.Character then
            -- Força de Impulso (LinearVelocity) - Mais natural que o BodyVelocity
            local attachment = Instance.new("Attachment", targetRoot)
            local force = Instance.new("LinearVelocity", attachment)
            
            force.MaxForce = 100000 -- Força suficiente para players
            force.VectorVelocity = (targetRoot.Position - player.Character.HumanoidRootPart.Position).Unit * 80 + Vector3.new(0, 35, 0)
            force.Attachment0 = attachment
            
            -- Giro leve para o efeito engraçado do vídeo
            local torque = Instance.new("AngularVelocity", attachment)
            torque.MaxTorque = 50000
            torque.AngularVelocity = Vector3.new(math.random(-10, 10), 40, math.random(-10, 10))
            torque.Attachment0 = attachment
            
            -- Remove a força quase instantaneamente para virar um "impulso"
            game.Debris:AddItem(attachment, 0.15)
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
