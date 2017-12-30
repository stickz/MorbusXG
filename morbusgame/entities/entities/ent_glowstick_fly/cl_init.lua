include("shared.lua")

function ENT:Draw()
	self.Entity:DrawModel()
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = 0
		dlight.g = 255
		dlight.b = 0
		dlight.Brightness = 1
		dlight.Size = 600
		dlight.Decay = 1
		dlight.DieTime = CurTime() + 90
	end
end

function ENT:OnRemove()
	DynamicLight( self:EntIndex() ).DieTime = CurTime()
end