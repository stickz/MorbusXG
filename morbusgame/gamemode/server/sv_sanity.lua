/* Sanity system 

This is like TTT's Karma system
*/

local math = math

SANITY = {}

SANITY.RememberedPlayers = {}
SANITY.WriteToMapChange = {}

SANITY.st = {} //settings
SANITY.st.Enabled = CreateConVar("mor_sanity", "1", FCVAR_ARCHIVE)
SANITY.st.Starting = CreateConVar("mor_sanity_starting", "1000")
SANITY.st.Max = CreateConVar("mor_sanity_max", "1000")
SANITY.st.KillBrood = 40
SANITY.st.KillSwarm = 15
SANITY.st.KillHuman = 30
SANITY.st.RDM = 50
SANITY.st.Dirty = 0.5 --used for brood attacking swarm
SANITY.st.Ratio = 0.00185
SANITY.st.AlienRatio = 0.0003
SANITY.st.ScaleRatio = 0.70
SANITY.st.BonusRatio = 7 --regen anther 1% for every 7% missing
SANITY.st.Heal = 13
SANITY.st.MinDamage = 0.05
SANITY.st.MapHealMin = 60
SANITY.st.MapHealPercent = 30

local cfg = SANITY.st

function SANITY.Init()
	SetGlobalBool("mor_sanity", cfg.Enabled:GetBool())
end

function SANITY.IsEnabled()
   return GetGlobalBool("mor_sanity", false)
end

function SANITY.GetDF(ply)
	local k = 1000 - ply:GetLiveSanity()
    local df = 1 - 0.00004 * (k ^ 1.5685)
	
	return df
end

//For shooting someone who you shouldn't be
function SANITY.GetHurtPenalty(victim_sanity, dmg)
	local scaledSanity = victim_sanity * cfg.ScaleRatio
	local baseSanity = cfg.Max:GetInt() * (1 - cfg.ScaleRatio)
	
	return (scaledSanity + baseSanity) * math.Clamp(dmg * cfg.Ratio,0,1)
end

function SANITY.GetHurtReward(ply, dmg)   
	local maxSanity = cfg.Max:GetInt()
	local regenRate = SANITY.GetRegenRate(ply, maxSanity)  
	
    return maxSanity * math.Clamp(dmg * regenRate, 0, 1)
end

--regen 30-50% of damage delt depending on sanity
function SANITY.GetRegenRate(ply, maxSanity)
	--regen a bonus 1% sanity for every 2% missing
	local regenBoost = (1 - SANITY.GetDF(ply)) / maxSanity
	local regenRatio = regenBoost / cfg.BonusRatio
	
	--regen a base of 30% + the bonus amount
	return cfg.AlienRatio + regenBoost
end

function SANITY.GetKillPenaltyHuman(victim_sanity)
	return SANITY.GetHurtPenalty(victim_sanity, cfg.RDM)
end

function SANITY.GetKillPenaltyAlien(victim_sanity)
	return SANITY.GetHurtPenalty(victim_sanity, cfg.RDM*3)
end

function SANITY.GetBroodKillReward(ply)
	return SANITY.GetHurtReward(ply, cfg.KillBrood)
end

function SANITY.GetSwarmKillReward(ply)
	return SANITY.GetHurtReward(ply, cfg.KillSwarm)
end

function SANITY.GetHumanKillReward(ply)
   return SANITY.GetHurtReward(cfg.KillHuman)
end

function SANITY.GivePenalty(ply, penalty)
   ply:SetLiveSanity(math.max(ply:GetLiveSanity() - penalty, 0))
   SANITY.Remember(ply)
end

function SANITY.GiveReward(ply, reward)
   reward = SANITY.DecayedMultiplier(ply) * reward
   
   --parse through max regen to make sure we're not regening more than the round max
   local maxRegen = ply:GetRegenSanity() or 0
   reward = math.min(reward, maxRegen)
   ply:SetRegenSanity(maxRegen - reward)   
  
   ply:SetLiveSanity(math.min(ply:GetLiveSanity() + reward, cfg.Max:GetInt()))
   return reward
end

local expdecay = math.ExponentialDecay
function SANITY.DecayedMultiplier(ply)
   local max   = cfg.Max:GetInt()
   local start = cfg.Starting:GetInt()
   local k     = ply:GetLiveSanity()

   if k < start then
      return 1
   elseif k < max then
      -- if falloff is enabled, then if our karma is above the starting value,
      -- our round bonus is going to start decreasing as our karma increases
      local basediff = max - start
      local plydiff  = k - start
      local half     = 0.3

      -- exponentially decay the bonus such that when the player's excess karma
      -- is at (basediff * half) the bonus is half of the original value
      return expdecay(basediff * half, plydiff)
   end

   return 1
end

function SANITY.ApplySanity(ply)
   local df = 1

   -- any karma at 1000 or over guarantees a df of 1, only when it's lower do we
   -- need the penalty curve
   if ply:GetBaseSanity() < 1000 then
      df = SANITY.GetDF(ply)
   end
   ply:SetDamageFactor(math.Clamp(df, cfg.MinDamage, 1.0))
end

function SANITY.Hurt(attacker, victim, dmginfo)
   if not IsValid(attacker) or not IsValid(victim) then return end
   if attacker == victim then return end
   if not attacker:IsPlayer() or not victim:IsPlayer() then return end
   -- Ignore excess damage
   local hurt_amount = math.min(victim:Health(), dmginfo:GetDamage())

   if attacker:GetBrood() then
   
      if victim:GetBrood() or (victim:IsHuman() and attacker:GetNWBool("alienform") == false) then
		  local penalty = SANITY.GetHurtPenalty(victim:GetLiveSanity(), hurt_amount)
		  SANITY.GivePenalty(attacker, penalty)
		  
	  elseif victim:IsSwarm() then
		  local penalty = SANITY.GetHurtPenalty(victim:GetLiveSanity(), hurt_amount) * cfg.Dirty
		  SANITY.GivePenalty(attacker, penalty)
	  end

   elseif (not attacker:GetAlien()) then
      if victim:IsBrood() then
			local reward = SANITY.GetHurtReward(attacker, hurt_amount)
			reward = SANITY.GiveReward(attacker, reward)
			//MsgN(reward)

    	elseif victim:IsHuman() then
    		local penalty = SANITY.GetHurtPenalty(victim:GetLiveSanity(), hurt_amount)
			SANITY.GivePenalty(attacker, penalty)
			//MsgN(penalty)
  		end
   end
end


-- Handle karma change due to one player killing another.
function SANITY.Killed(attacker, victim, dmginfo)
   if not IsValid(attacker) or not IsValid(victim) then return end
   if attacker == victim then return end
   if not attacker:IsPlayer() or not victim:IsPlayer() then return end

   if attacker:GetBrood() then
   
	   if victim:GetBrood() then
			local penalty = SANITY.GetKillPenaltyAlien(victim:GetLiveSanity())
			SANITY.GivePenalty(attacker, penalty)
			
	   --elseif victim:IsSwarm() then
			--local penalty = GetKillPenaltyHuman(victim:GetLiveSanity())
			--SANITY.GivePenalty(attacker, penalty)
			--SANITY.Remember(attacker)
			
	   elseif victim:IsHuman() and attacker:GetNWBool("alienform") == false then   

			local penalty = SANITY.GetKillPenaltyHuman(victim:GetLiveSanity())
			SANITY.GivePenalty(attacker, penalty)
			MsgN(attacker:Name().." lost ".. penalty.." sanity.")
			
			--local reward = SANITY.GetBroodKillReward()
			--reward = SANITY.GiveReward(attacker, reward)
			--MsgN(attacker:Name().." gained ".. reward.." sanity.")	
	   end	   

   elseif (not attacker:GetAlien()) then
      if victim:IsBrood() then

			local reward = SANITY.GetBroodKillReward(attacker)
			reward = SANITY.GiveReward(attacker, reward)
			MsgN(attacker:Name().." gained ".. reward.." sanity.")

      elseif victim:IsSwarm() then

  			local reward = SANITY.GetSwarmKillReward(attacker)
			reward = SANITY.GiveReward(attacker, reward)
			MsgN(attacker:Name().." gained ".. reward.." sanity.")


    	elseif victim:IsHuman() then

    		local penalty = SANITY.GetKillPenaltyHuman(victim:GetLiveSanity())
			SANITY.GivePenalty(attacker, penalty)
			MsgN(attacker:Name().." lost ".. penalty.." sanity.")
  		end
   end
end

function SANITY.RoundIncrement()
   local healbonus = cfg.Heal

   for _, ply in pairs(player.GetAll()) do
      local bonus = healbonus
      SANITY.GiveReward(ply, bonus)
   end
end

function SANITY.SetMaxRegen()
	for _, ply in pairs(player.GetAll()) do
		ply:SetRegenSanity(cfg.Max:GetInt() - ply:GetBaseSanity())
	end
end

function SANITY.Rebase()
   for _, ply in pairs(player.GetAll()) do
      ply:SetBaseSanity(ply:GetLiveSanity())
   end
end

-- Apply karma to damage factor for all players
function SANITY.ApplySanityAll()
   for _, ply in pairs(player.GetAll()) do
      SANITY.ApplySanity(ply)
   end
end

function SANITY.NotifyPlayer(ply)
   local df = ply:GetDamageFactor() or 1
   local k = math.Round(ply:GetBaseSanity())
   if df > 0.99 then
      	PlayerMsg(ply,"You are completley sane, you are doing full damage",false)
   else
   		local num = math.ceil(df * 100)
   		PlayerMsg(ply,"Your sanity is waning, you  only do "..num.."% damage (One third of that with guns as Brood Alien)",false)
   end
end

function SANITY.RoundEnd()
   if SANITY.IsEnabled() then
	  SANITY.SetMaxRegen()
      SANITY.RoundIncrement()

      -- if karma trend needs to be shown in round report, may want to delay
      -- rebase until start of next round
      SANITY.Rebase()

      SANITY.RememberAll()
	  
	  -- if cfg.AutoKick:GetBool() then
      --    for _, ply in pairs(player.GetAll()) do
      --       SANITY.CheckAutoKick(ply)
      --    end
      -- end
   end
end

function SANITY.RoundBegin()
   SANITY.Init()

   if SANITY.IsEnabled() then
      for _, ply in pairs(player.GetAll()) do
         SANITY.ApplySanity(ply)

         SANITY.NotifyPlayer(ply)
      end
   end
end

function SANITY.MapEnd()
	SANITY.Restore()
	SANITY.WriteToJson()
end

function SANITY.InitPlayer(ply)
   local k = SANITY.Recall(ply) or cfg.Starting:GetInt()

   k = math.Clamp(k, 0, cfg.Max:GetInt())

   print("Initializing player "..ply:GetName().." with ".. k .." sanity.")

   ply:SetBaseSanity(k)
   ply:SetLiveSanity(k)
   ply:SetRegenSanity(k)
   ply:SetDamageFactor(1.0)

   -- compute the damagefactor based on actual (possibly loaded) karma
   SANITY.ApplySanity(ply)
end

function SANITY.Remember(ply)
	if ply.SteamID == nil then return end
   if (not ply:IsFullyAuthenticated()) then return end


   -- if persist is on, this is purely a backup method
   SANITY.RememberedPlayers[ply:SteamID()] = ply:GetLiveSanity()
end

function SANITY.Recall(ply)
	if ply.SteamID == nil then return end
   return SANITY.RememberedPlayers[ply:SteamID()]
end

function SANITY.LateRecallAndSet(ply)
   local k = SANITY.RememberedPlayers[ply:SteamID()]
   if k and k < ply:GetLiveSanity() then
      ply:SetBaseSanity(k)
      ply:SetLiveSanity(k)
   end
end

function SANITY.LateRecallAll()
   for _, ply in pairs(player.GetAll()) do
      SANITY.LateRecallAndSet(ply)
   end
end

function SANITY.RememberAll()
   for _, ply in pairs(player.GetAll()) do
      SANITY.Remember(ply)
   end
end

function SANITY.Restore()
	local minHeal, percentHeal
	local percentToDecimal = cfg.MapHealPercent / 100
	for k,v in pairs(SANITY.RememberedPlayers) do
		minHeal = v + cfg.MapHealMin
		
		if minHeal < 1000 then		
			percentHeal = ( 1000 - v ) * percentToDecimal
			SANITY.WriteToMapChange[k] = minHeal > percentHeal and minHeal or percentHeal
		end
	end
end

function SANITY.ClearJsonFile()
	local emptyTable = {} 
	emptyTable = util.TableToJSON(emptyTable)
	file.Write("sanity.txt", emptyTable)
end

function SANITY.WriteToJson()
	local tab = util.TableToJSON(SANITY.WriteToMapChange, true)
	file.Write("sanity.txt", tab)
end

function SANITY.InitalizeFromJson()
	local file = file.Read("sanity.txt") --read the sanities from previous maps
	local tab = util.JSONToTable(file) --convert the sanity from json to table
	SANITY.RememberedPlayers = tab --recall the sanity into the lua table
	SANITY.ClearJsonFile() --clear the json file incase the server crashes
	SANITY.LateRecallAll()
end

function MakeInsane(ply)
   ply:SetBaseSanity(300)
   ply:SetLiveSanity(300)
end
concommand.Add("insane",MakeInsane)