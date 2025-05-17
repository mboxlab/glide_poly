AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Volvo VNL"

ENT.GlideCategory = "Poly - Truck"
ENT.ChassisModel = "models/simpoly/volvo_vnl.mdl"
ENT.MaxChassisHealth = 2000

if CLIENT then
	ENT.CameraOffset = Vector(-500, 0, 0)
	ENT.CameraCenterOffset = Vector(0, 0, 140)
	ENT.CameraTrailerDistanceMultiplier = 0.65

	ENT.StartSound = "Glide.Engine.TruckStart"
	ENT.ExhaustPopSound = ""
	ENT.StartedSound = "glide/engines/start_tail_truck.wav"
	ENT.StoppedSound = "glide/engines/shut_down_truck_1.wav"
	ENT.HornSound = "glide/horns/large_truck_horn_2.wav"

	ENT.ReverseSound = "glide/alarms/reverse_warning.wav"
	ENT.BrakeLoopSound = "glide/wheels/rig_brake_disc_1.wav"
	ENT.BrakeReleaseSound = "glide/wheels/rig_brake_release.wav"
	ENT.BrakeSqueakSound = "Glide.Brakes.Squeak"

	ENT.ExhaustAlpha = 120
	ENT.ExhaustOffsets = {{pos = Vector(25, 23, 128), scale = 2}}

	ENT.EngineSmokeStrips = {{offset = Vector(144, 0, -8), width = 55}}

	ENT.EngineFireOffsets = {{offset = Vector(144, 0, 8), angle = Angle(90, 0, 0)}}

	ENT.Headlights = {{offset = Vector(200, 40, 25)}, {offset = Vector(200, -40, 25)}}

	function ENT:OnCreateEngineStream(stream)
		stream.offset = Vector(50, 0, 0)
		stream:LoadPreset("hauler")
	end
end

if SERVER then
	ENT.SpawnPositionOffset = Vector(0, 0, 50)
	ENT.ChassisMass = 4000
	ENT.IsHeavyVehicle = true

	ENT.SuspensionHeavySound = "Glide.Suspension.CompressTruck"
	ENT.SuspensionDownSound = "Glide.Suspension.Stress"

	ENT.BurnoutForce = 12
	ENT.UnflipForce = 6
	function ENT:InitializePhysics()
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS, Vector(90, 0, 35))
	end

	ENT.AirControlForce = Vector(0.1, 0.05, 0.1) -- Roll, pitch, yaw
	ENT.AirMaxAngularVelocity = Vector(100, 100, 150) -- Roll, pitch, yaw

	ENT.Sockets = {{offset = Vector(-35, 0, 47), id = "TruckSocket", isReceptacle = true}}

	function ENT:GetGears()
		return {
			[-1] = 2.5, -- Reverse
			[0] = 0, -- Neutral (this number has no effect)
			[1] = 2.8,
			[2] = 1.7,
			[3] = 1.2,
			[4] = 0.9,
			[5] = 0.75,
			[6] = 0.68,
			[7] = 0.64,
		}
	end

	function ENT:CreateFeatures()
		self.engineBrakeTorque = 4000

		self:SetSuspensionLength(10)
		self:SetSpringStrength(1900)
		self:SetSpringDamper(8000)

		self:SetSideTractionMultiplier(90)
		self:SetForwardTractionMax(6000)
		self:SetSideTractionMax(4000)
		self:SetSideTractionMin(5500)

		self:SetDifferentialRatio(1.3)
		self:SetPowerDistribution(-0.7)

		self:SetMinRPM(600)
		self:SetMaxRPM(4500)
		self:SetMinRPMTorque(8000)
		self:SetMaxRPMTorque(9000)

		self:SetBrakePower(6000)
		self:SetMaxSteerAngle(40)
		self:SetSteerConeChangeRate(8)
		self:SetSteerConeMaxSpeed(800)
		self:SetSteerConeMaxAngle(0.4)
		self:SetCounterSteer(0.2)

		self:CreateSeat(Vector(87, 17, 45), Angle(0, 270, -5), Vector(90, 90, 0), true)
		self:CreateSeat(Vector(100, -17, 45), Angle(0, 270, 0), Vector(90, 90, 0), true)

		-- Front left
		self:CreateWheel(Vector(3.87508 * 39.37, 0.949529 * 39.37, 0.5 * 39.37),
		                 {model = "models/simpoly/wheels/volvo_vnl_front.mdl", modelAngle = Angle(0, 0, 0), useModelSize = true, steerMultiplier = 1})

		-- Rear left 1
		self:CreateWheel(Vector(-0.450241 * 39.37, 0.809811 * 39.37, 0.62 * 39.37),
		                 {model = "models/simpoly/wheels/volvo_vnl_rear.mdl", modelAngle = Angle(0, 0, 0), useModelSize = true})

		-- Rear left 2
		self:CreateWheel(Vector(-1.48729 * 39.37, 0.809811 * 39.37, 0.62 * 39.37),
		                 {model = "models/simpoly/wheels/volvo_vnl_rear.mdl", modelAngle = Angle(0, 0, 0), useModelSize = true})

		-- Front right
		self:CreateWheel(Vector(3.87508 * 39.37, -0.949529 * 39.37, 0.5 * 39.37),
		                 {model = "models/simpoly/wheels/volvo_vnl_front.mdl", modelAngle = Angle(0, 180, 0), useModelSize = true, steerMultiplier = 1})

		-- Rear right 1
		self:CreateWheel(Vector(-0.450241 * 39.37, -0.809811 * 39.37, 0.62 * 39.37),
		                 {model = "models/simpoly/wheels/volvo_vnl_rear.mdl", modelAngle = Angle(0, 180, 0), useModelSize = true})

		-- Rear right 2
		self:CreateWheel(Vector(-1.48729 * 39.37, -0.809811 * 39.37, 0.62 * 39.37),
		                 {model = "models/simpoly/wheels/volvo_vnl_rear.mdl", modelAngle = Angle(0, 180, 0), useModelSize = true})
	end
end
