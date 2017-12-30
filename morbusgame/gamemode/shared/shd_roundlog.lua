// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team


TYPE_KILL = 1
TYPE_INFECT = 2
TYPE_RDM = 3
TYPE_DIE = 4
TYPE_DAMAGE = 5

TypeName = {
  "Kill",
  "Infect",
  "] RDM [",
  "Die",
  "Damage"
}

TypeAction = {
  "killed",
  "infected",
  "--- RDM'd ---",
  "died",
  "damaged"
}

function ResetLog()
	Round_Log = {}
	Round_IDs = {}
end



if SERVER then
	function AddLog(type,ply1,ply2,info)
		local ins = ply1:GetName().." ("..GetRoleName(ply1:GetRole())..") has "..Get_TypeAction(type)
		if (ply2) then
			ins = ins.." "..ply2:GetName().." ("..GetRoleName(ply2:GetRole())..")"
		end

		if (info) then
			ins = ins.." ["..info.."]"
		end

		local tab = {}
		tab.Type = Get_TypeName(type)
		local t = CurTime() - (GetGlobalFloat("morbus_round_end", 0) - (GetConVar("morbus_roundtime"):GetInt() * 60))
		tab.Time = string.ToMinutesSeconds(t)
		tab.Text = ins

		if (!Round_IDs[ply1:UniqueID()]) then
			Round_IDs[ply1:UniqueID()] = {ply1:GetFName(true),ply1:SteamID(),ply1:IPAddress()}
		end
		table.insert(Round_Log,tab)
	end

	function LogKill(ply1,ply2,info)
		AddLog(TYPE_KILL,ply2,ply1,info)
	end

	function LogInfect(ply1,ply2)
		AddLog(TYPE_INFECT,ply1,ply2)
	end

	function LogRDM(ply1,ply2,info)
		AddLog(TYPE_RDM,ply1,ply2,info)
	end

	function LogDMG(ply1,ply2,info)
		AddLog(TYPE_DAMAGE,ply1,ply2,info)
	end

	function LogDeath(ply1,info)
		AddLog(TYPE_DIE,ply1,nil,info)
	end

	function SendLog()		
		net.Start("RoundLog")
		net.WriteTable(Round_Log)
		net.Broadcast()

		if Round_Log then
			local Timestamp = os.time()
			local month = os.date("%m", TimeStamp)
			local year = string.sub( os.date("%Y", TimeStamp), 3) --only use the last two numbers of the year
			
			local fileName = "rdm_logs/"..month.."-"..year.."-roundlog.txt"
			
			file.Append(fileName, "#### MORBUS ROUND LOG ####\n"..os.date().." -"..game.GetMap().."\n")
			for k,v in pairs(Round_Log) do
				file.Append(fileName ,"["..v.Time.."] ["..v.Type.."] "..v.Text.."\n")
			end

			file.Append(fileName, "#### PLAYER STEAM ID's ####\n")
			for k,v in pairs(Round_IDs) do
				file.Append(fileName, "["..v[1].."] "..v[2].." | "..v[3].."\n")
			end
			
			file.Append(fileName, "\n\n")	
		end
	end

else

	function GetLog()
		MsgN("Recieving Round Log")
		Round_Log = net.ReadTable()
		
		local ply = LocalPlayer()
		if IsValid(ply) then
			ply:ConCommand("print_log")
		end
	end
	net.Receive("RoundLog",GetLog)

	function PrintLog()
		for k,v in pairs(Round_Log) do
			MsgN("["..v.Time.."] ["..v.Type.."] "..v.Text)
		end
	end
	concommand.Add("print_log",PrintLog)

end


