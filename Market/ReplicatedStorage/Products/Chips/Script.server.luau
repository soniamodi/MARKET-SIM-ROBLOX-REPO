local product = script.Parent
local isContained = false
local prompt = product:WaitForChild("ProximityPrompt")
local drag = product:WaitForChild("DragDetector")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local updateInv = RS:WaitForChild("UpdateInventory")
local slot = nil
local weld = nil
local debounce = false 

local SNAP_DEBOUNCE_TIME = 0.2 

local PartAtt = Instance.new("Attachment")
PartAtt.Parent = product

local AlignPos = Instance.new("AlignPosition")
AlignPos.Parent = product
AlignPos.Attachment0 = PartAtt
AlignPos.Enabled = false
AlignPos.Responsiveness = 100

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



product.Touched:Connect(function(otherPart)
	if debounce then return end
	if otherPart.Parent and otherPart.Parent.Name == "Slots" and not isContained and otherPart.Value.Value == nil then
		isContained = true
		slot = otherPart
		otherPart.Value.Value = product
		drag.Enabled = false

		product.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		product.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

		product.CFrame = slot.CFrame

		weld = Instance.new("WeldConstraint")
		weld.Part0 = product
		weld.Part1 = slot
		weld.Parent = product

		drag.Enabled = true

		print("Snapped into slot:", slot.Name)
		updateInv:Fire("add", product, slot)
	end
end)

drag.DragStart:Connect(function(player)
	if weld then
		weld:Destroy()
		weld = nil
		isContained = false
		if slot then
			slot.Value.Value = nil
			slot = nil
		end
		updateInv:Fire("remove", product, slot)

		debounce = true
		task.delay(SNAP_DEBOUNCE_TIME, function()
			debounce = false
		end)
	end
	
	product:SetNetworkOwner(player)
	local Att = GetLookAtt(player)

	if Att then
		AlignPos.Attachment1 = Att
		AlignPos.Enabled = true
	end
	
end)





drag.DragContinue:Connect(function(plr:Player, CamRay:Ray, viewFrame:CFrame)
	local Att = GetLookAtt(plr)

	if Att  then
		local y = viewFrame.LookVector.Y
		Att.CFrame = CFrame.new(Vector3.new(0,y*10,-10))
	end

end)

drag.DragEnd:Connect(function(player)
	product:SetNetworkOwnershipAuto()
	AlignPos.Enabled = false
	AlignPos.Attachment1 = nil
end)