lightUseCooldown = CurTime()

gt1_lightNames = {
	"lights_button2",
	"lights_button_potty",
	"lights_button_tower",
	"lights_button_all",
	"lights_button_hall"		
}
chem_LightNames = {
	"Switch_01",
	"Switch_02"
}
outpost_LightNames = {
	"Trigger Warehouse Lights",
	"Trigger Lab Lights",
	"Trigger Indoor Lights"
}

other_lightNames = {
	"generator_control",
	"light button",
	"lights_button2",
	"main_button",
	"power",
	"power_button",
	"lights_button"
}

lightsAdminGroups = {
	"superadmin",
	"admintech"
}

lightSpamMaps = {
	"mor_breach_cv21",
	"mor_installation_gt1_re",
	"mor_chemical_labs_b3_re",
	"mor_facility_cv2"
}

-- parallel tables for documenting single light maps and their names
singleLightMaps = {
	"mor_breach_cv21",
	"mor_alphastation_b4_re",
	"mor_auriga_v4_re",
	"mor_facility_cv2",
	"mor_grem",
	"mor_horizon_v11_re",
	"mor_ptmc_v22",
	"mor_temple_v1",
	"mor_turbatio"
}
singleButtonName = {
	"LightsButton",
	"generator_control",
	"light button",
	"gen_button",
	"lights_button2",
	"main_button",
	"power",
	"power_button",
	"lights_button"
}

if table.KeyFromValue(lightSpamMaps, game.GetMap()) then 
	hook.Add( "PlayerUse", "light_switch_cooldown", 

	function( ply, ent )
		if !IsValid(ent) then return end	
		
		local entName = ent:GetName()
		
		if entName == "LightsButton" or entName == "gen_button"
		or table.KeyFromValue(gt1_lightNames, entName)
		or table.KeyFromValue(chem_LightNames, entName) then
		
			if GetRoundState() != ROUND_ACTIVE or lightUseCooldown > CurTime() then
				return false
			else
				lightUseCooldown = CurTime() + 20			
				PrintLightUse(ply)		
			end
		end
	end)
else
	hook.Add( "PlayerUse", "light_switch_round_start", 

	function( ply, ent )
		if !IsValid(ent) then return end

		local entName = ent:GetName()
		
		if table.KeyFromValue(other_lightNames, entName) 
		or table.KeyFromValue(outpost_LightNames, entName) then	
			if GetRoundState() != ROUND_ACTIVE then
				return false
			end
			
			-- Print when player uses light, once every 5 seconds. No console spam here!
			if lightUseCooldown < CurTime() then
				lightUseCooldown = CurTime() + 5
				PrintLightUse(ply)
			end
		end
	end)
end

function PrintLightUse(ply)
	local rTime = CurTime() - (GetGlobalFloat("morbus_round_end", 0) - (GetConVar("morbus_roundtime"):GetInt() * 60))
	local fTime = string.ToMinutesSeconds(rTime)	
	
	for k,v in pairs(player.GetAll()) do
		if table.KeyFromValue(lightsAdminGroups, v:GetUserGroup()) then
			v:PrintMessage(HUD_PRINTCONSOLE, "["..fTime.."] ".. ply:GetName().. " used the light switch!")
		end
	end
end

function LockLights()
	local currentMap = game.GetMap()
	local foundMap = false
	
	for k, v in pairs(singleLightMaps) do
		if (v == currentMap) then
			for a, b in pairs(ents.FindByName(singleButtonName[k])) do
				if b:GetClass() == "func_button" then			
					b:Fire("Lock","", 0)
				end
			end
			
			foundMap = true
			break
		end
	end
	
	if foundMap == false then
		if currentMap == "mor_installation_gt1_re" then
			BlockMultipleLights(gt1_lightNames)
		elseif currentMap == "mor_chemical_labs_b3_re" then
			BlockMultipleLights(chem_LightNames)
		elseif currentMap == "mor_outpostnorth32_a5" then
			BlockMultipleLights(outpost_LightNames)
		end
	end
end

function BlockMultipleLights(myTable)
	for a, b in pairs(ents.GetAll()) do
		if b:GetClass() == "func_button" then
			if table.KeyFromValue(myTable, b:GetName()) then
				b:Fire("Lock","", 0)
			end	
		end
	end
end

function ChangeLightState()	
	ToggleLights("light")
	ToggleLights("lights")
	ToggleLights("power")
end

function ToggleLights(entName)
	for a, b in pairs(ents.FindByName(entName)) do
		if b:GetClass() == "light" then
			b:Fire("Toggle","",0)
		end
	end
end

concommand.Add( "mor_locklights", function( ply, cmd, args )
	if table.KeyFromValue(lightsAdminGroups, ply:GetUserGroup()) then
		LockLights()
		ply:PrintMessage( HUD_PRINTTALK, "Light switch buttons succesfully locked!" )
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end
end)

concommand.Add( "mor_togglelights", function( ply, cmd, args )
	if table.KeyFromValue(lightsAdminGroups, ply:GetUserGroup()) then
		ChangeLightState()
		ply:PrintMessage( HUD_PRINTTALK, "Light state succesfully changed!" )
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end
end)