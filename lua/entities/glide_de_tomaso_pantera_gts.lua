AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "kekobka"
ENT.PrintName = "De Tomaso Pantera GTS"

ENT.GlideCategory = "Poly - Sport"
ENT.ChassisModel = "models/simpoly/de_tomaso_pantera_gts.mdl"

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
	ENT.ExhaustOffsets = {{pos = Vector(-100, -19, 18)}, {pos = Vector(-100, 19, 18)}}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("insurgent")
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
		self:SetSteerConeMaxSpeed(500)

		self:SetDifferentialRatio(1.1)
		self:SetPowerDistribution(-0.9)
		self:SetMinRPM(750)
		self:SetMaxRPM(8300)
		self:SetMinRPMTorque(2200)
		self:SetMaxRPMTorque(6300)

		self:SetForwardTractionMax(4500)
		self:SetSideTractionMultiplier(25)
		self:SetSideTractionMax(2700)

		self:CreateSeat(Vector(Vector(-18, 19, 8)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(-2, -19.5, 8), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(61.823600769043, 39.962398529053, 18), {
			model = "models/simpoly/wheels/de_tomaso_pantera_gts.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Front right
		self:CreateWheel(Vector(61.823600769043, -39.962398529053, 18), {
			model = "models/simpoly/wheels/de_tomaso_pantera_gts.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-61.823699951172, 41.476501464844, 18),
		                 {model = "models/simpoly/wheels/de_tomaso_pantera_gts.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-61.823699951172, -41.476501464844, 18),
		                 {model = "models/simpoly/wheels/de_tomaso_pantera_gts.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(14.7)
	end
end
