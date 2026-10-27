local RS = game:GetService("ReplicatedStorage")
local event = RS:WaitForChild("BuildMode")
local DragDetector = script.Parent
local obj = script.Parent.Parent
local ProximityPrompt = obj:WaitForChild("ProximityPrompt")
local DestroyModeEvent = RS:WaitForChild("DestroyMode")
local highlighter = obj:WaitForChild("Highlight")
local destroying = false
local purchaseEvent = RS:WaitForChild("Purchase")
local serverPurchaseEvent = RS:WaitForChild("ServerPurchase")
local fileName = obj.Parent.Name


local PartAtt = Instance.new("Attachment")
PartAtt.Parent = obj

local AlignPos = Instance.new("AlignPosition")
AlignPos.Parent = obj
AlignPos.Attachment0 = PartAtt
AlignPos.Enabled = false
AlignPos.Responsiveness = 100

local AlignOrient = Instance.new("AlignOrientation")
AlignOrient.Parent = obj
AlignOrient.Attachment0 = PartAtt
AlignOrient.Enabled = false
AlignOrient.Responsiveness = 200
AlignOrient.MaxTorque = 10000
AlignOrient.Mode = Enum.OrientationAlignmentMode.OneAttachment
AlignOrient.RigidityEnabled = true


local function GetLookAtt(plr): Attachment?
	local char = plr.Character

	if not char then return end

	local HRP = char:FindFirstChild("HumanoidRootPart")
	if not HRP then return end

	local Att = HRP:FindFirstChild("LookAtt")
	if Att then
		return Att
	end

end




event.OnServerEvent:Connect(function(p,o)
	DragDetector:SetPermissionPolicyFunction(function(player, part)
		if(player == p) then

			if(o) then
				return true
			else
				return false-- or false
			end

		else
			return false

		end
	end)

end)


DestroyModeEvent.OnServerEvent:Connect(function(p, onOrOff)
	if(onOrOff == "on") then
		destroying = true
		DragDetector.Enabled = false
		ProximityPrompt.Enabled = true
		highlighter.OutlineColor = Color3.new(1,0,0)
	else
		destroying = false
		DragDetector.Enabled = true
		ProximityPrompt.Enabled = false
		highlighter.OutlineColor = Color3.new(1,1,1)
	end
end)

local SS = game:GetService("ServerStorage")
local balance = SS:WaitForChild("Balance")

ProximityPrompt.Triggered:Connect(function()
	print("clicking")
	if destroying then
		balance.Value+=obj.Price.Value*0.75
		purchaseEvent:FireAllClients(os.date("%Y-%m-%d"),obj.Name, obj.Price.Value*0.75, "S", balance.Value, fileName)
		serverPurchaseEvent:Fire(fileName, obj.Name, "S","",1)
		obj:Destroy()
	end
end)

local detector = script.Parent
local part = detector.Parent


detector.DragStart:Connect(function(player)
	part.CollisionGroup = "BuildMode"
	for _, obj in ipairs(part:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("UnionOperation") or obj:IsA("MeshPart") then
			obj.CollisionGroup = "BuildMode"
		end
	end

	part.Anchored = false
	player:WaitForChild("MovingPart").Value = part

	part:SetNetworkOwner(player)
	local Att = GetLookAtt(player)

	if Att then
		AlignPos.Attachment1 = Att
		AlignPos.Enabled = true
		AlignOrient.Enabled = true 
	end
end)


detector.DragContinue:Connect(function(plr:Player, CamRay:Ray, viewFrame:CFrame)
	local Att = GetLookAtt(plr)

	if Att  then
		local y = viewFrame.LookVector.Y
		Att.CFrame = CFrame.new(Vector3.new(0,y*10,-10))
	end

end)

local sound = script:WaitForChild("Sound")

detector.DragEnd:Connect(function(player)
	part.CollisionGroup = "BuildMode"
	for _, obj in ipairs(part:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("UnionOperation") or obj:IsA("MeshPart") then
			obj.CollisionGroup = "Default"
		end
	end
	part.CollisionGroup = "Default"

	player:WaitForChild("MovingPart").Value = nil

	part:SetNetworkOwnershipAuto()
	AlignPos.Enabled = false
	AlignPos.Attachment1 = nil
	AlignOrient.Enabled = false 

	while true do
		local touching = part:GetTouchingParts()
		local isTouching = false

		for _, other in ipairs(touching) do
			if (other:IsA("Part") or other:IsA("UnionOperation") or other:IsA("MeshPart")) and other ~= part then
				isTouching = true
				break
			end
		end

		local velocity = part.AssemblyLinearVelocity.Magnitude

		if isTouching and velocity < 5 then
			if(part.Position.X<50 and part.Position.X>-50 and part.Position.Z<50 and part.Position.Z>-50) then
				part.Anchored = true
				sound:Play()
				print("anchored in place")
			end
			break
		end

		task.wait(0.1)
	end
end)





local currentRotation = Vector3.new(0, 0, 0) 

local function Round(number, step)
	return math.floor((number + step / 2) / step) * step
end

local moveEvent = RS:WaitForChild("MoveIt")

moveEvent.OnServerEvent:Connect(function(player, part1, typeOfMove, axis, direction)
	local step = player:WaitForChild("StepMove").Value

	if part1.Value == obj then
		if typeOfMove == "rotate" then
			local x, y, z = currentRotation.X, currentRotation.Y, currentRotation.Z

			obj.AssemblyAngularVelocity = Vector3.new(0,0,0)
			obj.AssemblyLinearVelocity = Vector3.new(0,0,0)

			if axis == "x" then
				if direction == "L" then
					x = (x + step) % 360
				elseif direction == "R" then
					x = (x - step) % 360
				end
			elseif axis == "y" then
				if direction == "L" then
					y = (y + step) % 360
				elseif direction == "R" then
					y = (y - step) % 360
				end
			elseif axis == "z" then
				if direction == "L" then
					z = (z + step) % 360
				elseif direction == "R" then
					z = (z - step) % 360
				end
			end

			x = Round(x, step)
			y = Round(y, step)
			z = Round(z, step)

			currentRotation = Vector3.new(x, y, z)

			obj.CFrame = CFrame.new(obj.Position) *
				CFrame.Angles(math.rad(x), math.rad(y), math.rad(z))

			if AlignOrient.Enabled then
				AlignOrient.CFrame = CFrame.Angles(math.rad(x), math.rad(y), math.rad(z))
			end
		end
	end
end)