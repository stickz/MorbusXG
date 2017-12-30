include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()
	render.SetMaterial( Material( "Sprites/light_glow02_add" ) )
	render.DrawSprite( self:GetPos(), 25, 25, Color(255,155,25,255))
end