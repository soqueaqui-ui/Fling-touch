local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InvisPush"
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
inputForca.Text = "5000" -- Aqui o valor deve ser alto (ex: 5000)
inputForca.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.65, 0)
button.Text = "LIGAR FLING"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA ---
local ativado = false
local noclipLoop

-- Função para criar a parte invisível que realmente empurra
local function criarFlingPart(char)
    local part = Instance.new("Part")
    part.Name = "FlingPart"
    part.Size = Vector3.new(4, 4, 4)
    part.Transparency = 1
    part.CanCollide = false
    part.Massless = true
    part.Parent = char

    local bva = Instance.new("BodyAngularVelocity")
    bva.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bva.P = math.huge
    bva.Name = "Forca"
    bva.Parent = part
    
    return part
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if ativado then
        button.Text = "ATIVADO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local fPart = criarFlingPart(char)
        
        noclipLoop = RunService.Stepped:Connect(function()
            if char and root and fPart then
                -- Atualiza a força do input
                if fPart:FindFirstChild("Forca") then
                    fPart.Forca.AngularVelocity = Vector3.new(0, tonumber(inputForca.Text) or 5000, 0)
                end
                
                -- Cola a parte invisível em você
                fPart.CFrame = root.CFrame
                
                -- NOCLIP: Mantém você estável sem cair no chão
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        button.Text = "LIGAR FLING"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if noclipLoop then noclipLoop:Disconnect() end
        if char:FindFirstChild("FlingPart") then char.FlingPart:Destroy() end
    end
end)
