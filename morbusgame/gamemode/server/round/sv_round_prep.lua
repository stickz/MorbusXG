/*----------------------------------------------------
PREPARE ROUND
----------------------------------------------------*/

singleMap =
{
	"mor_surface_v2",
	"mor_lorica_v2"
}

function SpawnPlayers(dead)

	for k, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			ply:SpawnForRound(dead)
		end
	end
end

local function SpawnEntities()
	local et = ents.MORBUS

	local import = et.CanImportEntities(game.GetMap())

	if import then
      et.ProcessImportScript(game.GetMap())
    else
      et.ReplaceEntities()
    end


	SpawnPlayers()
	MuteForRestart(false)
end

local function CleanUp()
	local et = ents.MORBUS
	MISSION_LOCS = nil

	-- Ragdoll fix from TTT
	for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
	    if IsValid(ent) then
	        ent:SetNoDraw(true)
	        ent:SetSolid(SOLID_NONE)
	        ent:SetColor(Color(0,0,0,0))
			ent:SetNWEntity("Player",self)
			ent:SetNWString("Name", "")
			 
	        -- Horrible hack to make targetid ignore this ent, because we can't
	        -- modify the collision group clientside.
	        ent.NoTarget = true
	    end
	end

	game.CleanUpMap()

	et.SetReplaceChecking(not et.CanImportEntities(game.GetMap()))
	et.FixParentedPreCleanup()
	et.FixParentedPostCleanup()
    

	  for k,v in pairs(player.GetAll()) do
      if IsValid(v) then
        v:StripWeapons()
      	end
	  end
end

function PrepareRound()
	RunConsoleCommand("sv_tags","Morbus"..GM_VERSION_SHORT)

	if CheckForAbort() then return end

	MuteForRestart(true)
	CleanUp()

	GAMEMODE.Round_Winner = WIN_NONE

	SANITY.RoundBegin()

	if CheckForAbort() then return end
	
	CheckMutators()
	PrepMutators()

	local ptime = GetConVar("morbus_round_prep"):GetInt()
	
	if GAMEMODE.FirstRound then
		GAMEMODE.FirstRound = false		
		
		if table.KeyFromValue(singleMap, game.GetMap()) then
			ptime = ptime*3
		else
			ptime = ptime*1.5
		end
		
		/* Do a bunch of tasks in prep round to speed up level change */		
		
		-- Recall the sanity from the prevous map
		timer.Simple((ptime - 7), function() SANITY.InitalizeFromJson() end)
		
		-- Recall the sanity from the prevous map		 
		timer.Simple((ptime - 5), function() SPEC.InitalizeFromJson() end)		

		-- Restore spectators from the previous map
		timer.Simple((ptime - 3), function() SPEC.MarkPreviousPlayers() end)	
		
		-- Set timelimits for the map we're currently playing
		timer.Simple((ptime - 1), function() SetTimeLimits() end)
		
		timer.Simple((ptime + 45), function() OutpostMessage() end)
	end

	timer.Create("prep2begin", ptime, 1, BeginRound)

	GameMsg("Round begins in "..ptime)
	print("Round Starts in ".. ptime .."\n")
	SetRoundState(ROUND_PREP)
	SetRoundEnd(CurTime() + ptime)
	
	timer.Simple(0.01, SpawnEntities)
	
	ClearClient()
end