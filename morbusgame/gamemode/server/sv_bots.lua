// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/* Bot features for the xg morbus server */

botIDs = {
	"STEAM_0:1:55327774",
	"STEAM_0:0:152456856",
	"STEAM_0:0:152462431",
	"STEAM_0:0:156086226",
	"STEAM_0:1:156075842"
}

ignoreBot = {
	"STEAM_0:0:152456856",
	"STEAM_0:0:152462431",
	"STEAM_0:1:156075842",
	"STEAM_0:0:156086226",
	"STEAM_0:1:55327774"
}

function GetBotCount()

	local count = 0
	local playerSteamID = -1
	
	for k,v in pairs(player.GetAll()) do
		playerSteamID = v:SteamID()
	
		if table.KeyFromValue(botIDs, playerSteamID) then
			count = count + 1
		end
	end
	
	return count
end

function SlayBots()
	local playerCount = GetValidCountEx()
	if playerCount > 1 then
		for k,v in pairs(player.GetAll()) do
			if v:IsGame() then
				if table.KeyFromValue(botIDs, v:SteamID()) then
					SetSpec(v)
					v.WantsSpec = false
					--v:Kill()
				end
			end
		end
	end
end

function SetSpec(ply)
  ply.WantsSpec = !ply.WantsSpec

  ply:SetRole(ROLE_SWARM)
  ply:MakeSpec()
  ply:Kill()
end

function GetSpecCount()
	local specCount = 0
	
	for k,v in pairs(player.GetAll()) do
		if !v:IsGame() then
			specCount = specCount + 1
		end
	end
	
	return specCount	
end

function GetValidCount()
	return #player.GetAll() - GetBotCount()
end

function GetValidCountEx()
	return GetValidCount() - GetSpecCount()
end

function PrintBotCount(ply)
	SendMsg(ply, "The valid count is " ..GetValidCount())
end

concommand.Add("mor_specbots" , 
		function( ply, cmd, args ) 
			if ply:IsAdmin() then
				SlayBots()
			else
				ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
			end
		end)	