// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

SMV = {}
SMV.RTVING = false

SMV.Maps = {
	"mor_alphastation_b4_re",
	"mor_auriga_v4_re",
	"mor_breach_cv21",
	"mor_chemical_labs_b3_re",
	"mor_facility_cv2",
	"mor_installation_gt1_re",
	"mor_outpostnorth32_a5",
	"mor_ptmc_v22",
	"mor_spaceship_v10_re",
	"mor_temple_v1",
	"mor_grem",
	"mor_turbatio",
	"mor_skandalon_b5_re",
	"mor_isolation_cv1",
	"mor_isolation_b4_re",
	"mor_horizon_v11_re"
}

/*========================================
ROCK THE VOTE FUNCTIONS
======================================*/

RTV_COUNT = 0
RTV_HASPASSED = false
RTV_PERCENT = 0.6

local rtvAllowed = false
timer.Simple(45, function() rtvAllowed = true end)

function NeededRTV()
	local need = math.ceil(GetValidCount() * RTV_PERCENT)
	return (need - RTV_COUNT)
end

function RTV(ply)
	if ply.RTV || ply.RTV == true then return end

	if !rtvAllowed then return end
	--if (CAN_RTV > CurTime()) then return end

	if SMV.RTVING then return end

	ply.RTV = true
	RTV_COUNT = RTV_COUNT + 1

	SMV.SendAll(ply:GetName().." typed /rtv to vote for a map change! ("..NeededRTV().." more required)")

	if (NeededRTV() < 1) then
		SMV.SendAll("RTV successful, pending round end.")
		RTV_HASPASSED = true		
	end
end

function ForceMap(ply)
	if !ply:IsAdmin() then return end
	SMV.SendAll(ply:Nick().." has forced a map change!")
	timer.Simple(3, function() hook.Call("Morbus_MapChange") end)
end

/*========================================
VOTING SYSTEM
======================================*/

util.AddNetworkString("smv_start")
util.AddNetworkString("smv_end")
util.AddNetworkString("smv_vote")
util.AddNetworkString("smv_vote_status")
util.AddNetworkString("smv_winner")


SMV.VoteTime = 30
SMV.OptionCount = 4
SMV.Voting = false
SMV.Votes = {}
SMV.TVotes = {}

SMV.MapVoteList = {}

function SMV.CreateMapList()
	SMV.ExcludedMaps = {}
	
	--read prevous maps and convert to table format
	local lastMaps = util.JSONToTable( file.Read( "lastmaps.txt") )
	
	--insert the current map into the table
	local currentMap = game.GetMap()
	table.insert(lastMaps, 1, currentMap)
	
	--exclude maps based on player count	
	local playerCount = GetValidCount()	
	
	local excludeString = ""
	
	if playerCount < 18 then
		table.insert(SMV.ExcludedMaps, "mor_horizon_v11_re")
		
		if playerCount < 12 then	
			table.insert(SMV.ExcludedMaps, "mor_installation_gt1_re")
			table.insert(SMV.ExcludedMaps, "mor_outpostnorth32_a5")
			table.insert(SMV.ExcludedMaps, "mor_auriga_v4_re")
			table.insert(SMV.ExcludedMaps, "mor_ptmc_v22")				
			excludeString = "large"
			SMV.OptionCount = 4
						
			if playerCount < 8 then
				--table.insert(SMV.ExcludedMaps, "mor_skandalon_b5_re")
				table.insert(SMV.ExcludedMaps, "mor_isolation_cv1")
				table.insert(SMV.ExcludedMaps, "mor_facility_cv2")
				table.insert(SMV.ExcludedMaps, "mor_turbatio")
				
				-- test changes, hard time populating on these maps
				table.insert(SMV.ExcludedMaps, "mor_spaceship_v10_re")
				SMV.OptionCount = 3
				
				if playerCount < 6 then
					SMV.OptionCount = 2
					table.insert(SMV.ExcludedMaps, "mor_breach_cv21")
				end
			end		
		end	
	end
		
	if playerCount > 13 then
		table.insert(SMV.ExcludedMaps, "mor_isolation_b4_re")
		table.insert(SMV.ExcludedMaps, "mor_temple_v1")
		excludeString = "tiny"
				
		if playerCount > 18 then
			table.insert(SMV.ExcludedMaps, "mor_alphastation_b4_re")
			table.insert(SMV.ExcludedMaps, "mor_grem")
			table.insert(SMV.ExcludedMaps, "mor_skandalon_b5_re")
			excludeString = "tiny and small sized"
			SMV.OptionCount = 3
			
			if playerCount > 23 then
				table.insert(SMV.ExcludedMaps, "mor_spaceship_v10_re")
				table.insert(SMV.ExcludedMaps, "mor_chemical_labs_b3_re")
				table.insert(SMV.ExcludedMaps, "mor_isolation_cv1")
				table.insert(SMV.ExcludedMaps, "mor_breach_cv21")
				excludeString = "tiny, small and medium sized"
				
				if playerCount > 25 then
					table.insert(SMV.ExcludedMaps, "mor_turbatio")
					table.insert(SMV.ExcludedMaps, "mor_facility_cv2")
					excludeString = "all non-large"
					SMV.OptionCount = 2
				end
			end
		end
	end
	
	--Get how many options will appear in the voter
	local optionCount = 0
	for k,v in pairs(SMV.Maps) do
		if !table.KeyFromValue(SMV.ExcludedMaps, v) then
			if file.Exists("maps/"..v..".bsp","GAME") then
				optionCount = optionCount + 1
			end		
		end	
	end	
	
	--how many maps are in the excluded maps table?
	local tableCount = table.Count(lastMaps)
	
	--Reduce the option count to a set amount by excluding previous maps
	if optionCount > SMV.OptionCount then
		for j=1, tableCount do					
			if !table.KeyFromValue(SMV.ExcludedMaps, lastMaps[j]) then
				table.insert(SMV.ExcludedMaps, lastMaps[j])
				optionCount = optionCount - 1
			end
			
			if optionCount == SMV.OptionCount then break end
		end
	end
	
	--Trim the map list of non-required repeats before writing to text
	local uniqueMaps = {}
	local lastMap = nil
	for k=1, tableCount do
		lastMap = lastMaps[k]
		
		if !table.KeyFromValue(uniqueMaps, lastMap) then
			table.insert(uniqueMaps, lastMap)
		end
	end
	
	if GetValidCount() > 1 then
		--convert the new map table to json and write to the text file
		file.Write( "lastmaps.txt", util.TableToJSON( uniqueMaps, true  ) )
	end
	
	--clear table from previous round (safety feature)
	table.Empty(SMV.MapVoteList)
	
	--Build list of maps to vote (check for excludes and the map is installed)
	for k,v in pairs(SMV.Maps) do
		if !table.KeyFromValue(SMV.ExcludedMaps, v) then
			if file.Exists("maps/"..v..".bsp","GAME") then
				table.insert(SMV.MapVoteList, v)
			end		
		end	
	end
	
	--send map vote when done
	net.Start("smv_start")
	net.WriteTable(SMV.MapVoteList)
	net.Broadcast()
	
	--let players know about our map rotions. Do it at the bottom incase if there's an error.
	SMV.SendAll("[xG] There are "..table.Count(SMV.Maps).." total maps in rotations!")
	SMV.SendAll("[xG] Player count thresholds have excluded "..excludeString.." maps!")	
end

function SMV.SendAll( msg )
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( 3, msg )
	end
end

function SMV.StartMapVote()
	MsgN("[SMV] Map voting started!")

	if SMV.RTVING == true then return end
	
	SMV.RTVING = true

	SMV.Voting = true
	GAMEMODE.STOP = true

	SMV.CreateMapList()	
	
	timer.Simple(SMV.VoteTime, function() SMV.EndMapVote() end)
	timer.Simple(2, function() ReconnectBots() end )
end
hook.Add("Morbus_MapChange", "SMV_MapHook",SMV.StartMapVote)

function SMV.EndMapVote()
	net.Start("smv_end")
	net.Broadcast()

	SMV.Voting = false

	local winner = SMV.GetWinner()

	if !winner then
		SMV.StartMapVote()
		return
	end
	
	timer.Simple(1.5, function() SMV.ChangeMap(winner) end)
	
	--net.Start("smv_winner")
	--net.WriteString(winner)
	--net.Broadcast()
	--SMV.SendAll(winner.." is the next map!")
	--timer.Simple(5, function() SMV.ChangeMap(winner) end)
end


function SMV.ChangeMap(mapname)
	RunConsoleCommand( "changelevel", mapname, gmod.GetGamemode().FolderName )
end

function SMV.GetWinner()
	local tab = {}
	local map = nil
	local sid = nil
	local votes = nil
	local num = 0
	for k,v in pairs(SMV.Votes) do
		sid = k
		map = v[1]
		votes = v[2]

		if tab[map] then
			tab[map] = tab[map] + votes				
		else
			tab[map] = votes
		end
		num = num + 1

		map = nil
		sid = nil
		votes = nil
	end
	local top = 0
	local winner = ""


	if num < 1 then
		return table.Random(SMV.MapVoteList)
	end

	for k,v in pairs(tab) do
		if v > top then
			top = v
			winner = k
		end
	end

	return winner
end

function SMV.SendVotes()
	local tab = {}
	local map = nil
	local sid = nil
	local votes = nil
	for k,v in pairs(SMV.Votes) do
		sid = k
		map = v[1]
		votes = v[2]

		if tab[map] then
			tab[map] = tab[map] + votes
			
			-- instantly change map when a majority is reached					
			if tab[map] >= math.ceil(GetValidCount() * 0.51) then
				timer.Simple(0.5, function() SMV.EndMapVote() end)
			end			
		else
			tab[map] = votes			
		end

		map = nil
		sid = nil
		votes = nil
	end

	SMV.TVotes = tab

	net.Start("smv_vote_status")
	net.WriteTable(tab)
	net.Broadcast()
end

function SMV.GetVote(len, ply)
	local map = net.ReadString()
	local sid = ply:SteamID()
	local votes = 1
	
	SMV.Votes[sid] = {map,votes}
	MsgN("Vote recieved "..sid.." ["..map.."] ["..votes.."]")
	SMV.SendVotes()
end
net.Receive("smv_vote",SMV.GetVote)
