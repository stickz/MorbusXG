// 4 second impulse
local IMPULSE = {}


function IMPULSE.SECOND4()
	IMPULSE.LOCATIONS()
	for k,v in pairs(player.GetAll()) do
		IMPULSE.SWARM(k,v)
		IMPULSE.AFK(k,v)
	end
end
hook.Add("Impulse_4Second","4Sec_Impulse",IMPULSE.SECOND4)


function IMPULSE.LOCATIONS()	
	if !MISSION_LOCS then -- I dont want to run this every time
		if (GetRoundState() != ROUND_ACTIVE) then return end -- Call the first time the round is active
		MISSION_LOCS = {}

		local buffer = {} -- speed
		for i=1,4 do	
			MISSION_LOCS[i] = {}
			MISSION_LOCS[i] = ents.FindByClass(NEED_ENTS[i][1])
			buffer = ents.FindByClass(NEED_ENTS[i][2])
			table.Add(MISSION_LOCS[i],buffer)
			buffer = {}
		end
	else
		for i=1,4 do
			local ent = MISSION_LOCS[i][math.random( 1,table.Count(MISSION_LOCS[i]) )]
			
			if IsValid(ent) then			
				local need_min, need_max = ent:WorldSpaceAABB()
				local need_pos = need_max - ((need_max - need_min) / 2)
				SetGlobalVector(NEED_ENTS[i][1], need_pos) --hurr durr
			end
		end
	end
end

iAdminGroups = { "admin", "superadmin", "owner", "administrators", "admintech", "moderators", "divisionmanagers", "operator" }

function IMPULSE.AFK(k,ply)	
	if ply:IsSpec() then return end
	
	local playerSteamID = ply:SteamID()	
	local playerCount = GetValidCount()	
	local botCount = GetBotCount()
	
	if table.KeyFromValue(ignoreBot, playerSteamID) then		
		if playerCount + botCount < 28 or botCount < 4 then			
			return
		end
	elseif table.KeyFromValue(botIDs, playerSteamID) then
		if playerCount < 9 && (GetRoundState() == ROUND_ACTIVE) then		
			SetSpec(ply)
		end		
		return		
	end

	if ply.LastAimVector and ply.LastAimVector == ply:GetAimVector() then
		if ply.KickTime <= CurTime() then
			if playerCount > 4 then
				if table.HasValue( iAdminGroups, ply:GetUserGroup()) then
					SetSpec(ply)
					return
				end
				
				if playerCount > 7 then
					ply:Kick("AFK")
				end
			end
		end
	else
		ply.LastAimVector = ply:GetAimVector()
		if table.HasValue( iAdminGroups, ply:GetUserGroup() ) then
			ply.KickTime = CurTime() + 75 //Move admin to spect after 90 (+ 0 - 4) seconds
		else		
			ply.KickTime = CurTime() + 160 //Kick afk player after 160 (+ 0 - 4) seconds
		end
	end
end


function IMPULSE.SWARM(k,v)
	if v:IsSwarm() && v:Team() == TEAM_GAME && v:Alive() then
		v:EmitSound(table.Random(Sounds.Swarm.Normal),400,100)
	end
end

function SetSpec(ply)
  ply.WantsSpec = true
  local msg = "You will now remain a spectator"

  ply:SetRole(ROLE_SWARM)
  SendMsg(ply,msg)
  ply:MakeSpec()
  ply:Kill()
end