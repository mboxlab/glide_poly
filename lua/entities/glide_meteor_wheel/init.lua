AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

-- Store the TraceResult on this table instead of
-- creating a new one every time. It's contents are
-- overritten every time a wheel calls `util.TraceHull`.
local UNITS_PER_METER = 39.37
local UNITS_TO_METERS = 0.01905

local ray = Glide.LastWheelTraceResult or {}
Glide.LastWheelTraceResult = ray

function ENT:Initialize()
	self:SetModel("models/editor/axis_helper.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self.params = {
		-- Suspension
		suspensionLength = 10,
		springStrength = 800,
		springDamper = 3000,

		-- Brake force
		brakePower = 3000,

		--  traction
		lateralFrictionPreset = {B = 12.0, C = 1.3, D = 1.8, E = -1.8},
		longitudinalFrictionPreset = {B = 10.86, C = 2.15, D = 2, E = 0.992},

		-- Other parameters
		radius = 15,
		basePos = Vector(),
		steerMultiplier = 0,
		enableAxleForces = false,
	}

	self.state = {
		torque = 0, -- Amount of torque to apply to the wheel
		brake = 0, -- Amount of brake torque to apply to the wheel
		spin = 0, -- Wheel spin angle around it's axle axis

		-- Suspension length multiplier
		suspensionLengthMult = 1,

		-- Forward traction multiplier
		forwardTractionMult = 1,

		isOnGround = false,
		lastFraction = 1,
		lastSpringOffset = 0,
		angularVelocity = 0,
		isDebugging = Glide.GetDevMode(),
	}

	-- Used for raycasting, updates with wheel radius
	self.traceData = {
		mins = Vector(),
		maxs = Vector(1, 1, 1),
		collisiongroup = COLLISION_GROUP_WORLD,

		-- Output TraceResult to `ray`
		output = ray,
	}

	self.contractSoundCD = 0
	self.expandSoundCD = 0

	self:SetupWheel()
end

function ENT:longitudinalFrictionPreset(slip)

	local LongitudinalFrictionPreset = self.params.longitudinalFrictionPreset
	local B = LongitudinalFrictionPreset.B
	local C = LongitudinalFrictionPreset.C
	local D = LongitudinalFrictionPreset.D
	local E = LongitudinalFrictionPreset.E

	return self:CalcFriction(B, C, D, E, slip)
end

function ENT:lateralFrictionPreset(slip)
	local LateralFrictionPreset = self.params.lateralFrictionPreset
	local B = LateralFrictionPreset.B
	local C = LateralFrictionPreset.C
	local D = LateralFrictionPreset.D
	local E = LateralFrictionPreset.E

	return self:CalcFriction(B, C, D, E, slip)
end

--- Set the size, models and steering properties to use on this wheel.
function ENT:SetupWheel(t)
	t = t or {}

	local params = self.params

	-- Physical wheel radius, also affects the model size
	params.radius = t.radius or 15

	-- Wheel offset relative to the parent
	params.basePos = t.basePos or self:GetLocalPos()

	-- How much the parent's steering angle affects this wheel
	params.steerMultiplier = t.steerMultiplier or 0

	-- Wheel model
	if type(t.model) == "string" then
		params.model = t.model
	end

	-- Model rotation and scale
	params.modelScale = t.modelScale or Vector(0.3, 1, 1)

	self:SetModelAngle(t.modelAngle or Angle(0, 0, 0))
	self:SetModelOffset(t.modelOffset or Vector(0, 0, 0))

	-- Should this wheel have the same size/radius as the model?
	-- If you use this, the `radius` and `modelScale` parameters are going to be overritten.
	-- Requires the `model` parameter to be set previously.
	params.useModelSize = params.model and t.useModelSize == true

	if params.useModelSize then
		self:SetModel(params.model)

		local obbSize = self:OBBMaxs() - self:OBBMins()
		params.baseModelRadius = obbSize[3] * 0.5
		params.radius = params.baseModelRadius
		params.modelScale = Vector(1, 1, 1)
	end

	-- Should forces be applied at the axle position?
	-- (Recommended for small vehicles like the Blazer)
	params.enableAxleForces = false -- t.enableAxleForces or false

	-- Should this wheel play sounds?
	self:SetSoundsEnabled(t.disableSounds ~= true)

	-- Repair to update the model and radius
	self:Repair()

	-- Suspension
	params.suspensionLength = t.suspensionLength or params.suspensionLength
	params.springStrength = t.springStrength or params.springStrength
	params.springDamper = t.springDamper or params.springDamper

	-- Brake force
	params.brakePower = t.brakePower or params.brakePower

	-- friction
	params.longitudinalFrictionPreset = t.longitudinalFrictionPreset or params.longitudinalFrictionPreset
	params.lateralFrictionPreset = t.lateralFrictionPreset or params.lateralFrictionPreset

end

function ENT:Repair()
	if self.params.model then
		self:SetModel(self.params.model)
	end

	self:ChangeRadius()
end

function ENT:Blow()
	self:ChangeRadius(self.params.radius * 0.8)
	self:EmitSound("glide/wheels/blowout.wav", 80, math.random(95, 105), 1)
end

function ENT:ChangeRadius(radius)
	radius = radius or self.params.radius

	local size = self.params.modelScale * radius * 2
	local obbSize = self:OBBMaxs() - self:OBBMins()
	local scale = Vector(size[1] / obbSize[1], size[2] / obbSize[2], size[3] / obbSize[3])

	if self.params.useModelSize then
		local s = radius / self.params.baseModelRadius
		scale[1] = s
		scale[2] = s
		scale[3] = s
	end

	self:SetRadius(radius)
	self:SetModelScale2(scale)

	-- Used on util.TraceHull
	self.traceData.mins = Vector(radius * -0.2, radius * -0.2, 0)
	self.traceData.maxs = Vector(radius * 0.2, radius * 0.2, 1)
end

do
	local Deg = math.deg
	local Approach = math.Approach

	function ENT:Update(vehicle, steerAngle, isAsleep, dt)
		local state, params = self.state, self.params

		-- Get the wheel rotation relative to the vehicle, while applying the steering angle
		local ang = vehicle:LocalToWorldAngles(steerAngle * params.steerMultiplier)

		-- Rotate the wheel around the axle axis
		state.spin = (state.spin - Deg(state.angularVelocity) * dt) % 360

		ang:RotateAroundAxis(ang:Right(), state.spin)
		self:SetAngles(ang)

		if isAsleep then
			self:SetForwardSlip(0)
			self:SetSideSlip(0)
		else
			self:SetLastSpin(state.spin)
			self:SetLastOffset(self:GetLocalPos()[3] - params.basePos[3])
		end

		if isAsleep or not state.isOnGround then
			-- Let the torque spin the wheel's fake mass
			state.angularVelocity = state.angularVelocity + (state.torque / 20) * dt

			-- Slow down eventually
			state.angularVelocity = Approach(state.angularVelocity, 0, dt * 4)
		end
	end

	local TAU = math.pi * 2

	function ENT:GetRPM()
		return self.state.angularVelocity * 60 / TAU
	end

	function ENT:SetRPM(rpm)
		self.state.angularVelocity = rpm / (60 / TAU)
	end
end

local Abs = math.abs
local Clamp = math.Clamp

do
	local CurTime = CurTime
	local PlaySoundSet = Glide.PlaySoundSet

	function ENT:DoSuspensionSounds(change, vehicle)
		if not self:GetSoundsEnabled() then
			return
		end

		local t = CurTime()

		if change > 0.01 and t > self.expandSoundCD then
			self.expandSoundCD = t + 0.3
			PlaySoundSet(vehicle.SuspensionUpSound, self, Clamp(Abs(change) * 15, 0, 0.5))
		end

		if change < -0.01 and t > self.contractSoundCD then
			change = Abs(change)

			self.contractSoundCD = t + 0.3
			PlaySoundSet(change > 0.03 and vehicle.SuspensionHeavySound or vehicle.SuspensionDownSound, self, Clamp(change * 20, 0, 1))
		end
	end
end

function ENT:CalcFriction(B, C, D, E, slip)
	local t = math.abs(slip)

	return D * math.sin(C * math.atan(B * t - E * (B * t - math.atan(B * t))))
end

local MAP_SURFACE_OVERRIDES = Glide.MAP_SURFACE_OVERRIDES

local PI = math.pi
local TAU = math.pi * 2

local Min = math.min
local Max = math.max
local Atan2 = math.atan2
local Approach = math.Approach
local TraceHull = util.TraceHull
local TractionRamp = Glide.TractionRamp

-- Temporary variables
local pos, ang, fw, rt, up, radius, maxLen
local fraction, contactPos, surfaceId, vel, velF, velR, absVelR
local offset, springForce, damperForce
local surfaceGrip, maxTraction, brakeForce, forwardForce, signForwardForce
local tractionCycle, gripLoss, groundAngularVelocity, angularVelocity = Vector()
local slipAngle, sideForce
local force, linearImp, angularImp
local state, params, traceData

function ENT:StepLongitudinal(Tm, Tb, Vx, W, Lc, R, I, dt)
	local Winit = W
	local VxAbs = math.abs(Vx)
	local Sx = 0

	if Lc < 0.01 then
		Sx = 0
	elseif VxAbs >= 0.01 then
		Sx = (W * R - Vx) / VxAbs
	else
		Sx = (W * R - Vx) * 0.6
	end

	Sx = math.Clamp(Sx, -1, 1)

	W = W + Tm / I * dt

	Tb = Tb * (W > 0 and -1 or 1)
	local TbCap = math.abs(W) * I / dt
	local Tbr = math.abs(Tb) - math.abs(TbCap)
	Tbr = Max(Tbr, 0)
	Tb = math.Clamp(Tb, -TbCap, TbCap)
	W = W + Tb / I * dt

	local maxTorque = self:longitudinalFrictionPreset(Sx) * Lc * R
	local errorTorque = (W - Vx / R) * I / dt
	local surfaceTorque = math.Clamp(errorTorque, -maxTorque, maxTorque)

	W = W - surfaceTorque / I * dt
	local Fx = surfaceTorque / R

	Tbr = Tbr * (W > 0 and -1 or 1)
	local TbCap2 = math.abs(W) * I / dt
	local Tb2 = math.Clamp(Tbr, -TbCap2, TbCap2)
	W = W + Tb2 / I * dt

	local deltaOmegaTorque = (W - Winit) * I / dt
	local Tcnt = -surfaceTorque + Tb + Tb2 - deltaOmegaTorque

	return W, Sx, Fx, Tcnt
end

function ENT:StepLateral(Vx, Vy, Lc, dt)
	local VxAbs = math.abs(Vx)
	local Sy = 0

	if Lc < 0.01 then
		Sy = 0
	elseif VxAbs > 0.1 then
		Sy = math.deg(math.atan(Vy / VxAbs)) / 50
	else
		Sy = Vy * (0.003 / dt)
	end

	Sy = math.Clamp(Sy, -1, 1)
	local slipSign = Sy < 0 and -1 or 1
	local Fy = -slipSign * self:lateralFrictionPreset(Sy) * Lc

	return Sy, Fy
end

function ENT:SlipCircle(Sx, Sy, Fx, Fy)
	local SxAbs = math.abs(Sx)

	if SxAbs > 0.01 then
		local SxClamped = math.Clamp(Sx, -1, 1)
		local SyClamped = math.Clamp(Sy, -1, 1)
		local combinedSlip = Vector(SxClamped * 1.05, SyClamped, 0)
		combinedSlip:Normalize()

		local F = math.sqrt(Fx * Fx + Fy * Fy)
		local absSlipDirY = math.abs(combinedSlip.y)

		Fy = F * absSlipDirY * (Fy < 0 and -1 or 1)
	end

	return Sx, Sy, Fx, Fy
end

function ENT:GetLongitudinalLoadCoefficient(load)
	return 11000 * (1 - math.exp(-0.00014 * load))
end
function ENT:GetLateralLoadCoefficient(load)
	return 18000 * (1 - math.exp(-0.0001 * load))
end
local function VectorPlaneProject(v, plane)
	return v - (plane * v:Dot(plane))
end
function ENT:DoPhysics(vehicle, phys, traceFilter, outLin, outAng, dt, vehSurfaceGrip, vehSurfaceResistance, vehPos, vehVel, vehAngVel)
	state, params = self.state, self.params

	-- Get the starting point of the raycast, where the suspension connects to the chassis
	pos = phys:LocalToWorld(params.basePos)

	-- Get the wheel rotation relative to the chassis, applying the steering angle if necessary
	ang = vehicle:LocalToWorldAngles(vehicle.steerAngle * params.steerMultiplier)

	up = ang:Up()

	-- Do the raycast
	radius = self:GetRadius()
	maxLen = state.suspensionLengthMult * params.suspensionLength + radius

	traceData = self.traceData
	traceData.filter = traceFilter
	traceData.start = pos
	traceData.endpos = pos - up * maxLen

	-- TraceResult gets stored on the `ray` table
	TraceHull(traceData)

	fw = VectorPlaneProject(ang:Forward(), ray.HitNormal);
	rt = VectorPlaneProject(ang:Right(), ray.HitNormal);

	fraction = Clamp(ray.Fraction, radius / maxLen, 1)
	contactPos = pos - maxLen * fraction * up

	-- Update ground contact NW variables
	surfaceId = ray.Hit and (ray.MatType or 0) or 0
	surfaceId = MAP_SURFACE_OVERRIDES[surfaceId] or surfaceId

	state.isOnGround = ray.Hit
	self:SetContactSurface(surfaceId)

	if state.isDebugging then
		debugoverlay.Cross(pos, 10, 0.05, Color(100, 100, 100), true)
		debugoverlay.Box(contactPos, traceData.mins, traceData.maxs, 0.05, Color(0, 200, 0))
	end

	-- Update the wheel position and sounds
	self:SetLocalPos(phys:WorldToLocal(contactPos + up * radius))
	self:DoSuspensionSounds(fraction - state.lastFraction, vehicle)
	state.lastFraction = fraction

	if not ray.Hit then
		self:SetForwardSlip(0)
		self:SetSideSlip(0)

		return
	end

	pos = params.enableAxleForces and pos or contactPos

	-- Get the velocity at the wheel position
	vel = phys:GetVelocityAtPoint(pos)

	-- Split that velocity among our local directions
	velF = vel:Dot(fw) * UNITS_TO_METERS
	velR = vel:Dot(rt) * UNITS_TO_METERS

	-- Suspension spring force & damping
	offset = maxLen - (fraction * maxLen)
	springForce = (offset * params.springStrength)
	damperForce = (state.lastSpringOffset - offset) * params.springDamper
	state.lastSpringOffset = offset

	local velU = ray.HitNormal:Dot(vel)

	-- If the suspension spring is going to be fully compressed on the next frame...
	if velU < 0 and offset + Abs(velU * dt) > params.suspensionLength then
		-- Completely negate the downwards velocity at the local position
		linearImp, angularImp = phys:CalculateVelocityOffset((-velU / dt) * ray.HitNormal, pos)
		vehVel:Add(linearImp)
		vehAngVel:Add(angularImp)

		-- Teleport back up, using phys:SetPos to prevent going through stuff.
		linearImp = phys:CalculateVelocityOffset(ray.HitPos - (contactPos + ray.HitNormal * velU * dt), pos)
		vehPos:Add(linearImp / dt)

		-- Remove the damping force, to prevent a excessive bounce.
		damperForce = 0
	end

	force = (springForce - damperForce) * ray.HitNormal

	-- Rolling resistance
	local roll = (vehSurfaceResistance[surfaceId] or 0.05) * velF

	-- Brake and torque forces
	surfaceGrip = (vehSurfaceGrip[surfaceId] or 1) * state.forwardTractionMult

	-- Grip loss logic
	brakeForce = state.brake * params.brakePower
	forwardForce = state.torque

	local longitudinalLoadCoefficient = self:GetLongitudinalLoadCoefficient(springForce - damperForce) * surfaceGrip
	local lateralLoadCoefficient = self:GetLateralLoadCoefficient(springForce - damperForce) * surfaceGrip

	radius = radius * UNITS_TO_METERS
	local W, Sx, Fx, CounterTq = self:StepLongitudinal( --
	forwardForce, --
	(brakeForce + roll), --
	velF, --
	state.angularVelocity, --
	longitudinalLoadCoefficient, --
	radius, --
	30 * math.pow(radius, 2), --
	dt --
	)
	local Sy, Fy = self:StepLateral(velF, velR, lateralLoadCoefficient, dt)

	Sx, Sy, Fx, Fy = self:SlipCircle(Sx, Sy, Fx, Fy)

	state.angularVelocity = W

	self:SetForwardSlip(TAU * ( velF / ( radius * TAU ) ) - W)
	self:SetSideSlip(Sy * Clamp(vehicle.totalSpeed * 0.005, 0, 1) * 2)
	force:Add(ang:Forward() * Fx)
	force:Add(ang:Right() * Fy * Clamp(vehicle.totalSpeed * 0.005, 0, 1))

	-- Apply the forces at the axle/ground contact position
	linearImp, angularImp = phys:CalculateForceOffset(force, pos)

	outLin[1] = outLin[1] + linearImp[1] / dt
	outLin[2] = outLin[2] + linearImp[2] / dt
	outLin[3] = outLin[3] + linearImp[3] / dt

	outAng[1] = outAng[1] + angularImp[1] / dt
	outAng[2] = outAng[2] + angularImp[2] / dt
	outAng[3] = outAng[3] + angularImp[3] / dt
end
