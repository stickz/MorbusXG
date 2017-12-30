if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName 		= "TAR-91 Railgun"
if (CLIENT) then
	SWEP.PrintName 		= "TAR-91 Railgun"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true
end

SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05
SWEP.MuzzleAttachment		= "1"


SWEP.Instructions 		= "Weapon"

SWEP.Base 				= "mor_base_weapon"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel = "models/weapons/v_plasmagun.mdl"
SWEP.WorldModel = "models/weapons/w_plasmagun.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.Primary.Sound 		= Sound("weapons/railgun/teslar_shot1.wav")

SWEP.Primary.Recoil 		= 2
SWEP.Primary.Damage 		= 90
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.001
SWEP.Primary.ClipSize 		= 8
SWEP.Primary.RPM 		       = 12
SWEP.Primary.DefaultClip 	= 8
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "Battery"
SWEP.Primary.Delay = 2

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(3.6, 0, 0)
SWEP.IronSightsAng = Vector(-1.922, 0.481, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 6
SWEP.Primary.KickDown           = 1.5
SWEP.Primary.KickHorizontal         = 0.5

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "mor_ammo_battery"
SWEP.NeverRandom = true
SWEP.AutoSpawnable = true

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = false}

SWEP.KGWeight = 33

SWEP.CustomModel 		=	"models/mass_effect_3/weapons/sniper_rifles/m-98 widow.mdl"
SWEP.CustomMaterial		=	"models/mass_effect_3/weapons/sniper_rifles/m-98 widow/wpn_snpj_diff"

SWEP.ViewModelBoneMods = {
    ["bone_body"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
  ["a"] = { 
	type = "Model", 
	model = SWEP.CustomModel,
	bone = "bone_body", 
	rel = "", 
	pos = Vector(0.518, 2.596, 0.518), 
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
	pos = Vector(3.635, 0.518, -3.636), 
	angle = Angle(180, 90, 0), 
	size = Vector(1, 1, 1), 
	color = Color(255, 255, 255, 255), 
	surpresslightning = false,
	material = SWEP.CustomMaterial, 
	skin = 0, 
	bodygroup = {}
	}
}

SWEP.Sniper = true
SWEP.Secondary.Sound = Sound("Default.Zoom")

function SWEP:ShootBullet( damage, recoil, num_bullets, aimcone )

    if self.Primary.Delay < CurTime() then
        
        num_bullets         = num_bullets or 1
        aimcone             = aimcone or 0


        
        -- Perform Bullet Table
        local bullet = {}
            bullet.Num          = num_bullets
            bullet.Src          = self.Owner:GetShootPos() 
            bullet.Dir          = self.Owner:GetAimVector() 
            bullet.Spread       = Vector(aimcone, aimcone, 0)
            bullet.Tracer       = 1 
            bullet.TracerName   = "mor_tracer_laserr"
            bullet.Force        = damage * 0.5 
            bullet.Damage       = damage
            bullet.Callback = function( attacker, tracedata, dmginfo ) 
              if SERVER then
                  -- Damage in sphere
                  for _, v in ipairs( ents.FindInSphere( tracedata.HitPos, 105 ) ) do
                      if v != self.Owner then
                          local dmginfo = DamageInfo()
                          dmginfo:SetAttacker( self.Owner )
                          dmginfo:SetInflictor( self )
                          dmginfo:SetDamage( math.Round( damage * 0.5 ) )
                          v:TakeDamageInfo( dmginfo )
                      end
                  end

                  self.tes = ents.Create( "point_tesla" )
                  self.tes:SetPos( tracedata.HitPos )
                  self.tes:SetKeyValue( "m_SoundName", "" )
                  self.tes:SetKeyValue( "texture", "sprites/bluelight1.spr" )
                  self.tes:SetKeyValue( "m_Color", "255 75 55" )
                  self.tes:SetKeyValue( "m_flRadius", "155" )
                  self.tes:SetKeyValue( "beamcount_min", "2" )
                  self.tes:SetKeyValue( "beamcount_max", "3" )
                  self.tes:SetKeyValue( "thick_min", "16" )
                  self.tes:SetKeyValue( "thick_max", "32" )
                  self.tes:SetKeyValue( "lifetime_min", "0.3" )
                  self.tes:SetKeyValue( "lifetime_max", "0.5" )
                  self.tes:SetKeyValue( "interval_min", "0.1" )
                  self.tes:SetKeyValue( "interval_max", "0.3" )
                  self.tes:Spawn()
                  self.tes:Fire( "DoSpark", "", 0 )
                  self.tes:Fire( "DoSpark", "", 0.1 )
                  self.tes:Fire( "DoSpark", "", 0.2 )
                  self.tes:Fire( "DoSpark", "", 0.3 )
                  self.tes:Fire( "DoSpark", "", 0.4 )
                  self.tes:Fire( "DoSpark", "", 0.5 )
                  self.tes:Fire( "kill", "", 0.6 )


                  self.tes:EmitSound("ambient/energy/zap9.wav")

              end
            return self:RicochetCallback( 0, attacker, tracedata, dmginfo ) 
          end

        -- Perform Bullet
        self.Owner:FireBullets( bullet )
        if CLIENT and !self.Owner:IsNPC() then
            local anglo = Angle( math.Rand( -self.Primary.KickDown, self.Primary.KickUp ) * recoil, math.Rand( -self.Primary.KickHorizontal, self.Primary.KickHorizontal ) * recoil, 0 )
            self.Owner:ViewPunch( anglo )

            local eyeang    = self.Owner:EyeAngles()
            eyeang.pitch    = eyeang.pitch - anglo.pitch
            eyeang.yaw      = eyeang.yaw - anglo.yaw
            self.Owner:SetEyeAngles( eyeang )
        end

    end

    local effect = EffectData()
        effect:SetOrigin( self.Owner:GetShootPos() )
        effect:SetEntity( self.Weapon )
        effect:SetAttachment( 1 )
    util.Effect( "X11Muzzle", effect )

end

function SWEP:DoImpactEffect( tr, dmgtype )
    if self.Primary.Delay < CurTime() then

        local effect = EffectData()
        effect:SetOrigin( tr.HitPos )
        effect:SetNormal( tr.HitNormal )
        ParticleEffect( "h_energy_imp_r", tr.HitPos, Angle(0, 0, 0), nil )
        util.Effect( "mor_decal_pulser", effect )

        return true
    end
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
    if self.Primary.Delay < CurTime() then
        if self:CanPrimaryAttack() and self.Owner:IsPlayer() and self.Owner:WaterLevel() < 3 then
        if !self.Owner:KeyDown( IN_SPEED ) and !self.Owner:KeyDown( IN_RELOAD ) then
            self:ShootBulletInformation()
            self.Weapon:TakePrimaryAmmo( 1 )
            
            if self.Silenced then
                self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_SILENCED )
                self.Weapon:EmitSound( self.Primary.SilencedSound )
            else
                self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
                self.Weapon:EmitSound( self.Primary.Sound, 135, 100 )
            end 
        
            local fx = EffectData()
            fx:SetEntity( self.Weapon )
            fx:SetOrigin( self.Owner:GetShootPos() )
            fx:SetNormal( self.Owner:GetAimVector() )
            fx:SetAttachment( self.MuzzleAttachment )
            self.Owner:SetAnimation( PLAYER_ATTACK1 )
            self.Weapon:SetNextPrimaryFire( CurTime() + 1 / ( self.Primary.RPM / 60 ) )
            self.RicochetCoin = ( math.random( 1, 4 ) )
            self:BoltBack()
        end
        elseif self:CanPrimaryAttack() and self.Owner:IsNPC() then
            self:ShootBulletInformation()
            self.Weapon:TakePrimaryAmmo( 1 )
            
            if self.Silenced then
                self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_SILENCED )
                self.Weapon:EmitSound( self.Primary.SilencedSound )
            else
                self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
                self.Weapon:EmitSound( self.Primary.Sound, 135, 100 )
            end 
        
            local fx = EffectData()
            fx:SetEntity( self.Weapon )
            fx:SetOrigin( self.Owner:GetShootPos() )
            fx:SetNormal( self.Owner:GetAimVector() )
            fx:SetAttachment( self.MuzzleAttachment )
            self.Owner:SetAnimation( PLAYER_ATTACK1 )
            self.Weapon:SetNextPrimaryFire( CurTime() + 1 / ( self.Primary.RPM  /60 ) )
            self.RicochetCoin = ( math.random( 1, 4 ) )
        end
        self.Primary.Delay = CurTime() + 2
    end
end


function SWEP:SetZoom(state)
   if CLIENT then
      return
   elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
      if state then
         self.Owner:SetFOV(20, 0.3)
      else
         self.Owner:SetFOV(0, 0.2)
      end
   end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   if SERVER then
      self:SetZoom(bIronsights)
   else
      self:EmitSound(self.Secondary.Sound)
   end

   self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Think()
	if CLIENT then
		if self.Sniper == true then
			if self:GetIronsights() == true then
				self.Owner:DrawViewModel(false)
			else
				self.Owner:DrawViewModel(true)
			end
		end
	end
end

function SWEP:OnReload()
   self:SetIronsights( false )
   self:SetZoom( false )
end


function SWEP:OnHolster()
   self:SetIronsights(false)
   self:SetZoom(false)
end

if CLIENT then
   local scope = surface.GetTextureID("weapons/scopes/mor_snipe_4")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local scrW = ScrW()
         local scrH = ScrH()

         local x = scrW / 2.0
         local y = scrH / 2.0
         local scope_size = scrH

         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         
         -- cover gaps on top and bottom of screen
         surface.DrawLine( 0, 0, scrW, 0 )
         surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end
