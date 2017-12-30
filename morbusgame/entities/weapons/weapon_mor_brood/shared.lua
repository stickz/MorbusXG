SWEP.PrintName = "Alien Form"

if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName      = "Alien Form"
if (CLIENT) then
	SWEP.PrintName 		= "Alien Form"
	SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= false
	SWEP.Slot 			= WEAPON_ROLE - 1
    SWEP.DrawCrosshair  = true 
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "y"

end
SWEP.Weight             = 5
SWEP.Base 				= "weapon_mor_melee"
SWEP.DrawWeaponInfoBox=false

SWEP.ViewModel = "models/Zed/weapons/v_Banshee.mdl"
SWEP.WorldModel = "models/weapons/w_fists.mdl"

SWEP.AllowDrop = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

sound.Add({
    name =          "brood.swing",
    channel =       CHAN_ITEM,
    volume =        0.9,
    sound =             "npc/fast_zombie/claw_miss2.wav"
})

sound.Add({
    name =          "brood.hit",
    channel =       CHAN_ITEM,
    volume =        0.9,
    sound =             "hellknight/hit1.wav"
})

SWEP.SwingSound = Sound("brood.swing")
SWEP.HitSound = Sound("brood.hit")


SWEP.HoldType= "melee"

SWEP.Delay=0.55
SWEP.Range=92
SWEP.Damage=13
SWEP.Kind = WEAPON_ROLE
SWEP.AutoSpawnable = false

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    self:SetWeaponHoldType("melee")
    self.HolsterTime = CurTime() + 1.5
	
    if SERVER then
        if self.Owner.Upgrades[UPGRADE.ATKSPEED] then
            self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay-(((self.Owner.Upgrades[UPGRADE.ATKSPEED]*UPGRADE.ATKSPEED_AMOUNT)/100)*self.Delay))
        else
            self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)
        end
    else
        if Morbus.Upgrades[UPGRADE.ATKSPEED] then
            self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay-(((Morbus.Upgrades[UPGRADE.ATKSPEED]*UPGRADE.ATKSPEED_AMOUNT)/100)*self.Delay))
        else
            self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)
        end
    end
	
	local pos = self.Owner:GetShootPos()
	local range = pos + (self.Owner:GetAimVector()*self.Range)
	local vec = Vector(1,1,0.5)
	
    self.Owner:LagCompensation(true)
    local trace = util.TraceHull({
		start = pos,
		endpos = range,
		filter = self.Owner,
		mins = vec * -15,
		maxs = vec * 15,
		mask = CONTENTS_MONSTER + CONTENTS_HITBOX
    })
	
	
    local trace2 = util.TraceHull({
		start = pos,
		endpos = range,
		filter = self.Owner,
		mins = vec * -14,
		maxs = vec * 14
    })
	self.Owner:LagCompensation(false)
	
	local ent = trace.Entity

    if trace2.Fraction*1.3 < trace.Fraction then
        if SERVER then self.Owner:EmitSound(self.SwingSound,400,100) end
        trace = util.TraceLine({
			start = pos,
			endpos = range,
			filter = self.Owner		
		})
		
		ent = trace.Entity
		
        if trace.Fraction < 1 && trace.HitNonWorld && ent && !ent:IsPlayer() then
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            if SERVER then 
                local dmg = self.Damage+(UPGRADE.CLAW_AMOUNT*(self.Owner.Upgrades[UPGRADE.CLAWS] or 0))
                ent:TakeDamage( dmg*5, self.Owner, self.Weapon )            
            end
        else
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        end
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        self.HolsterTime = CurTime() + 1.5
        return 
    end

    if SERVER then self.Owner:EmitSound(self.SwingSound) end    

    if trace.Fraction < 1 && trace.HitNonWorld && ent:IsPlayer()  then
        if SERVER then
            local a1,a2 = ent:GetAngles().y, self.Owner:GetAngles().y
            local diff = a1-a2

            local dmg = self.Damage

            if (diff <= 60 && diff >= -60) then
                dmg = dmg*1.8 +(UPGRADE.CLAW_AMOUNT*(self.Owner.Upgrades[UPGRADE.CLAWS] or 0))
                ent:TakeDamage( dmg , self.Owner, self.Weapon )
            else
                dmg = dmg +(UPGRADE.CLAW_AMOUNT*(self.Owner.Upgrades[UPGRADE.CLAWS] or 0))
                ent:TakeDamage( dmg, self.Owner, self.Weapon )
            end

            self.Owner:EmitSound(self.HitSound,500,100)
        end
    end
	
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.HolsterTime = CurTime() + 1
end

function SWEP:Deploy()
    if !self.Owner.CanTransform then return false end
    
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    return true
end