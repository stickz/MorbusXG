AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/weapons/W_missile_launch.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 0, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(5, 5, 5, 255), false, 25, 1, 1, 65, "trails/smoke.vmt")

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	self.Created = CurTime()
end

function ENT:Explode()	
	-- SFX
	ParticleEffect( "spit_blast_dark", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "alien/acid_hit.wav", 100, math.random(95,125) );

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 125 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 13.5 )
		v:TakeDamageInfo( dmginfo )
	end
end


function ENT:PhysicsCollide( data, phys )
	self:Explode()
	self:Remove()
end
