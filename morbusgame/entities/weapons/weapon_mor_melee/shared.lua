AddCSLuaFile("shared.lua")
SWEP.PrintName = "Crowbar"

if (CLIENT) then
    SWEP.PrintName      = "Crowbar"
    SWEP.ViewModelFOV       = 70
    SWEP.ViewModelFlip      = false
    SWEP.Slot           = 1
    SWEP.SlotPos        = 1
    SWEP.IconLetter         = "y"

end
SWEP.Base               = "weapon_mor_base"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawWeaponInfoBox=false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.SwingSound = "Weapon_Crowbar.Single"
SWEP.HitSound = "Weapon_Crowbar.Melee_Hit"

SWEP.HoldType="melee"

SWEP.AllowDrop = false
SWEP.Kind = WEAPON_MELEE

SWEP.Delay=0.7
SWEP.Range=75
SWEP.Damage=20
SWEP.AutoSpawnable = false

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    return true
end


function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)

	local pos = self.Owner:GetShootPos()
	local range = pos + (self.Owner:GetAimVector()*self.Range)
	local vec = Vector(1,1,0.5)
	
	self.Owner:LagCompensation(true)  
	local trace = util.TraceHull({
		start = pos,  
		endpos = range,
		filter = self.Owner,
		mins = vec * -13,
		maxs = vec * 13,
		mask = CONTENTS_MONSTER + CONTENTS_HITBOX		
	})

	local trace2 = util.TraceHull({
		start = pos,
		endpos = range,
		filter = self.Owner,
		mins = vec * -11,
		maxs = vec * 11	
	})  
	self.Owner:LagCompensation(false)
	
	local ent = trace.Entity

	if trace2.Fraction*1.3 < trace.Fraction then
		if SERVER then self.Owner:EmitSound(self.SwingSound,300,100) end
		
		trace = util.TraceLine({
			start = pos,
			endpos = range,
			filter = self.Owner		
		})
		
		ent = trace.Entity

		if trace.Fraction < 1 && trace.HitNonWorld && ent && !ent:IsPlayer() then
			if SERVER then
				local dmg = self.Damage * 2
				ent:TakeDamage( dmg, self.Owner, self.Weapon )
			end
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		else
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		end
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.HolsterTime = CurTime() + 1.5
		return 
	end

	if SERVER then self.Owner:EmitSound(self.SwingSound) end

	if trace.Fraction < 1 && trace.HitNonWorld && ent:IsPlayer()  then
		if SERVER then
			local a1,a2 = ent:GetAngles().y, self.Owner:GetAngles().y

			local dmg = self.Damage
			ent:TakeDamage( dmg, self.Owner, self.Weapon )

			self.Owner:EmitSound(self.HitSound,300,100)
		end
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	  
	self.HolsterTime = CurTime() + 1
end

function SWEP:Reload()
    return false
end

function SWEP:Think()
    return false
end

function SWEP:SecondaryAttack()
    return false
end