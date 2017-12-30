AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/mass_effect_3/weapons/misc/grenade.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self.Death 		= CurTime() + 6
	self.Beep 		= CurTime() + 1
	self.Created 	= CurTime()
	self.Exploded 	= false

	self:SetMaterial("reskins/masseffect/grenade_plasma")
end

function ENT:Think()
	if self.Exploded == 1 then
		self:WhileExploding()
		self:Remove()
	end
	if self.Beep && self.Beep < CurTime() then
		self.Beep 		= CurTime() + 1
		self.Entity:EmitSound( "weapons/demon/charge.wav", 75, 250 )
		ParticleEffect( "l_photon_imp_b", self:GetPos(), Angle(0, 0, 0), nil )
	end
	if self.Death && self.Death < CurTime() then
		self:WhileExploding()
		self:Remove()
	end
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ent_plasma_grenade")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()

    return ent
end
ents.Create("prop_physics")

function ENT:Explode()
	self.Exploded = true
end

function ENT:WhileExploding()
	ParticleEffect( "plasma_explosion", self:GetPos(), Angle(0, 0, 0), nil )
	ParticleEffect( "h_energy_imp_b", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "weapons/demon/energy_heavy4.wav", 100, 100 )

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 125 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self.GrenadeOwner )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 85 )
		v:TakeDamageInfo( dmginfo )
	end

	local shake = ents.Create( "env_shake" )
	shake:SetOwner( self.Owner )
	shake:SetPos( self:GetPos() )
	shake:SetKeyValue( "amplitude", "2000" )	-- Power of the shake
	shake:SetKeyValue( "radius", "900" )	-- Radius of the shake
	shake:SetKeyValue( "duration", "0.5" )	-- Time of shake
	shake:SetKeyValue( "frequency", "255" )	-- How har should the screenshake be
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
end

function ENT:PhysicsCollide( data, physobj )
  if IsValid(self:GetParent()) then return end
  if data.HitEntity then
    ent = data.HitEntity
    if ent:IsWorld() then
      self:SetMoveType(MOVETYPE_NONE)
      self:SetPos(data.HitPos - data.HitNormal * 1.2)
      flip = 1
      if data.HitNormal.y > 0 then
        flip = -1
      end
      self:SetAngles(Angle(0,data.HitNormal.y + data.HitNormal.x,-data.HitNormal.z * flip) * 90)
    elseif ent:IsPlayer() and !ent:IsWeapon() then
      self:SetPos(data.HitPos - data.HitNormal )
      flip = 1
      if data.HitNormal.y > 0 then
        flip = -1
      end
      self:SetAngles(Angle(0,data.HitNormal.y + data.HitNormal.x,-data.HitNormal.z * flip) * 90)
   	  self:SetSolid( SOLID_NONE )
      self:SetParent(ent)
    end

	ParticleEffect( "l_photon_imp_b", self:GetPos(), Angle(0, 0, 0), nil )
    self.Entity:EmitSound( "weapons/demon/charge.wav", 100, 150 )
  end
end