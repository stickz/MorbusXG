if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName 		= ""

if (CLIENT) then
	SWEP.PrintName 		= "Tech Rifle"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true
end

SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05
SWEP.MuzzleAttachment		= "1"

SWEP.Instructions 		= "Weapon"

SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel = "models/weapons/v_plasmagun.mdl"
SWEP.WorldModel = "models/weapons/w_plasmagun.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.CustomModel 		=	"models/mass_effect_3/weapons/assault_rifles/m-55 argus.mdl"
SWEP.CustomMaterial		=	"models/mass_effect_3/weapons/assault_rifles/m-55 argus/wpn_asli_diff"

SWEP.Primary.Sound 		= Sound("rail.Single.light")

SWEP.Primary.Recoil 		= 0.45
SWEP.Primary.Damage 		= 16
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.030
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.RPM 		= 550
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "Battery"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(3.6, 0, 0)
SWEP.IronSightsAng = Vector(-1.922, 0.481, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.3
SWEP.Primary.KickDown           = 0.3
SWEP.Primary.KickHorizontal         = 0.3

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_battery_mor"
SWEP.AutoSpawnable = true
SWEP.NeverRandom    = false

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = true}

SWEP.KGWeight = 19

SWEP.ViewModelBoneMods = {
    ["bone_body"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
    ["a"] = { 
	type = "Model", 
	model = SWEP.CustomModel, 
	bone = "bone_body", 
	rel = "", 
	pos = Vector(0, -2.597, 0.699), 
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
	pos = Vector(8.831, 1.2, -3.636),
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
        bullet.TracerName = "mor_tracer_pulseb"
        bullet.Force    = damage * 0.5
        bullet.Damage   = damage
        bullet.Callback = function(attacker, tracedata, dmginfo) 
        
                        return self:RicochetCallback(0, attacker, tracedata, dmginfo) 
                      end

    self.Owner:FireBullets(bullet)
    if CLIENT and !self.Owner:IsNPC() then
        --local anglo = Angle(math.Rand(-self.Primary.KickDown,-self.Primary.KickUp), 0, 0)
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
    util.Effect( "ArcMuzzle", effect )

end

function SWEP:DoImpactEffect( tr, dmgtype )
    if( tr.HitSky ) then return true end
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

        local effect = EffectData()
        effect:SetOrigin( tr.HitPos )
        effect:SetNormal( tr.HitNormal )
        ParticleEffect( "l_energy_imp_b", tr.HitPos, Angle(0, 0, 0), nil )
        util.Effect( "mor_decal_pulseb", effect )

    end

    return true
end