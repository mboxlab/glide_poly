AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "kekobka"
ENT.PrintName = "Dodge Durango SRT 2018"

ENT.GlideCategory = "Poly - Suv"
ENT.ChassisModel = "models/simpoly/dodge_durango_srt_2018.mdl"

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
	ENT.ExhaustOffsets = {{pos = Vector(-105, -23, 18)}, {pos = Vector(-105, 23, 18)}}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("insurgent")
	end
end

if SERVER then
	ENT.ChassisMass = 2700
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
		self:SetSteerConeMaxSpeed(600)
		
		self:SetSpringStrength(2500)
		self:SetSpringDamper(7000)

		self:SetDifferentialRatio(1.1)
		self:SetPowerDistribution(-0)
		self:SetMinRPM(750)
		self:SetMaxRPM(6500)
		self:SetMinRPMTorque(2200)
		self:SetMaxRPMTorque(6300)

		self:SetForwardTractionMax(4500)
		self:SetSideTractionMultiplier(25)
		self:SetSideTractionMax(2700)

		self:CreateSeat(Vector(Vector(-8, 19, 23)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(12, -19.5, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-30, -19.5, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-30, 19.5, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-30, 0, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-60, -10, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-60, 10, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(62.390800476074, 36.092998504639, 23), {
			model = "models/simpoly/wheels/dodge_durango_srt_2018.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Front right
		self:CreateWheel(Vector(62.390800476074, -36.092998504639, 23), {
			model = "models/simpoly/wheels/dodge_durango_srt_2018.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-62.390800476074, 36.092998504639, 23),
		                 {model = "models/simpoly/wheels/dodge_durango_srt_2018.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-62.390800476074, -36.092998504639, 23),
		                 {model = "models/simpoly/wheels/dodge_durango_srt_2018.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(17.3)
	end
end
