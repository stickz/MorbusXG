 -- Weapon Information System
 -- Created by Zignd (http://steamcommunity.com/id/zignd/)
 -- Inspired by TTT Weapon Info created by Wolf Halez and available as paid stuff :(.
 -- The Weapon Information System is not a source code copy of the TTT Weapon Info, I analysed how it works an built my own version from scratch.
 -- The Weapon Information System is an open-source Garry's Mod addon and is available on Garry's Mod Workshop on Steam.
 
 -- Add me on Steam for contact.
 

-- Modified by Demonkush
-- This is the MORBUS VARIANT: ONLY USE ON MORBUS

surface.CreateFont( "WpnInfoTitle", {
	font 		= "DeadSpaceTitleFont",
	size 		= 80,
	weight 		= 700,
	antialias	= true
})

wpninfo = {}
wpninfo.colors =
{

	background = Color( 5, 95, 175, 55 ),
	text = Color( 175, 215, 255, 255 )

}
wpninfo.infos =
{

	name = "N/A",
	damage = "N/A",
	clipsize = "N/A",
	spread = "0.00",
	RPM = "0",
	ammo = "N/A"

}

local equipweps = {"Glow Sticks", "Sticky Glow Sticks", "Grav Sticks", "Motion Detector", "Laser Tripwire", "AL-1 Tripmine", "Medkit", "Vitamins", "Frag Grenade", "Cryo Grenade", "Incendiary Grenade", "Smoke Grenade", "Toxic Grenade", "Plasma Grenade", "Pulse Grenade", "Beacon" }
local function drawwpninfo()

	local x, y, width, height, panelwidth, panelheight, desc, padding, position, angle, scale, ammoname, wepammoname, grenade, texture, color
	local empty = false
	local rechargable = false
	local explosive = false
	local scoped = false
	local ply = LocalPlayer()
	local wpn = ply:GetActiveWeapon()
	local ent = util.TraceLine(
	{

		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ( ply:GetAimVector() * 160 ),
		filter = ply,
		mask = MASK_SHOT_HULL

	} ).Entity

	local function getnewy( text )

		width, height = surface.GetTextSize( text )
		return (y + height) + 10

	end

	if IsValid( ent ) then
		
		padding = 50
		angle = Angle( 0, ply:EyeAngles().y - 90, 90 )
		scale = 0.04

		if ent:IsWeapon() and ent:IsScripted() then

			if ent.Primary.Damage && ent.Primary.Damage > 1 then
				wpninfo.infos.damage = ent.Primary.Damage 	or 0
			end
			if ent.Primary.ClipSize && ent.Primary.ClipSize > 0 then
				wpninfo.infos.clipsize = ent.Primary.ClipSize
			end
			if ent:Clip1() == 0 then
				empty = true
			end
			if ent.Rechargable && ent.Rechargable == true then
				rechargable = true
			end
			if ent.Explosive && ent.Explosive == true then
				explosive = true
			end
			if ent.Sniper && ent.Sniper == true then
				scoped = true
			end

			if table.HasValue( equipweps, wpninfo.infos.name ) then
				grenade = true
			end

			wpninfo.infos.name 		= ent.PrintName 		or "N/A"
			wpninfo.infos.spread 	= ent.Primary.Cone 		or 0
			wpninfo.infos.RPM 		= ent.Primary.RPM 		or 0
			wpninfo.infos.ammo 		= ent.Primary.Ammo 		or 0
			wpninfo.infos.weight	= ent.KGWeight 			or 0
			

			if string.len(wpninfo.infos.name) > 14 then
				panelwidth = 700 + string.len(wpninfo.infos.name) * 10

			else
				panelwidth = 700

			end

			wepammoname = "None"
			if wpninfo.infos.ammo == "SMG1" then
				wepammoname = "SMG"

			elseif wpninfo.infos.ammo == "Buckshot" then
				wepammoname = "Shotgun"

			elseif wpninfo.infos.ammo == "357" then
				wepammoname = "what is this?"

			elseif wpninfo.infos.ammo == "AlyxGun" then
				wepammoname = "Rifle"

			elseif wpninfo.infos.ammo == "Battery" then
				wepammoname = "Battery"

			elseif wpninfo.infos.ammo == "Pistol" then
				wepammoname = "Pistol"

			end

			if explosive == true then
				wepammoname = "Bomb"
			end

			x = -panelwidth / 2
			y = 0
			position = ent:GetPos() + Vector( 0, 0, 37 + math.sin( CurTime() * 1.5 ) * 2 )	

			panelheight = 800
			texture = surface.GetTextureID "vgui/morbus/itemoverlay"
			color = Color(25, 215, 255, 215)
			if grenade == true then
				panelheight = 135
				texture = surface.GetTextureID "vgui/morbus/hpbar"
				color = Color(55, 155, 255, 85)
			position = ent:GetPos() + Vector( 0, 0, 25 + math.sin( CurTime() * 1.5 ) * 2 )	
			end

			cam.Start3D2D( position, angle, scale )
				draw.RoundedBox( 30, x, y, panelwidth, panelheight, wpninfo.colors.background )
				draw.TexturedQuad
				{
					texture = texture,
					color = color,
					x = x,
					y = y,
					w = panelwidth,
					h = panelheight
				}
				desc = wpninfo.infos.name
				if grenade == true then
					draw.DrawText( desc, "WpnInfoTitle", 0, y + 25, Color( 155, 200, 255, 255 ), TEXT_ALIGN_CENTER )
				else
					draw.DrawText( desc, "WpnInfoTitle", 0, y + 50, Color( 155, 200, 255, 255 ), TEXT_ALIGN_CENTER )
				end
				
				if grenade != true then

					if rechargable == true then
						draw.DrawText( "Rechargable", "DSMass", 0, y+115, Color( 155, 215, 255, 155 ), TEXT_ALIGN_CENTER )
					end

					if explosive == true then
						draw.DrawText( "Explosive", "DSMass", 0, y+115, Color( 255, 215, 155, 155 ), TEXT_ALIGN_CENTER )
					end

					if scoped == true then
						draw.DrawText( "Scoped", "DSMass", 0, y+115, Color( 215, 215, 215, 155 ), TEXT_ALIGN_CENTER )
					end

					y = getnewy( desc ) + 100
					desc = "Damage: "
					draw.DrawText( desc, "DSMass", x + padding, y +65, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.damage, "DSMass", x + panelwidth - padding, y +56, wpninfo.colors.text, TEXT_ALIGN_RIGHT )

					y = getnewy( desc )
					desc = "Mag. Size: "
					draw.DrawText( desc, "DSMass", x + padding, y +65, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.clipsize, "DSMass", x + panelwidth - padding, y +65, wpninfo.colors.text, TEXT_ALIGN_RIGHT )

					y = getnewy( desc )
					desc = "Spread: "
					draw.DrawText( desc, "DSMass", x + padding, y +65, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.spread, "DSMass", x + panelwidth - padding, y +65, wpninfo.colors.text, TEXT_ALIGN_RIGHT )

					y = getnewy( desc )
					desc = "RPM: "
					draw.DrawText( desc, "DSMass", x + padding, y +65, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.RPM, "DSMass", x + panelwidth - padding, y +65, wpninfo.colors.text, TEXT_ALIGN_RIGHT )

					y = getnewy( desc )
					desc = "Weight: "
					draw.DrawText( desc, "DSMass", x + padding, y +65, wpninfo.colors.text, TEXT_ALIGN_LEFT )
					draw.DrawText( wpninfo.infos.weight, "DSMass", x + panelwidth - padding, y +65, wpninfo.colors.text, TEXT_ALIGN_RIGHT )

					y = getnewy( desc )
					if rechargable == true then
						desc = "Ammo: "
						draw.DrawText( desc, "DSMass", x + padding, y+ 65, wpninfo.colors.text, TEXT_ALIGN_LEFT )
						draw.DrawText( "Infinite", "DSMass", x + panelwidth - padding, y +65, Color( 155, 255, 155, 155 ), TEXT_ALIGN_RIGHT )
					else
						desc = "Ammo: "
						draw.DrawText( desc, "DSMass", x + padding, y+ 65, wpninfo.colors.text, TEXT_ALIGN_LEFT )
						draw.DrawText( wepammoname or wpninfo.infos.name, "DSMass", x + panelwidth - padding, y +65, wpninfo.colors.text, TEXT_ALIGN_RIGHT )
					end

					if empty == true then

						y = getnewy( desc )
						desc = "Empty clip!"
						draw.DrawText( desc, "DSMass", 0, y+ 65, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
					end
				end
			cam.End3D2D()

		-- Ammo identifier
		elseif ent.Type and ent.AmmoType and ent.Type == "anim" then
			
			width, height = surface.GetTextSize(ent.AmmoType)
			panelwidth = width + padding > 500 and width + padding * 4 or 500
			panelheight = 100

				-- Compatability
				if ent.AmmoType == "SMG1" then
					ammoname = "SMG Ammo"
				elseif ent.AmmoType == "Buckshot" then
					ammoname = "Shotgun Ammo"
					panelwidth = 600
				elseif ent.AmmoType == "357" then
					ammoname = "what is this?"
				elseif ent.AmmoType == "AlyxGun" then
					ammoname = "Rifle Ammo"
				elseif ent.AmmoType == "Battery" then
					ammoname = "Battery"
				elseif ent.AmmoType == "Pistol" then
					ammoname = "Pistol Ammo"
				end
				
			x = -panelwidth / 2
			y = 0
			position = ent:GetPos() + Vector( 0, 0, 30 + math.sin( CurTime() * 2 ) * 2 )
			
			cam.Start3D2D( position, angle, scale )
				-- Valid Ammo Highlight
				--draw.RoundedBox( 30, x, y, panelwidth, panelheight, (wpn:IsWeapon() and wpn.Primary and (wpn.Primary.Ammo == ent.AmmoType) and Color( 155, 255, 55, 215 ) or wpninfo.colors.background) )
				draw.TexturedQuad
				{
					texture = surface.GetTextureID "vgui/morbus/hpbar",
					color = Color( 200, 255, 85, 75 ),
					x = x,
					y = y,
					w = panelwidth,
					h = panelheight
				}
				draw.DrawText( ammoname, "DSMass", 0, y + 15, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER )

			cam.End3D2D()
		end
	end
end
hook.Add( "PostDrawOpaqueRenderables", "drawwpn", drawwpninfo )