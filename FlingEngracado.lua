-- Script Fling Touch Anti-Bug (Você não voa)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingFinalGui"
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

-- SEGURANÇA: Impede que VOCÊ voe ou gire
runService.RenderStepped:Connect(function()
    if ativado and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
    end
end)

local function criarTool()
    local t = Instance.new("Tool")
    t.Name = " "
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
        
        if targetRoot and target ~= player.Character then
            -- Força de arremesso estilo 'Engraçado' (Não atravessa parede fácil)
            local pushForce = Instance.new("BodyVelocity")
            pushForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            pushForce.Velocity = (targetRoot.Position - player.Character.HumanoidRootPart.Position).Unit * 130 + Vector3.new(0, 40, 0)
            pushForce.Parent = targetRoot
            
            local spinForce = Instance.new("BodyAngularVelocity")
            spinForce.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            spinForce.AngularVelocity = Vector3.new(0, 5000, 0) -- Giro para o alvo voar
            spinForce.Parent = targetRoot
            
            game.Debris:AddItem(pushForce, 0.1)
            game.Debris:AddItem(spinForce, 0.1)
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
