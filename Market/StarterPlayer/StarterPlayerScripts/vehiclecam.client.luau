local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera


local preferredCameraMode = Enum.CameraMode.LockFirstPerson


local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.Seated:Connect(function(active, seat)
		if active and seat and seat:IsA("VehicleSeat") then
			RunService.RenderStepped:Wait()
			player.CameraMode = preferredCameraMode
			camera.CameraType = Enum.CameraType.Custom
		end
	end)
end

if player.Character then
	onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)
