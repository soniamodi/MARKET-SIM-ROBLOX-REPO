local WS = game.Workspace
local cam = WS.CurrentCamera
local locPla = game.Players.LocalPlayer
local locName = locPla.Name
local UserInputService = game.UserInputService
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local mobileUI = ReplicatedStorage:WaitForChild("MobileUIClick")

local Gui = script.Parent

local Screen = WS:WaitForChild("Computer")
local prompt = Screen.Use
local active = Screen.Active
local playerS = Screen.Player
local CamPos = WS.CompCam



prompt.Triggered:Connect(function(player)
	print(player.Name .. " activated the prompt")
	playerS = player.Name
	active.Value = true
	prompt.Enabled = false

	if(playerS==locName) then
		player.Character.HumanoidRootPart.Anchored = true	
		player.CameraMode = Enum.CameraMode.Classic
		cam.CameraType = Enum.CameraType.Scriptable
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		cam.CFrame = CamPos.CFrame


		local humanoid = player.Character:WaitForChild("Humanoid")

		humanoid.Died:Connect(function()
			active.Value = false
			prompt.Enabled = true
			player.Character.HumanoidRootPart.Anchored = false	
			cam.CameraType = Enum.CameraType.Custom
			
		end)


		UserInputService.JumpRequest:Connect(function()
				if(playerS==locName) then
						active.Value = false
						prompt.Enabled = true
						player.Character.HumanoidRootPart.Anchored = false	
						cam.CameraType = Enum.CameraType.Custom

					
				end
				
					
		end)
		
		mobileUI.Event:Connect(function(key)
			if key=="interact" then
				if(playerS==locName) then			
						active.Value = false
						prompt.Enabled = true
						player.Character.HumanoidRootPart.Anchored = false	
						cam.CameraType = Enum.CameraType.Custom
				end
			end
		end)


	end


	
end)