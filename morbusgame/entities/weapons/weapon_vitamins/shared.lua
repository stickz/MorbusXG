if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if ( CLIENT ) then
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Vitamins"
	SWEP.Slot				= WEAPON_MISC - 1
	SWEP.SlotPos			= 0
end

SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.HoldType			= "pistol"

SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false


SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay		= 3

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AllowDrop = true
SWEP.Kind = WEAPON_VITA
SWEP.KGWeight = 8
SWEP.AutoSpawnable = true
SWEP.StoredAmmo = 0

SWEP.TotalVitamins = 5


SWEP.ViewModelBoneMods = {
   ["ValveBiped.Grenade_body"] = { 
      scale = Vector(0.702, 0.702, 0.702), 
	  pos = Vector(0, 0, 0), 
	  angle = Angle(0, 0, 0) 
   }
}

SWEP.VElements = {
   ["a"] = { 
      type = "Model", 
	  model = "models/props_lab/jar01b.mdl", 
	  bone = "ValveBiped.Grenade_body", 
	  rel = "", 
	  pos = Vector(0, 0, 0), 
	  angle = Angle(0, 111.039, 180), 
	  size = Vector(0.74, 0.74, 0.74), 
	  color = Color(255, 255, 255, 255), 
	  surpresslightning = false, 
	  material = "", 
	  skin = 0, 
	  bodygroup = {} 
   }
}

SWEP.WElements = {
   ["a"] = { 
      type = "Model", 
	  model = "models/props_lab/jar01b.mdl", 
	  bone = "ValveBiped.Bip01_R_Hand", 
	  rel = "", 
	  pos = Vector(5, 2, 0), 
	  angle = Angle(180, 0, 0), 
	  size = Vector(0.755, 0.755, 0.755), 
	  color = Color(255, 255, 255, 255), 
	  surpresslightning = false, 
	  material = "", 
	  skin = 0, 
	  bodygroup = {} 
   }
}

SWEP.NextPing = 0
function SWEP:Reload()
	if self.NextPing < CurTime() then
		if SERVER then
			if self.TotalVitamins > 0 then
				self.Owner:PrintMessage(HUD_PRINTTALK,self.TotalVitamins .. " vitamin(s) remain.")
			end
		end
		self.NextPing = CurTime() + 1
	end
end

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	if IsValid(self.Owner) && self.Owner:Alive() then
		self.Owner:PrintMessage(HUD_PRINTTALK, self.TotalVitamins .. " vitamin(s) remain.")
	end
	return true
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		if GetRoundState() != ROUND_ACTIVE then self.Owner:PrintMessage(HUD_PRINTTALK,"Wait to use these until the round starts!") return end
		--if self.Owner:IsCyborg() then self.Owner:PrintMessage( HUD_PRINTTALK, "Cyborgs don't need vitamins!" ) return end
	end
		if self.Owner:IsAlien() then
			if SERVER then
				self.TotalVitamins = self.TotalVitamins - 1
				self.Owner:PrintMessage(HUD_PRINTTALK,"You injest and destroy the vitamin.")
			end
			self:EatSound()
			if self.TotalVitamins <= 0 then
				if SERVER then
					self.Owner:StripWeapon("weapon_vitamins") 
					--self.Owner:SelectWeapon("weapon_mor_crowbar")
					self.Owner:PrintMessage(HUD_PRINTTALK,"Vitamins destroyed.")
				end
			end
			return
		end
		if SERVER then
			if (self.Owner.Mission == MISSION_NONE) then self.Owner:PrintMessage(HUD_PRINTTALK,"You don't need these yet!") self.Owner:PrintMessage(HUD_PRINTTALK,"There are " .. self.TotalVitamins .. " left.") return end
			local amount = math.Round( math.random(9,15) )
			-- Add onto the need timer.
			if self.Owner.Mission_End < 1 then
				self.Owner.Mission_End = 0
			end
			self.Owner.Mission_End = self.Owner.Mission_End + amount

			Send_MissionInfo(self.Owner) -- send player new need time

			self.Owner:PrintMessage(HUD_PRINTTALK,"Your need has been delayed " .. amount .. " seconds.")
			self.TotalVitamins = self.TotalVitamins - 1
		end
		self:EatSound()
		--VitaminFunc(self.Owner)

	if SERVER then
		if self.TotalVitamins <= 0 then
			self.Owner:StripWeapon("weapon_vitamins") 
			--self.Owner:SelectWeapon("weapon_mor_crowbar")
		end
	end
end

function SWEP:EatSound()
	--if self.Owner:IsCyborg() then return end
	if GetRoundState() != ROUND_ACTIVE then return end
	self:EmitSound("morbus/eating.wav")
end

function SWEP:DampenDrop()
   local phys = self:GetPhysicsObject()
   if IsValid(phys) then
      phys:SetVelocityInstantaneous(Vector(0,0,-75) + phys:GetVelocity() * 0.001)
      phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
   end
end


function SWEP:Equip(newowner)
   if SERVER then
      if self:IsOnFire() then
         self:Extinguish()
      end
   end
end

function SWEP:IsEquipment()
   return WEPS.IsEquipment(self)
end