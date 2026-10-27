local cars = {
	script.Parent:WaitForChild("car1"),
	script.Parent:WaitForChild("car2")
}

local screenWidth = game:GetService("Workspace").CurrentCamera.ViewportSize.X

while true do
	wait()
	for i, car in ipairs(cars) do
		if car.AbsolutePosition.X <-50 then

			local screenWidth = game:GetService("Workspace").CurrentCamera.ViewportSize.X

			car.Position = UDim2.new(0, screenWidth, car.Position.Y.Scale, 0)
		else
			car.Position = car.Position - UDim2.new(0, 2, 0, 0)
		end
	end
end
