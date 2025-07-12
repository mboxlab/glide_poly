TOOL.Category = "Glide"
TOOL.Name = "Редактор Трения Колеса"

TOOL.Information = {{name = "left"}, {name = "left_use", icon2 = "gui/e.png"}, {name = "right"}}

TOOL.ClientConVar = {
	radius = 15,
	model = "models/props_vehicles/apc_tire001.mdl",

	long_b = 10.86,
	long_c = 2.15,
	long_d = 0.933,
	long_e = 0.992,

	lat_b = 12,
	lat_c = 1.3,
	lat_d = 1.8,
	lat_e = -1.8,
	--
}
local IsValid = IsValid

local function IsGlideVehicle(ent)
	return IsValid(ent) and ent.IsMeteorGlide
end

local function GetGlideVehicle(trace)
	local ent = trace.Entity

	if IsGlideVehicle(ent) then
		return ent
	end

	return false
end

local function GetAimingAtWheel(vehicle, pos)
	local wheels = vehicle.wheels

	if #wheels < 1 then
		return
	end

	local closestDist = 99999
	local dist, closestWheel
	for _, w in Glide.EntityPairs(wheels) do
		dist = pos:DistToSqr(w:GetPos())

		if dist < closestDist then
			closestDist = dist
			closestWheel = w
		end
	end

	return closestWheel
end

local ApplyVehicleWheelParameters

if SERVER then
	local ValidateNumber = Glide.ValidateNumber
	local IsValidModel = Glide.IsValidModel

	local function ApplyWheelParameters(wheel, params)

		wheel.params.longitudinalFrictionPreset = {
			B = ValidateNumber(params.long_b, 0.1, 5, 18),
			C = ValidateNumber(params.long_c, 0.1, 5, 1.5),
			D = ValidateNumber(params.long_d, 0.1, 5, 1.5),
			E = ValidateNumber(params.long_e, 0.1, 5, 0.3),
		}

		wheel.params.lateralFrictionPreset = {
			B = ValidateNumber(params.lat_b, 0.1, 5, 12),
			C = ValidateNumber(params.lat_c, 0.1, 5, 1.3),
			D = ValidateNumber(params.lat_d, 0.1, 5, 1.8),
			E = ValidateNumber(params.lat_e, 0.1, 5, -1.8),
		}
	end

	ApplyVehicleWheelParameters = function(_ply, vehicle, paramsPerWheel)
		if not IsGlideVehicle(vehicle) then
			return false
		end

		duplicator.ClearEntityModifier(vehicle, "glide_wheel_params")

		-- Make sure the target vehicle has at least one wheel
		local wheels = vehicle.wheels
		if type(wheels) ~= "table" then
			return false
		end
		if #wheels < 1 then
			return false
		end

		local filteredParamsPerWheel = {}

		for index, params in pairs(paramsPerWheel) do
			if type(index) == "number" then
				-- Check if a wheel with this index exists
				local wheel = wheels[index]

				if IsValid(wheel) and not wheel.GlideIsHidden then
					-- Apply parameters to this wheel
					ApplyWheelParameters(wheel, params)

					filteredParamsPerWheel[index] = params
				end
			end
		end

		duplicator.StoreEntityModifier(vehicle, "glide_wheel_params", filteredParamsPerWheel)

		return true
	end

	duplicator.RegisterEntityModifier("glide_wheel_params", ApplyVehicleWheelParameters)
end

function TOOL:LeftClick(trace)
	local vehicle = GetGlideVehicle(trace)
	if not vehicle then
		return false
	end

	local wheel = GetAimingAtWheel(vehicle, trace.HitPos)
	if not IsValid(wheel) then
		return false
	end

	if SERVER then
		local ply = self:GetOwner()

		if wheel.GlideIsHidden then
			Glide.SendNotification(ply, {
				text = "#tool.glide_wheel_editor.vehicle_model",
				icon = "materials/icon16/cancel.png",
				sound = "glide/ui/radar_alert.wav",
				immediate = true,
			})

			return false
		end

		local paramsPerWheel = {}

		if type(vehicle.EntityMods["glide_wheel_params"]) == "table" then
			paramsPerWheel = table.Copy(vehicle.EntityMods["glide_wheel_params"])
		end

		local setOnAllWheels = ply:KeyDown(IN_USE)

		local params = {
			long_b = self:GetClientNumber("long_b", 18),
			long_c = self:GetClientNumber("long_c", 1.5),
			long_d = self:GetClientNumber("long_d", 1.5),
			long_e = self:GetClientNumber("long_e", 0.3),
			lat_b = self:GetClientNumber("lat_b", 12),
			lat_c = self:GetClientNumber("lat_c", 1.3),
			lat_d = self:GetClientNumber("lat_d", 1.8),
			lat_e = self:GetClientNumber("lat_e", -1.8),
		}

		for index, w in Glide.EntityPairs(vehicle.wheels) do
			if wheel == w or setOnAllWheels then
				paramsPerWheel[index] = table.Copy(params)

				if not setOnAllWheels then
					break
				end
			end
		end

		return ApplyVehicleWheelParameters(ply, vehicle, paramsPerWheel)
	end

	return true
end

function TOOL:RightClick(trace)
	local vehicle = GetGlideVehicle(trace)
	if not vehicle then
		return false
	end

	local wheel = GetAimingAtWheel(vehicle, trace.HitPos)
	if not IsValid(wheel) then
		return false
	end

	if SERVER then
		if not wheel.params or not wheel.params.longitudinalFrictionPreset then return end

		local ply = self:GetOwner()
		
		ply:ConCommand("glide_wheel_traction_long_b " .. wheel.params.longitudinalFrictionPreset.B)
		ply:ConCommand("glide_wheel_traction_long_c " .. wheel.params.longitudinalFrictionPreset.C)
		ply:ConCommand("glide_wheel_traction_long_d " .. wheel.params.longitudinalFrictionPreset.D)
		ply:ConCommand("glide_wheel_traction_long_e " .. wheel.params.longitudinalFrictionPreset.E)

		ply:ConCommand("glide_wheel_traction_lat_b " .. wheel.params.lateralFrictionPreset.B)
		ply:ConCommand("glide_wheel_traction_lat_c " .. wheel.params.lateralFrictionPreset.C)
		ply:ConCommand("glide_wheel_traction_lat_d " .. wheel.params.lateralFrictionPreset.D)
		ply:ConCommand("glide_wheel_traction_lat_e " .. wheel.params.lateralFrictionPreset.E)
	end

	return true
end

function TOOL:Reload()
	return false
end

if not CLIENT then
	return
end

local matWireframe = Material("models/wireframe")

function TOOL:DrawHUD()
	local trace = self:GetOwner():GetEyeTrace()
	local vehicle = GetGlideVehicle(trace)
	if not vehicle then
		return
	end

	local wheel = GetAimingAtWheel(vehicle, trace.HitPos)

	if not IsValid(wheel) then
		return
	end

	local pulse = 0.6 + math.sin(RealTime() * 8) * 0.4

	cam.Start3D()
	render.SetColorMaterialIgnoreZ()
	render.SetColorModulation(0, pulse * 0.4, pulse)
	render.SuppressEngineLighting(true)
	render.ModelMaterialOverride(matWireframe)

	wheel:SetupBones()
	wheel:DrawModel()

	render.ModelMaterialOverride(nil)
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1, 1, 1)
	cam.End3D()
end

local function AddGraph()
	local Base = vgui.Create("Panel")
	Base:DockMargin(0, 5, 0, 5)
	Base:SetMouseInputEnabled(true)

	-- Color of the back pane of the graph
	AccessorFunc(Base, "BGColor", "BGColor", FORCE_COLOR)
	AccessorFunc(Base, "FGColor", "FGColor", FORCE_COLOR)
	AccessorFunc(Base, "GridColor", "GridColor", FORCE_COLOR)

	Base:SetBGColor(Color(255, 255, 255)) -- Back panel
	Base:SetFGColor(Color(25, 25, 25)) -- Border lines, text
	Base:SetGridColor(Color(175, 175, 175)) -- Grid lines

	Base.Function = function()
	end

	Base.Paint = function(self, w, h)
		surface.SetDrawColor(self.BGColor)
		surface.DrawRect(0, 0, w, h)

		local func = self.Function

		local max = -math.huge
		local tbl = {}
		for I = 0, 1, 0.01 do
			local val = func(I)
			tbl[#tbl + 1] = val
			if max < val then
				max = val
			end
		end

		local GridX = 24
		local GridY = 1 * max

		local Hovering = self:IsHovered()
		local LocalMouseX, LocalMouseY = 0, 0
		local ScaledMouseX, ScaledMouseY = 0, 0

		surface.SetDrawColor(self.GridColor)
		for I = 1, math.floor(GridX) do
			local xpos = I * (w / GridX)
			surface.DrawLine(xpos, 0, xpos, h)
		end

		for I = 1, math.floor(GridY) do
			local ypos = h - (I * (h / GridY))
			surface.DrawLine(0, ypos, w, ypos)
		end

		surface.SetDrawColor(Color(255, 0, 0))

		local xp1 = 0
		local yp1 = h - (h * func(0))
		for k, v in ipairs(tbl) do
			local xp2 = (k / 100) * w
			local yp2 = h - (h * (v / max))

			surface.DrawLine(xp1, yp1, xp2, yp2)
			xp1 = xp2
			yp1 = yp2
		end
	end

	return Base
end

local conVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(panel)
	panel:ToolPresets("glide_wheel_traction", conVarsDefault)

	panel:Help("Продольное трение")
	local B = panel:NumSlider("B", "glide_wheel_traction_long_b", 0, 30, 2)
	local C = panel:NumSlider("C", "glide_wheel_traction_long_c", 0, 5, 2)
	local D = panel:NumSlider("D", "glide_wheel_traction_long_d", 0, 30, 2)
	local E = panel:NumSlider("E", "glide_wheel_traction_long_e", -5, 5, 2)

	local long_graph = AddGraph()
	long_graph:SetHeight(200)

	long_graph.Function = function(x)
		local t = math.abs(x)
		return D:GetValue() * math.sin(C:GetValue() * math.atan(B:GetValue() * t - E:GetValue() * (B:GetValue() * t - math.atan(B:GetValue() * t))))
	end
	panel:AddItem(long_graph)

	panel:Help("Поперечное трение")
	local B = panel:NumSlider("B", "glide_wheel_traction_lat_b", 0, 30, 2)
	local C = panel:NumSlider("C", "glide_wheel_traction_lat_c", 0, 5, 2)
	local D = panel:NumSlider("D", "glide_wheel_traction_lat_d", 0, 30, 2)
	local E = panel:NumSlider("E", "glide_wheel_traction_lat_e", -5, 5, 2)

	local long_graph = AddGraph()
	long_graph:SetHeight(200)

	long_graph.Function = function(x)
		local t = math.abs(x)
		return D:GetValue() * math.sin(C:GetValue() * math.atan(B:GetValue() * t - E:GetValue() * (B:GetValue() * t - math.atan(B:GetValue() * t))))
	end
	panel:AddItem(long_graph)
end
