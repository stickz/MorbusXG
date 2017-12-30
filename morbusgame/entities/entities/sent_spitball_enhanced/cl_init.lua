include( "shared.lua" )

function ENT:Draw()
	render.SetMaterial( Material( "effects/blood_core" ) )
	render.DrawSprite( self:GetPos(), 65, 65, Color(25,155,0,255))
end