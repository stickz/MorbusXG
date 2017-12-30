-- Read the weapon_real_base if you really want to know what each action does
-- Original Author: Remscar
-- Creator of "weapon_mor_phaser": Demonkush

if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType 			= "revolver"
SWEP.PrintName 		  = "Blaster" -- Jarvis

if (CLIENT) then
	SWEP.PrintName 		= "Blaster"
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
SWEP.NeverRandom 			= true

SWEP.CustomModel 	=	"models/mass_effect_3/weapons/pistols/m-3 predator.mdl"
SWEP.CustomMaterial	=	"models/mass_effect_3/weapons/pistols/m-3 predator/wpn_psta_diff"

SWEP.ViewModel 			     = "models/weapons/v_pistol.mdl"
SWEP.WorldModel 			 = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.Primary.Recoil			= 0.4
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.ClipSize		= 12
SWEP.Primary.RPM			= 90
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic 		= false
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
SWEP.KGWeight       = 7

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
	pos = Vector(0, -1.558, -1.558), 
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
	pos = Vector(3.635, 1, -3.636), 
	angle = Angle(0, -90, 169.481),
	size = Vector(1, 1.029, 1), 
	color = Color(255, 255, 255, 255), 
	surpresslightning = false, 
	material = SWEP.CustomMaterial, 
	skin = 0, 
	bodygroup = {} 
	}
}

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()

    self:SetWeaponHoldType(self.HoldType)

    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    -- Set the deploy animation when deploying

    self.Reloadaftershoot = CurTime() + 1
    -- Can't shoot while deploying

    self.Weapon:SetNWBool( "IsLaserOn", true )

    self:SetIronsights(false)
    -- Set the ironsight mod to false

    self.Weapon:SetNextPrimaryFire(CurTime() + 1)
    -- Set the next primary fire to 1 second after deploying

end

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone, charge)
    local tr = self.Owner:GetEyeTrace()
    local ent = ents.Create( "sent_chargebolt_small" )

    local aim = self.Owner:GetAimVector()
    local side = aim:Cross(Vector(0,0,1))
    local up = side:Cross(aim)
    if SERVER then
    ent:SetPos(self.Owner:GetShootPos() +  aim * 24 + side * 8 + up * -15)
    ent:SetOwner( self.Owner )
    ent:SetAngles(self.Owner:EyeAngles())
    ent.RocketOwner = self.Owner
    --print(charge)
    ent:Spawn()
 
    local phys = ent:GetPhysicsObject()
    phys:ApplyForceCenter( self.Owner:GetAimVector() +  self.Owner:GetForward(Vector(math.random(-255,255), math.random(-255,255), 0)) * 3000)
    phys:SetVelocity( phys:GetVelocity() + self.Owner:GetVelocity() )
    phys:EnableGravity(false)

    end
    self.Owner:RemoveAmmo( 0, self.Primary.Ammo )

    self.Weapon:EmitSound("pulsar.Single.light", 135, 100)


    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self.Weapon:TakePrimaryAmmo(1)


    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "BlasterMuzzle", effect )
end