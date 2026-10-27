local prompt = script.Parent
local register = script.Parent.Parent.Parent
local posPart = script.Parent.Parent
local current = register:WaitForChild("Current")

prompt.Triggered:Connect(function(player)
	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	current.Value = player.Name
	print("using register:", player.Name)

	hrp.CFrame = CFrame.new(posPart.Position + Vector3.new(0, 3, 0)) * CFrame.Angles(0, math.rad(posPart.Orientation.Y), 0)

	hrp.Anchored = true
	prompt.Enabled = false
end)



local RS = game:GetService("ReplicatedStorage")
local unanchorEvent = RS:WaitForChild("UnanchorRequest")

unanchorEvent.OnServerEvent:Connect(function(player)
	if current.Value == player.Name then
		local character = player.Character
		if not character then return end

		local hrp = character:FindFirstChild("HumanoidRootPart")
		if character.Name ==current.Value then
			if hrp then
				hrp.Anchored = false
				print(player.Name .. " has left the register.")
				current.Value = "" 
				prompt.Enabled = true
			end
		end
	end
end)
