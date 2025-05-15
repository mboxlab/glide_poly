AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "kekobka"
ENT.PrintName = "Mazda RX-7"

ENT.GlideCategory = "Poly - Sedan"
ENT.ChassisModel = "models/simpoly/rx7.mdl"

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
	ENT.ExhaustOffsets = {}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("i6_supra")
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

		self:SetDifferentialRatio(0.7)
		self:SetPowerDistribution(-0.9)
		self:SetMinRPM(900)
		self:SetMaxRPM(9500)
		self:SetMinRPMTorque(4000)
		self:SetMaxRPMTorque(7800)

		self:SetForwardTractionMax(6500)
		self:SetSideTractionMultiplier(25)
		self:SetSideTractionMax(2700)


		self:CreateSeat(Vector(Vector(-28, 17, 18)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(-8, -17.5, 18), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(58.507099151611, 34.069000244141, 23),
		                 {model = "models/simpoly/wheels/rx7.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Front right
		self:CreateWheel(Vector(58.507099151611, -34.069000244141, 23),
		                 {model = "models/simpoly/wheels/rx7.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Rear left
		self:CreateWheel(Vector(-58.492099761963, 34.069000244141, 23),
		                 {model = "models/simpoly/wheels/rx7.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-58.492099761963, -34.069000244141, 23),
		                 {model = "models/simpoly/wheels/rx7.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(15.3)
	end
end
