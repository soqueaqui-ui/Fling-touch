local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StaticPush"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 130)
main.Position = UDim2.new(0.5, -100, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.8, 0, 0, 30)
inputForca.Position = UDim2.new(0.1, 0, 0.35, 0)
inputForca.Text = "10000" -- Força de vibração (precisa ser alta)
inputForca.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 35)
button.Position = UDim2.new(0.1, 0, 0.7, 0)
button.Text = "DESLIGADO"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA ---
local ativado = false

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if ativado then
        button.Text = "LIGADO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

        -- O SEGREDO: Criar uma velocidade que muda tão rápido que você não sai do lugar
        -- mas quem te toca é arremessado pela "vibração"
        task.spawn(function()
            while ativado and task.wait() do
                if root then
                    local forca = tonumber(inputForca.Text) or 10000
                    -- Alterna a velocidade para criar um impacto constante sem movimento
                    root.AngularVelocity = Vector3.new(0, forca, 0)
                    -- Noclip seletivo: apenas enquanto toca no chão para não cair
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        button.Text = "DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)
