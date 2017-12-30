include( "shared.lua" )

function ENT:Draw()
	render.SetMaterial( Material( "effects/blood_core" ) )
	render.DrawSprite( self:GetPos(), 45, 45, Color(115,155,0,255))
end