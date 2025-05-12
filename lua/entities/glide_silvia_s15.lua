AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "kekobka"
ENT.PrintName = "Nissan Silvia S15"

ENT.GlideCategory = "Poly - Sedan"
ENT.ChassisModel = "models/simpoly/silvia_s15.mdl"

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
		{pos = Vector(-105, 20, 15)},
		{pos = Vector(-105, 16, 15)},
		--
	}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("insurgent")
	end
end

if SERVER then
	ENT.ChassisMass = 1600
	ENT.SpawnPositionOffset = Vector(0, 0, 15)
	ENT.BurnoutForce = 35

	function ENT:InitializePhysics()
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
	end

	function ENT:CreateFeatures()
		self:SetHeadlightColor(Vector(1, 1, 1))
		self:SetSteerConeChangeRate(25)
		self:SetCounterSteer(0.18)
		self:SetSpringStrength(1500)
		self:SetSteerConeMaxSpeed(800)

		self:SetDifferentialRatio(1.1)
		self:SetPowerDistribution(-1)
		self:SetMinRPM(800)
		self:SetMaxRPM(7800)
		self:SetMinRPMTorque(2200)
		self:SetMaxRPMTorque(6800)

		self:SetForwardTractionMax(4500)
		self:SetSideTractionMultiplier(25)
		self:SetSideTractionMax(2700)

		self:CreateSeat(Vector(Vector(-25, 19, 13)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(-8, -19.5, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(60.347198486328, 34.373870849609, 23),
		                 {model = "models/simpoly/wheels/nissan_r34.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Front right
		self:CreateWheel(Vector(60.347198486328, -34.373870849609, 23), {
			model = "models/simpoly/wheels/nissan_r34.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-60.379501342773, 34.373870849609, 23),
		                 {model = "models/simpoly/wheels/nissan_r34.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-60.379501342773, -34.373870849609, 23),
		                 {model = "models/simpoly/wheels/nissan_r34.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(16.1)
	end
end
