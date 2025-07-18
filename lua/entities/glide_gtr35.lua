AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Nissan 350Z"

ENT.GlideCategory = "Poly - Sedan"
ENT.ChassisModel = "models/simpoly/gtr35.mdl"

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
	ENT.ExhaustOffsets = {{pos = Vector(-105, -19, 12)}, {pos = Vector(-105, 19, 12)}}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("v8_vxr8")
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

		self:SetDifferentialRatio(0.7)
		self:SetPowerDistribution(-0.4)
		self:SetMinRPM(750)
		self:SetMaxRPM(8000)
		self:SetMinRPMTorque(6900)
		self:SetMaxRPMTorque(9300)

		 
		 
		 

		self:CreateSeat(Vector(Vector(-28, 17, 18)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(-8, -17.5, 18), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(63.060699462891, 35.957901000977, 23),
		                 {model = "models/simpoly/wheels/gtr35.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Front right
		self:CreateWheel(Vector(63.060699462891, -35.957901000977, 23),
		                 {model = "models/simpoly/wheels/gtr35.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Rear left
		self:CreateWheel(Vector(-63.817100524902, 35.549800872803, 23),
		                 {model = "models/simpoly/wheels/gtr35.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-63.817100524902, -35.549800872803, 23),
		                 {model = "models/simpoly/wheels/gtr35.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(17)
	end
end
