local RS = game:GetService("ReplicatedStorage")
local ev = RS:WaitForChild("MobileUIClick")
local button = script.Parent

button.MouseButton1Click:Connect(function()
	button.ImageTransparency = 0
	task.wait(0.1)
	button.ImageTransparency = 0.5
	ev:Fire("z")
end)