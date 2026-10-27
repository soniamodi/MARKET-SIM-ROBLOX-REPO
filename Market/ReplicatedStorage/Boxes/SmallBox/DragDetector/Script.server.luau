local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local obj = script.Parent.Parent
local ProximityPrompt = obj:WaitForChild("Sticker"):WaitForChild("ProximityPrompt")
local fileName = obj.File.Value
local ID = obj.ID.Value
local quantity = obj.Quantity.Value
local detector = script.Parent
local part = detector.Parent
local WS = game:GetService("Workspace")
local parts = obj:WaitForChild("Parts")
local Center = parts:WaitForChild("Center")


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
	plr:WaitForChild("MovingPart").Value = part
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

Det.DragEnd:Connect(function(player)
	player:WaitForChild("MovingPart").Value = nil
	Obj:SetNetworkOwnershipAuto()
	AlignPos.Enabled = false
	AlignPos.Attachment1 = nil
end)


ProximityPrompt.Triggered:Connect(function()
	for i = 1, quantity do
		local file = RS:WaitForChild(fileName)
		local item = file:WaitForChild(ID)
		local toWS = item:Clone()
		toWS:PivotTo(CFrame.new(Center.Position + Vector3.new(0, 2, 0)))
		toWS.Parent = WS:WaitForChild(fileName)
		wait(0.05)
	end
	obj:Destroy()
end)