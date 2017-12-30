resource.AddWorkshop("311376670") -- server content pack
resource.AddWorkshop("667638861") -- acceleration pack
--resource.AddWorkshop("678646979") -- pointshop pack
--resource.AddWorkshop("811776488") -- sound pack (morbus
resource.AddSingleFile( "resource/fonts/DeadSpaceTitleFont.ttf" ) --Font must be sent seperately

--Scripts for mounting the map packs
local currentMap = game.GetMap()

-- If the current map is on a seperate list
if currentMap == "mor_facility_cv2" then
	resource.AddWorkshop("811812938") -- mor_facility_cv2
	
elseif currentMap == "mor_chemical_labs_b3_re" then
	resource.AddWorkshop("658240507") -- mor_chemical_labs_b3_re
	
elseif currentMap == "mor_spaceship_v10_re" then
	resource.AddWorkshop("658267074") -- mor_spaceship_v10_re

elseif currentMap == "mor_isolation_b4_re" then
	resource.AddWorkshop("658249952") -- mor_isolation_b4_re
	
elseif currentMap == "mor_skandalon_b5_re" then
	resource.AddWorkshop("658250566") -- mor_skandalon_b5_re
	
elseif currentMap == "mor_outpostnorth32_a5" then
	resource.AddWorkshop("658265026") -- mor_outpostnorth32_a5
	
elseif currentMap == "mor_auriga_v4_re" then
	resource.AddWorkshop("658240137") -- mor_auriga_v4_re
	
elseif currentMap == "mor_temple_v1" then
	resource.AddWorkshop("282458169") -- mor_temple_v1

elseif currentMap == "mor_grem" then
	resource.AddWorkshop("522713387") -- mor_grem
	
elseif currentMap == "mor_turbatio" then
	resource.AddWorkshop("524166998") -- mor_turbatio
		
elseif currentMap == "mor_installation_gt1_re" then 	
	resource.AddWorkshop("187895089") -- mor_installation_gt1_re
		
elseif currentMap == "mor_ptmc_v22" then
	resource.AddWorkshop("186357825") -- mor_ptmc_v22
		
elseif currentMap == "mor_horizon_v11_re" then
	resource.AddWorkshop("187893806") -- mor_horizon_v11_re		

elseif currentMap == "mor_isolation_cv1" then
	resource.AddWorkshop("272900384") -- mor_isolation_cv1
	
elseif currentMap == "mor_breach_cv21" then
	resource.AddWorkshop("272895564") -- mor_breach_cv21	
	
elseif currentMap == "mor_alphastation_b4_re" then
	resource.AddWorkshop("187891235") -- mor_alphastation_b4_re
end