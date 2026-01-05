local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingClassicoGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0.5, -80, 0.05, 0)
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
    t.Name = "BugFisica"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(3, 3, 3)
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= player.Character then
            -- Aplica um "tranco" de giro (Método que funciona em jogos antigos)
            local bodyAngular = Instance.new("BodyAngularVelocity")
            bodyAngular.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            -- Velocidade de 150 é o ponto ideal para um empurrão legal sem sumir com o player
            bodyAngular.AngularVelocity = Vector3.new(0, 150, 0) 
            bodyAngular.Parent = targetRoot
            
            -- Empurra um pouco para trás e para cima
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = (targetRoot.Position - player.Character.HumanoidRootPart.Position).Unit * 60 + Vector3.new(0, 25, 0)
            bodyVelocity.Parent = targetRoot
            
            -- Remove as forças rápido para ser apenas um empurrão
            game.Debris:AddItem(bodyAngular, 0.2)
            game.Debris:AddItem(bodyVelocity, 0.2)
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
