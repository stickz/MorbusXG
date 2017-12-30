AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/weapons/W_missile_launch.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 55, 155, 255, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	-- Sprite Trail Effect
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(255, 155, 55, 255), false, 55, 1, 0.5, 45, "trails/plasma.vmt")

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:Explode()
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "mor_bfg_o", fx )
	ParticleEffect( "h_plasma_imp_o", self:GetPos(), Angle( 0, 0, 1 ), nil)
	self.Entity:EmitSound( "ambient/explosions/explode_5.wav", 100, math.random(125,135) )

	util.BlastDamage( self, self.Owner, self:GetPos(), 155, 35 )

	-- Damage in sphere
	/*for _, v in ipairs(ents.FindInSphere( self:GetPos(), 75 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 100 )
			v:TakeDamageInfo( dmginfo )
		end
	end*/
	
	-- Extra cone 
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 310 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 25 )
			v:TakeDamageInfo( dmginfo )
		end
	end
	self:Remove()
end

function ENT:PhysicsCollide( data, phys )
	self:Explode()
end