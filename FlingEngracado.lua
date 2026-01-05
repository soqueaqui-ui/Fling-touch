-- Script Fling Touch Definitivo (Rápido e Invisível)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface Simples
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingTouchGui"
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
local flingPart = nil

-- Função principal do Fling
local function toggleFling()
    if ativado then
        -- Cria uma parte invisível que gira muito rápido ao redor de ti
        flingPart = Instance.new("Part")
        flingPart.Name = "FlingPart"
        flingPart.Transparency = 1 -- Totalmente invisível
        flingPart.CanCollide = false
        flingPart.Massless = true
        flingPart.Size = Vector3.new(3, 3, 3)
        flingPart.Parent = character:WaitForChild("HumanoidRootPart")
        
        local weld = Instance.new("Weld", flingPart)
        weld.Part0 = flingPart
        weld.Part1 = character.HumanoidRootPart
        
        local angularV = Instance.new("AngularVelocity", flingPart)
        angularV.MaxTorque = math.huge
        angularV.AngularVelocity = Vector3.new(0, 99999, 0) -- Velocidade extrema para o fling
        angularV.RelativeTo = Enum.RelativeTo.Attachment0
        
        local attachment = Instance.new("Attachment", flingPart)
        angularV.Attachment0 = attachment

        -- Detecta o toque e aplica o arremesso
        flingPart.Touched:Connect(function(hit)
            local target = hit.Parent
            if target:FindFirstChildOfClass("Humanoid") and target ~= character then
                local root = target:FindFirstChild("HumanoidRootPart")
                if root then
                    -- Arremessa o alvo com base no giro
                    root.Velocity = Vector3.new(9999, 9999, 9999) 
                end
            end
        end)
    else
        if flingPart then flingPart:Destroy() end
    end
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "FLING: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        button.Text = "FLING: DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
    toggleFling()
end)
