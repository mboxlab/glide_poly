AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Mercedes Benz GT R"

ENT.GlideCategory = "Poly - Sport"
ENT.ChassisModel = "models/simpoly/mercedes_benz_gt_r.mdl"

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
		{pos = Vector(-105, -24, 15)},
		{pos = Vector(-105, 24, 15)},
		{pos = Vector(-103, 3, 12), ang = Angle(0, -25, 0)},
		{pos = Vector(-103, -3, 12), ang = Angle(0, 25, 0)},
		--
	}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("v8_c63")
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

		self:SetDifferentialRatio(0.65)
		self:SetPowerDistribution(-0.9)
		self:SetMinRPM(750)
		self:SetMaxRPM(8000)
		self:SetMinRPMTorque(7200)
		self:SetMaxRPMTorque(10000)

		self:CreateSeat(Vector(Vector(-38, 18, 10)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(-18, -18.5, 12), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(61.454498291016, 39.770500183105, 23), {
			model = "models/simpoly/wheels/mercedes_benz_gt_r.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Front right
		self:CreateWheel(Vector(61.454498291016, -39.770500183105, 23), {
			model = "models/simpoly/wheels/mercedes_benz_gt_r.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Rear left
		self:CreateWheel(Vector(-61.454498291016, 39.770500183105, 23), {
			model = "models/simpoly/wheels/mercedes_benz_gt_r.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		-- Rear right
		self:CreateWheel(Vector(-61.454498291016, -39.770500183105, 23), {
			model = "models/simpoly/wheels/mercedes_benz_gt_r.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},
		})

		self:ChangeWheelRadius(15.3)
	end
end
