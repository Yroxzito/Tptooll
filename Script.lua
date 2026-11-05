-- == Teleporte Tool (client-side, PC + Mobile) ==
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Cria a Tool no cliente
local tool = Instance.new("Tool")
tool.Name = "Teste"
tool.RequiresHandle = false
tool.CanBeDropped = false
tool.Parent = player:WaitForChild("Backpack")

local equipped = false
local inputConn

tool.Equipped:Connect(function()
    equipped = true
end)

tool.Unequipped:Connect(function()
    equipped = false
end)

-- Escuta toque/clique global
inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end          -- ignora clique em GUI do jogo
    if not equipped then return end
    if not player.Character then return end

    local isClick = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    if not (isClick or isTouch) then return end

    -- Converte posição da tela -> raio no mundo
    local ray = camera:ViewportPointToRay(input.Position.X, input.Position.Y)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { player.Character }

    local result = workspace:Raycast(ray.Origin, ray.Direction * 5000, params)
    if not result then return end

    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
    end
end)
