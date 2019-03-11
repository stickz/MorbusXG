/*----------------------------------------------------
MORBUS DEVELOPED BY REMSCAR
Credits====
Production: Remscar
Code Snippets:
-BadKingUrgrain (Round system and some framework stuff)
-Gmod4Ever (Upgrade Menu)
Original Idea:
-IcklyLevel
-Movie: The Thing
Thanks to:
Gmod4Ever
M4RK
Sonoran Warrior
Demonkush
017
LauScript (schu)
----------------------------------------------------*/



// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team



-----------------------------------Includes
include("shared.lua")
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/shared/*.lua","LUA")) do include("shared/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/*.lua","LUA")) do include("server/" .. v) end

for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/alien/*.lua","LUA")) do include("server/alien/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/player/*.lua","LUA")) do include("server/player/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/round/*.lua","LUA")) do include("server/round/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/impulse/*.lua","LUA")) do include("server/impulse/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/mutators/*.lua","LUA")) do include("server/mutators/" .. v) end
-------------------------------------------




---------------------------SEND CLIENT FILES
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/shared/*.lua","LUA")) do AddCSLuaFile("shared/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/*.lua","LUA")) do AddCSLuaFile("client/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/vgui/*.lua","LUA")) do AddCSLuaFile("client/vgui/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/sb/*.lua","LUA")) do AddCSLuaFile("client/sb/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/fx/*.lua","LUA")) do AddCSLuaFile("client/fx/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/hud/*.lua","LUA")) do AddCSLuaFile("client/hud/" .. v) end
---------------------------------------------


------------STORE HOOK
--include("store/init.lua")



--------------------------------SERVER CONVARS
CreateConVar("morbus_roundtime", "10", FCVAR_NOTIFY)
CreateConVar("morbus_evactime", "3", FCVAR_NOTIFY)
CreateConVar("morbus_rounds", "5", FCVAR_NOTIFY)
CreateConVar("morbus_round_prep", "20", FCVAR_NOTIFY)
CreateConVar("morbus_round_post", "20", FCVAR_NOTIFY)
CreateConVar("morbus_mission_time_max", "180", FCVAR_NOTIFY)
CreateConVar("morbus_mission_time_min", "120", FCVAR_NOTIFY)
CreateConVar("morbus_mission_next_time_max", "80", FCVAR_NOTIFY)
CreateConVar("morbus_mission_next_time_min", "160", FCVAR_NOTIFY)
CreateConVar("morbus_exclude_last_played", "0", FCVAR_NOTIFY)

CreateConVar("morbus_rpnames_optional", "0", FCVAR_NOTIFY)
-----------------------------------------------

util.AddNetworkString("RoundLog")
util.AddNetworkString("RoundHistory")
util.AddNetworkString("ReceivedBody")
util.AddNetworkString("FoundBody")
-- util.AddNetworkString("OOCChat")
-- util.AddNetworkString("LocalChat")
-- util.AddNetworkString("SpecChat")
-- util.AddNetworkString("SelfRole")
-- util.AddNetworkString("PlayerRole")
-- util.AddNetworkString("RoundState")
-- util.AddNetworkString("Weight")
-- util.AddNetworkString("ClearClient")
-- util.AddNetworkString("MissionInfo")
-- util.AddNetworkString("MissionUpdate")
-- util.AddNetworkString("MissionComplete")
-- util.AddNetworkString("MissionReset")
-- util.AddNetworkString("UpgradePoints")
-- util.AddNetworkString("UpgradeData")
-- util.AddNetworkString("ClearUpgrades")
-- util.AddNetworkString("AlienChat")

--------------------------------INITIALIZE GAMEMODE

hook.Remove("PreDrawHalos", "PropertiesHover")

function GM:Initialize()
	MsgN("Morbus Server Loading...\n")
	SetGlobalInt("morbus_winner",0)


	RunConsoleCommand("mp_friendlyfire", "1")
    RunConsoleCommand("sv_alltalk", "0")
    RunConsoleCommand("sv_tags","Morbus"..GM_VERSION_SHORT)
    RunConsoleCommand("mp_show_voice_icons", "0")

	GAMEMODE.Round_State = ROUND_WAIT
	GAMEMODE.Round_Winner = WIN_NONE
	GAMEMODE.FirstRound = true
	GAMEMODE.STOP = false
	Round_RDMs = 0
	Round_Brood_Infects = 0
	Round_Brood_Kills = 0
	Round_Swarm_Infects = 0
	Round_Swarm_Kills = 0
	RoundHistory = {}
	Round_Log = {}
	Round_IDs = {}
	Total_Evolution_Points = 0
	Swarm_Respawns = 0
	Evacuation_Map = false
	Human_Evacuated = false

	SetGlobalFloat("morbus_round_end", -1)
	SetGlobalInt("morbus_swarm_spawns", 0)
	--SetGlobalInt("morbus_rounds_left", GetConVar("morbus_rounds"):GetInt())	
	
	SetGlobalInt("morbus_minutes_left", 27)
	SetGlobalInt("morbus_rounds_left", 6)

	SetGlobalInt("alien_wins", 0)
	SetGlobalInt("human_wins", 0)
	SetGlobalInt("total_cyborgs", 0)
	SetGlobalFloat("morbus_round_time", GetConVar("morbus_roundtime"):GetInt())

	SetGlobalBool("morbus_rpnames_optional", GetConVar("morbus_rpnames_optional"):GetBool())
	WaitForPlayers()

	--CAN_RTV = CurTime() + 120

	PrepMutators()
	
	--SANITY.InitalizeFromJson()
	--sSPEC.InitalizeFromJson()

	MsgN("Morbus Server Loaded!\n")
end


concommand.Add( "mor_swarmtreat", function( ply, cmd, args )
	if ply:GetUserGroup() == "superadmin" then
		for k, v in pairs( player.GetAll() ) do
			v:SetSwarmPoints( v:GetSwarmPoints() + 5 )
			v:PrintMessage( HUD_PRINTTALK, "The owner has given you 5 Swarm Points!" )
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end
end)

concommand.Add( "mor_playerstates", function( ply, cmd, args )
	if ply:GetUserGroup() == "superadmin" then
		for k, v in pairs( player.GetAll() ) do
			if v:IsBrood() then
				ply:PrintMessage( HUD_PRINTTALK, "Brood == " .. v:Name() )
			elseif v:IsSwarm() then
				ply:PrintMessage( HUD_PRINTTALK, "Swarm == " .. v:Name() )
			elseif !v:IsAlien() then
				ply:PrintMessage( HUD_PRINTTALK, "Human == " .. v:Name() )
			end
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end

end)

concommand.Add( "mor_playerpotential", function( ply, cmd, args )
	if ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "admin" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "mod" then
		for k, v in pairs( player.GetAll() ) do

				ply:PrintMessage( HUD_PRINTTALK, "RDM: " .. v:GetRDMScorePotential() .. " || Infect: " .. v:GetInfectionsPotential() .. " || Alien Kill: " .. v:GetAlienKillsPotential() .. " || == " .. v:Name() )

		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end

end)

concommand.Add( "mor_playersanity", function( ply, cmd, args )
	if ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "admin" or ply:GetUserGroup() == "moderator" or ply:GetUserGroup() == "mod" then
		for k, v in pairs( player.GetAll() ) do

				ply:PrintMessage( HUD_PRINTTALK, "Live Sanity: " .. math.Round(v:GetLiveSanity()) .. " || " .. v:Name() )

		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end

end)

concommand.Add( "mor_playerpoints", function( ply, cmd, args )
	if ply:GetUserGroup() == "superadmin" then
		for k, v in pairs( player.GetAll() ) do

				ply:PrintMessage( HUD_PRINTTALK, "Swarm Points: " .. v:GetSwarmPoints() .. " || " .. v:Name() )

		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end

end)

concommand.Add( "mor_setrounds", function( ply, cmd, args )
	local rounds = tonumber( args[1] )

	local userGroup = ply:GetUserGroup()	
	if userGroup == "superadmin" or userGroup == "admintech" then
		SetGlobalInt( "morbus_rounds_left", rounds )
		ply:PrintMessage( HUD_PRINTTALK, "You have set the rounds to " .. tostring( rounds ) .. "." )
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end
end)

concommand.Add( "mor_resetrounds", function( ply, cmd, args )
	if ply:GetUserGroup() == "superadmin" then
		SetGlobalInt("morbus_rounds_left", GetConVar("morbus_rounds"):GetInt())
		ply:PrintMessage( HUD_PRINTTALK, "You have reset the rounds." )
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end
end)

concommand.Add( "mor_vetortv", function( ply, cmd, args )
	local userGroup = ply:GetUserGroup()
	
	if userGroup == "superadmin" or userGroup == "admintech" then
		RTV_PERCENT = 0.6
		PrintMessage( HUD_PRINTTALK, ply:GetName().." raised the rtv requirement to 60%." )
	else
		ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
	end
end)


/*timer.Create( "TagCheck", 1, 0, function()
	if not GetConVar( "sv_tags" ) then CreateConVar("sv_tags","") end
	if ( !string.find( GetConVar( "sv_tags" ):GetString(), "morbus"..tostring(GM_VERSION_SHORT) ) ) then
	RunConsoleCommand( "sv_tags", GetConVar( "sv_tags" ):GetString() .. ",morbus"..tostring(GM_VERSION_SHORT) )
	end
end )*/

------------------------------------------------

DEBUG_MORBUS = false
