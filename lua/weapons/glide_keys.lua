SWEP.Author = "kekobka"
SWEP.PrintName = "Ключи"
SWEP.Instructions = "ЛКМ - Закрыть\nПКМ - Открыть"

SWEP.Category = "Glide"

SWEP.Slot = 1
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ViewModel = Model("models/weapons/v_slam.mdl")
SWEP.WorldModel = Model("models/weapons/w_slam.mdl")

if CLIENT then
	SWEP.DrawCrosshair = true
	SWEP.DrawAmmo = false
	SWEP.ViewModelFOV = 80
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/simfkeys")
end

SWEP.skullModel = nil

function SWEP:Initialize()

	self.UseDel = CurTime()

	if SERVER then
		self:SetWeaponHoldType("normal")
	else
		self.skullModel = ClientsideModel("models/props_junk/gascan001a.mdl", RENDERGROUP_OPAQUE)
		self.skullModel:SetNoDraw(true)
		self.skullModel:SetModelScale(0.2, 0)
	end
end

function SWEP:PrimaryAttack()
	self:DoLock(true)
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	self:DoLock(false)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:DoLock(lockUnLock)
	if CLIENT then
		return
	end
	local car = self:GetOwner():GetEyeTrace().Entity

	if IsValid(car) and car:CPPIGetOwner() == self:GetOwner() and car.SetIsLocked then
		car:SetIsLocked(lockUnLock)
		self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
		car:EmitSound("Buttons.snd13", 30)
	end
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
	return true
end

SWEP.Primary.Delay = 0
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 0
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Delay = 0
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Damage = 0
SWEP.Secondary.NumShots = 0
SWEP.Secondary.Cone = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

if CLIENT then
	SWEP.righModel = ClientsideModel("models/props_c17/tools_wrench01a.mdl", RENDERGROUP_OPAQUE)
	SWEP.righModel:SetNoDraw(true)
	SWEP.righModel:SetModelScale(0.2, 0)
	SWEP.righModel:SetMaterial("lights/white")
	SWEP.LastPos = Vector(0, 0, 0)
	SWEP.Posdiff = Vector(0, 0, 0)
	SWEP.LastPosSkull = Vector(0, 0, 0)
	SWEP.PosdiffSkull = Vector(0, 0, 0)

	function SWEP:DrawHUD()

	end

	function SWEP:ViewModelDrawn()

		local vm = self.Owner:GetViewModel()
		local bm = vm:GetBoneMatrix(0)
		local pos = bm:GetTranslation()
		local ang = bm:GetAngles()

		-- Drawing original model
		local normal = Vector(1, 0, 0)
		local origin = Vector(0, 0, 0)
		local distance = normal:Dot(origin)

		local oldEnableClipping = render.EnableClipping(true)
		render.PushCustomClipPlane(normal, distance)
		self:DrawModel()
		render.PopCustomClipPlane()
		render.EnableClipping(oldEnableClipping)

		if self.skullModel and self.Owner and self.Owner ~= NULL then

			bm = vm:GetBoneMatrix(vm:LookupBone("Bip01_L_Finger3"))
			pos = bm:GetTranslation()
			ang = bm:GetAngles()

			self.Posdiff = self.Posdiff + (self.LastPos - pos)
			self.Posdiff = self.Posdiff + Vector(0, 0, -2)
			self.LastPos = pos

			self.Posdiff.x = math.Approach(self.Posdiff.x, 0, -self.Posdiff.x * FrameTime() * 10)
			self.Posdiff.y = math.Approach(self.Posdiff.y, 0, -self.Posdiff.y * FrameTime() * 10)
			self.Posdiff.z = math.Approach(self.Posdiff.z, 0, -self.Posdiff.z * FrameTime() * 10)

			local movAng = self.Posdiff
			movAng = movAng:Angle()

			pos = pos + vm:GetUp() * 1 + vm:GetRight() * 4 + vm:GetForward() * 0.5
			ang = movAng
			ang:RotateAroundAxis(ang:Up(), -90)
			ang.p = 0
			pos = pos + movAng:Right() * -1.5

			-- Skull
			local scullPos = Vector(0, 0, 0)
			local scullAng = Angle(0, 0, 0)

			scullPos = pos + movAng:Right() * -1.8

			self.PosdiffSkull = self.PosdiffSkull + (self.LastPosSkull - scullPos) * 50
			self.PosdiffSkull = self.PosdiffSkull + Vector(0, 0, -2)
			self.LastPosSkull = scullPos

			self.PosdiffSkull.x = math.Approach(self.PosdiffSkull.x, 0, -self.PosdiffSkull.x * FrameTime() * 2)
			self.PosdiffSkull.y = math.Approach(self.PosdiffSkull.y, 0, -self.PosdiffSkull.y * FrameTime() * 2)
			self.PosdiffSkull.z = math.Approach(self.PosdiffSkull.z, 0, -self.PosdiffSkull.z * FrameTime() * 2)

			movAng = self.PosdiffSkull
			movAng = movAng:Angle()
			scullAng = movAng

			self.righModel:SetPos(pos)
			self.righModel:SetAngles(ang)
			self.righModel:DrawModel()

			self.skullModel:SetPos(scullPos)
			self.skullModel:SetAngles(scullAng)
			self.skullModel:DrawModel()

		end
	end
end
