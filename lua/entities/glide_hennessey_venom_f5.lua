AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.Author = "kekobka"
ENT.PrintName = "Hennessey Venom F5"

ENT.GlideCategory = "Poly - Sport"
ENT.ChassisModel = "models/simpoly/hennessey_venom_f5.mdl"

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
	ENT.ExhaustOffsets = {{pos = Vector(-100, 0, 15)}, {pos = Vector(-100, 3, 22)}, {pos = Vector(-100, -3, 22)}}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("v12_aventador")
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
		self:SetSteerConeMaxSpeed(1200)
		self:SetBrakePower(9000)
		self:SetFastTransmission(true)

		self:SetDifferentialRatio(0.6)
		self:SetPowerDistribution(-0.9)
		self:SetMinRPM(750)
		self:SetMaxRPM(8700)
		self:SetMinRPMTorque(10200)
		self:SetMaxRPMTorque(16300)

		self:SetForwardTractionMax(8500)
		self:SetSideTractionMultiplier(25)
		self:SetSideTractionMax(6700)

		self:CreateSeat(Vector(Vector(-3, 15, 6)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(15, -15.5, 6), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(65.072303771973, 37.771900177002, 23), {
			model = "models/simpoly/wheels/hennessey_venom_f5.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Front right
		self:CreateWheel(Vector(65.072303771973, -37.771900177002, 23), {
			model = "models/simpoly/wheels/hennessey_venom_f5.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-65.037101745605, 38.87739944458, 23),
		                 {model = "models/simpoly/wheels/hennessey_venom_f5.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-65.037101745605, -38.87739944458, 23),
		                 {model = "models/simpoly/wheels/hennessey_venom_f5.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(15.6)
	end
end
