AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/weapons/W_missile_launch.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 0, 0, 0, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )


	self:SetModelScale(0.5)

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	timer.Simple(math.random(1,3),function()
		if IsValid(self) then
			self:Explode()
		end
	end)

	self.Created = CurTime()
end


function ENT:Explode()
	ParticleEffect("l_delta_imp_o",self:GetPos(),Angle(0,0,0),nil)
	self.Entity:EmitSound( "weapons/blaster/blaster_hit.wav", 100, math.random(95,125) )

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 55 )) do
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
	if ( data.Speed > 25 ) then
		self:EmitSound("weapons/blaster/blaster_hit.wav", 75, 175)
	end
	if ( data.Speed > 1000 ) then
		ParticleEffect("l_delta_imp_o",self:GetPos(),Angle(0,0,0),nil)
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 45 )) do
			if v != self:GetOwner() then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( self:GetOwner() )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( 10 )
				v:TakeDamageInfo( dmginfo )
			end
		end
		self:Remove()
	end
end