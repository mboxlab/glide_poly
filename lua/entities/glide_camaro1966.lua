AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Chevrolet Camaro 1966"

ENT.GlideCategory = "Poly - Muscle"
ENT.ChassisModel = "models/simpoly/camaro1966.mdl"

function ENT:GetFirstPersonOffset(_, localEyePos)
	localEyePos[1] = localEyePos[1] + 8
	localEyePos[3] = localEyePos[3] + 3
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
		stream:LoadPreset("v8_c63")
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
		self:SetBrakePower(5000)
		self:SetSteerConeMaxSpeed(1200)

		self:SetDifferentialRatio(0.7)
		self:SetPowerDistribution(-1)
		self:SetMinRPM(750)
		self:SetMaxRPM(5500)
		self:SetMinRPMTorque(5000)
		self:SetMaxRPMTorque(6000)

		 
		 
		 

		self:CreateSeat(Vector(Vector(-28, 20, 13)), Angle(0, 270, 2), Vector(0, 80, 0), true)

		-- Front left
		self:CreateWheel(Vector(61.24520111084, 34.635299682617, 18),
		                 {model = "models/simpoly/wheels/camaro1966.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1), steerMultiplier = 1})

		-- Front right
		self:CreateWheel(Vector(61.24520111084, -34.635299682617, 18), {
			model = "models/simpoly/wheels/camaro1966.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-61.244800567627, 34.635299682617, 18),
		                 {model = "models/simpoly/wheels/camaro1966.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-61.244800567627, -34.635299682617, 18),
		                 {model = "models/simpoly/wheels/camaro1966.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(14.5)
	end
end
