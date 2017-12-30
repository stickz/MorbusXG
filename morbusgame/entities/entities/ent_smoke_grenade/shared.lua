ENT.Type = "anim"  

ENT.PrintName		= "GlowStick Green"
ENT.Author			= "Patrick Hunt"
ENT.Information		= ""
ENT.Category		= "GlowSticks"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Smoked" )
end