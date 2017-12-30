
AddCSLuaFile()

SWEP.PrintName 		= "A22-Flak Shotgun"
if (CLIENT) then
	SWEP.PrintName 		= "A22-Flak Shotgun"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "k"
    SWEP.ViewModelFlip = false

end


SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models

SWEP.EjectDelay			= 0.53


SWEP.HoldType 		= "shotgun"

SWEP.Instructions 		= ""

SWEP.Base 				= "weapon_mor_base_pump"

SWEP.Spawnable 			= false
SWEP.AdminSpawnable 		= false

SWEP.CustomModel 	= "models/mass_effect_3/weapons/shotguns/graal spike thrower.mdl"
SWEP.CustomMaterial = "models/mass_effect_3/weapons/shotguns/graal spike thrower/wpn_blsf_diff"	

SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.Primary.Sound 		= Sound("solsar.Single.heavy")   
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 5
SWEP.Primary.Cone			= 0.115
SWEP.Primary.ClipSize		= 8
SWEP.Primary.RPM            = 45
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "Buckshot"
SWEP.DestroyDoor = 1

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"


SWEP.IronSightsPos = Vector(-8.7, .394, 1.659)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.8
SWEP.Primary.KickDown           = 0.4
SWEP.Primary.KickHorizontal         = 0.5

SWEP.Gun = "weapon_mor_shot_a2"

SWEP.Kind = WEAPON_RIFLE
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_buckshot_mor"
SWEP.KGWeight = 28
SWEP.AutoSpawnable = true
SWEP.NeverRandom = true
SWEP.StoredAmmo = 0

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 0.3
SWEP.ShellTime		= 0.5
SWEP.InsertingShell	=		false


SWEP.ViewModelBoneMods = {
	["ValveBiped.Gun"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["a"] = { 
	type = "Model", 
	model = SWEP.CustomModel, 
	bone = "ValveBiped.Gun", 
	rel = "", 
	pos = Vector(0.319, 1, -15.065), 
	angle = Angle(0, 0, -90), 
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
	pos = Vector(3.635, 0, -3.636), 
	angle = Angle(0, -90, 171.817), 
	size = Vector(1.2, 1.2, 1.2), 
	color = Color(255, 255, 255, 255), 
	surpresslightning = false, 
	material = SWEP.CustomMaterial, 
	skin = 0, 
	bodygroup = {} 
	}
}

function SWEP:ShootBullet()
	self:DoFlak()
	self:DoFlak()
	self:DoFlak()
	self:DoFlak()
	self:DoFlak()
end

function SWEP:DoFlak()
		local tr = self.Owner:GetEyeTrace()
	   local ent = ents.Create( "sent_flak" )

	local aim = self.Owner:GetAimVector()
	local side = aim:Cross(Vector(0,0,1))
	local up = side:Cross(aim)
	if SERVER then
 	ent:SetPos(self.Owner:GetShootPos() +  aim * 24 + side * 8 + up * -5)
	ent:SetOwner( self.Owner )
	ent:SetAngles(self.Owner:EyeAngles())
	ent.RocketOwner = self.Owner
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	phys:ApplyForceCenter( self.Owner:GetAimVector() + 	self.Owner:GetForward() * math.random(1750,5000))
	phys:SetVelocity( phys:GetVelocity() + self.Owner:GetVelocity() + Vector( math.random(-150,150),math.random(-150,150),math.random(-150,150)) )
	phys:EnableGravity(true)

	end
	self.Owner:RemoveAmmo( 0, self.Primary.Ammo )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end
		
end