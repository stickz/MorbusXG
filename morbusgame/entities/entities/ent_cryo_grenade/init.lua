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

	self:SetMaterial("reskins/masseffect/grenade_cryo")
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ent_cryo_grenade")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()

    return ent
end
ents.Create("prop_physics")

function ENT:Explode()
	ParticleEffect( "cryo_explosion", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "weapons/demon/hit1.wav", 100, 85 );

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 275 )) do
		local dmginfo = DamageInfo()
		if v:IsPlayer() then
		dmginfo:SetAttacker( self.GrenadeOwner )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 15 )
		v:TakeDamageInfo( dmginfo )
			v:Freeze( true )
			v:SetColor( Color( 0,155,255,255 ) )
				timer.Simple(3, function()
					if !v:IsValid() then return end
					v:Freeze( false )
					v:SetColor( Color( 255,255,255,255 ) )
				end)
		end
	end
	
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