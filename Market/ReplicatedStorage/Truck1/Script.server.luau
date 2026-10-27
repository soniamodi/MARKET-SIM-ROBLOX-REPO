local runService = game:GetService("RunService")

local seat = script.Parent.VehicleSeat
local screenpart = script.Parent.SpeedPart
local gui = screenpart:WaitForChild("SurfaceGui")
local textBox = gui:WaitForChild("TextLabel")
local backLeft = script.Parent.BackLeft
local backRight = script.Parent.BackRight

local MAX_SPEED = 60
local MAX_STEER = 30
local WHEEL_RADIUS = 2.6 / 2
local SOUND_MIN_SPEED = 0.6
local SOUND_MAX_SPEED = 1.5
local SOUND_MAX_VELOCITY = MAX_SPEED * WHEEL_RADIUS
local sound = script.Parent:WaitForChild("Sound")
local chassis = script.Parent:WaitForChild("Chassis")

if sound then
	seat:GetPropertyChangedSignal("Occupant"):Connect(function()
		if seat.Occupant then
			sound:Play()
		else
			sound:Stop()
		end
	end)

	runService.Heartbeat:Connect(function()
		local speed = math.abs(chassis.CFrame.LookVector:Dot(chassis.AssemblyLinearVelocity))

		sound.PlaybackSpeed = SOUND_MIN_SPEED + (SOUND_MAX_SPEED - SOUND_MIN_SPEED) * math.min(speed / SOUND_MAX_VELOCITY, 1)
	end)
end


local frontLeft = script.Parent.FrontLeft
local frontRight = script.Parent.FrontRight

local steerAngle = 30
local speed = 60

seat:GetPropertyChangedSignal("Steer"):Connect(function()
	frontLeft.PartB.SteeringConstraint.TargetAngle = steerAngle * seat.Steer
	frontRight.PartB.SteeringConstraint.TargetAngle = steerAngle * seat.Steer
end)

seat:GetPropertyChangedSignal("Throttle"):Connect(function()
	frontLeft.Wheel.WheelConstraint.AngularVelocity = speed * seat.Throttle
	frontRight.Wheel.WheelConstraint.AngularVelocity = speed * -seat.Throttle
	backLeft.Wheel.WheelConstraint.AngularVelocity = speed * seat.Throttle
	backRight.Wheel.WheelConstraint.AngularVelocity = speed * -seat.Throttle
end)

local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function()
	local speed = math.round(seat.Velocity.Magnitude)
	textBox.Text = speed .. " mph"
end)