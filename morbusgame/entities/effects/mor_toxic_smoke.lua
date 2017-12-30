function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 3 do
		local part = emit:Add ("sprites/particles/mor_glow01", data:GetOrigin())
		
		if (part) then
			part:SetVelocity(VectorRand()* Vector( math.Rand( -512, 512 ), math.Rand( -512, 512 ), 512 ))
			part:SetDieTime(12)
			part:SetStartSize(1024)
			part:SetColor( 155, 255, 55 ) 
			part:SetEndSize(1024)
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