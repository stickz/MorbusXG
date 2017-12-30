// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/*--------------------------------------------
MORBUS COMMUNICATION SYSTEM
--------------------------------------------*/

function ChangeMuteState(ply,cmd,args)
  if #args < 1 then
	ply:PrintMessage(HUD_PRINTTALK, "0-None 1-Alive Only 2-Spectators Only 3-No Spectators 4-No Alien Chat + Alive Only")
    return
  end

  local n = tonumber(args[1])
  ply:SetNWInt("Mute_Status",n)

end
concommand.Add("morbus_mute_status",ChangeMuteState)

ISLOCALCHAT = true
NO_OOCCHAT = false
/*--------------------------------------------------
CHAT FUNCTIONS
---------------------------------------------------*/

ChatCommandList = {
	"/rtv",
	"/spec",
	"/light",
	"/forcertv",
	"/remscar",
	"/nightmare",
	"/yes",
	"/taunt",
	"/europe",
	"!rtv",
	"!spec",
	"!light",
	"!forcertv",
	"!remscar",
	"!nightmare",
	"!yes",
	"!taunt",
	"!europe"
}

GetChatText = {
	["/rtv"] = function(text, ply) if !rtvCheck(ply) then RTV(ply) end return "" end,
	["/spec"] = function(text, ply) SetSpecStatus(ply) return "" end,
	["/light"] = function(text, ply) GAMEMODE:PlayerSwitchFlashlight(ply,true) return "" end,
	["/forcertv"] = function(text, ply) if !rtvCheck(ply) then ForceMap(ply) end return "" end,
	["/remscar"] = function(text, ply) WhoIsRemscar() return "" end,
	["/nightmare"] = function(text, ply) ChangeNightmare(ply) return "" end,
	["/yes"] = function(text, ply) if ply.CanUseResponse == true then playYesTaunt(ply) end return "" end,
	["/taunt"] = function(text, ply) if ply.CanUseResponse == true then playTaunt(ply) end return "" end,
	["/europe"] = function(text, ply) ConnectToEU(ply, false) return "" end,
	["!rtv"] = function(text, ply) if !rtvCheck(ply) then RTV(ply) end return "" end,
	["!spec"] = function(text, ply) SetSpecStatus(ply) return "" end,
	["!light"] = function(text, ply) GAMEMODE:PlayerSwitchFlashlight(ply,true) return "" end,
	["!forcertv"] = function(text, ply) if !rtvCheck(ply) then ForceMap(ply) end return "" end,
	["!remscar"] = function(text, ply) WhoIsRemscar() return "" end,
	["!nightmare"] = function(text, ply) ChangeNightmare(ply) return "" end,
	["!yes"] = function(text, ply) if ply.CanUseResponse == true then playYesTaunt(ply) end return "" end,
	["!taunt"] = function(text, ply) if ply.CanUseResponse == true then playTaunt(ply) end return "" end,
	["!europe"] = function(text, ply) ConnectToEU(ply, false) return "" end
}

function SendOOCChat(ply,text)
  if NO_OOCCHAT && (GetRoundState() == ROUND_ACTIVE) then
    ply:PrintMessage(HUD_PRINTTALK, "OOC Chat is disabled!")
    return
  end

  umsg.Start("SendOOCChat")
  umsg.String(ply:Nick())
  umsg.String(ply:GetFName())
  umsg.String(text)  
  umsg.String(ply:SteamID()) -- new
  umsg.End()
end

function SendLocalChat(ply,text)
  local filter = RecipientFilter()
  for k,v in pairs(player.GetAll()) do
    if (v:GetShootPos():Distance(ply:GetShootPos()) < 800) then
      filter:AddPlayer(v)
    end
  end
  
  umsg.Start("SendLocalChat",filter)
  umsg.String(ply:GetFName())
  umsg.String(text)
  umsg.String(ply:SteamID()) -- new
  umsg.End()
end

function SendSpecChat(ply,text)
  local filter = RecipientFilter()
  for k,v in pairs(player.GetAll()) do
    if v:Team() == TEAM_SPEC then
      filter:AddPlayer(v)
    end
  end
  umsg.Start("SendSpecChat",filter)
  umsg.String(ply:GetName())
  umsg.String(text)
  umsg.String(ply:SteamID()) -- new
  umsg.End()
end

function GM:PlayerSay(ply, text, to_all)
	if not ValidEntity(ply) then return end
	
	to_all = !to_all
	
	--check if message matches an chat command
	if table.KeyFromValue(ChatCommandList,text) then
		GetChatText[text](text,ply)
		return ""
	end
	
	if table.KeyFromValue(PermMutedPlayers, ply:SteamID()) then return "" end
	
	if ply:GetNWBool("ulx_gagged", false) then return "" end
	
	if string.sub(text,0,2) == "//" then
       SendOOCChat(ply,string.sub(text,3))
       return ""
    end
	
    local firstChar = string.sub(text,0,1)	
	if firstChar == "!" || firstChar == "/" then
       return ""
    end
	
	local roundState = GetRoundState()
	
	if (roundState != ROUND_ACTIVE) then
		SendOOCChat(ply," "..text)
		return ""
	elseif (ply:Team() == TEAM_SPEC) then
		SendSpecChat(ply," "..text)
		return ""
	elseif (roundState == ROUND_ACTIVE && ply:IsAlien() && not to_all) then
		AlienChatMsg(ply, text)
		return ""
	elseif (!ply:Alive() && !ply:IsBrood()) then
		ply:PrintMessage(HUD_PRINTTALK, "You can't talk when you're dead!")
		return ""
	else
		SendLocalChat(ply," "..text)
		return ""		
	end
	
	return ""
end

local mute_all = false
function MuteForRestart(state)
  mute_all = state
end

--this function is used to fix an lua error when trying to rtv mid round
function rtvCheck(ply)
	if GetRoundState() == ROUND_WAIT then
		ply:PrintMessage(HUD_PRINTTALK, "Cannot use rtv feature while in initial waiting phase!")
		return true
	end	
	return false
end

function playYesTaunt(ply)
	if !ply:IsSwarm() && !ply:GetNWBool("alienform",false) then			
		ply:EmitSound(table.Random(Response.Male.Yes),100,100)
			
		ply.CanUseResponse = !ply.CanUseResponse			
		timer.Simple(15, 	function() 
								if IsValid(ply) then 
									ply.CanUseResponse = !ply.CanUseResponse 
								end 
							end)		
		
		return ""	
	end
	
	ply:PrintMessage(HUD_PRINTTALK, "Cannot use taunts while swarm or in brood form!")
	return ""
end

function playTaunt(ply)
	if !ply:IsSwarm() && !ply:GetNWBool("alienform",false) then
		ply:EmitSound(table.Random(Tuants.Male),100,100)			
		ply.CanUseResponse = !ply.CanUseResponse	
		
		timer.Simple(15, 	function() 
								if IsValid(ply) then 
									ply.CanUseResponse = !ply.CanUseResponse 
								end 
							end)
		
		return ""
	end
	
	ply:PrintMessage(HUD_PRINTTALK, "Cannot use taunts while swarm or in brood form!")
	return ""
end

function GM:PlayerCanHearPlayersVoice(listener, speaker)
  
	if (mute_all or speaker:GetNWBool("ulx_muted", false) or table.KeyFromValue(PermMutedPlayers, speaker:SteamID())) then 
		return false,false
	end
  
	local muteStatus = listener:GetNWInt("Mute_Status",0)

	if (speaker:Team() == TEAM_SPEC && listener:Team() == TEAM_SPEC) && (muteStatus == 0 || muteStatus == 2) then
		return true,false
	end
  
	if speaker:IsAlien() && (speaker.alien_voice==false) then
		return (listener:IsAlien() && (muteStatus < 2 || muteStatus == 3)),false
	end
  
	if (GetRoundState() == ROUND_ACTIVE) then
	
		if !listener:Alive() && !listener:IsSwarm() && listener:IsGame() then
			return false,false
		end  
  
		if (ISLOCALCHAT == true) then
		
			if (muteStatus == 0) then		
			
				local distance = listener:GetShootPos():Distance(speaker:GetShootPos())
				if distance < 2000 then	
				
					if (listener:Team() == TEAM_SPEC) || (distance < 750 && (speaker:Team() != TEAM_SPEC)) then					
						return true,true
					end		
				end
			end
			
		else
			return true,false -- this is not local chat
		end
	
	else
		return true,false -- round is not active	
	end

	return false,false
end

local function SwitchVoice(ply)
  if ply:IsSuperAdmin() then
    ISLOCALCHAT = !ISLOCALCHAT
    Chat_SendAll("OOC Voice Chat Disabled: "..tostring(ISLOCALCHAT))
  end
end
concommand.Add("Switch_Voice",SwitchVoice)

local function SwitchChat(ply)
  if ply:IsSuperAdmin() then
    NO_OOCCHAT = !NO_OOCCHAT
    Chat_SendAll("OOC Text Chat Disabled: "..tostring(NO_OOCCHAT))
  end
end
concommand.Add("Switch_Chat",SwitchChat)

local function SendAlienVoiceState(speaker, state)
  local rf = AlienFilter()

  umsg.Start("avstate", rf)
  umsg.Short(speaker:EntIndex())
  umsg.Bool(state)
  umsg.End()
end

function Chat_SendAll( msg )
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( 3, msg )
	end
end

function SetAlienVoiceState(ply, cmd, args)
  if not ValidEntity(ply) or not ply:IsActiveAlien() then return end
  if not #args == 1 then return end
  local state = tonumber(args[1])

  ply.alien_voice = (state == 1)

  SendAlienVoiceState(ply, ply.alien_voice)
end
concommand.Add("morbus_alien_voice", SetAlienVoiceState)


function AlienChatMsg(sender,str)

  umsg.Start("alien_chat", AlienFilter())
  umsg.Entity(sender)
  umsg.String(str)
  umsg.String(sender:SteamID()) --new
  umsg.End()
end


function SetSpecStatus(ply)
	SPEC.ToggleSpec(ply)
end
/*--------------------------------------------
UTILITY FILTERS
---------------------------------------------*/


function GetPlayerFilter(req)
  local filter = RecipientFilter()
  for k,v in pairs(player.GetAll()) do
    if ValidEntity(v) and req(v) then
      filter:AddPlayer(v)
    end
  end
  return filter
end