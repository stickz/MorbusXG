ENT.Type = "point"
ENT.Base = "base_point"

function ENT:Initialize()
   local grenades = ents.MORBUS.GetSpawnableGrenades(true)
   
   if grenades then
      local w = table.Random(grenades)
   
      local ent = ents.Create(WEPS.GetClass(w))

      if IsValid(ent) then
         local pos = self:GetPos()
         ent:SetPos(pos)
         ent:SetAngles(self:GetAngles())
         ent:Spawn()
         ent:PhysWake()
      end

      self:Remove()
   end
end