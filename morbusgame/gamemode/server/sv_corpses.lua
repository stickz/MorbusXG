//Player bodies

function CreateCorpse(ply, attacker, dmginfo)
   if not IsValid(ply) then return end
   
   -- fix bug where corposes appear during prep rounds
   local roundState = GetRoundState()   
   if roundState != ROUND_ACTIVE then return end

   local rag = ents.Create("prop_ragdoll")
   if not IsValid(rag) then return nil end
   rag.ragdoll = true
   ply.Body = rag

   rag:SetPos(ply:GetPos())
   
   local playerModel = ply:GetModel()   
   -- If the ragdoll is a valid player model
   if table.KeyFromValue(Models.Male, playerModel) or table.KeyFromValue(Models.Female, playerModel) then
   -- do nothing
   elseif (playerModel != Models.Brood and playerModel != Models.Swarm) then
      -- set the ragdoll to a valid player model
	  playerModel = table.Random(Models.Male)   
   end   
   rag:SetModel(playerModel)
   
   rag:SetAngles(ply:GetAngles())
   rag:SetNWBool("HumanBody",!ply:GetSwarm())
   rag:SetNWEntity("Player",ply)
   rag:SetNWString("Name", ply:GetFName())
   rag:SetNWInt("RoundNum", GetGlobalInt("morbus_rounds_left"))

   rag:Spawn()
   rag:Activate()

   if rag:GetNWBool("HumanBody") == false then
      timer.Simple( 30, function() 
         if ( rag ) and ( IsValid( rag ) ) then SafeRemoveEntity(rag) end 
      end)
   end

   -- Remove bodies on deathmatch.
   if roundState == ROUND_WAIT then
      timer.Simple( 3, function() 
         if ( rag ) and ( IsValid( rag ) ) then SafeRemoveEntity(rag) end 
      end);
      rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
   else
      rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)
   end
   -- nonsolid to players, but can be picked up and shot
end


function FoundBody()
   local pos = net.ReadVector()
   local ply = net.ReadEntity()
   if !ply || !IsValid(ply) then return end

   for k,v in pairs(player.GetAll()) do
      if v:IsGame() && !v:IsSwarm() && v:GetPos():Distance(pos) < 200 then
         net.Start("ReceivedBody")
         net.WriteEntity(ply)
         net.Send(v)
      end
   end
end
net.Receive("FoundBody",FoundBody)