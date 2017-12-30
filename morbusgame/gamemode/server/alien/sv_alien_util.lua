// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/*----------------------------------------------------
SEND ALIENS
----------------------------------------------------*/
function RevealAll()
   local brood = GetBroodList()
   local swarm = GetSwarmList()
   for k,v in pairs(brood) do
      SendOtherPlayerRole(ROLE_BROOD,v,HumanFilter())
   end
   for k,v in pairs(swarm) do
      SendOtherPlayerRole(ROLE_SWARM,v,HumanFilter())
   end

end

function UpdateAliens()
	local brood = GetBroodList()
	local swarm = GetSwarmList()

		for k,v in pairs(brood) do
			SendOtherPlayerRole(ROLE_BROOD,v,AlienFilter())
         v:SendEvoPoints()
         v:SendUpgrades()
		end

		--SEND SWARM ALIENS
		for k,v in pairs(swarm) do
			SendOtherPlayerRole(ROLE_SWARM,v,AlienFilter())
		end


end

function NewAlien(ply,role)
   if !ValidEntity(ply) then return end

   if ply:Team() == TEAM_SPEC then
      ply:SetTeam(TEAM_GAME)
      ply:UnSpectate()
      ply:SpectateEntity(nil)
      ply:SetRole(ROLE_SWARM)
      ply:SetPos(GAMEMODE:PlayerSelectSpawn(ply):GetPos())
      ply:Spawn()
   else
      AlienMsg(AlienFilter(),ply:GetFName(true).." is now a "..GetRoleName(role))
   end

   if role then
      if ply:GetRole() != role then
         ply:SetRole(role)
      end
   end

   SendPlayerRole(role,ply)
   ply.Mission = MISSION_KILL
   ply:SendMission()
   UpdateAliens()

   if (role == ROLE_BROOD) then
      if (Swarm_Respawns < 0) then Swarm_Respawns = 0 end
      Swarm_Respawns = Swarm_Respawns + GetBroodCount(GetValidCount())
      SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns)
   end

   if (role == ROLE_SWARM) then
      if (Swarm_Respawns > 0) || GetRoundState() == ROUND_EVAC then
         if GetRoundState() == ROUND_ACTIVE then
            if !table.KeyFromValue(botIDs, ply:SteamID()) then
				Swarm_Respawns = Swarm_Respawns - 1
				SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns)
			end
         end
         ply.NextSpawnTime = CurTime() + 6
      else
         ply:MakeSpec()
         ply.NextSpawnTime = CurTime() + 1
      end
   end
   
end

function BroodInfected(ply)
   local up = POINTS_PER_KILL
   local finalPoints = 4
   local newPlayerMax = 6
   local totalIncrease = Total_Evolution_Points + up
   
   if totalIncrease > finalPoints then
      if totalIncrease > newPlayerMax then
	     finalPoints = newPlayerMax
	  else
	     finalPoints = totalIncrease	  
	  end
   end
   
   Total_Evolution_Points = totalIncrease
   
   AlienMsg(BroodFilter(),"You have gained "..(up).." upgrade points!")

   local tPoints = 0
   for k,v in pairs(player.GetAll()) do
      if ValidEntity(v) && v:IsBrood() then
	     tPoints = v:GetTBroodPoints()
		 if tPoints and tPoints < 18 then
			 v.Evo_Points = v.Evo_Points + up
			 v:SetTBroodPoints(tPoints + up)
		 end
      end
   end

   ply:LightReset()
   ply.Evo_Points = finalPoints
   ply:SetTBroodPoints(finalPoints)
   NewAlien(ply,ROLE_BROOD)   
end

function SwarmInfected(ply)
   NewAlien(ply,ROLE_SWARM)
end

function AlienFilter()
  return GetPlayerFilter(function(p) return p:IsAlien() end )
end

function BroodFilter()
  return GetPlayerFilter(function(p) return p:IsBrood() end )
end

function HumanFilter()
  return GetPlayerFilter(function(p) return !p:IsAlien() end )
end




function GetAlienList()
   local trs = {}
   for k,v in ipairs(player.GetAll()) do
      if v:IsAlien() and v:IsGame() then table.insert(trs, v) end
   end

   return trs
end

function GetHumanList()
   local trs = {}
   for k,v in ipairs(player.GetAll()) do
      if !v:IsAlien() and v:IsGame() then table.insert(trs, v) end
   end

   return trs
end

function GetSpectatorList()
   local trs = {}
   for k,v in ipairs(player.GetAll()) do
      if !v:IsGame() then table.insert(trs, v) end
   end

   return trs
end

function GetSwarmList()
   local trs = {}
   for k,v in ipairs(player.GetAll()) do
      if v:IsSwarm() && v:IsGame() then table.insert(trs, v) end
   end

   return trs
end

function GetBroodList()
   local trs = {}
   for k,v in ipairs(player.GetAll()) do
      if v:IsBrood() then table.insert(trs, v) end
   end

   return trs
end