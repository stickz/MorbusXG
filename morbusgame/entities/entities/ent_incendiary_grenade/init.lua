AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/mass_effect_3/weapons/misc/grenade.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetMaterial("reskins/masseffect/grenade_incendiary")
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ent_incendiary_grenade")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()

    return ent
end
ents.Create("prop_physics")

function ENT:Explode()
	local effectdata = EffectData()
	effectdata:SetNormal( Vector(0,0,1) )
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "shockwave", effectdata, true, true )
	util.Effect( "explosion_dust", effectdata, true, true )
	ParticleEffect( "h_energy_imp_r", self:GetPos(), Angle(0, 0, 0), nil )
	ParticleEffect( "fire_explosion", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "weapons/demon/explosion.wav", 100, math.random(95,125) )

	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 185 )) do
		if v:IsPlayer() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self.GrenadeOwner )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 25 )
			v:TakeDamageInfo( dmginfo )
			v:Ignite( 4 )
		end
	end

	local explo = ents.Create( "env_explosion" )
	explo:SetOwner( self.GrenadeOwner )
	explo:SetPos( self:GetPos() )
	explo:SetKeyValue( "iMagnitude", "85" )
	explo:Spawn()
	explo:Activate()
	explo:Fire( "Explode", "", 0 )

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
	
	--remove after explosion
	self.Entity:Remove()
end

local BounceSnd = Sound( "HEGrenade.Bounce" )
function ENT:PhysicsCollide( data, phys )
	if data.Speed > 50 then
		self:EmitSound( BounceSnd )
	end
	local impulse = (-data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6))*0.5
	phys:ApplyForceCenter( impulse )
end

function ENT:Use( activator, caller )
	self.Entity:Remove()
end
