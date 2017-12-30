trapUseCooldown = CurTime()

trapNames = {
	"trap_mgbutton1",
	"button_em1",
	"button_em2"
}

trapTableBans = {
	"STEAM_0:1:27587967",
	"STEAM_0:1:25486721"
}

trapAdminGroups = {
	"superadmin",
	"admintech"
}

hook.Add( "PlayerUse", "trap_blocking", 

function( ply, ent )
	if !IsValid(ent) then return end

	-- If the trap is found from the entity listing
	if table.KeyFromValue(trapNames, ent:GetName()) then
		-- If the player is trap banned, don't let them use it
		if table.KeyFromValue(trapTableBans, ply:SteamID()) then
			return false
		end
	
		-- display trap notification every 5 seconds, no spam here!
		if trapUseCooldown < CurTime() then
			trapUseCooldown = CurTime() + 5
			PrintTrapUse(ply)			
		end
	end	
end)

function PrintTrapUse(ply)
	local rTime = CurTime() - (GetGlobalFloat("morbus_round_end", 0) - (GetConVar("morbus_roundtime"):GetInt() * 60))
	local fTime = string.ToMinutesSeconds(rTime)
	
	for k,v in pairs(player.GetAll()) do
		if table.KeyFromValue(trapAdminGroups, v:GetUserGroup()) then
			v:PrintMessage(HUD_PRINTCONSOLE, "["..fTime.."] ".. ply:GetName().. " used a map trap!")
		end
	end
end