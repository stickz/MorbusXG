
//Utility

function SendAll( msg )
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( 3, msg )
	end
end

function SendMsg( ply, msg)
	ply:PrintMessage(3,msg)
end


function WhoIsPlayer(name)
	if !name then return end
	local match = nil
	for k,v in pairs(player.GetAll()) do
		if (v:GetFName() == name) then
			return match
		end
	end
	if !match then return false end
end

function util.AverageSanity()
	local cnt = #player.GetAll()
	local sanity = 0
	for k,v in pairs(player.GetAll()) do
		sanity = sanity + v:GetBaseSanity()
	end
	return sanity / cnt
end

function OutpostMessage()
	if game.GetMap() == "mor_outpostnorth32_a5" then		
		for k, v in pairs( player.GetAll() ) do
			if (v:GetInfoNum("morbus_disable_tooltips", 0) == 0) then
				v:PrintMessage(HUD_PRINTTALK, "[xG] This map requires Half Life 2 Episode 1 & 2 mounted for textures.")
			end	
		end
	end
end

function WhoIsRemscar()
   for k,v in player.GetAll() do
      if v:SteamID() == "STEAM_0:0:20749231" then
         SendAll("Remscar the creator of Morbus is playing on this server.")
      end
   end
   SendMsg("Remscar is not playing on this server")
end
concommand.Add("remscar",WhoIsRemscar)