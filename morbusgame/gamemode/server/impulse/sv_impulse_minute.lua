// 1 minute impulse

local IMPULSE = {}
local max = math.max

function IMPULSE.MINUTE()	
	IMPULSE.DECREASEMINUTES()
	IMPULSE.SWARM_LIVES()
end
hook.Add("Impulse_Minute","Min_Impulse",IMPULSE.MINUTE)

function IMPULSE.DECREASEMINUTES()	
	if GetValidCount() >= 2 then
		local left = GetGlobalInt("morbus_minutes_left", 45)
		local decrease = max(0, left - 1)	
		
		SetGlobalInt("morbus_minutes_left", decrease)
	end
end

function IMPULSE.SWARM_LIVES()	
	--local respawns = GetGlobalInt("morbus_swarm_spawns",0)
	if (Swarm_Respawns < 0) then Swarm_Respawns = 0 end
	
	if Swarm_Respawns == 0 then
		--Create more swarm lives equivalent to the brood count	
		Swarm_Respawns = Swarm_Respawns + GetBroodCount(GetValidCount())
		SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns)
		
		timer.Simple(1, function()
							if Swarm_Respawns == 0 then
								SlayBots() 
							end
						end)
	end
end