include( "shared.lua" )

function ENT:Draw()
	render.SetMaterial( Material( "Sprites/light_glow02_add" ) )
	render.DrawSprite( self:GetPos(), 45, 45, Color(255,215,155,255))
end