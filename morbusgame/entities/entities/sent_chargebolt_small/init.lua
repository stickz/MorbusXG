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
	
	-- Sprite Trail Effect
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(255, 155, 55, 155), false, 5, 0.2, 0.1, 15, "trails/laser.vmt")

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	self.Created = CurTime()
end

function ENT:Explode()
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "mor_blast_smallo", fx )
	self.Entity:EmitSound( "weapons/blaster/blaster_hit.wav", 100, math.random(95,125) )

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 95 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 15 )
			v:TakeDamageInfo( dmginfo )
		end
	end

	self:Remove()
end

function ENT:PhysicsCollide( data, phys )
	self:Explode()
end