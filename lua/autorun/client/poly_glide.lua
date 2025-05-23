list.Set("GlideCategories", "Poly - Hatchback", {name = "Poly - Hatchback", icon = "glide/icons/car.png"})
list.Set("GlideCategories", "Poly - Muscle", {name = "Poly - Muscle", icon = "glide/icons/car.png"})
list.Set("GlideCategories", "Poly - Sedan", {name = "Poly - Sedan", icon = "glide/icons/car.png"})
list.Set("GlideCategories", "Poly - Sport", {name = "Poly - Sport", icon = "glide/icons/car.png"})
list.Set("GlideCategories", "Poly - Suv", {name = "Poly - Suv", icon = "glide/icons/car.png"})
list.Set("GlideCategories", "Poly - Truck", {name = "Poly - Truck", icon = "glide/icons/car.png"})


local cl_interp = GetConVar("cl_interp"):GetFloat()
hook.Add( "Glide_OnLocalEnterVehicle", "Poly.Interp", function( vehicle, seatIndex )
    RunConsoleCommand("cl_interp", 0)
end )

hook.Add( "Glide_OnLocalExitVehicle", "Poly.Interp", function()
    RunConsoleCommand("cl_interp", cl_interp)
end )
