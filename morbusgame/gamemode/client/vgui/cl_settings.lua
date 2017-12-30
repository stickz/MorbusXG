//Options/Settings menu

function CreateSettingsMenu()

	local W_POS = 12

	local pnl = vgui.Create("DFrame")
	pnl:SetSize(150,295)
	pnl:Center()
	pnl:MakePopup()
	pnl:SetTitle("Settings")

	local s1 = vgui.Create("DCheckBoxLabel",pnl)
	s1:SetPos(W_POS,30)
	s1:SetText("Hide Role Hints")
	s1:SetConVar("morbus_hide_rolehint")
	s1:SetValue(GetConVar("morbus_hide_rolehint"):GetBool())
	s1:SizeToContents()

	local s1a = vgui.Create("DCheckBoxLabel",pnl)
	s1a:SetPos(W_POS,50)
	s1a:SetText("Hide Alien Distortion")
	s1a:SetConVar("morbus_hide_distortion")
	s1a:SetValue(GetConVar("morbus_hide_distortion"):GetBool())
	s1a:SizeToContents()

	local s1b = vgui.Create("DCheckBoxLabel",pnl)
	s1b:SetPos(W_POS,70)
	s1b:SetText("Hide RP Names")
	s1b:SetConVar("morbus_hide_rpnames")
	s1b:SetValue(GetConVar("morbus_hide_rpnames"):GetBool())
	s1b:SizeToContents()

	local s1c = vgui.Create("DCheckBoxLabel",pnl)
	s1c:SetPos(W_POS,90)
	s1c:SetText("Disable Music")
	s1c:SetConVar("morbus_disable_music")
	s1c:SetValue(GetConVar("morbus_disable_music"):GetBool())
	s1c:SizeToContents()
	
	local s1d = vgui.Create("DCheckBoxLabel",pnl)
	s1d:SetPos(W_POS,110)
	s1d:SetText("Disable Kill Stats")
	s1d:SetConVar("morbus_disable_regui")
	s1d:SetValue(GetConVar("morbus_disable_regui"):GetBool())
	s1d:SizeToContents()
	
	local s1d = vgui.Create("DCheckBoxLabel",pnl)
	s1d:SetPos(W_POS,130)
	s1d:SetText("Disable Tooltips")
	s1d:SetConVar("morbus_disable_tooltips")
	s1d:SetValue(GetConVar("morbus_disable_tooltips"):GetBool())
	s1d:SizeToContents()
	
	local sby = vgui.Create( "DNumSlider", pnl)
	sby:SetPos(W_POS,145)
	sby:SetSize(150, 20)
	sby:SetText( "SB Y-POS" )
	sby:SetMin( 0 )
	sby:SetMax( 120 )
	sby:SetDecimals( 0 )
	sby:SetConVar("morbus_scoreboard_ypos")
	sby:SetValue(GetConVar("morbus_scoreboard_ypos"):GetInt())
	
	local cAlienHud = vgui.Create("DComboBox", pnl)
	cAlienHud:SetPos(W_POS,170)
	cAlienHud:SetSize(120, 20)
	cAlienHud:SetValue( "Alien Hud Colour" )
	cAlienHud:AddChoice( "Red" )
	cAlienHud:AddChoice( "Blue" )
	cAlienHud:AddChoice( "Purple" )
	cAlienHud.OnSelect = function( panel, index, value )
		if value == "Red" then
			GetConVar("morbus_alienhud_disable"):SetBool(false)
			GetConVar("morbus_alienhud_purple"):SetBool(false)
		
		elseif value == "Blue" then
			GetConVar("morbus_alienhud_disable"):SetBool(true)
			GetConVar("morbus_alienhud_purple"):SetBool(false)
			
		elseif value == "Purple" then
			GetConVar("morbus_alienhud_disable"):SetBool(false)
			GetConVar("morbus_alienhud_purple"):SetBool(true)
		end
		
		LocalPlayer():PrintMessage( HUD_PRINTTALK, "Alien HUD colour set to "..value..".")
		cAlienHud:SetValue( "Alien Hud Colour" )
	end	
	
	local s2 = vgui.Create("DButton",pnl)
	s2:SetPos(W_POS,197)
	s2:SetText("Toggle Spectator Mode")
	s2:SetSize(120,20)
	function s2:DoClick()
		RunConsoleCommand("say", "/spec")
	end

	local s3 = vgui.Create("DLabel",pnl)
	s3:SetPos(W_POS,225)
	s3:SetText("CONSOLE COMMANDS:")
	s3:SizeToContents()

	local s4 = vgui.Create("DLabel",pnl)
	s4:SetPos(W_POS,245)
	s4:SetText("morbus_toggle_hud\nmorbus_toggle_chat\nmorbus_mute_status")
	s4:SizeToContents()

end
concommand.Add("morbus_settings",CreateSettingsMenu)