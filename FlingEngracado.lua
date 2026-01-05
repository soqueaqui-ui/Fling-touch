-- Script de Empurrão Aleatório por Colisão (Sem Bloco Visível)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Interface (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingAleatorioGui"
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

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

local ativado = false
local tool = nil

-- Função de Arremesso Aleatório
local function criarFling()
    local t = Instance.new("Tool")
    t.Name = " "
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(4, 5, 4) -- Área maior para tocar fácil
    handle.Transparency = 1 -- 100% Invisível (sem bloco azul)
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetHum = target:FindFirstChildOfClass("Humanoid")
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetHum and targetRoot and target ~= player.Character then
            if not target:FindFirstChild("FlingForce") then
                local tag = Instance.new("BoolValue", target)
                tag.Name = "FlingForce"
                game.Debris:AddItem(tag, 0.3) -- Rapidez para tocar em vários seguidos
                
                targetHum.PlatformStand = true
                
                -- Cálculo de direção e força aleatória
                local direcaoBase = (targetRoot.Position - player.Character.HumanoidRootPart.Position).Unit
                local forcaAleatoria = math.random(150, 250) -- Distância legal e variada
                local giroAleatorio = math.random(-50, 50)
                
                -- Aplica o impulso caótico
                targetRoot.Velocity = (direcaoBase + Vector3.new(0, 0.3, 0)) * forcaAleatoria
                targetRoot.RotVelocity = Vector3.new(giroAleatorio, giroAleatorio, giroAleatorio)
                
                task.wait(1.5)
                targetHum.PlatformStand = false
            end
        end
    end)
    return t
end

-- Lógica do Botão
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
