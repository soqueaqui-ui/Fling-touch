local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlingFixGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 45)
button.Position = UDim2.new(0.5, -75, 0.05, 0)
button.Text = "FLING: DESLIGADO"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16
button.Parent = screenGui
Instance.new("UICorner", button)

local ativado = false

local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "EmpurraoEstavel"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(4, 4, 4)
    handle.Transparency = 1 
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and target ~= character then
            -- 1. CONGELA VOCÊ (Impede ser jogado pra trás)
            local posAntiga = hrp.CFrame
            hrp.Anchored = true 
            
            -- 2. EMPURRÃO LEGAL (Aplica força no alvo)
            local direcao = (targetRoot.Position - hrp.Position).Unit
            targetRoot.Velocity = (direcao * 100) + Vector3.new(0, 40, 0)
            
            -- Giro engraçado
            local bv = Instance.new("BodyAngularVelocity")
            bv.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bv.AngularVelocity = Vector3.new(0, 50, 0)
            bv.Parent = targetRoot
            game.Debris:AddItem(bv, 0.2)
            
            -- 3. DESCONGELA (Rápido o suficiente para você não notar)
            task.wait(0.1)
            hrp.Anchored = false
            hrp.CFrame = posAntiga -- Garante que você não saiu do lugar
        end
    end)
    return t
end

button.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        button.Text = "FLING: ATIVO"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        local tool = criarTool()
        tool.Parent = player.Backpack
    else
        button.Text = "FLING: DESLIGADO"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        local t = player.Backpack:FindFirstChild("EmpurraoEstavel") or character:FindFirstChild("EmpurraoEstavel")
        if t then t:Destroy() end
    end
end)            
