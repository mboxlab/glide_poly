AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Mercedes Benz G"

ENT.GlideCategory = "Poly - Suv"
ENT.ChassisModel = "models/simpoly/mercedes_benz_g_class.mdl"

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
		{pos = Vector(-27, -43, 12), ang = Angle(0, 45, 0)},
		{pos = Vector(-34, -43, 12), ang = Angle(0, 45, 0)},
		{pos = Vector(-27, 43, 12), ang = Angle(0, -45, 0)},
		{pos = Vector(-34, 43, 12), ang = Angle(0, -45, 0)},
		--
	}

	ENT.EngineFireOffsets = {{offset = Vector(60, 0, 20), angle = Angle()}}
	ENT.Headlights = {{offset = Vector(110, 30, 15)}, {offset = Vector(110, -30, 15)}}

	function ENT:OnCreateEngineStream(stream)
		stream:LoadPreset("v8_c63")
	end
end

if SERVER then
	ENT.ChassisMass = 2700
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
		self:SetSteerConeMaxSpeed(1000)
		
		self:SetBrakePower(9000)
		self:SetFastTransmission(true)
		self:SetSpringStrength(2500)
		self:SetSpringDamper(7000)

		self:SetDifferentialRatio(0.7)
		self:SetPowerDistribution(-0)
		self:SetMinRPM(750)
		self:SetMaxRPM(6500)
		self:SetMinRPMTorque(12200)
		self:SetMaxRPMTorque(16300)

		 
		 
		 

		self:CreateSeat(Vector(Vector(-13, 19, 23)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(7, -19.5, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-30, -19.5, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-30, 19.5, 23), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(59.701698303223, 35.794898986816, 23), {
			model = "models/simpoly/wheels/mercedes_benz_g_class.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Front right
		self:CreateWheel(Vector(59.701698303223, -35.794898986816, 23), {
			model = "models/simpoly/wheels/mercedes_benz_g_class.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-59.701698303223, 35.794898986816, 23),
		                 {model = "models/simpoly/wheels/mercedes_benz_g_class.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-59.701698303223, -35.794898986816, 23),
		                 {model = "models/simpoly/wheels/mercedes_benz_g_class.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(16.8)
	end
end
