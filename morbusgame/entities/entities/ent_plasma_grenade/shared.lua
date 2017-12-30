ENT.Type = "anim"  

ENT.PrintName		= "Plasma Grenade"
ENT.Author			= "Demonkush"
ENT.Information		= ""

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Initialize()
	self:SetModel("models/weapons/w_eq_fraggrenade.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self.Death 		= CurTime() + 5
	self.Beep 		= CurTime() + 1
	self.Created 	= CurTime()
	self.Exploded 	= false
end