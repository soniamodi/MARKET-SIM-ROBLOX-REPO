local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	local movingPart = Instance.new("ObjectValue")
	movingPart.Name = "MovingPart"
	movingPart.Value = nil
	movingPart.Parent = player
	
	local step = Instance.new("IntValue")
	step.Name = "StepMove"
	step.Value=45
	step.Parent = player
end)
