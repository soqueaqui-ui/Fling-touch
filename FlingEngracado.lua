local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ForcePush"
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 130)
main.Position = UDim2.new(0.5, -100, 0.05, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Active = true
main.Draggable = true
main.Parent = screenGui
Instance.new("UICorner", main)

local inputForca = Instance.new("TextBox")
inputForca.Size = UDim2.new(0.8, 0, 0, 30)
inputForca.Position = UDim2.new(0.1, 0, 0.35, 0)
inputForca.Text = "150" -- Para velocidade linear, valores entre 100 e 500 são ideais
inputForca.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.65, 0)
button.Text = "PUSH: OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE IMPACTO ---
local ativado = false
local conexao

button.MouseButton1Click:Connect(function()
	ativado = not ativado
	local char = plr.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if ativado then
		button.Text = "PUSH: ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

		conexao = RunService.Stepped:Connect(function()
			if char and root then
				-- FORÇA DE IMPACTO: Criamos uma zona de colisão na frente do seu personagem
				local forca = tonumber(inputForca.Text) or 150
				
				-- Procurar players próximos para aplicar a força
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						local tRoot = p.Character.HumanoidRootPart
						local dist = (root.Position - tRoot.Position).Magnitude
						
						if dist < 5 then -- Se estiver perto (5 studs)
							-- Aplica a velocidade diretamente no alvo
							local direcao = (tRoot.Position - root.Position).Unit
							tRoot.Velocity = (direcao * forca) + Vector3.new(0, forca/2, 0)
							
							-- Faz o alvo "deitar" (Bug de física para ele não reagir)
							if p.Character:FindFirstChildOfClass("Humanoid") then
								p.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
								task.delay(0.5, function()
									if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
										p.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
									end
								end)
							end
						end
					end
				end
				
				-- NOCLIP APENAS PARA PLAYERS (Para você não ser barrado por eles)
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
				-- Mantém você no chão (Corrige o erro de cair no mapa)
				root.Velocity = Vector3.new(root.Velocity.X, -0.1, root.Velocity.Z)
			end
		end)
	else
		button.Text = "PUSH: OFF"
		button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
		if conexao then conexao:Disconnect() end
	end
end)
