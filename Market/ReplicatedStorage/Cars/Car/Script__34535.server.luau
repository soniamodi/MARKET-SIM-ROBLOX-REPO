
local hitBox = script:WaitForChild("HitBox")
local debounceTime = 2 
local touchedPlayers = {} 
local audio = script:WaitForChild("Sound")




local function onTouch(hit)
	if hit.Parent:FindFirstChildOfClass("Humanoid") then

		local character = hit.Parent
		local humanoid = character.Humanoid
		if humanoid ==nil then
			return
		end
		local player = game.Players:GetPlayerFromCharacter(character)
		if humanoid and player then

			if touchedPlayers[player] then return end
			touchedPlayers[player] = true
			print(player.Name)

			audio:Play()
			local bodyVelocity = Instance.new("BodyVelocity")
			humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
			bodyVelocity.Velocity = Vector3.new(math.random(-200,200), 200, math.random(-200,200))
			bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bodyVelocity.Parent = character.PrimaryPart
			game:GetService("Debris"):AddItem(bodyVelocity, 0.5)

			if math.random(1,10) <= 5 then
				humanoid.Health = 0
			else
				humanoid.Health = humanoid.Health / 2
			end

			task.delay(debounceTime, function()
				touchedPlayers[player] = nil
			end)
		end
	end
end

hitBox.Touched:Connect(onTouch)
