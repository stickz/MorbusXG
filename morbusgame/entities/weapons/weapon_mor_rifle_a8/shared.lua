if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName 		= "Bulldog-HMG"
if (CLIENT) then
	SWEP.PrintName 		= "Bulldog-HMG"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false
end

SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05
SWEP.MuzzleAttachment		= "1"

SWEP.Instructions 		= "Weapon"

SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel = "models/weapons/v_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.CustomModel 		=	"models/mass_effect_3/weapons/assault_rifles/n7 typhoon.mdl"
SWEP.CustomMaterial		=	"models/mass_effect_3/weapons/assault_rifles/n7 valkyrie/wpn_asll_diff"

SWEP.Primary.Recoil 		= 1.5
SWEP.Primary.Damage 		= 18
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.08
SWEP.Primary.ClipSize 		= 100
SWEP.Primary.RPM 		= 500
SWEP.Primary.DefaultClip 	= 100
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(-6.3, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.5
SWEP.Primary.KickDown           = 0.5
SWEP.Primary.KickHorizontal         = 0.5

SWEP.Kind = WEAPON_RIFLE
SWEP.HoldKind = WEAPON_LIGHT
SWEP.AmmoEnt = "item_ammo_none_mor"
SWEP.AutoSpawnable  = true
SWEP.NeverRandom    = true

SWEP.KGWeight = 55

SWEP.Tracer = 1

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "2", enabled = true}

SWEP.ViewModelBoneMods = {
	["ValveBiped.base"] = { scale = Vector(0.758, 0.758, 0.758), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["a"] = { 
	type = "Model", 
	model = SWEP.CustomModel, 
	bone = "ValveBiped.base", 
	rel = "", 
	pos = Vector(0.2, 1.557, -4.676), 
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
	pos = Vector(8.831, 1, -3.636), 
	angle = Angle(0, -90, 169.481), 
	size = Vector(1, 1, 1), 
	color = Color(255, 255, 255, 255), 
	surpresslightning = false,
	material = SWEP.CustomMaterial, 
	skin = 0,
	bodygroup = {} 
	}
}

SWEP.shootsound = Sound("bulldog.shoot")

SWEP.NextReload = 0
function SWEP:Reload()
    if SERVER then
        if self.NextReload < CurTime() then
            self.Owner:PrintMessage(HUD_PRINTTALK,"There is no ammo for this weapon, but you can still replenish it somehow...")
            self.NextReload = CurTime() + 5
        end
    end
end

function SWEP:Replenish()
    self.Weapon:SetClip1(self.Primary.ClipSize)
end

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

	self.Owner:EmitSound( "weapons/Bianachi/mach_parts2.wav" ) ;

end
function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)

    num_bullets         = num_bullets or 1
    aimcone             = aimcone or 0

    
    local bullet = {}
        bullet.Num      = num_bullets
        bullet.Src      = self.Owner:GetShootPos()
        bullet.Dir      = self.Owner:GetAimVector()
        bullet.Spread   = Vector(aimcone, aimcone, 0)
        bullet.Tracer   = 1
        bullet.TracerName = "mor_tracer_pulseo"
        bullet.Force    = damage * 0.5
        bullet.Damage   = damage

        self:EmitSound(self.shootsound,25,25)

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
    util.Effect( "BulldogMuzzle", effect )

end

function SWEP:DoImpactEffect( tr, dmgtype )
    if( tr.HitSky ) then return true end
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

        local effect = EffectData()
        effect:SetOrigin( tr.HitPos )
        effect:SetNormal( tr.HitNormal )
        ParticleEffect( "l_energy_imp_o", tr.HitPos, Angle(0, 0, 0), nil )
        util.Effect( "mor_decal_pulseo", effect )

    end

    return true
end


if( CLIENT ) then
    local GlowMaterial = CreateMaterial( "mb/glow", "UnlitGeneric", {
        [ "$basetexture" ]      = "sprites/light_glow01",
        [ "$additive" ]         = "1",
        [ "$vertexcolor" ]      = "1",
        [ "$vertexalpha" ]      = "1",
    } )
    
    local EFFECT = {}

    function EFFECT:Init( data )
        self.Weapon = data:GetEntity()
        
        self.Entity:SetRenderBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
        self.Entity:SetParent( self.Weapon )
        
        self.LifeTime = math.Rand( 0.25, 0.35 )
        self.DieTime = CurTime() + self.LifeTime
        self.Size = math.Rand( 5, 15 )
        
        local pos, ang = GetMuzzlePosition( self.Weapon )
        
        local light = DynamicLight( self.Weapon:EntIndex() )
        light.Pos               = pos
        light.Size              = 200
        light.Decay             = 400
        light.R                 = 155
        light.G                 = 115
        light.B                 = 55
        light.Brightness        = 2
        light.DieTime           = CurTime() + 0.35
    end
    
    function EFFECT:Think()
        return IsValid( self.Weapon ) && self.DieTime >= CurTime()
    end
    
    function EFFECT:Render()
        if( !IsValid( self.Weapon ) ) then
            return
        end
    
        local pos, ang = GetMuzzlePosition( self.Weapon )
        
        local percent = math.Clamp( ( self.DieTime - CurTime() ) / self.LifeTime, 0, 1 )
        local alpha = 255 * percent
        
        render.SetMaterial( GlowMaterial )
        
        for i = 1, 2 do
            render.DrawSprite( pos, self.Size, self.Size, Color( 155, 115, 55, alpha ) )
            render.StartBeam( 2 )
                render.AddBeam( pos - ang:Forward() * 12, 16, 0, Color( 155, 115, 55, alpha ) )
                render.AddBeam( pos + ang:Forward() * 12, 16, 1, Color( 155, 115, 55, 0 ) )
            render.EndBeam()
        end
    end
    
    effects.Register( EFFECT, "BulldogMuzzle" )
end