include("shared.lua")
function ENT:Initialize()
	self:DrawShadow(false)

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(24, 48)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
	self.NextEmit = 0
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
	return true
end

local matFire = Material("sprites/light_glow02_add")
local matHeatWave = Material("sprites/heatwave")
function ENT:Draw ()
	self:SetModelScale(2, 0)
	self:DrawModel()

	local rt = RealTime()

	local vPos = self:GetPos()
	local siz = math.abs(math.sin(rt * 10)) * 128 + 64
	render.SetMaterial(matFire)
	render.DrawSprite(vPos, siz, siz, Color( 215, 115, 255 ))

	if RealTime() < self.NextEmit then return end
	self.NextEmit = RealTime() + 0.03

	local emitter = self.Emitter
	emitter:SetPos(vPos)

	local particle = emitter:Add("sprites/particles/mor_glow02", vPos)
	particle:SetVelocity( VectorRand() * 25 )
	particle:SetDieTime(0.4)
	particle:SetStartAlpha(155)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.random(25,35))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-41, 41))
	particle:SetGravity(Vector(0,0,0))
	particle:SetAirResistance(0)
	particle:SetColor( 215, 115, 255 )
end