AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Mercedes Benz 190e"

ENT.GlideCategory = "Poly - Sedan"
ENT.ChassisModel = "models/simpoly/benz190e.mdl"

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
		{pos = Vector(-108, -15, 13)},
		{pos = Vector(-108, -19, 13)},
		{pos = Vector(-108, 15, 13)},
		{pos = Vector(-108, 19, 13)},
		--
	}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("i4_a45amg")
	end
end

if SERVER then
	ENT.ChassisMass = 1200
	ENT.SpawnPositionOffset = Vector(0, 0, 15)

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

		self:SetDifferentialRatio(0.5)
		self:SetPowerDistribution(-1)
		self:SetMinRPM(1000)
		self:SetMaxRPM(8500)
		self:SetMinRPMTorque(5000)
		self:SetMaxRPMTorque(8800)

		self:CreateSeat(Vector(Vector(-18, 17, 13)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(2, -17.5, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-40, -17.5, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-40, 17.5, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-40, 0, 15), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(62.749698638916, 35.252601623535, 23),
		                 {model = "models/simpoly/wheels/benz190e.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Front right
		self:CreateWheel(Vector(62.749698638916, -35.252601623535, 23),
		                 {model = "models/simpoly/wheels/benz190e.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Rear left
		self:CreateWheel(Vector(-62.737998962402, 35.252601623535, 23),
		                 {model = "models/simpoly/wheels/benz190e.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-62.737998962402, -35.252601623535, 23),
		                 {model = "models/simpoly/wheels/benz190e.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(15.3)
	end
end
