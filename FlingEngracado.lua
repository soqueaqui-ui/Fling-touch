local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolFling_Final"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 100)
main.Position = UDim2.new(0.5, -100, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
main.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.9, 0, 0, 60)
button.Position = UDim2.new(0.05, 0, 0.2, 0)
button.Text = "TOOL FLING: OFF\n(Equipa um item)"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main

-- --- LÓGICA DE FÍSICA ---
local ativado = false

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    local char = plr.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    
    if ativado then
        if not tool or not tool:FindFirstChild("Handle") then
            ativado = false
            button.Text = "ERRO: SEGURA UM ITEM!"
            task.wait(2)
            button.Text = "TOOL FLING: OFF"
            return
        end

        button.Text = "TOOL FLING: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

        -- Criar a força APENAS no cabo da ferramenta (Handle)
        local handle = tool.Handle
        local bva = Instance.new("BodyAngularVelocity")
        bva.Name = "FlingForce"
        bva.AngularVelocity = Vector3.new(0, 99999, 0) -- Força máxima
        bva.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bva.P = math.huge
        bva.Parent = handle

        -- Noclip para tu não seres afetado pelo giro do teu próprio item
        task.spawn(function()
            while ativado do
                RunService.Stepped:Wait()
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        button.Text = "TOOL FLING: OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") and tool.Handle:FindFirstChild("FlingForce") then
            tool.Handle.FlingForce:Destroy()
        end
    end
end)
