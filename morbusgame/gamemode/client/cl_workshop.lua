local foundSounds = false
local foundPS = false
local fastFinish = true
local whenToFinish = nil
local firstMap = true

function InitWorkshopContent()	
	
	timer.Simple(10, function()	
		whenToFinish = CurTime() + 30
	
		timer.Simple(1, function()		
			if foundSounds == false then
				PrintWorkshopMessage("Downloading morbus sound pack..." )
			end end)
			
		-- Download morbus sound pack 
		steamworks.FileInfo( 811776488, function( result )
			if result.installed == false then
				steamworks.Download( result.fileid, true, function( name )
					game.MountGMA( name )
					PrintWorkshopMessage("Mounted morbus sound pack." )
					foundSounds = true
					DownloadPointshopPack()
				end )
			else
				foundSounds = true
				DownloadPointshopPack()
			end
		end )
	end)
end
usermessage.Hook("Morbus_SpawnInitialized", InitWorkshopContent)

function DownloadPointshopPack()
	
	timer.Simple(1, function()		
		if foundPS == false then
			PrintWorkshopMessage("Downloading pointshop pack..." )
		end end)

	steamworks.FileInfo( 678646979, function( result )
		if result.installed == false then
			steamworks.Download( result.fileid, true, function( name )
				game.MountGMA( name )
				PrintWorkshopMessage("Mounted pointshop pack." )
				foundPS = true
				CacheWorkshopMaps()
			end )
		else
			foundPS = true
			CacheWorkshopMaps()
		end
	end )
end


MapIdList = {
	"658240507", -- 8.1mb (chem)
	"282458169", -- 8.6mb (temple)
	"658267074", -- 10.7mb (spaceship)
	"658250566", -- 11.6mb (skand)
	"658249952", -- 11.7mb (iso old)
	"658240137", -- 13.4mb (auriga)
	"524166998", -- 14.6mb (turbatio)
	"522713387", -- 16.1mb (grem)
	"187893806", -- 17.7mb (horizon)
	"658265026", -- 18.3mb (outpost)
	"187895089", -- 19.7mb (install)
	"811812938", -- 21.8mb (facility)
	"186357825", -- 28.4mb (ptmc)
	"272895564", -- 33.1mb (breach)
	"187891235", -- 33.4mb (alpha)
	"272900384" -- 34.7mb (iso new)
}

function CacheWorkshopMaps()
	local id = MapIdList[1]	
	table.RemoveByValue(MapIdList, id)

	steamworks.FileInfo( id, function( result )
		if result.installed == false and not steamworks.IsSubscribed(id) then
			steamworks.Download( result.fileid, false, function( name )			
				CheckMapListTable(true)
				
				if firstMap == true then
					firstMap = false
				end
			end )
		else
			CheckMapListTable(false)
		end		
	end )
end

function CheckMapListTable(foundMap)
	local tableCount = table.Count(MapIdList)
	
	if whenToFinish > CurTime() and tableCount > 0  then
		if foundMap == true then			
			if firstMap == true then
				PrintWorkshopMessage("Caching maps for a little bit...")
			end
			
			whenToFinish = whenToFinish + 3
		end
					
		CacheWorkshopMaps()
	else
		if tableCount > 0 then
			PrintWorkshopMessage("Caching stopped to prevent lag spikes!")
		elseif firstMap == false then
			PrintWorkshopMessage("You have all server maps cached!")
		end
	end
end

function PrintWorkshopMessage(message)
	chat.AddText(Color(196, 187, 143), message)
end