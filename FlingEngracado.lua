-- Script de Empurrão Físico Engraçado (Colocar dentro de uma Tool)
local tool = script.Parent
local forcaEmpurrao = 80 -- Ajuste a força aqui (80-150 é o ideal)
local duracaoRagdoll = 2 -- Tempo que o jogador fica caído

tool.Touched:Connect(function(hit)
    local character = hit.Parent
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    -- Verifica se atingiu um jogador e se ele já não foi empurrado recentemente
    if humanoid and rootPart and not character:FindFirstChild("Empurrado") then
        
        -- Marcador para evitar empurrões múltiplos
        local tag = Instance.new("BoolValue")
        tag.Name = "Empurrado"
        tag.Parent = character
        game.Debris:AddItem(tag, 1)

        -- Faz o jogador cair (Efeito Ragdoll básico)
        humanoid.PlatformStand = true
        
        -- Cálculo da direção (do atacante para a vítima)
        local meuRoot = tool.Parent:FindFirstChild("HumanoidRootPart")
        if meuRoot then
            local direcao = (rootPart.Position - meuRoot.Position).Unit
            direcao = (direcao + Vector3.new(0, 0.5, 0)).Unit -- Adiciona um pouco de altura

            -- Aplica a força física (Respeita paredes)
            rootPart:ApplyImpulse(direcao * rootPart.AssemblyMass * forcaEmpurrao)

            -- Rotação aleatória engraçada
            rootPart.RotVelocity = Vector3.new(math.random(-20, 20), math.random(-20, 20), math.random(-20, 20))
        end

        -- Devolve o controle ao jogador após o tempo definido
        task.wait(duracaoRagdoll)
        humanoid.PlatformStand = false
    end
end)
