local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()

-- --- INTERFACE MODERNA ---
local SysBroker = Instance.new("ScreenGui")
SysBroker.Name = "FlingControl"
SysBroker.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 90)
MainFrame.Position = UDim2.new(0.5, -90, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true -- Você pode arrastar
MainFrame.Parent = SysBroker

local Corner = Instance.new("UICorner", MainFrame)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.3, 0)
ToggleBtn.Text = "FLING: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = MainFrame

Instance.new("UICorner", ToggleBtn)

-- --- LÓGICA DO FLING (BUG DE COLISÃO) ---
local ativado = false

local function aplicarBugFling(targetRoot, targetHum)
    if targetRoot and targetHum then
        -- 1. FAZ CAIR (O personagem "deita" e fica mole)
        targetHum.PlatformStand = true
        
        -- 2. EMPURRÃO CONTROLADO (Direção e força média)
        local direcao = (targetRoot.Position - character.HumanoidRootPart.Position).Unit
        -- 100 de força empurra longe mas não deleta do mapa
        targetRoot.Velocity = (direcao * 100) + Vector3.new(0, 40, 0)
        
        -- 3. GIRO DE COLISÃO (O que causa o "Fling")
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        -- Girar rápido nos eixos X e Z faz ele capotar
        bav.AngularVelocity = Vector3.new(5000, 5000, 5000) 
        bav.Parent = targetRoot
        
        -- Limpeza rápida para o cara não sumir do mapa
        game:GetService("Debris"):AddItem(bav, 0.1)
        
        -- Devolve o controle ao player após 2 segundos
        task.delay(2, function()
            if targetHum then targetHum.PlatformStand = false end
        end)
    end
end

-- Ferramenta de Toque
local function criarTool()
    local t = Instance.new("Tool")
    t.Name = "FlingTouch"
    t.RequiresHandle = true
    t.CanBeDropped = false
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(4, 4, 4) -- Tamanho do toque
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Parent = t
    
    handle.Touched:Connect(function(hit)
        if not ativado then return end
        local target = hit.Parent
        local tRoot = target:FindFirstChild("HumanoidRootPart")
        local tHum = target:FindFirstChildOfClass("Humanoid")
        
        if tRoot and tHum and target ~= character then
            aplicarBugFling(tRoot, tHum)
        end
    end)
    return t
end

ToggleBtn.MouseButton1Click:Connect(function()
    ativado = not ativado
    if ativado then
        ToggleBtn.Text = "FLING: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        criarTool().Parent = plr.Backpack
    else
        ToggleBtn.Text = "FLING: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        local tool = plr.Backpack:FindFirstChild("FlingTouch") or character:FindFirstChild("FlingTouch")
        if tool then tool:Destroy() end
    end
end)            
