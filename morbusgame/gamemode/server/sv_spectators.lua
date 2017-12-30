/* Player Spectator Management */

SPEC = {}
SPEC.RememberedPlayers = {}
SPEC.WriteToMapChange = {}

function SPEC.ClearJsonFile()
	local emptyTable = {} 
	emptyTable = util.TableToJSON(emptyTable)
	file.Write("spectators.txt", emptyTable)
end

function SPEC.WriteToJson()
	local tab = util.TableToJSON(SPEC.WriteToMapChange, true)
	file.Write("spectators.txt", tab)
end

function SPEC.MapEnd()
	SPEC.SaveSpecators()
	SPEC.WriteToJson()
end

function SPEC.SaveSpecators()
	for k,v in pairs(player.GetAll()) do
		if v.WantsSpec then
			table.insert(SPEC.WriteToMapChange, v:SteamID()) 
		end
	end	
end

function SPEC.MarkPreviousPlayers()
	--if GetValidCount() > 3 then	
		for k,v in pairs(player.GetAll()) do
			if table.KeyFromValue(SPEC.RememberedPlayers, v:SteamID()) then
				if !v.WantsSpec then
					SPEC.ToggleSpec(v)
				end
			end	
		end
	--end
end

function SPEC.InitalizeFromJson()
	local file = file.Read("spectators.txt") --read the spectators from previous map
	local tab = util.JSONToTable(file) --convert the spectators from json to table
	SPEC.RememberedPlayers = tab --recall the spectators into the lua table
	SPEC.ClearJsonFile() --clear the json file incase the server crashes
end

function SPEC.ToggleSpec(ply)
  if !ply:IsAdmin() then   
	  if CAN_SUICIDE == false then
		ply:PrintMessage(HUD_PRINTTALK, "[xG] Please wait 30s after round start before joining spectate!")
		return
	  end

	  if !ply.WantsSpec and ply.LastWentSpec > CurTime() then
	    ply:PrintMessage(HUD_PRINTTALK, "[xG] Please wait 30s before going spectator again!")
	    return 	  
      end
  end
    
  if GAMEMODE.FirstRound then
	local SteamID = ply:SteamID()
	
	if table.HasValue(SPEC.RememberedPlayers, SteamID) then
		table.RemoveByValue(SPEC.RememberedPlayers, SteamID)
		ply:PrintMessage(HUD_PRINTTALK, "[xG] Spectator status succesfully revoked!")	
		return
	end	
  end  
  
  ply.WantsSpec = !ply.WantsSpec
  local msg = "You will now remain a spectator"

  if !ply.WantsSpec then
    msg = "You can now respawn"
	ply.LastWentSpec = CurTime() + 30
  end
  
  ply:SetRole(ROLE_SWARM)
  SendMsg(ply,msg)
  ply:MakeSpec()
  ply:Kill()
end