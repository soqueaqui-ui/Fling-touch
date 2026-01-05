
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local backpack = player.Backpack


local tool = Instance.new("Tool")
tool.Name = "Empurrão Engraçado"
tool.RequiresHandle = true


local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 1, 1)
handle.Transparency = 0.5
handle.BrickColor = BrickColor.new("Bright blue")
handle.Parent = tool

tool.Parent = backpack


handle.Touched:Connect(function(hit)
    local victimChar = hit.Parent
    local humanoid = victimChar:FindFirstChildOfClass("Humanoid")
    local rootPart = victimChar:FindFirstChild("HumanoidRootPart")

    if humanoid and rootPart and victimChar ~= character then
        if not victimChar:FindFirstChild("Empurrado") then
            local tag = Instance.new("BoolValue", victimChar)
            tag.Name = "Empurrado"
            game.Debris:AddItem(tag, 1)

            humanoid.PlatformStand = true
            local direcao = (rootPart.Position - character.HumanoidRootPart.Position).Unit
            rootPart:ApplyImpulse((direcao + Vector3.new(0, 0.5, 0)) * rootPart.AssemblyMass * 100)
            
            task.wait(2)
            humanoid.PlatformStand = false
        end
    end
end)
