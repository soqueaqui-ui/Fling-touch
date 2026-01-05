-- Script Fling Touch: Estilo Engraçado (Sem atravessar paredes)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingTouchFinal"
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

-- Lógica de Fling por Impulso Angular (Causa o efeito engraçado)
runService.Stepped:Connect(function()
    if not ativado or not player.Character then return end
    
    -- Faz o seu personagem "vibrar" para o motor de física
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false -- Evita que você se jogue longe
            part.Velocity = Vector3.new(0, 45, 0) -- Força vertical constante
            part.RotVelocity = Vector3.new(0, 45, 0) -- Giro constante
        end
    end
end)

-- Detecta toque sem precisar de Tool
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart").Touched:Connect(function(hit)
        if ativado and hit.Parent:FindFirstChildOfClass("Humanoid") and hit.Parent ~= player.Character then
            local targetRoot = hit.Parent:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                -- O SEGREDO: Força alta com limite de colisão
                local pos = targetRoot.Position
                targetRoot.Velocity = Vector3.new(math.random(-150, 150), 100, math.random(-150, 150)) -- Força aleatória e engraçada
                targetRoot.RotVelocity = Vector3.new(500, 500, 500) -- Faz o alvo girar muito
            end
        end
    end)
end)

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "FLING: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        button.Text = "FLING: DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)
