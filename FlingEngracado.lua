-- Script Fling Touch Ultra (Método de Vibração de Física)
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraFlingGui"
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
local flingConnection = nil

-- Lógica de Fling por Vibração (Mais difícil de bloquear)
local function startFling()
    flingConnection = runService.Heartbeat:Connect(function()
        if not ativado or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local root = player.Character.HumanoidRootPart
        local oldVelocity = root.Velocity
        
        -- Cria uma velocidade "fantasma" que o motor de física usa para arremessar outros
        root.Velocity = oldVelocity + Vector3.new(0, 5000, 0) -- Força vertical invisível
        
        runService.RenderStepped:Wait() -- Sincroniza com o frame do jogo
        root.Velocity = oldVelocity -- Restaura a velocidade original para você não voar
    end)
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "FLING: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        if not flingConnection then startFling() end
    else
        button.Text = "FLING: DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if flingConnection then
            flingConnection:Disconnect()
            flingConnection = nil
        end
    end
end)
