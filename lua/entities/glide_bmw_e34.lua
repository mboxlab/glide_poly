AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "kekobka"
ENT.PrintName = "BMW E46"

ENT.GlideCategory = "Poly - Sedan"
ENT.ChassisModel = "models/simpoly/bmw_e34.mdl"

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
		{pos = Vector(-108, 15, 13)},
		{pos = Vector(-108, 11, 13)},
		{pos = Vector(-108, -15, 13)},
		{pos = Vector(-108, -11, 13)},
		--
	}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("i6_supra")
	end
end

if SERVER then
	ENT.ChassisMass = 1300
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

		self:SetDifferentialRatio(0.65)
		self:SetPowerDistribution(-0)
		self:SetMinRPM(750)
		self:SetMaxRPM(7500)
		self:SetMinRPMTorque(6200)
		self:SetMaxRPMTorque(17300)

		self:SetForwardTractionMax(4500)
		self:SetSideTractionMultiplier(25)
		self:SetSideTractionMax(2700)

		self:CreateSeat(Vector(Vector(-28, 16, 15)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(-5, -16.5, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-40, -16.5, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-40, 16.5, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-40, 0, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(62.489101409912, 33.791301727295, 23),
		                 {model = "models/simpoly/wheels/bmw_e34.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Front right
		self:CreateWheel(Vector(62.489101409912, -33.791301727295, 23),
		                 {model = "models/simpoly/wheels/bmw_e34.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Rear left
		self:CreateWheel(Vector(-62.486400604248, 33.791301727295, 23),
		                 {model = "models/simpoly/wheels/bmw_e34.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-62.486400604248, -33.791301727295, 23),
		                 {model = "models/simpoly/wheels/bmw_e34.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(15.1)
	end
end
