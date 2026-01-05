local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- --- INTERFACE DE TESTE ---
local SysBroker = Instance.new("ScreenGui")
SysBroker.Name = "TesteFling"
SysBroker.Parent = game.CoreGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.2, 0)
Button.Text = "TOUCH FLING: OFF"
Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Button.Parent = SysBroker

-- --- PARTE EXTRAÍDA DO SYSTEMBROKEN ---
local FlingToggled = false

-- Esta é a lógica de rotação que estava no seu script
local function CreateFling()
    local Velocity = Instance.new("BodyAngularVelocity")
    Velocity.Name = "Velocity_Asset"
    Velocity.AngularVelocity = Vector3.new(0, 99999, 0) -- Força máxima do seu script
    Velocity.MaxTorque = Vector3.new(0, math.huge, 0)
    Velocity.P = math.huge
    return Velocity
end

Button.MouseButton1Click:Connect(function()
    FlingToggled = not FlingToggled
    if FlingToggled then
        Button.Text = "TOUCH FLING: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- O Fling do SystemBroken funciona através do HumanoidRootPart do seu personagem
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = CreateFling()
            vel.Parent = root
            
            -- Mantém o personagem girando e sem colisão interna para flingar outros
            task.spawn(function()
                while FlingToggled and task.wait() do
                    for _, v in pairs(plr.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
                vel:Destroy()
            end)
        end
    else
        Button.Text = "TOUCH FLING: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)    
