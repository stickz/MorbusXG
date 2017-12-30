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
	self.Death = CurTime() + 3
	self.Exploded = false
	self.Range = 155

	self:SetMaterial("reskins/masseffect/grenade_toxic")
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ent_toxic_grenade")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()

    return ent
end
ents.Create("prop_physics")

local GasSnd = Sound( "gas.Loop" )

function ENT:Explode()
	ParticleEffect( "h_plasma_imp_g", self:GetPos(), Angle(0, 0, 0), nil )
	
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "mor_toxic_smoke", fx )
	
	self.Entity:EmitSound( "weapons/demon/hit1.wav", 100, 85 );
	
	self:EmitSound( GasSnd )

	self.Exploded = true
	
	timer.Simple(6, function()
	if !IsValid(self.Entity) then return end
		self.Range = 255
	end)
	
	timer.Simple(12, function()
	if !IsValid(self.Entity) then return end
		self.Range = 300
	end)
	
	timer.Simple(15, function()
	if !IsValid(self.Entity) then return end
		self:Remove()
	end)
end

function ENT:DoToxicDamage()
	-- Damage in sphere
	if self.Exploded == false then return end
	
	/*local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "mor_toxic_smoke", fx )*/
	
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), self.Range )) do
		local dmginfo = DamageInfo()
		if IsValid(v) && v:IsPlayer() then
			dmginfo:SetAttacker( self.GrenadeOwner )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 2 )
			v:TakeDamageInfo( dmginfo )
		end
	end
end

function ENT:Think()
	if self.Exploded == false then return end
	self:DoToxicDamage()
end

local BounceSnd = Sound( "HEGrenade.Bounce" )

function ENT:PhysicsCollide( data, phys )
	if data.Speed > 50 then
		self:EmitSound( BounceSnd )
	end

	local impulse = (-data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6))*0.5
	phys:ApplyForceCenter( impulse )
end

function ENT:OnRemove()
	self:StopSound( GasSnd )
end