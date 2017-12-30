function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	for i=0, 5 do
		local part = emit:Add ("sprites/particles/mor_glow02", data:GetOrigin())
		part:SetVelocity(Vector(0,0,0))
		part:SetDieTime(1)
		part:SetStartSize(256)
		part:SetColor( 55, 115, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 5 do
		local part = emit:Add ("sprites/particles/mor_glow02", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -55, 55 ), math.Rand( -55, 55 ), 55 ))
		part:SetDieTime(3)
		part:SetStartSize(128)
		part:SetColor( 55, 55, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(math.random(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
		part:SetGravity(Vector(0, 0, 0))
	end
	for i=0, 200 do
		local part = emit:Add ("sprites/particles/mor_glow01", data:GetOrigin())
		part:SetVelocity(VectorRand()* Vector( math.Rand( -455, 455 ), math.Rand( -455, 455 ), 455 ))
		part:SetDieTime(3)
		part:SetStartSize(64)
		part:SetColor( 55, 175, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(0)
		part:SetRollDelta(0)
		part:SetAirResistance(15)
		part:SetCollide(true)
		part:SetBounce(0.2)
		part:SetGravity(Vector(0, 0, -355))
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end