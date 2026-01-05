local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StablePushPro"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 130)
main.Position = UDim2.new(0.5, -100, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.8, 0, 0, 30)
inputForca.Position = UDim2.new(0.1, 0, 0.35, 0)
inputForca.Text = "5000" 
inputForca.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 35)
button.Position = UDim2.new(0.1, 0, 0.7, 0)
button.Text = "ATIVAR"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA INQUEBRÁVEL ---
local ativado = false
local flingPart

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if ativado then
        button.Text = "LIGADO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

        -- Criar o objeto de colisão
        flingPart = Instance.new("Part")
        flingPart.Name = "FlingOrb"
        flingPart.Size = Vector3.new(4, 4, 4)
        flingPart.Transparency = 1
        flingPart.CanCollide = true
        flingPart.Massless = false -- Queremos que ela tenha peso para empurrar
        flingPart.Parent = char
        
        local bva = Instance.new("BodyAngularVelocity")
        bva.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bva.P = math.huge
        bva.AngularVelocity = Vector3.new(0, tonumber(inputForca.Text) or 5000, 0)
        bva.Parent = flingPart

        -- LOOP DE ESTABILIZAÇÃO (O SEGREDO)
        RunService.Stepped:Connect(function()
            if ativado and char and root and flingPart then
                flingPart.CFrame = root.CFrame
                
                -- 1. Zera a velocidade que o impacto tenta te dar
                -- Isso impede que você seja jogado para trás
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                root.RotVelocity = Vector3.new(0, 0, 0) -- Te impede de girar
                
                -- 2. Noclip seletivo para você não bater na sua própria peça
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        button.Text = "ATIVAR"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if flingPart then flingPart:Destroy() end
    end
end)
