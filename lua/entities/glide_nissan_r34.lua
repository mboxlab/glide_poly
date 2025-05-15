AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "kekobka"
ENT.PrintName = "Nissan GTR R34"

ENT.GlideCategory = "Poly - Sedan"
ENT.ChassisModel = "models/simpoly/nissan_r34.mdl"

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
		{pos = Vector(-108, -22, 15)},
		{pos = Vector(-108, -16, 15)},
		{pos = Vector(-108, 22, 15)},
		{pos = Vector(-108, 16, 15)},
		--
	}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("i6_r33")
	end
end

if SERVER then
	ENT.ChassisMass = 2000
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
		self:SetSteerConeMaxSpeed(1000)
		self:SetTurboCharged(true)

		self:SetDifferentialRatio(0.75)
		self:SetPowerDistribution(0)
		self:SetMinRPM(1000)
		self:SetMaxRPM(8000)
		self:SetMinRPMTorque(7400)
		self:SetMaxRPMTorque(12200)

		self:SetForwardTractionMax(4500)
		self:SetSideTractionMultiplier(25)
		self:SetSideTractionMax(2700)

		self:CreateSeat(Vector(Vector(-20, 17, 20)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(-3, -17.5, 20), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-37, -17.5, 20), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-37, 17.5, 20), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-37, 0, 20), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(62.886699676514, 35.60290145874, 23),
		                 {model = "models/simpoly/wheels/nissan_r34.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Front right
		self:CreateWheel(Vector(62.886699676514, -35.60290145874, 23), {
			model = "models/simpoly/wheels/nissan_r34.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-62.883098602295, 35.60290145874, 23),
		                 {model = "models/simpoly/wheels/nissan_r34.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-62.883098602295, -35.60290145874, 23),
		                 {model = "models/simpoly/wheels/nissan_r34.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(16.1)
	end
end
