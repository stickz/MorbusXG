function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 1 do
		local part = emit:Add ("sprites/particles/mor_glow04", data:GetOrigin())
		
		if (part) then
			part:SetVelocity(VectorRand()* Vector( math.Rand( -512, 512 ), math.Rand( -512, 512 ), 512 ))
			part:SetDieTime(30)
			part:SetStartSize(750)
			part:SetColor( 55, 55, 55, 255 ) 
			part:SetEndSize(750)
			part:SetRoll(math.random(0,360))
			part:SetRollDelta(0)
			part:SetAirResistance(100)
			part:SetGravity(Vector(0, 0, 0))
		end
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end