if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName 		= "C2-Pulsar"

if (CLIENT) then
	SWEP.PrintName 		= "C2-Pulsar"
	SWEP.Slot 			= 2
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true
end

SWEP.EjectDelay			= 0.05	

SWEP.Instructions 		= "Weapon"
SWEP.MuzzleAttachment		= "1"
SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.CustomModel 	= "models/mass_effect_3/weapons/smgs/m-25 hornet.mdl"
SWEP.CustomMaterial = "models/mass_effect_3/weapons/smgs/m-25 hornet/wpn_psti_diff"

SWEP.HoldType = "smg"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_plasmagun.mdl"
SWEP.WorldModel = "models/weapons/w_plasmagun.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
    ["bone_body"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.Primary.Sound 		= Sound("delta.Single.heavy")
util.PrecacheSound(SWEP.Primary.Sound)
SWEP.Primary.Recoil 		= 0.6
SWEP.Primary.Damage 		= 14
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.015
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.RPM 			= 450
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "Battery"


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
SWEP.NeverRandom = true
SWEP.AmmoEnt = "item_ammo_battery_mor"

SWEP.KGWeight = 15

SWEP.VElements = {
    ["a"] = { 
	type = "Model", 
	model = SWEP.CustomModel, 
	bone = "bone_body", 
	rel = "", 
	pos = Vector(-0, 0, 2.299), 
	angle = Angle(0, 180, 0), 
	size = Vector(1, 1, 1), 
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
	size = Vector(1, 1, 1), 
	color = Color(255, 255, 255, 255), 
	surpresslightning = false, 
	material = SWEP.CustomMaterial, 
	skin = 0, 
	bodygroup = {} 
	}
}

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)
    num_bullets         = num_bullets or 1
    aimcone             = aimcone or 0

    local bullet = {}
        bullet.Num      = num_bullets
        bullet.Src      = self.Owner:GetShootPos()
        bullet.Dir      = self.Owner:GetAimVector()
        bullet.Spread   = Vector(aimcone, aimcone, 0)
        bullet.Tracer   = 1
        bullet.TracerName = "mor_tracer_pulsew"
        bullet.Force    = damage * 0.5
        bullet.Damage   = damage

    self.Owner:FireBullets(bullet)
    if CLIENT and !self.Owner:IsNPC() then
        local anglo = Angle(math.Rand(-self.Primary.KickDown,self.Primary.KickUp)*recoil, math.Rand(-self.Primary.KickHorizontal,self.Primary.KickHorizontal)*recoil, 0)
        self.Owner:ViewPunch(anglo)

        local eyeang = self.Owner:EyeAngles()
        eyeang.pitch = eyeang.pitch - anglo.pitch
        eyeang.yaw = eyeang.yaw - anglo.yaw
        self.Owner:SetEyeAngles(eyeang)
    end

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "C1Muzzle", effect )
end

function SWEP:DoImpactEffect( tr, dmgtype )
    if( tr.HitSky ) then return true end
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then
        local effect = EffectData()
        effect:SetOrigin( tr.HitPos )
        effect:SetNormal( tr.HitNormal )
        ParticleEffect( "l_photon_imp_w", tr.HitPos, Angle(0, 0, 0), nil )
        util.Effect( "mor_decal_pulsew", effect )
    end
    return true
end