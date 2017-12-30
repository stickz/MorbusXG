// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/*-----------------------------
ROLE SELECTION
------------------------------*/

function GetBroodCount(ply_count)	
	if ply_count > 22 then
		return 3
	elseif ply_count > 11 then
		return 2
	else
		return 1
	end
end

local function SendRoles()
   for k,v in pairs(player.GetAll()) do
      if IsValid(v) then
         SendPlayerRole(v:GetRole(), v)
      end
   end
end

local function HighBaseSanity(ply)
	if ply:GetBaseSanity() > 700 then
		return true
	end

	return false
end

local function GetHighNum(ply)
	if HighBaseSanity(ply) then
		return 4		
	end
	
	return 8
end

local function SelectBrood(ply)
	if (table.HasValue(LAST_ALIEN,ply) and math.random(1, GetHighNum(ply)) < 2) then
		return true
	elseif (HighBaseSanity(ply) or math.random(1,3) < 3) then
		return true
	end
	
	return false	
end


LAST_ALIEN = {}
local Allow_Bots = false
function SelectRoles()
   local choices = {}	
  
   -- Loop through all players, remove 500 or lower sanity and bots
   -- From the brood selection table
   for k,v in pairs(player.GetAll()) do
      if IsValid(v) && v:IsGame() then
         if (Allow_Bots && v:IsBot()) || !v:IsBot() then
			if table.KeyFromValue(botIDs, v:SteamID()) then			
			
			elseif v:GetBaseSanity() > 500 then
               table.insert(choices, v)
            end
         end
      end

      v:SetRole(ROLE_HUMAN)
   end
  
   -- Check if we need to add bots back into the brood selection table
   if #choices < 2 then
      for k,v in pairs(player.GetAll()) do
         if IsValid(v) && v:IsGame() then
		    if table.KeyFromValue(botIDs, v:SteamID()) then
               table.insert(choices, v)
			   break
            end		   
	     end
      end
   end
   
   -- Cache these varriables, we'll need them for the loop
   local choice_count = #choices   
   local brood_count = GetBroodCount(choice_count)
   local la = {}
   local ts = 0
   
   -- Three cheers for micro-optimizations
   local pick = nil
   local pply = nil
   local pass = nil
   
   -- While we need still to select our broods
   while ts < brood_count do  
      
	  -- Choose a random player from the choices table
      pick = math.random(1,#choices)
   	  pply = choices[pick]
      pass = SelectBrood(pply)

	  -- If they're valid and usable, select them as brood
   	  if IsValid(pply) && (pass == true) then		
		  InitalizeBroodPlayer(pply, brood_count, choice_count)
		
   		  table.remove(choices, pick)
   		  ts = ts + 1
          RoundHistory["First"][ts] = pply
          table.insert(la,pply)
   	  end
   end
   
   -- If the bots are not needed, drop them to swarm
   if choice_count > 1 then
      timer.Simple(0.5, function() SlayBots() end)
   end
   
   -- Finalzie things by copying/updating aliens and sending roles
   LAST_ALIEN = table.Copy(la)
   SendRoles()
   UpdateAliens(true)
end

function InitalizeBroodPlayer(ply, brood_count, choice_count)
	ply:SetRole(ROLE_BROOD)
	ply.Mission = MISSION_KILL
	ply:SendMission()
	
	if brood_count == 1 and choice_count > 3 then
		if choice_count > 20 then
			ply.Evo_Points = STARTING_EVOLUTION_QUEEN + 1
			ply:PrintMessage( HUD_PRINTTALK, "You've been given one extra point, due to limited starting broods!" )
		elseif choice_count > 7 then
			ply.Evo_Points = STARTING_EVOLUTION_QUEEN + 2
			ply:PrintMessage( HUD_PRINTTALK, "You've been given two extra points, for being the only starting brood!" )
		else
			ply.Evo_Points = STARTING_EVOLUTION_QUEEN + 1
			ply:PrintMessage( HUD_PRINTTALK, "You've been given one extra point, for being the only starting brood!" )
		end
	elseif brood_count > 2 then
		ply.Evo_Points = STARTING_EVOLUTION_QUEEN - 1
		ply:PrintMessage( HUD_PRINTTALK, "You've been given one less point, due to more than two starting broods!" )
	else
		ply.Evo_Points = STARTING_EVOLUTION_QUEEN
	end
end