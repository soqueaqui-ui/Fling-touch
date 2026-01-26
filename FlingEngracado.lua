local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingEstabilizado"
-- SOLUÇÃO PARA NÃO SUMIR AO MORRER:
screenGui.ResetOnSpawn = false 
screenGui.Parent = plr:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 150)
main.Position = UDim2.new(0.5, -100, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.8, 0, 0, 30)
inputForca.Position = UDim2.new(0.1, 0, 0.3, 0)
inputForca.Text = "5000"
inputForca.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputForca.TextColor3 = Color3.fromRGB(0, 255, 0)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.6, 0)
button.Text = "FLING: OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE ANTIDANO DE QUEDA (Exemplo Desastres Naturais) ---
RunService.Stepped:Connect(function()
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        -- Se a velocidade de queda for muito alta, ele estabiliza levemente
        -- Isso evita que o script de dano do jogo detecte o impacto forte
        if root.Velocity.Y < -50 then
            root.Velocity = Vector3.new(root.Velocity.X, -50, root.Velocity.Z)
        end
    end
end)

-- --- LÓGICA DE ESTABILIZAÇÃO TOTAL ---
local ativado = false
local noclipLoop
local alturaFixa = 0

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if ativado and root then
        button.Text = "FLING: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        alturaFixa = root.Position.Y -- Guarda a altura exata de quando ativaste
        local forcaDigitada = tonumber(inputForca.Text) or 5000
        
        local bva = Instance.new("BodyAngularVelocity")
        bva.Name = "FlingForce"
        bva.AngularVelocity = Vector3.new(0, forcaDigitada, 0)
        -- O SEGREDO: Só aplicamos torque no eixo Y (giro), X e Z ficam travados
        bva.MaxTorque = Vector3.new(0, math.huge, 0) 
        bva.P = math.huge
        bva.Parent = root
        
        noclipLoop = RunService.PreSimulation:Connect(function()
            if char and root then
                -- 1. FORÇAR FICAR EM PÉ: Impede o boneco de inclinar para os lados
                root.CFrame = CFrame.new(root.Position.X, alturaFixa, root.Position.Z) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
                
                -- 2. ZERAR VELOCIDADE VERTICAL: Impede de afundar ou voar
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                root.RotVelocity = Vector3.new(0, root.RotVelocity.Y, 0)

                -- 3. NOCLIP SELETIVO
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        button.Text = "FLING: OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if noclipLoop then noclipLoop:Disconnect() end
        if root and root:FindFirstChild("FlingForce") then
            root.FlingForce:Destroy()
        end
    end
end)
