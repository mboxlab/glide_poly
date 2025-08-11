hook.Add("PlayerSpawnSENT", "MetShop.Restrict", function(ply, class)
	if MetShop.Items[class] then
		if not MetShop.HasItem(ply, class) and not ply:IsSuperAdmin() then
            sdk.notifyLang(ply, "Эту машину можно приобрести в F2 магазине", 1, 3, {})
			return false
		end
	end
end, -1)
