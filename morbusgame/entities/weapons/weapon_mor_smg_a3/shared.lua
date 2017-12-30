if (SERVER) then
	AddCSLuaFile("shared.lua")	
end

SWEP.PrintName 		= "T60 Mini-SMG"
if (CLIENT) then
	SWEP.PrintName 		= "T60 Mini-SMG"
	SWEP.Slot 			= 2
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true
end

SWEP.HoldType 		= "crossbow"
SWEP.EjectDelay			= 0.05	

SWEP.Instructions 		= "Weapon"
SWEP.MuzzleAttachment		= "1"
SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.CustomModel 	= "models/mass_effect_3/weapons/smgs/m-4 shuriken.mdl"
SWEP.CustomMaterial = "models/mass_effect_3/weapons/smgs/m-4 shuriken/wpn_pstc_diff"

SWEP.ViewModel = "models/weapons/v_plasmagun.mdl"
SWEP.WorldModel = "models/weapons/w_plasmagun.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false


SWEP.Primary.Sound 		= Sound("weapon_uzi.Single")
SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 12
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.04
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.RPM 			= 650
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "SMG1"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(3.6, 0, 0)
SWEP.IronSightsAng = Vector(-1.922, 0.481, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.3
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 0.3


SWEP.Kind = WEAPON_LIGHT
SWEP.AutoSpawnable = true
SWEP.NeverRandom = false
SWEP.AmmoEnt = "item_ammo_smg1_mor"

SWEP.KGWeight = 15


SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = false}
SWEP.ViewModelBoneMods = {
    ["bone_body"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["a"] = { 
	type = "Model",
	model = SWEP.CustomModel, 
	bone = "bone_body", 
	rel = "",
	pos = Vector(-0.201, -0.519, 2.5),
	angle = Angle(0, 180, 0),
	size = Vector(1.2, 1.2, 1.2),
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	material = SWEP.CustomMaterial,
	skin = 0, 
	bodygroup = {} 
	}
}

SWEP.WElements = {
	["a"] = { 
	type = "Model", 
	model = SWEP.CustomModel,
	bone = "ValveBiped.Bip01_R_Hand",
	rel = "",
	pos = Vector(5.714, 1.557, -3.636),
	angle = Angle(180, 90, 0),
	size = Vector(1.2, 1.2, 1.2),
	color = Color(255, 255, 255, 255),
	surpresslightning = false,
	material = SWEP.CustomMaterial,
	skin = 0,
	bodygroup = {} 
	}
}