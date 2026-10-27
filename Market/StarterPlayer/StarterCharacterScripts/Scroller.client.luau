local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local movingPartValue = player:WaitForChild("MovingPart")

local scrollOffset = 0
local SCROLL_SENSITIVITY = 2

UIS.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		local obj = movingPartValue.Value
		if not obj then return end

		local detector = obj:FindFirstChildWhichIsA("DragDetector")
		if not detector then return end

		local cam = workspace.CurrentCamera
		local dir = cam.CFrame.LookVector
		local delta = input.Position.Z * SCROLL_SENSITIVITY
		scrollOffset += delta

		local pivot = obj:GetPivot()

		obj:PivotTo(pivot + dir * delta)
	end
end)
