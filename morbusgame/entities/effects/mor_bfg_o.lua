function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())


	for i=0, 15 do
		local part = emit:Add ("sprites/particles/mor_glow03", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(2)
		part:SetStartSize(355)
		part:SetColor( 255, 155, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, -155))
	end
	for i=0, 25 do
		local part = emit:Add ("sprites/particles/mor_glow01", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -55, 55 ), math.Rand( -55, 55 ), 55 ))
		part:SetDieTime(8)
		part:SetStartSize(180)
		part:SetColor( 255, 155, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 200 do
		local part = emit:Add ("sprites/particles/mor_glow01", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -455, 455 ), math.Rand( -455, 455 ), 455 ))
		part:SetDieTime(3)
		part:SetStartSize(64)
		part:SetColor( 255, 155, 55 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(5)
		part:SetCollide(true)
		part:SetBounce(1)
		part:SetGravity(Vector(0, 0, -355))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end