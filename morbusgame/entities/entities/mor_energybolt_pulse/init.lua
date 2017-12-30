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
		util.SpriteTrail(self.Entity, 0, Color(55, 155, 255, 255), false, 25, 0.5, 0.3, 45, "trails/plasma.vmt")

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:Think()
    if SERVER then
        self.tes = ents.Create( "point_tesla" )
        self.tes:SetPos( self:GetPos() )
        self.tes:SetKeyValue( "m_SoundName", "" )
        self.tes:SetKeyValue( "texture", "sprites/bluelight1.spr" )
        self.tes:SetKeyValue( "m_Color", "55 255 215" )
        self.tes:SetKeyValue( "m_flRadius", "55" )
        self.tes:SetKeyValue( "beamcount_min", "1" )
        self.tes:SetKeyValue( "beamcount_max", "2" )
        self.tes:SetKeyValue( "thick_min", "8" )
        self.tes:SetKeyValue( "thick_max", "16" )
        self.tes:SetKeyValue( "lifetime_min", "0.3" )
        self.tes:SetKeyValue( "lifetime_max", "0.5" )
        self.tes:SetKeyValue( "interval_min", "0.1" )
        self.tes:SetKeyValue( "interval_max", "0.3" )
        self.tes:Spawn()
        self.tes:Fire( "DoSpark", "", 0 )
        self.tes:Fire( "kill", "", 0.3 )
    end
end

function ENT:Explode()
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() )
	util.Effect( "mor_blast_smallb", fx )
	self.Entity:EmitSound( "weapons/demon/hit3.wav", 100, math.random(135,145) )

    if SERVER then
        self.tes = ents.Create( "point_tesla" )
        self.tes:SetPos( self:GetPos() )
        self.tes:SetKeyValue( "m_SoundName", "" )
        self.tes:SetKeyValue( "texture", "sprites/bluelight1.spr" )
        self.tes:SetKeyValue( "m_Color", "55 255 215" )
        self.tes:SetKeyValue( "m_flRadius", "185" )
        self.tes:SetKeyValue( "beamcount_min", "4" )
        self.tes:SetKeyValue( "beamcount_max", "5" )
        self.tes:SetKeyValue( "thick_min", "8" )
        self.tes:SetKeyValue( "thick_max", "16" )
        self.tes:SetKeyValue( "lifetime_min", "0.3" )
        self.tes:SetKeyValue( "lifetime_max", "0.5" )
        self.tes:SetKeyValue( "interval_min", "0.1" )
        self.tes:SetKeyValue( "interval_max", "0.3" )
        self.tes:Spawn()
        self.tes:Fire( "DoSpark", "", 0 )
        self.tes:Fire( "kill", "", 0.3 )
    end

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 65 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 15 )
			v:TakeDamageInfo( dmginfo )
		end
	end
	-- Extra cone 
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 135 )) do
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

function ENT:PhysicsCollide( data, phys )
	self:Explode()
end