local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- --- INTERFACE ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GhostFling"
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
inputForca.Text = "5000" -- Ajusta aqui a força
inputForca.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputForca.TextColor3 = Color3.fromRGB(255, 255, 255)
inputForca.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.65, 0)
button.Text = "FLING: OFF"
button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main
Instance.new("UICorner", button)

-- --- LÓGICA DE FÍSICA INVISÍVEL ---
local ativado = false
local noclipLoop
local flingPart

button.MouseButton1Click:Connect(function()
	ativado = not ativado
	local char = plr.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if ativado then
		button.Text = "FLING: ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

		-- CRIAR A PARTE QUE GIRA (Tu ficas parado, ela gira por ti)
		flingPart = Instance.new("Part")
		flingPart.Name = "FlingPart"
		flingPart.Transparency = 1 -- Invisível
		flingPart.Size = Vector3.new(5, 5, 5) -- Área do empurrão
		flingPart.CanCollide = false
		flingPart.Massless = true
		flingPart.Parent = char

		local bva = Instance.new("BodyAngularVelocity")
		bva.AngularVelocity = Vector3.new(0, tonumber(inputForca.Text) or 5000, 0)
		bva.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bva.P = math.huge
		bva.Parent = flingPart

		-- Manter a parte colada em ti sem te fazer girar
		noclipLoop = RunService.Stepped:Connect(function()
			if char and root and flingPart then
				flingPart.CFrame = root.CFrame -- A parte fica dentro de ti
				for _, v in pairs(char:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false -- Noclip para não seres arremessado
					end
				end
				-- Trava a tua altura para não caíres no chão
				root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
			end
		end)
	else
		button.Text = "FLING: OFF"
		button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
		if noclipLoop then noclipLoop:Disconnect() end
		if flingPart then flingPart:Destroy() end
	end
end)        
