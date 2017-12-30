-- Code to handle reconnecting and redirecting of certain clients

if SERVER then
	
	/* Bot Functions */
	function ReconnectBots()
		for k , v in ipairs(player.GetAll()) do
			playerSteamID = v:SteamID()
	
			if table.KeyFromValue(botIDs, playerSteamID) then
				ReconnectToServer(v)
			end		
		end	
	end	
	function BotsToNA()
		for k , v in ipairs(player.GetAll()) do
			playerSteamID = v:SteamID()
	
			if table.KeyFromValue(botIDs, playerSteamID) then
				ConnectToNA(v, true)
			end		
		end	
	end	
	function BotsToEU()
		for k , v in ipairs(player.GetAll()) do
			playerSteamID = v:SteamID()
	
			if table.KeyFromValue(botIDs, playerSteamID) then
				ConnectToEU(v, true)
			end		
		end	
	end	
	
	/* Server Admin Functions */
	function ReconnectAdmins()
		for k , v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				ReconnectToServer(v)
			end
		end
	end		
	function AdminsToNA()
		for k , v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				ConnectToNA(v, true)
			end		
		end	
	end
	function AdminsToEU()
		for k , v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				ConnectToEU(v, true)
			end		
		end	
	end	
	
	/* Generic Player Functions */	
	function ReconnectToServer(ply)
		umsg.Start("reconnecttoserver" , ply)
			umsg.String("")
		umsg.End()	
	end	
	function ConnectToEU(ply, silent)
		
		if not silent then
			local plyName = ply:GetName()		
			PrintMessage(HUD_PRINTTALK, plyName.." typed !europe to join the xG Europe Morbus Server")
		end
		
		umsg.Start("connecttoeu" , ply)
			umsg.String("")
		umsg.End()	
	end
	function ConnectToNA(ply, silent)
		
		if not silent then
			local plyName = ply:GetName()		
			PrintMessage(HUD_PRINTTALK, plyName.." typed !chicago to join the xG Chicago Morbus Server")
		end
		
		umsg.Start("connecttona" , ply)
			umsg.String("")
		umsg.End()	
	end	
	
	
	
	/* Console Commands */	
	concommand.Add("mor_rcb" , 
		function( ply, cmd, args ) 
			if ply:IsAdmin() then
				ReconnectBots()
			else
				ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
			end
		end)		
	concommand.Add("mor_rcta" , 
		function( ply, cmd, args ) 
			if ply:IsAdmin() then
				ReconnectAdmins()
			else
				ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
			end
		end)		
	concommand.Add("mor_joineu", 
		function( ply, cmd, args ) 
			ConnectToEU(ply, true)
		end)		
	concommand.Add("mor_joinna", 
		function( ply, cmd, args ) 
			ConnectToNA(ply, true)
		end)
	concommand.Add("mor_botsna", 
		function( ply, cmd, args ) 
			if ply:IsAdmin() then
				BotsToNA()
			else
				ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
			end
		end)
	concommand.Add("mor_botseu", 
		function( ply, cmd, args ) 
			if ply:IsAdmin() then
				BotsToEU()
			else
				ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
			end	
		end)
	concommand.Add("mor_adminsna", 
		function( ply, cmd, args ) 
			if ply:IsAdmin() then
				AdminsToNA()
			else
				ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
			end	
		end)
	concommand.Add("mor_adminseu", 
		function( ply, cmd, args ) 
			if ply:IsAdmin() then
				AdminsToEU()
			else
				ply:PrintMessage( HUD_PRINTTALK, "You do not have access to this command!" )
			end	
		end)
else

	usermessage.Hook("connecttona" , function(um) LocalPlayer():ConCommand("connect 192.223.30.49:27015") end )
	usermessage.Hook("connecttoeu" , function(um) LocalPlayer():ConCommand("connect 82.163.79.241:27015") end )
	
	usermessage.Hook("reconnecttoserver" , function(um) RunConsoleCommand("retry") end )	
end