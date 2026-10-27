local UIS = game:GetService("UserInputService")
sound = script:WaitForChild("Sound")


UIS.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		sound:Play()
	end
end)