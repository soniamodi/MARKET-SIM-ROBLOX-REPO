local UIS = game:GetService("UserInputService")
local WS = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local event = RS:WaitForChild("BuildMode")
local player = game.Players.LocalPlayer
local GUIs = player.PlayerGui
local BuildUI = GUIs:WaitForChild("Building")
local BuildModeBoxGuis = GUIs:WaitForChild("BuildModeBoxGuis")
local gui1 = BuildModeBoxGuis:WaitForChild("BorderIn1")
local gui2 = BuildModeBoxGuis:WaitForChild("BorderIn2")
local gui3 = BuildModeBoxGuis:WaitForChild("BorderIn3")
local gui4 = BuildModeBoxGuis:WaitForChild("BorderIn4")
local gui5 = BuildModeBoxGuis:WaitForChild("BorderOut1")
local gui6 = BuildModeBoxGuis:WaitForChild("BorderOut2")
local gui7 = BuildModeBoxGuis:WaitForChild("BorderOut3")
local gui8 = BuildModeBoxGuis:WaitForChild("BorderOut4")
local DestroyEvent = RS:WaitForChild("DestroyMode")
local walls = WS:WaitForChild("Walls")
local building = script:WaitForChild("Building")
local destroying = false

local notMobile = UIS.KeyboardEnabled and not UIS.TouchEnabled

if not notMobile then
	BuildUI = GUIs:WaitForChild("MobileBuildGui")
end


local mobileEvent = RS:WaitForChild("MobileUIClick")

mobileEvent.Event:Connect(function(a)
	if(a=="build") then
		if(building.Value == false) then
				print("B pressed")
				building.Value = true
				BuildUI.Enabled= true
				gui1.Enabled = true
				gui2.Enabled = true
				gui3.Enabled = true
				gui4.Enabled = true
				gui5.Enabled = true
				gui6.Enabled = true
				gui7.Enabled = true
				gui8.Enabled = true
				event:FireServer(true)
		else
				print("B pressed")
				building.Value = false
				BuildUI.Enabled= false
				gui1.Enabled = false
				gui2.Enabled = false
				gui3.Enabled = false
				gui4.Enabled = false
				gui5.Enabled = false
				gui6.Enabled = false
				gui7.Enabled = false
				gui8.Enabled = false
				event:FireServer(false)
		end
	end
	
	
	if(a=="destroy") then
		print(building.Value)
		if(building.Value==true) then
			print("Event Fired with on")
			if(destroying == false) then
				print("Event Fired with on")
				destroying = true
				DestroyEvent:FireServer("on")

			else
				print("Event Fired with off")
				destroying = false
				DestroyEvent:FireServer("off")
			end

		end
	end
end)


UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if(building.Value == false) then
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.B then
			print("B pressed")
			building.Value = true
			BuildUI.Enabled= true
			gui1.Enabled = true
			gui2.Enabled = true
			gui3.Enabled = true
			gui4.Enabled = true
			gui5.Enabled = true
			gui6.Enabled = true
			gui7.Enabled = true
			gui8.Enabled = true
			event:FireServer(true)
		end
	else
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.B then
			print("B pressed")
			building.Value = false
			BuildUI.Enabled= false
			gui1.Enabled = false
			gui2.Enabled = false
			gui3.Enabled = false
			gui4.Enabled = false
			gui5.Enabled = false
			gui6.Enabled = false
			gui7.Enabled = false
			gui8.Enabled = false
			event:FireServer(false)
			
			
		end
	end
	if(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.P) then
		print(building.Value)
		if(building.Value==true) then
			print("Event Fired with on")
			if(destroying == false) then
				print("Event Fired with on")
				destroying = true
				DestroyEvent:FireServer("on")
				
			else
				print("Event Fired with off")
				destroying = false
				DestroyEvent:FireServer("off")
			end
			
		end
	end
end)



local value = Instance.new("ObjectValue")
local valueHL = Instance.new("ObjectValue")


game:GetService("RunService").RenderStepped:Connect(function()
	if(building.Value) then
		local target = game.Players.LocalPlayer:GetMouse().Target
		if target then
			local highlight = target:FindFirstChild("Highlight")
			if highlight then
				value.Parent = highlight
				value.Value = highlight
				target.Highlight.Enabled = true
				
				
				if value.Value ~= valueHL.Value then
					if valueHL.Value ~= nil then
						valueHL.Value.Enabled = false
						
					end
				end
				valueHL.Parent = highlight
				valueHL.Value = highlight
			end
			if not highlight then
				if value.Value ~= nil then
					value.Value.Enabled = false
				end
			end
		end	
	end
end)


