local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingCustom"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 150)
main.Position = UDim2.new(0.5, -100, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "AJUSTE DE FLING"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = main

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.8, 0, 0, 30)
inputForca.Position = UDim2.new(0.1, 0, 0.3, 0)
inputForca.Text = "5000" -- Força padrão (mude aqui)
inputForca.PlaceholderText = "Digite a força..."
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

-- --- LÓGICA ---
local ativado = false
local noclipLoop

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if ativado then
        button.Text = "FLING: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Cria a força baseada no que você digitou
        local forcaDigitada = tonumber(inputForca.Text) or 5000
        
        local bva = Instance.new("BodyAngularVelocity")
        bva.Name = "FlingForce"
        bva.AngularVelocity = Vector3.new(0, forcaDigitada, 0)
        bva.MaxTorque = Vector3.new(0, math.huge, 0)
        bva.P = math.huge
        bva.Parent = root
        
        -- NOCLIP: Essencial para você não ser arremessado de volta
        noclipLoop = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
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
