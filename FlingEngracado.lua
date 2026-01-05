-- Player
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EmpurraoGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 170, 0, 45)
button.Position = UDim2.new(0.5, -85, 0.05, 0)
button.Text = "EMPURRÃO: OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16
button.Parent = screenGui

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(0, 10)

-- Variáveis
local ativado = false
local tool

-- Função Empurrão
local function criarTool()
    local tool = Instance.new("Tool")
    tool.Name = "Empurrao"
    tool.RequiresHandle = true
    tool.CanBeDropped = false

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(5,5,5)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = tool

    handle.Touched:Connect(function(hit)
        if not ativado then return end

        local char = hit.Parent
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

        if hum and root and myRoot and char ~= player.Character then
            if char:FindFirstChild("EmpurraoCD") then return end

            local cd = Instance.new("BoolValue", char)
            cd.Name = "EmpurraoCD"
            game.Debris:AddItem(cd, 0.4)

            -- Direção
            local dir = (root.Position - myRoot.Position).Unit

            -- Attachment
            local att = Instance.new("Attachment", root)

            -- Força linear
            local lv = Instance.new("LinearVelocity")
            lv.Attachment0 = att
            lv.MaxForce = math.huge
            lv.VectorVelocity = (dir * 45) + Vector3.new(0, 22, 0)
            lv.Parent = root

            -- Remove força (queda natural)
            task.delay(0.25, function()
                lv:Destroy()
                att:Destroy()
            end)
        end
    end)

    return tool
end

-- Botão
button.MouseButton1Click:Connect(function()
    ativado = not ativado

    if ativado then
        button.Text = "EMPURRÃO: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

        tool = criarTool()
        tool.Parent = player.Backpack
    else
        button.Text = "EMPURRÃO: OFF"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

        if tool then
            tool:Destroy()
            tool = nil
        end
    end
end)
