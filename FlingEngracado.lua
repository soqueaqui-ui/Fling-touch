local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE DISCRETA ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingInvisible"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 130)
main.Position = UDim2.new(0.5, -110, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "FLING DISCRETO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = main

local labelInfo = Instance.new("TextLabel")
labelInfo.Size = UDim2.new(1, 0, 0, 20)
labelInfo.Position = UDim2.new(0, 0, 0.25, 0)
labelInfo.Text = "FORÇA (100 a 50000):"
labelInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
labelInfo.BackgroundTransparency = 1
labelInfo.TextSize = 12
labelInfo.Parent = main

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.6, 0, 0, 25)
inputForca.Position = UDim2.new(0.2, 0, 0.45, 0)
inputForca.Text = "3000" 
inputForca.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
inputForca.TextColor3 = Color3.fromRGB(0, 255, 150)
inputForca.Parent = main
Instance.new("UICorner", inputForca)

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 30)
button.Position = UDim2.new(0.1, 0, 0.72, 0)
button.Text = "ATIVAR"
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA DISCRETA ---
local ativado = false
local noclipConn

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if ativado then
        button.Text = "ATIVADO"
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        
        -- Aplica a força de giro
        local forca = tonumber(inputForca.Text) or 3000
        local bva = Instance.new("BodyAngularVelocity")
        bva.Name = "InvisFling"
        -- O segredo: Girar rápido, mas manter o MaxTorque apenas no eixo Y 
        -- para o corpo não inclinar visualmente de forma feia
        bva.AngularVelocity = Vector3.new(0, forca, 0)
        bva.MaxTorque = Vector3.new(0, math.huge, 0)
        bva.P = math.huge
        bva.Parent = root
        
        -- Noclip Seletivo: Mantém colisão nos braços/pernas para empurrar,
        -- mas remove no RootPart para não causar repulsão em você.
        noclipConn = RunService.Stepped:Connect(function()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name == "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        button.Text = "ATIVAR"
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        if noclipConn then noclipConn:Disconnect() end
        if root and root:FindFirstChild("InvisFling") then
            root.InvisFling:Destroy()
        end
    end
end)
