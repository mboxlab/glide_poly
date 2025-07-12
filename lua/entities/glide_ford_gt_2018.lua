AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Ford GT 2018"

ENT.GlideCategory = "Poly - Sport"
ENT.ChassisModel = "models/simpoly/ford_gt_2018.mdl"

function ENT:GetFirstPersonOffset(_, localEyePos)
	localEyePos[1] = localEyePos[1] + 8
	localEyePos[3] = localEyePos[3] + 5
	return localEyePos
end

if CLIENT then
	ENT.CameraOffset = Vector(-240, 0, 50)
	ENT.CameraCenterOffset = Vector(0, 0, 20)
	ENT.HornSound = "glide/horns/car_horn_med_9.wav"

	ENT.EngineSmokeMaxZVel = 5
	ENT.ExhaustOffsets = {{pos = Vector(-100, -4, 28)}, {pos = Vector(-100, 4, 28)}}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("v8_vxr8")
	end
end

if SERVER then
	ENT.ChassisMass = 1700
	ENT.SpawnPositionOffset = Vector(0, 0, 15)
	ENT.BurnoutForce = 35

	function ENT:InitializePhysics()
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS, Vector(5, 0, 10))
	end

	function ENT:CreateFeatures()
		self:SetHeadlightColor(Vector(1, 1, 1))
		self:SetSteerConeChangeRate(25)
		self:SetCounterSteer(0.18)
		self:SetSpringStrength(1500)
		self:SetBrakePower(9000)
		self:SetSteerConeMaxSpeed(1200)

		self:SetDifferentialRatio(0.7)
		self:SetPowerDistribution(-1)
		self:SetMinRPM(750)
		self:SetMaxRPM(7000)
		self:SetMinRPMTorque(8900)
		self:SetMaxRPMTorque(12300)

		self:CreateSeat(Vector(Vector(-13, 14, 3)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(5, -14.5, 6), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(59.516201019287, 36.632598876953, 23), {
			model = "models/simpoly/wheels/ford_gt_2018.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Front right
		self:CreateWheel(Vector(59.516201019287, -36.632598876953, 23), {
			model = "models/simpoly/wheels/ford_gt_2018.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Rear left
		self:CreateWheel(Vector(-59.516201019287, 36.632598876953, 23), {
			model = "models/simpoly/wheels/ford_gt_2018.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Rear right
		self:CreateWheel(Vector(-59.516201019287, -36.632598876953, 23), {
			model = "models/simpoly/wheels/ford_gt_2018.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		self:ChangeWheelRadius(15.6)
	end
end
