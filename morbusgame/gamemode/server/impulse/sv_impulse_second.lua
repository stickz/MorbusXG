// 1 second impulse



local IMPULSE = {}


function IMPULSE.SECOND()

	--Added Major optimizations by casting variables and merging repeated if statements
	local roundState = GetRoundState()
	IMPULSE.BONUSLIVES(roundState)
	
	for k,v in pairs(player.GetAll()) do
		local team = v:Team()	
		local alive = v:Alive()
		IMPULSE.ALIEN(k,v,team,alive)
		IMPULSE.LIGHT(k,v)		
			
		if roundState == ROUND_ACTIVE then
			IMPULSE.NEED(k,v)
			IMPULSE.GENERAL(k,v)
		end
		
		IMPULSE.SPECTATOR(k,v,roundState,alive)		
	end
end
hook.Add("Impulse_Second","Sec_Impulse",IMPULSE.SECOND)

function IMPULSE.BONUSLIVES(roundState)
	local tend = GetGlobalFloat("morbus_round_end",nil)
	if tend and ((tend-90) < CurTime()) and roundState == ROUND_ACTIVE then
		Swarm_Respawns =  Swarm_Respawns + 1
		SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns)
	end

end

function IMPULSE.ALIEN(k,v,team,alive) --s
	if v:IsBrood() && team == TEAM_GAME && alive && ValidEntity(v) then
		if ValidEntity(v:GetActiveWeapon()) && v:GetActiveWeapon():GetClass() == "weapon_mor_brood" then
			-- In alien form
			if v.Upgrades[UPGRADE.BREATH] then
				--v:EmitSound(table.Random(Sounds.Brood.Breath),80,100)
			else
				v:EmitSound(table.Random(Sounds.Brood.Breath),200,100) -- Breathing sound
			end
			local hpmax = 100
			if v.Upgrades[UPGRADE.HEALTH] then
				hpmax = hpmax + v.Upgrades[UPGRADE.HEALTH] * UPGRADE.HEALTH_AMOUNT
			end
			if v:Health() <= hpmax then
				local amt = 0
				if v.Upgrades[UPGRADE.REGEN] then
					amt = amt + (v.Upgrades[UPGRADE.REGEN] * UPGRADE.REGEN_AMOUNT)
				end

				v:SetHealth(math.Clamp(v:Health() + amt,0,hpmax))
			else
				v:SetHealth(hpmax)
			end
		else
			-- Not in alien form
		end
	elseif v:IsSwarm() && alive then
		v:SetSpeed()
		--Swarm Alien
		if v:Health() < 100 then
			v:SetHealth(v:Health() + 3)
		else
			v:SetHealth(100)
		end
	end

end

function IMPULSE.LIGHT(k,v)
	if !v:IsSwarm() then
		LIGHT.Think(v)
	end
end

function IMPULSE.NEED(k,v) --s
	if !(v:IsAlien()) then
		if (v.Mission_End < CurTime()) && (v.Mission != MISSION_NONE) && (v.Mission_Doing == false) then
			v:SetHealth(v:Health()-1)

			if v:Health() < 1 then
				v:Kill()
			end
		end
	end
end

function IMPULSE.GENERAL(k,v)
	
	if ValidEntity(v) && !v:GetNWBool("alienform",false) then
		local w = v.Weight
		v:CalcWeight()
		if w != v.Weight then
			v:SendWeight()
		end
	end
end


function IMPULSE.SPECTATOR(k,ply,roundState,alive)
	if ply:IsSpec() then
		if (alive) then
			ply:Kill()
		end		

		if !(roundState == ROUND_ACTIVE || roundState== ROUND_EVAC) then return end
		if (Swarm_Respawns > 0 || roundState == ROUND_EVAC) && (ply.WantsSpec != true) && (ply.TempSpec != true) then
			MsgN(ply)
			NewAlien(ply,ROLE_SWARM)
	    end
	end
end

