local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SilentFling"
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
inputForca.Text = "15000" -- Força de impacto (pode ser alta pois é instantânea)
inputForca.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.65, 0)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA SILENCIOSA ---
local ativado = false

button.MouseButton1Click:Connect(function()
	ativado = not ativado
	local char = plr.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if ativado then
		button.Text = "ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		
		-- Loop de Toque
		task.spawn(function()
			while ativado do
				task.wait()
				if char and root then
					-- Detectar inimigos próximos
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							local targetRoot = p.Character.HumanoidRootPart
							local dist = (root.Position - targetRoot.Position).Magnitude
							
							if dist < 4 then -- Se encostar ou estiver muito perto
								-- O PULO DO GATO: Cria a força por apenas um milésimo de segundo
								local bva = Instance.new("BodyAngularVelocity")
								bva.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
								bva.P = math.huge
								bva.AngularVelocity = Vector3.new(0, tonumber(inputForca.Text) or 15000, 0)
								bva.Parent = root
								
								-- Noclip instantâneo para não seres arremessado de volta
								for _, part in pairs(char:GetDescendants()) do
									if part:IsA("BasePart") then part.CanCollide = false end
								end
								
								task.wait(0.05) -- Tempo da "batida"
								bva:Destroy()
								
								for _, part in pairs(char:GetDescendants()) do
									if part:IsA("BasePart") then part.CanCollide = true end
								end
							end
						end
					end
				end
			end
		end)
	else
		button.Text = "OFF"
		button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	end
end)
