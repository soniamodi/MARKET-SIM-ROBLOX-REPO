local clouds = {
	script.Parent:WaitForChild("cloud1"),
	script.Parent:WaitForChild("cloud2"),
	script.Parent:WaitForChild("cloud3"),
	script.Parent:WaitForChild("cloud4")
}

local speeds = {1, 2, 2, 1}

local originalSizes = {
	clouds[1].Size,
	clouds[2].Size,
	clouds[3].Size,
	clouds[4].Size
}


while true do
	wait()
	for i, cloud in ipairs(clouds) do
		local screenWidth = game:GetService("Workspace").CurrentCamera.ViewportSize.X
		local screenLength = game:GetService("Workspace").CurrentCamera.ViewportSize.Y / 3

		if cloud.AbsolutePosition.X > screenWidth then
			local scale = math.random() + 0.5
			cloud.Size = UDim2.new(0, originalSizes[i].X.Offset * scale, 0, originalSizes[i].Y.Offset * scale)
			cloud.Position = UDim2.new(0, -cloud.Size.X.Offset, 0, math.random(1, screenLength))
		else
			cloud.Position = cloud.Position + UDim2.new(0, speeds[i], 0, 0)
		end
	end
end
