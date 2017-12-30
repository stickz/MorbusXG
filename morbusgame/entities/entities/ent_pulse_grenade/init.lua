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
	self.exploding = false
	self.explodecount = 0

	self:SetMaterial("reskins/masseffect/grenade_pulse")
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ent_frag_grenade")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()

    return ent
end
ents.Create("prop_physics")

function ENT:Explode()
	self.exploding = true
end

function ENT:ExplodeLoop()
	local phys = self.Entity:GetPhysicsObject()
	phys:AddVelocity( VectorRand() * 150 )

	ParticleEffect( "m_energy_imp_p", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "weapons/demon/hit1.wav", 100, 150)

    local bullet = {}
    bullet.Num      = 10
    bullet.Src      = self:GetPos() + Vector( 0, 0, 1 )
    bullet.Dir      = VectorRand()
    bullet.Spread   = Vector(5, 5, 1)
    bullet.Tracer   = 0
    bullet.TracerName = "mor_tracer_pulsep"
    bullet.Force    = 50
    bullet.Damage   = 10
	bullet.Callback = function(DInf, hPos, Dir)
		local EffectI = EffectData()
		
		EffectI:SetOrigin(hPos.HitPos)
		EffectI:SetStart(hPos.HitPos)
		EffectI:SetNormal(hPos.HitNormal)
		
		ParticleEffect( "l_energy_imp_p", hPos.HitPos, Angle(0, 0, 0), nil )
		util.Effect( "mor_decal_pulsep", EffectI, true, true)
	end 
    self:FireBullets(bullet)

    self.explodecount = self.explodecount + 1
    if self.explodecount > 25 then
    	self:Remove()
    end
end

function ENT:Think()
	if self.exploding == true then
		self:ExplodeLoop()
	end

	self:NextThink( CurTime() + 0.1 )
	return true
end

local BounceSnd = Sound( "HEGrenade.Bounce" )
function ENT:PhysicsCollide( data, phys )

	if data.Speed > 50 then
		self:EmitSound( BounceSnd )
	end

	local impulse = (-data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6))*0.5
	phys:ApplyForceCenter( impulse )	
end