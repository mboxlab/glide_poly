AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "glide_meteor_car"
ENT.Author = "kekobka"
ENT.PrintName = "Ford Mustang 1969"

ENT.GlideCategory = "Poly - Muscle"
ENT.ChassisModel = "models/simpoly/mustang1969.mdl"

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
	ENT.ExhaustOffsets = {{pos = Vector(-100, -20, 13)}, {pos = Vector(-100, 20, 13)}}

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
		self:SetSteerConeMaxSpeed(800)

		self:SetDifferentialRatio(0.7)
		self:SetPowerDistribution(-0.9)
		self:SetMinRPM(750)
		self:SetMaxRPM(5000)
		self:SetMinRPMTorque(4200)
		self:SetMaxRPMTorque(6300)

		 
		 
		 

		self:CreateSeat(Vector(Vector(-18, 17, 13)), Angle(0, 270, 2), Vector(0, 80, 0), true)
		self:CreateSeat(Vector(2, -17.5, 14), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-30, -17.5, 14), Angle(0, 270, 18), Vector(0, -80, 0), true)
		self:CreateSeat(Vector(-30, 17.5, 14), Angle(0, 270, 18), Vector(0, -80, 0), true)
		-- Front left
		self:CreateWheel(Vector(59.634601593018, 30.180099487305, 23), {
			model = "models/simpoly/wheels/mustang1969.mdl",
			modelAngle = Angle(0, 0, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Front right
		self:CreateWheel(Vector(59.634601593018, -30.180099487305, 23), {
			model = "models/simpoly/wheels/mustang1969.mdl",
			modelAngle = Angle(0, 180, 0),
			modelScale = Vector(1, 0.4, 1),
			steerMultiplier = 1,
		})

		-- Rear left
		self:CreateWheel(Vector(-59.623798370361, 30.180099487305, 23),
		                 {model = "models/simpoly/wheels/mustang1969.mdl", modelAngle = Angle(0, 0, 0), modelScale = Vector(1, 0.4, 1)})

		-- Rear right
		self:CreateWheel(Vector(-59.623798370361, -30.180099487305, 23),
		                 {model = "models/simpoly/wheels/mustang1969.mdl", modelAngle = Angle(0, 180, 0), modelScale = Vector(1, 0.4, 1)})

		self:ChangeWheelRadius(15)
	end
end
