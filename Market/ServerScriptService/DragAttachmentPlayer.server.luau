local PlayerServ = game:GetService("Players")

local OffsetVector = Vector3.new(0, 0, -10)

PlayerServ.PlayerAdded:Connect(function(plr: Player)
	plr.CharacterAppearanceLoaded:Connect(function(char: Model)
		local HRP = char:FindFirstChild("HumanoidRootPart")
		
		if HRP then
			local Att = Instance.new("Attachment")
			Att.Parent = HRP
			Att.Name = "LookAtt"
			
			Att.CFrame = CFrame.new(OffsetVector)
		end
	end)
end)