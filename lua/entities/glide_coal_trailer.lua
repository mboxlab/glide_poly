AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_trailer"
ENT.PrintName = "Coal Trailer"

ENT.GlideCategory = "Poly - Truck"
ENT.ChassisModel = "models/simpoly/coal_trailer.mdl"

if SERVER then
	ENT.SpawnPositionOffset = Vector(0, 0, 50)
	ENT.ChassisMass = 2000

	ENT.IsHeavyVehicle = true
	ENT.SuspensionHeavySound = "Glide.Suspension.CompressTruck"

	ENT.Sockets = {{offset = Vector(325, 0, 50), id = "TruckSocket", isReceptacle = false}}

	function ENT:CreateFeatures()
		local params = {
			model = "models/simpoly/wheels/volvo_vnl_rear.mdl",
			modelAngle = Angle(0, 0, 0),
			useModelSize = true,
			springStrength = 500,
			springDamper = 2500,
		}

		-- Left
		self:CreateWheel(Vector(1.0109 * 39.37, 0.935658 * 39.37, 0.6 * 39.37), params)
		self:CreateWheel(Vector(0.007974 * 39.37, 0.935658 * 39.37, 0.6 * 39.37), params)
		self:CreateWheel(Vector(-1.01864 * 39.37, 0.935658 * 39.37, 0.6 * 39.37), params)

		-- Right
		params.modelAngle = Angle(0, 180, 0)
		self:CreateWheel(Vector(1.0109 * 39.37, -0.935658 * 39.37, 0.6 * 39.37), params)
		self:CreateWheel(Vector(0.007974 * 39.37, -0.935658 * 39.37, 0.6 * 39.37), params)
		self:CreateWheel(Vector(-1.01864 * 39.37, -0.935658 * 39.37, 0.6 * 39.37), params)
	end
end
