include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
end

local matFire = Material("sprites/particles/mor_glow02")
local matHeatWave = Material("sprites/heatwave")

function ENT:Draw ()
	self:SetModelScale(2, 0)
	self:DrawModel()

	local rt = RealTime()

	local vPos = self:GetPos()
	local siz = math.abs(math.sin(rt * 2)) * 16 + 8
	render.SetMaterial(matFire)
	render.DrawSprite(vPos, siz, siz, Color( 215, 255, 155 ))
end