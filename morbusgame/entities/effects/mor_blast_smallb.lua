function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 5 do
		local part = emit:Add ("sprites/particles/mor_glow03", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(0.5)
		part:SetStartSize(155)
		part:SetColor( 55, 155, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -155))
	end
	for i=0, 35 do
		local part = emit:Add ("sprites/particles/mor_glow01", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -255, 255 ), math.Rand( -255, 255 ), 255 ))
		part:SetDieTime(1.5)
		part:SetStartSize(15)
		part:SetColor( 55, 155, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -155))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end