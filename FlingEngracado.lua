local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingFinal"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 130)
main.Position = UDim2.new(0.5, -100, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.8, 0, 0, 30)
inputForca.Position = UDim2.new(0.1, 0, 0.35, 0)
inputForca.Text = "2500" 
inputForca.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.65, 0)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA ---
local ativado = false
local noclipLoop

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if ativado then
        button.Text = "ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local forca = tonumber(inputForca.Text) or 2500
        local bva = Instance.new("BodyAngularVelocity")
        bva.Name = "FlingForce"
        -- Giro discreto para bugar a colisão do alvo
        bva.AngularVelocity = Vector3.new(0, forca, 0)
        bva.MaxTorque = Vector3.new(0, math.huge, 0)
        bva.P = math.huge
        bva.Parent = root
        
        -- NOCLIP SELETIVO: O SEGREDO PARA NÃO CAIR NO CHÃO
        noclipLoop = RunService.Stepped:Connect(function()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        -- Aqui nós ignoramos o chão e as peças do mapa
                        -- Mas tiramos a colisão para interagir com outros Players
                        part.CanCollide = false 
                    end
                end
            end
        end)
    else
        button.Text = "OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if noclipLoop then noclipLoop:Disconnect() end
        if root and root:FindFirstChild("FlingForce") then
            root.FlingForce:Destroy()
        end
        -- Devolve a colisão ao desligar
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)
