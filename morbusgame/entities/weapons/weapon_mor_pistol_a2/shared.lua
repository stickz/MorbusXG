-- Read the weapon_real_base if you really want to know what each action does
-- Original Author: Remscar
-- Creator of "weapon_mor_phaser": Demonkush

if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType 			= "revolver"
SWEP.PrintName 		  = "B1-Beamer" -- Jarvis

if (CLIENT) then
	SWEP.PrintName 		= "B1-Beamer"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter     = "b"
	SWEP.ViewModelFlip	= false
end

------------------------------------------------*/
SWEP.Base 				      = "weapon_mor_base"
SWEP.MuzzleAttachment		  = "1"

SWEP.Spawnable 			    = false
SWEP.AdminSpawnable 		= false
SWEP.AutoSpawnable  		= true
SWEP.NeverRandom 			= false

SWEP.CustomModel 	=	"models/mass_effect_3/weapons/pistols/m-358 talon.mdl"
SWEP.CustomMaterial	=	"models/mass_effect_3/weapons/pistols/m-358 talon/wpn_pstj_diff"

SWEP.ViewModel 			     = "models/weapons/v_pistol.mdl"
SWEP.WorldModel 			 = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.Sound 		   = Sound("delta.Single.heavy")
SWEP.Primary.Damage         = 8
SWEP.Primary.Recoil         = 0.5
SWEP.Primary.NumShots       = 2
SWEP.Primary.Cone           = 0.02
SWEP.Primary.ClipSize       = 16
SWEP.Primary.RPM            = 500
SWEP.Primary.DefaultClip    = 16
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo 		    = "Battery"

SWEP.Primary.KickUp                 = 0.4
SWEP.Primary.KickDown               = 0.2
SWEP.Primary.KickHorizontal         = 0.4

SWEP.IronSightsPos  = Vector(-5.75, -14, 3)
SWEP.IronSightsAng  = Vector(0, -1.6, 2)
SWEP.SightsPos      = SWEP.IronSightsPos
SWEP.SightsAng      = SWEP.IronSightsAng

SWEP.Kind           = WEAPON_PISTOL
SWEP.AmmoEnt        = "item_ammo_battery_mor"
SWEP.KGWeight       = 5

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = false}

SWEP.UseHands = true
SWEP.HoldType = "revolver"

SWEP.ViewModelBoneMods = {
    ["ValveBiped.base"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
    ["a"] = { 
	type = "Model", 
	model = SWEP.CustomModel, 
	bone = "ValveBiped.base", 
	rel = "", 
	pos = Vector(0, -0.519, -1.558), 
	angle = Angle(0, 0, -90), 
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
	pos = Vector(3.635, 1, -3), 
	angle = Angle(0, -90, 169.481), 
	size = Vector(1, 1.029, 1), 
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
        bullet.TracerName = "mor_tracer_pulsey"
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
    util.Effect( "B1Muzzle", effect )

end

function SWEP:DoImpactEffect( tr, dmgtype )
    if( tr.HitSky ) then return true end
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

        local effect = EffectData()
        effect:SetOrigin( tr.HitPos )
        effect:SetNormal( tr.HitNormal )
        ParticleEffect( "l_energy_imp_y", tr.HitPos, Angle(0, 0, 0), nil )
        util.Effect( "mor_decal_pulsey", effect )

    end

    return true
end