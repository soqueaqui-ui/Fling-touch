local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingEstabilizado"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 130)
main.Position = UDim2.new(0.5, -110, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.8, 0, 0, 30)
inputForca.Position = UDim2.new(0.1, 0, 0.35, 0)
inputForca.Text = "3000" 
inputForca.PlaceholderText = "Força (Ex: 3000)"
inputForca.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.65, 0)
button.Text = "DESLIGADO"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA CORRIGIDA ---
local ativado = false
local noclipLoop

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if ativado then
        button.Text = "ATIVADO (ESTÁVEL)"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local forca = tonumber(inputForca.Text) or 3000
        
        local bva = Instance.new("BodyAngularVelocity")
        bva.Name = "StableFling"
        -- O SEGREDO: Girar nos eixos X e Z (5000) e manter o Y baixo. 
        -- Isso cria um "turbilhão" de colisão que não te joga pra trás.
        bva.AngularVelocity = Vector3.new(forca, forca, forca)
        bva.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bva.P = math.huge
        bva.Parent = root
        
        -- Noclip Total enquanto estiver ativo para evitar que você voe
        noclipLoop = RunService.Stepped:Connect(function()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        button.Text = "DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if noclipLoop then noclipLoop:Disconnect() end
        if root and root:FindFirstChild("StableFling") then
            root.StableFling:Destroy()
        end
    end
end)        
