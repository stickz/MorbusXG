if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if ( CLIENT ) then
	language.Add ("ent_toxic_grenade", "Toxic Grenade") --wtf
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Toxic Grenade"
	SWEP.Slot				= WEAPON_MISC - 1
	SWEP.SlotPos			= 0
end

SWEP.Base 				= "weapon_mor_base_grenade"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.HoldType			= "grenade"

SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay		= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AllowDrop = true
SWEP.Kind = WEAPON_GRENADE
SWEP.KGWeight = 8
SWEP.AutoSpawnable = false
SWEP.NeverRandom = true
SWEP.StoredAmmo = 0

SWEP.GrenadeEnt = "ent_toxic_grenade"
SWEP.GrenadeWep = "weapon_toxic"

SWEP.VElements = {
	["a"] = { 
	type = "Model", 
	model = "models/mass_effect_3/weapons/misc/grenade.mdl", 
	bone = "ValveBiped.Grenade_body", 
	rel = "", 
	pos = Vector(0, 0, -1.558), 
	angle = Angle(0, 0, 0), 
	size = Vector(1.5, 1.5, 1.5), 
	color = Color(255, 255, 255, 255), 
	surpresslightning = false, 
	material = "reskins/masseffect/grenade_toxic", 
	skin = 0, 
	bodygroup = {} 
	}
}

SWEP.WElements = {
	["a"] = { 
	type = "Model", 
	model = "models/mass_effect_3/weapons/misc/grenade.mdl", 
	bone = "ValveBiped.Bip01_R_Hand", 
	rel = "", 
	pos = Vector(3.635, 2.596, -0.519), 
	angle = Angle(0, 0, 0),
	size = Vector(1.5, 1.5, 1.5),
	color = Color(255, 255, 255, 255), 
	surpresslightning = false, 
	material = "reskins/masseffect/grenade_toxic", 
	skin = 0, 
	bodygroup = {} 
	}
}