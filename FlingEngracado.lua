-- Script Fling Real com Limitador de Colisão
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingSeguroGui"
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
    t.Name = " "
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2, 2, 2)
    handle.Transparency = 1 -- Totalmente invisível
    handle.CanCollide = false
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetHum = target:FindFirstChildOfClass("Humanoid")
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= player.Character and myRoot then
            -- 1. Previne que VOCÊ voe junto
            myRoot.Anchored = true 
            
            -- 2. Força de Empurrão (Ajustada para não atravessar paredes)
            local bodyVelocity = Instance.new("BodyVelocity")
            -- Velocidade de 120 é forte mas respeita colisões melhor que 500
            bodyVelocity.Velocity = (targetRoot.Position - myRoot.Position).Unit * 120 + Vector3.new(0, 20, 0) 
            bodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000) -- Força alta, mas não infinita
            bodyVelocity.Parent = targetRoot
            
            -- 3. Giro Controlado (Evita o efeito 'Noclip')
            local bodyAngular = Instance.new("BodyAngularVelocity")
            bodyAngular.AngularVelocity = Vector3.new(0, 3000, 0) -- Giro suficiente para ejetar, mas mantendo colisão
            bodyAngular.MaxTorque = Vector3.new(1000000, 1000000, 1000000)
            bodyAngular.Parent = targetRoot
            
            game.Debris:AddItem(bodyVelocity, 0.15)
            game.Debris:AddItem(bodyAngular, 0.15)
            
            task.wait(0.1)
            myRoot.Anchored = false 
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
