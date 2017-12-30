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

	self:SetSmoked( false )
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ent_smoke_grenade")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()

    return ent
end
ents.Create("prop_physics")

local GasSnd = Sound( "gas.Loop" )

function ENT:Explode()
	local fx = EffectData()
	fx:SetOrigin( self:GetPos() + Vector(0, 0, 70) )
	
	for i=1, 35 do
		util.Effect( "mor_smoke", fx )	
	end
	
	self:SetSmoked( true )
	
	timer.Simple(15, function()
	if !self.Entity:IsValid() then return end
		self:Remove()
	end)
	
	self:EmitSound( GasSnd )
end

/*function ENT:Think()
	if self:GetSmoked() == true then
		self:Explode()
		self:NextThink(CurTime() + 3)
	end
end*/

local BounceSnd = Sound( "HEGrenade.Bounce" )
local GasSnd = Sound( "gas.Loop" )
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