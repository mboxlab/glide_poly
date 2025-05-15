AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "kekobka"
ENT.PrintName = "Ford Focus RS"

ENT.GlideCategory = "Poly - Hatchback"
ENT.ChassisModel = "models/simpoly/ford_focus_rs.mdl"

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
	ENT.ExhaustOffsets = {{pos = Vector(-95, -22, 14)}, {pos = Vector(-95, 22, 14)}}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("i4_redtop")
	end
end

if SERVER then
	ENT.ChassisMass = 1700
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
		self:SetBrakePower(9000)
		self:SetSteerConeMaxSpeed(1200)

		self:SetDifferentialRatio(0.7)
		self:SetPowerDistribution(1)
		self:SetMinRPM(750)
		self:SetMaxRPM(7000)
		self:SetMinRPMTorque(5900)
		self:SetMaxRPMTorque(8300)

		self:SetForwardTractionMax(5500)
		self:SetSideTractionMultiplier(25)
		self:SetSideTractionMax(2700)

		self:CreateSeat(Vector(Vector(-8, 20, 18)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(12, -20.5, 18), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-25, -20.5, 18), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-25, 20.5, 18), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(60.922401428223, 37.220100402832, 23), {
			model = "models/simpoly/wheels/ford_focus_rs.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Front right
		self:CreateWheel(Vector(60.922401428223, -37.220100402832, 23), {
			model = "models/simpoly/wheels/ford_focus_rs.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-60.922401428223, 37.220100402832, 23),
		                 {model = "models/simpoly/wheels/ford_focus_rs.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-60.922409057617, -37.220100402832, 23),
		                 {model = "models/simpoly/wheels/ford_focus_rs.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(15.3)
	end
end
