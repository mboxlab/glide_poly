AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Lamborghini Huracan Roadster"

ENT.GlideCategory = "Poly - Sport"
ENT.ChassisModel = "models/simpoly/lamborghini_aventador_lp_750_4_super_veloce_roadster.mdl"

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
	ENT.ExhaustOffsets = {{pos = Vector(-100, -17, 22)}, {pos = Vector(-100, 17, 22)}}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("v12_aventador")
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
		self:SetSteerConeMaxSpeed(1200)
		self:SetBrakePower(9000)
		self:SetFastTransmission(true)

		self:SetDifferentialRatio(0.6)
		self:SetPowerDistribution(-0.9)
		self:SetMinRPM(750)
		self:SetMaxRPM(8700)
		self:SetMinRPMTorque(10200)
		self:SetMaxRPMTorque(16300)

		self:CreateSeat(Vector(Vector(-13, 18, 5)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(10, -18.5, 5), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(60.405101776123, 39.149799346924, 23), {
			model = "models/simpoly/wheels/lamborghini_aventador_lp_750_4_super_veloce_roadster.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 3, E = 0.992}
		})

		-- Front right
		self:CreateWheel(Vector(60.405101776123, -39.149799346924, 23), {
			model = "models/simpoly/wheels/lamborghini_aventador_lp_750_4_super_veloce_roadster.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 3, E = 0.992}
		})

		-- Rear left
		self:CreateWheel(Vector(-60.405101776123, 39.149799346924, 23), {
			model = "models/simpoly/wheels/lamborghini_aventador_lp_750_4_super_veloce_roadster.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 3, E = 0.992}
		})

		-- Rear right
		self:CreateWheel(Vector(-60.405101776123, -39.149799346924, 23), {
			model = "models/simpoly/wheels/lamborghini_aventador_lp_750_4_super_veloce_roadster.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 3, E = 0.992}
		})

		self:ChangeWheelRadius(15.1)
	end
end
