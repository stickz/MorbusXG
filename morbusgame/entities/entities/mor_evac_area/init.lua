
ENT.Base = "base_entity"
ENT.Type = "brush"

/*---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )
   if entity:IsPlayer() then
      entity.Evacuated = true
      Human_Evacuated = true
      local ply = entity
     
      ply:SetRole(ROLE_SWARM)
      ply:MakeSpec(true)
      ply:Kill()
   end
end

/*---------------------------------------------------------
   Name: PassesTriggerFilters
   Desc: Return true if this object should trigger us
---------------------------------------------------------*/
function ENT:PassesTriggerFilters( entity )
   return true
end