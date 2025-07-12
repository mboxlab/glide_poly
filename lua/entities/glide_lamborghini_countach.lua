AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Lamborghini Countach"

ENT.GlideCategory = "Poly - Sport"
ENT.ChassisModel = "models/simpoly/lamborghini_countach.mdl"

function ENT:GetFirstPersonOffset(_, localEyePos)
	localEyePos[1] = localEyePos[1] + 8
	localEyePos[3] = localEyePos[3] + 8
	return localEyePos
end

if CLIENT then
	ENT.CameraOffset = Vector(-240, 0, 50)
	ENT.CameraCenterOffset = Vector(0, 0, 20)
	ENT.HornSound = "glide/horns/car_horn_med_9.wav"

	ENT.EngineSmokeMaxZVel = 5
	ENT.ExhaustOffsets = {
		{pos = Vector(-100, -14, 16)},
		{pos = Vector(-100, -11, 16)},
		{pos = Vector(-100, 14, 16)},
		{pos = Vector(-100, 11, 16)},
		--
	}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("v12_aventador")
	end
end

if SERVER then
	ENT.ChassisMass = 1200
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
		self:SetSuspensionLength(8)
		self:SetSteerConeMaxSpeed(1200)
		self:SetBrakePower(9000)
		self:SetFastTransmission(true)

		self:SetDifferentialRatio(0.6)
		self:SetPowerDistribution(-0.9)
		self:SetMinRPM(750)
		self:SetMaxRPM(7700)
		self:SetMinRPMTorque(8200)
		self:SetMaxRPMTorque(12300)

		self:CreateSeat(Vector(Vector(-3, 18, 5)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(15, -18.5, 5), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(61.071998596191, 40.677200317383, 18), {
			model = "models/simpoly/wheels/lamborghini_countach.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Front right
		self:CreateWheel(Vector(61.071998596191, -40.677200317383, 18), {
			model = "models/simpoly/wheels/lamborghini_countach.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Rear left
		self:CreateWheel(Vector(-61.071998596191, 40.677200317383, 18), {
			model = "models/simpoly/wheels/lamborghini_countach.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1.02, 0.5, 1.02),
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Rear right
		self:CreateWheel(Vector(-61.071998596191, -40.677200317383, 18), {
			model = "models/simpoly/wheels/lamborghini_countach.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1.02, 0.5, 1.02),
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		self:ChangeWheelRadius(14)
	end
end
