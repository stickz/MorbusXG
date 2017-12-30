EFFECT.Duration			= 0.7
EFFECT.Size				= 64

local MaterialGlow		= Material( "sprites/particles/mor_glow01.png" )

function EFFECT:Init( data )
	self.Position 	= data:GetOrigin()
	self.Normal 	= data:GetNormal()
	self.LifeTime 	= self.Duration
end

function EFFECT:Think()
	self.LifeTime = self.LifeTime - FrameTime()
	return self.LifeTime > 0
end

function EFFECT:Render()
	local frac = math.max( 0, self.LifeTime / self.Duration )
	local rgb = 255 * frac
	local r = 55 * frac
	local g = 155 * frac
	local b = 255 * frac
	local color = Color( r, g, b, rgb )

	render.SetMaterial( MaterialGlow )
	render.DrawQuadEasy( self.Position + self.Normal, self.Normal, self.Size, self.Size, color )
end
