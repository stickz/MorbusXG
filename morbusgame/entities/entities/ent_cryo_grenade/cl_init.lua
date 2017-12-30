include("shared.lua")

function ENT:Draw()
	self.Entity:DrawModel()
	render.SetMaterial( Material( "Sprites/light_glow02_add" ) )
	render.DrawSprite( self:GetPos(), 75, 75, Color(85,195,255,255))
end


