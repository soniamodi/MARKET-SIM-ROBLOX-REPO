local Det = script.Parent
local Obj = Det.Parent

local PartAtt = Instance.new("Attachment")
PartAtt.Parent = Obj

local AlignPos = Instance.new("AlignPosition")
AlignPos.Parent = Obj
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

Det.DragStart:Connect(function(plr: Player)
	Obj:SetNetworkOwner(plr)
	local Att = GetLookAtt(plr)

	if Att then
		AlignPos.Attachment1 = Att
		AlignPos.Enabled = true
	end

end)

Det.DragContinue:Connect(function(plr:Player, CamRay:Ray, viewFrame:CFrame)
	local Att = GetLookAtt(plr)

	if Att  then
		local y = viewFrame.LookVector.Y
		Att.CFrame = CFrame.new(Vector3.new(0,y*10,-10))
	end

end)

Det.DragEnd:Connect(function()
	Obj:SetNetworkOwnershipAuto()
	AlignPos.Enabled = false
	AlignPos.Attachment1 = nil
end)

