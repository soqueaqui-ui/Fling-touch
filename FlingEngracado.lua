local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingPro_V3"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 130)
main.Position = UDim2.new(0.5, -100, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 25)
label.Text = "PODER DO EMPURRÃO"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.Parent = main

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.8, 0, 0, 30)
inputForca.Position = UDim2.new(0.1, 0, 0.35, 0)
inputForca.Text = "2000" -- Valor inicial recomendado
inputForca.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputForca.TextColor3 = Color3.fromRGB(0, 255, 0)
inputForca.Parent = main
Instance.new("UICorner", inputForca)

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 35)
button.Position = UDim2.new(0.1, 0, 0.7, 0)
button.Text = "LIGAR"
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
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
        button.Text = "ATIVADO"
        button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        -- Cria a força de giro invisível
        local forca = tonumber(inputForca.Text) or 2000
        local bva = Instance.new("BodyAngularVelocity")
        bva.Name = "InvisForce"
        bva.AngularVelocity = Vector3.new(0, forca, 0)
        bva.MaxTorque = Vector3.new(0, math.huge, 0)
        bva.P = math.huge
        bva.Parent = root
        
        -- NOCLIP TOTAL: Isso impede que VOCÊ seja empurrado de volta
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
        button.Text = "LIGAR"
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        if noclipLoop then noclipLoop:Disconnect() end
        if root and root:FindFirstChild("InvisForce") then
            root.InvisForce:Destroy()
        end
    end
end)
