-- Script de Empurrão com Interface (GUI)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local backpack = player.Backpack

-- Criando a Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EmpurraoGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.5, -75, 0.1, 0) -- Fica no topo central
button.Text = "Ligar Empurrão"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho inicial
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui

local ativado = false
local tool = nil

-- Função para criar a ferramenta
local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "Empurrar Engraçado"
    t.RequiresHandle = true
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2, 2, 2)
    handle.Transparency = 0.5
    handle.BrickColor = BrickColor.new("Bright blue")
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        local victim = hit.Parent
        local hum = victim:FindFirstChildOfClass("Humanoid")
        local root = victim:FindFirstChild("HumanoidRootPart")
        
        if hum and root and victim ~= player.Character then
            if not victim:FindFirstChild("Empurrado") then
                local tag = Instance.new("BoolValue", victim)
                tag.Name = "Empurrado"
                game.Debris:AddItem(tag, 1)
                
                hum.PlatformStand = true
                local direcao = (root.Position - player.Character.HumanoidRootPart.Position).Unit
                root:ApplyImpulse((direcao + Vector3.new(0, 0.5, 0)) * root.AssemblyMass * 150) -- Força aumentada para 150
                
                task.wait(2)
                hum.PlatformStand = false
            end
        end
    end)
    return t
end

-- Lógica do Botão
button.MouseButton1Click:Connect(function()
    ativado = not ativado
    
    if ativado then
        button.Text = "Empurrão: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Verde
        tool = criarTool()
        tool.Parent = player.Backpack
    else
        button.Text = "Empurrão: DESATIVADO"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho
        if tool then
            tool:Destroy()
            tool = nil
        end
    end
end)
