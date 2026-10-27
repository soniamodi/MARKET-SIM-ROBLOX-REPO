local ContextActionService = game:GetService("ContextActionService")
local RS = game:GetService("ReplicatedStorage")
local moveEvent = RS:WaitForChild("MoveIt")
local mobileUIClick = RS:WaitForChild("MobileUIClick")
local typeOfMove = "rotate"
local axis = "x"
local player = game.Players.LocalPlayer
local part = player:WaitForChild("MovingPart")
local building = script.Parent:WaitForChild("BuildMode"):WaitForChild("Building")

mobileUIClick.Event:Connect(function(key)
	if not building.Value then return end
	if part then
		if key == "r" then
			print("R key pressed")
			typeOfMove = "rotate"
		elseif key == "x" then
			print("X key pressed")
			axis = "x"
		elseif key == "y" then
			print("Y key pressed")
			axis = "y"
		elseif key == "z" then
			print("Z key pressed")
			axis = "z"
		elseif key == "left" then
			print("J key pressed")
			moveEvent:FireServer(part, typeOfMove, axis, "L")
		elseif key == "right" then
			print("K key pressed")
			moveEvent:FireServer(part, typeOfMove, axis, "R")
		end
	end
end)


local function handleInput(actionName, inputState, inputObject)
	if not building.Value then return end
	if part then
		if inputState == Enum.UserInputState.Begin then
			local key = inputObject.KeyCode
			if key == Enum.KeyCode.R then
				print("R key pressed")
				typeOfMove = "rotate"
			elseif key == Enum.KeyCode.X then
				print("X key pressed")
				axis = "x"
			elseif key == Enum.KeyCode.Y then
				print("Y key pressed")
				axis = "y"
			elseif key == Enum.KeyCode.Z then
				print("Z key pressed")
				axis = "z"
			elseif key == Enum.KeyCode.J then
				print("J key pressed")
				moveEvent:FireServer(part, typeOfMove, axis, "L")
			elseif key == Enum.KeyCode.K then
				print("K key pressed")
				moveEvent:FireServer(part, typeOfMove, axis, "R")
			end
		end
	end
end

ContextActionService:BindAction("HandleInput", handleInput, false, 
	Enum.KeyCode.R, Enum.KeyCode.M, Enum.KeyCode.X, Enum.KeyCode.Y, Enum.KeyCode.Z, Enum.KeyCode.J, Enum.KeyCode.K)
