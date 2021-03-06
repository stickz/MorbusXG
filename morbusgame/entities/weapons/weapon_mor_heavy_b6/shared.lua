if (SERVER) then
	AddCSLuaFile("shared.lua")	
end

SWEP.PrintName 		= "YN-8800 Zeus"
if (CLIENT) then
	SWEP.PrintName 		= "YN-8800 Zeus"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true
end

SWEP.HoldType 		= "crossbow"
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

SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 60
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 3
SWEP.Primary.RPM			= 15
SWEP.Primary.DefaultClip	= 9
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Primary.KickUp         = 0.4
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 0.4

SWEP.IronSightsPos = Vector(3.6, 0, 0)
SWEP.IronSightsAng = Vector(-1.922, 0.481, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_none_mor"
SWEP.KGWeight = 30

SWEP.NeverRandom 	= false
SWEP.AutoSpawnable 	= true

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "2", enabled = true}

SWEP.CustomModel 		=	"models/mass_effect_3/weapons/heavy_weapons/m-622 avalanche.mdl"
SWEP.CustomMaterial		=	"models/mass_effect_3/weapons/heavy_weapons/m-622 avalanche/wpn_hvyc_diff"

SWEP.ViewModelBoneMods = {
    ["bone_body"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["a"] = { 
	type = "Model", 
	model = SWEP.CustomModel, 
	bone = "bone_body",
	rel = "", 
	pos = Vector(1.557, -2.597, -1.558),
	angle = Angle(0, 180, 0), 
	size = Vector(0.8, 0.8, 0.8), 
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
	pos = Vector(4.675, 1.2, -2.597), 
	angle = Angle(180, 90, 3.506), 
	size = Vector(1, 1, 1), 
	color = Color(255, 255, 255, 255), 
	surpresslightning = false,
	material = SWEP.CustomMaterial, 
	skin = 0,
	bodygroup = {} 
	}
}


SWEP.Explosive = true

function SWEP:ShootBullet()
	local tr = self.Owner:GetEyeTrace()
	   local ent = ents.Create( "mor_bfg_electro" )

	local aim = self.Owner:GetAimVector()
	local side = aim:Cross(Vector(0,0,1))
	local up = side:Cross(aim)
	if SERVER then
 	ent:SetPos(self.Owner:GetShootPos() +  aim * 24 + side * 8 + up * -5)
	ent:SetOwner( self.Owner )
	ent:SetAngles(self.Owner:EyeAngles())
	ent.RocketOwner = self.Owner
	ent:Spawn()

	self.Owner:EmitSound("npc/combine_gunship/attack_start2.wav",100,75)

	local phys = ent:GetPhysicsObject()
	phys:ApplyForceCenter( self.Owner:GetAimVector() + 	self.Owner:GetForward() * 1000)
	phys:SetVelocity( phys:GetVelocity() + self.Owner:GetVelocity() + Vector( math.random(-25,25),math.random(-25,25),math.random(-25,25)) )
	phys:EnableGravity(false)

	end
	self.Owner:RemoveAmmo( 0, self.Primary.Ammo )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "ZeusMuzzle", effect )
		
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
        light.Size              = 64
        light.Decay             = 400
        light.R                 = 55
        light.G                 = 155
        light.B                 = 255
        light.Brightness        = 2
        light.DieTime           = CurTime() + 2
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
            render.DrawSprite( pos, self.Size, self.Size, Color( 55, 155, 255, alpha ) )
            render.StartBeam( 2 )
                render.AddBeam( pos - ang:Forward() * 12, 16, 0, Color( 55, 155, 255, alpha ) )
                render.AddBeam( pos + ang:Forward() * 12, 16, 1, Color( 55, 155, 255, 0 ) )
            render.EndBeam()
        end
    end
    
    effects.Register( EFFECT, "ZeusMuzzle" )
end