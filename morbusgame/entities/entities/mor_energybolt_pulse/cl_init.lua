include( "shared.lua" )

function ENT:Draw()
	--self:DrawModel()
	render.SetMaterial( Material( "Sprites/light_glow02_add" ) )
	render.DrawSprite( self:GetPos(), 50, 50, Color(55,155,255,255))
end