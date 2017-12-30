if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName 		= "IXR Particle Beamer"
if (CLIENT) then
	SWEP.PrintName 		= "IXR Particle Beamer"
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

SWEP.CustomModel 		=	"models/mass_effect_3/weapons/assault_rifles/phaeston.mdl"
SWEP.CustomMaterial		=	"models/mass_effect_3/weapons/assault_rifles/phaeston/wpn_aslg_diff"

SWEP.Primary.Sound 		= Sound("particle.Single.light")
util.PrecacheSound(SWEP.Primary.Sound)
SWEP.Primary.Recoil 		= 0.6
SWEP.Primary.Damage 		= 20
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.015
SWEP.Primary.ClipSize 		= 20
SWEP.Primary.RPM 			= 200
SWEP.Primary.DefaultClip 	= 20
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "Battery"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(3.9, 0, 0)
SWEP.IronSightsAng = Vector(-1.922, 0.481, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.3
SWEP.Primary.KickDown           = 0.3
SWEP.Primary.KickHorizontal         = 0.3

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_battery_mor"
SWEP.AutoSpawnable = true
SWEP.NeverRandom    = true

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = true}

SWEP.KGWeight = 25

SWEP.ViewModelBoneMods = {
    ["bone_body"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
  ["a"] = { 
  type = "Model", 
  model = SWEP.CustomModel,
  bone = "bone_body", 
  rel = "",
  pos = Vector(0.3, -2.597, 0.699), 
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
  pos = Vector(4.675, 1.2, -3.636), 
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
        bullet.TracerName = "mor_tracer_pulsep"
        bullet.Force    = damage * 0.5
        bullet.Damage   = damage
        bullet.HullSize = 2


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
    util.Effect( "IXMuzzle", effect )

end

function SWEP:DoImpactEffect( tr, dmgtype )
    if( tr.HitSky ) then return true end
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then
        local effect = EffectData()
        effect:SetOrigin( tr.HitPos )
        effect:SetNormal( tr.HitNormal )
        ParticleEffect( "m_energy_imp_p", tr.HitPos, Angle(0, 0, 0), nil )
        util.Effect( "mor_decal_pulsep", effect )
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
        light.B                 = 255
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
            render.DrawSprite( pos, self.Size, self.Size, Color( 155, 115, 255, alpha ) )
            render.StartBeam( 2 )
                render.AddBeam( pos - ang:Forward() * 12, 16, 0, Color( 155, 115, 255, alpha ) )
                render.AddBeam( pos + ang:Forward() * 12, 16, 1, Color( 155, 115, 255, 0 ) )
            render.EndBeam()
        end
    end
    
    effects.Register( EFFECT, "IXMuzzle" )
end