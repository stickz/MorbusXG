// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team


function GM:HUDDrawTargetID()

	local tr = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
	local trace = util.TraceLine( tr )
	if !trace.Hit || !trace.HitNonWorld then return end

	local text = ""
	local font = "TargetID"
	local text2 = ""
	
	local ent = trace.Entity
	
	local entClass = ent:GetClass()	
	if entClass && entClass == "prop_ragdoll"  then

		local distance = trace.HitPos:Distance(trace.StartPos)

		if ent:GetNWBool("HumanBody",false) && distance < 140 then
			local ply = ent:GetNWEntity("Player",nil)
			if !ply or !IsValid(ply) then return end
			local name = ent:GetNWString("Name", "")
			local text = ""
			if name == "" then
				return
			else
				text = name.."'s Corpse"
			end

			surface.SetFont( font )
			local w, h = surface.GetTextSize( text )
			local poss = Vector(0, 0, 0) + ent:GetPos()
			local popos = poss:ToScreen()
			local x = popos.x
			local y = popos.y

			x = x - w / 2
		
			// The fonts internal drop shadow looks lousy with AA on
			draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
			draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
			draw.SimpleText( text, font, x, y, Color(205,15,15,255))
		end

		return


	end

	if !ent:IsPlayer() then return end


	local activateWeapon = ent:GetActiveWeapon()
	if activateWeapon != NULL then

	      
		if (ent:GetNWBool("alienform",false)!= true && activateWeapon:GetClass() != "weapon_mor_swarm") or LocalPlayer():IsAlien() then
			

			text = ent:GetFName()
			local clr = 255
		 
		 	if ent:IsAlien() && LocalPlayer():IsAlien() || ent:IsSwarm()  then
		 		
		 		text = " "..ent:GetFName().." (ALIEN)"
		 		clr = 0
		 	else
		 		text = ent:GetFName()
		 	end

		 	surface.SetFont( font )
			local w, h = surface.GetTextSize( text )
			local poss = Vector(0, 0, 40) + ent:GetPos()
			local popos = poss :ToScreen()
			local x = popos.x
			local y = popos.y

			x = x - w / 2
		
			// The fonts internal drop shadow looks lousy with AA on
			draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
			draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
			draw.SimpleText( text, font, x, y, Color(255,clr,clr,255) )


			y = y + h - 4

			local text, col = util.HealthToString(ent:Health())

			local font = "TargetIDSmall"

			surface.SetFont( font )
			local w, h = surface.GetTextSize( text )
			local x =  popos.x  - w / 2

			draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
			draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
			draw.SimpleText( text, font, x, y, col )

			y = y + h - 4

			local text, col = util.SanityToString(ent:GetBaseSanity())

			local font = "TargetIDSmall"

			surface.SetFont( font )
			local w, h = surface.GetTextSize( text )
			local x =  popos.x  - w / 2

			draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
			draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
			draw.SimpleText( text, font, x, y, col )

			y = y + h - 4

			if ent.sb_tag and ent.sb_tag.txt != nil then

				local text = ent.sb_tag.txt
				local col = ent.sb_tag.color

				local font = "TargetIDSmall"

				surface.SetFont( font )
				local w, h = surface.GetTextSize( text )
				local x =  popos.x  - w / 2

				draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
				draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
				draw.SimpleText( text, font, x, y, col )
			end



		end
	end

end