-- Little notification + hint at the start of the round

ROLEHELP = {}
ROLEHELP[ROLE_HUMAN] = {}
ROLEHELP[ROLE_BROOD] = {}
ROLEHELP[ROLE_SWARM] = {}

ROLEHELP[ROLE_HUMAN].Title = "You are a Human"
ROLEHELP[ROLE_HUMAN].Bullets = {"There is an Alien among you. Find it and kill it.", 
								"You are stronger with others, but be careful who you trust.", 
								"Be sure to complete missions to prevent health decay/death.",
								"Weapons slow you down, so choose your load-out carefully."}


ROLEHELP[ROLE_BROOD].Title = "You are a Brood Alien"

ROLEHELP[ROLE_BROOD].Bullets = {"Find Humans and INFECT using \"Brood Form\".",
								"Press v to transform between \"Human\" and \"Brood\" Form.",
								"Disguise yourself as human and transform alone targets first.",
								"Press C to put points into Offensive, Defensive, or Utility upgrades."}
							

ROLEHELP[ROLE_SWARM].Title = "You are a Swarm Alien"
ROLEHELP[ROLE_SWARM].Bullets = {"You are very weak alone so attack humans together!",
								"Limited respawns are created on a per infect basis!",
								"Assist broods wherever possible, but be careful if they're disguised!"}


surface.CreateFont("hint_font", {font = "Verdana",
                                size = 21,
                                weight = 400,
                                outline = true
                              	})
surface.CreateFont("hint_font_small", {font = "Verdana",
                                size = 18,
                                weight = 400,
                                outline = true
                              	})

local pnl = nil								
								
function CreateRoleHelp(role)
	if pnl != nil && pnl:IsValid() then pnl:Remove() end
	if GetConVar("morbus_hide_rolehint"):GetBool() or LocalPlayer():Team() == TEAM_SPEC then return end
	pnl = vgui.Create("Panel")
	pnl:SetSize(ScrW(),700)
	pnl:Center()	
	timer.Simple(30, function() if pnl:IsValid() then pnl:Remove() end end)

	pnl:SetMouseInputEnabled(false)

	local ttl = vgui.Create("DLabel",pnl)
	ttl:SetText(ROLEHELP[role].Title)
	ttl:SetFont("DSHuge")
	ttl:SizeToContents()
	ttl:SetColor(Color(255,255,255,180))
	surface.SetFont("DSHuge")
	local w = surface.GetTextSize(ROLEHELP[role].Title)
	ttl:SetPos(pnl:GetWide()/2 - w/2,20)
	ttl:SetMouseInputEnabled(false)
	
	for i=1, #ROLEHELP[role].Bullets do
		local blt = vgui.Create("DLabel",pnl)
		blt:SetText(ROLEHELP[role].Bullets[i])
		blt:SetFont("hint_font")
		blt:SizeToContents()
		blt:SetColor(Color(255,255,255,180))
		surface.SetFont("hint_font")
		blt:SetMouseInputEnabled(false)
		local w = surface.GetTextSize(ROLEHELP[role].Bullets[i])
		blt:SetPos(pnl:GetWide()/2 - w/2,40 + 25*i)
	end

	local blt = vgui.Create("DLabel",pnl)
	blt:SetText("Read the guide in F1 for more help!")
	blt:SetFont("hint_font_small")
	blt:SizeToContents()
	blt:SetColor(Color(255,255,255,180))
	surface.SetFont("hint_font_small")
	local w = surface.GetTextSize("Read the guide in F1 for more help!")
	blt:SetPos(pnl:GetWide()/2 - w/2,65 + 25*#ROLEHELP[role].Bullets)
	blt:SetMouseInputEnabled(false)
end