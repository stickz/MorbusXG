/*========================================
MAP TIME LIMITS
======================================*/

sanctionedByType = {
	"mor_outpostnorth32_a5",
	"mor_horizon_v11_re",
	"mor_isolation_cv1",
	"mor_turbatio"
}

sanctionedBySize = {
	"mor_breach_cv21",
	"mor_skandalon_b5_re",
	"mor_spaceship_v10_re"
}

sanctionedByLargePC = {
	"mor_chemical_labs_b3_re",
	"mor_breach_cv21"
}

function SetTimeLimits()
	local currentMap = game.GetMap()	
	local clientCount = GetValidCount()
	
	if currentMap == "mor_isolation_b4_re" then	
		SetGlobalInt("morbus_minutes_left", 28)
		
	-- If the map is less popular for w/e reason
	elseif table.KeyFromValue( sanctionedByType, currentMap ) then
		SetGlobalInt("morbus_minutes_left", 21)
		
	-- If the map doesn't play well with lower player counts
	elseif table.KeyFromValue( sanctionedBySize, currentMap ) and clientCount < 8 then
		SetGlobalInt("morbus_minutes_left", 21)
		
	-- If the map doesn't play well with the highest player counts
	elseif table.KeyFromValue( sanctionedByLargePC, currentMap ) and clientCount > 20 then
		SetGlobalInt("morbus_minutes_left", 21)
		
	else
		SetGlobalInt("morbus_minutes_left", 24)
	end
end