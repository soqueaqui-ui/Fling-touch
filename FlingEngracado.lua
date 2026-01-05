-- Script Fling Real (Funciona em Jogadores)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RealFlingGui"
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
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

local ativado = false
local tool = nil

local function criarFling()
    local t = Instance.new("Tool")
    t.Name = "Fling Real"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(3, 3, 3)
    handle.Transparency = 1 -- Invisível
    handle.CanCollide = false
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= player.Character then
            -- O segredo para jogadores reais: Força Rotacional Extrema
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(500, 500, 500) -- Joga pra longe
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = targetRoot
            
            local bodyAngular = Instance.new("BodyAngularVelocity")
            bodyAngular.AngularVelocity = Vector3.new(0, 99999, 0) -- Faz girar e bugar a física
            bodyAngular.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyAngular.Parent = targetRoot
            
            game.Debris:AddItem(bodyVelocity, 0.2)
            game.Debris:AddItem(bodyAngular, 0.2)
        end
    end)
    return t
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "FLING: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        tool = criarFling()
        tool.Parent = player.Backpack
    else
        button.Text = "FLING: DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if tool then tool:Destroy() end
    end
end)
