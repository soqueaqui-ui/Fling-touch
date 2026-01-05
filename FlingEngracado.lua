local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FinalPush"
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
inputForca.Text = "5000" -- Força de impacto
inputForca.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 35)
button.Position = UDim2.new(0.1, 0, 0.7, 0)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA ---
local ativado = false
local noclipLoop
local flingPart

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if ativado then
        button.Text = "ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

        -- Cria a peça que realmente vai bater no player
        flingPart = Instance.new("Part")
        flingPart.Name = "FlingPart"
        flingPart.Transparency = 1
        flingPart.Size = Vector3.new(3, 3, 3)
        flingPart.CanCollide = true
        flingPart.Parent = char

        local bva = Instance.new("BodyAngularVelocity")
        bva.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bva.P = math.huge
        bva.AngularVelocity = Vector3.new(0, tonumber(inputForca.Text) or 5000, 0)
        bva.Parent = flingPart

        noclipLoop = RunService.Stepped:Connect(function()
            if char and root and flingPart then
                -- O SEGREDO: A peça fica um pouco à frente do seu corpo
                -- Assim ela bate no inimigo antes dele encostar em você
                flingPart.CFrame = root.CFrame * CFrame.new(0, 0, -1)
                flingPart.Velocity = Vector3.new(99, 99, 99) -- Força extra de colisão

                -- Você não colide com ela, mas o inimigo sim
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                -- Impede que você seja jogado ou caia
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        button.Text = "OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if noclipLoop then noclipLoop:Disconnect() end
        if flingPart then flingPart:Destroy() end
    end
end)
