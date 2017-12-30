/*----------------------------------------------------
END ROUND
----------------------------------------------------*/

checkWin = {
	[WIN_HUMAN] = function () GameMsg("Humans have won") return "" end,
	[WIN_ALIEN] = function () GameMsg("Aliens have won") return "" end
}

function EndRound(type)

	print("Round Ending \n")

	RevealAll()

	checkWin[type]() --lookup table is faster than if statements
	SetGlobalInt("morbus_winner",type)

	SANITY.RoundEnd()
	STATS.Send()

	SetRoundState(ROUND_POST)
	
	EndMutators()

	local ptime = GetConVar("morbus_round_post"):GetInt()
	timer.Create("end2prep", ptime, 1, PrepareRound)

	StopWinChecks()

	local rounds_left = math.max(0,GetGlobalInt("morbus_rounds_left",10)-1)
	SetGlobalInt("morbus_rounds_left", rounds_left)
	SetRoundEnd(CurTime() + ptime)
	
	local minutes_left = math.max(0, GetGlobalInt("morbus_minutes_left", 45))

	if rounds_left < 1 or minutes_left < 1 then
		RE_SendAll("Map is changing!")
		timer.Simple(3, function() SPEC.MapEnd() end)
		timer.Simple(6, function() SANITY.MapEnd() end)
		timer.Simple(12,function() hook.Call("Morbus_MapChange") end)
		
	elseif RTV_HASPASSED == true then
		SMV.SendAll("RTV map vote started. A majority will change instantly.")
		timer.Simple(3, function() hook.Call("Morbus_MapChange") end)
		RTV_HASPASSED = false
	end

	--So mission timer doesn't go negative
	for k,v in pairs(player.GetAll()) do
		v:End_ClearMission() --There now stop bitching
		if !v.WantsSpec then
			v:SetTeam(TEAM_GAME)
		end
	end

	Send_RoundHistory()
end

function RE_SendAll( msg )
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( 3, msg )
	end
end