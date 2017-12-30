-- English is not my first language, so sorry if I did some errors in my little "tutorial"

if GetConVar("M9KGasEffect") == nil then
	CreateConVar("M9KGasEffect", "1", { FCVAR_ARCHIVE }, "Use gas effect when shooting? 1 for true, 0 for false")
end


/*---------------------------------------------------------*/
local HitImpact = function(attacker, tr, dmginfo)

	local hit = EffectData()
	hit:SetOrigin(tr.HitPos)
	hit:SetNormal(tr.HitNormal)
	hit:SetScale(20)
	util.Effect("effect_hit", hit)

	return true
end
/*---------------------------------------------------------*/


if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight 		= 5
end

if (CLIENT) then
	SWEP.DrawAmmo		= false		-- Should we draw the number of ammos and clips?
	SWEP.DrawCrosshair	= false		-- Should we draw the half life 2 crosshair?
	SWEP.ViewModelFOV       = 70			-- "Y" position of the sweps
	SWEP.ViewModelFlip	= true		-- Should we flip the sweps?
	SWEP.CSMuzzleFlashes	= false		-- Should we add a CS Muzzle Flash?
end

SWEP.HoldType		= "ar2"		-- Hold type style ("ar2" "pistol" "shotgun" "rpg" "normal" "melee" "grenade" "smg")

SWEP.MuzzleAttachment			= "1" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 		-- Should be "2" for CSS models or "1" for hl2 models


SWEP.Category			= "Morbus Weapons"		-- Swep Categorie (You can type what your want)

SWEP.DrawWeaponInfoBox  	= true					-- Should we draw a weapon info when you're selecting your swep?
SWEP.PrintName 		= "A Large Dildo"
SWEP.Author 			= "Remscar"				-- Author Name
SWEP.Contact 			= ""						-- Author E-Mail
SWEP.Purpose 			= ""						-- Author's Informations
SWEP.Instructions 		= ""						-- Instructions of the sweps

SWEP.Spawnable 			= false					-- Everybody can spawn this swep
SWEP.AdminSpawnable 		= false					-- Admin can spawn this swep

SWEP.Weight 			= 5						-- Weight of the swep
SWEP.AutoSwitchTo 		= false
SWEP.AutoSwitchFrom 		= false

SWEP.Primary.Round 			= ("")					-- What kind of bullet?
SWEP.Primary.NumShots	= 1
SWEP.Primary.ClipSize			= 0					-- Size of a clip
SWEP.Primary.DefaultClip			= 0					-- Default number of bullets in a clip
SWEP.Primary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.NeverRandom = false

SWEP.Secondary.ClipSize			= 0					-- Size of a clip
SWEP.Secondary.DefaultClip			= 0					-- Default number of bullets in a clip
SWEP.Secondary.Automatic			= false					-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"

SWEP.Kind = WEAPON_RIFLE
SWEP.KGWeight = 0
SWEP.AllowDrop = true
SWEP.StoredAmmo = 0
SWEP.IsDropped = false
SWEP.CanBeSilenced= false
SWEP.AutoSpawnable = false

SWEP.VElements = {}
SWEP.WElements = {}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

/*---------------------------------------------------------
Throw Second for custom content
---------------------------------------------------------*/
function SWEP:ThrowSound()	
	local gender = self.Owner:GetGender()
	
	if gender == 2 then
		self:EmitSound( "vo/npc/male01/watchout.wav", 100, math.random( 95, 105 ) )
	elseif gender == 1 then
		self:EmitSound( "vo/npc/female01/uhoh.wav", 100, math.random( 95, 105 ) )
	elseif gender == 3 then
		self:EmitSound( "npc/combine_soldier/gear3.wav", 100, math.random( 75, 95 ) )
	end
end

/*---------------------------------------------------------
Attack functions
---------------------------------------------------------*/
SWEP.PrimaryAttackVector 		= Vector(math.random(-50,50),math.random(-50,50),math.random(-50,50))
SWEP.SecondaryAttackVector 		= Vector(0,0,0)

SWEP.DropOnSpot				= 30
SWEP.PropelForwardSpeed		= 1000

SWEP.GrenadeEnt = ""
SWEP.GrenadeWep = ""

function SWEP:PrimaryAttack()
	self:PrepareAttack()
	self:DuringAttack(self.GrenadeEnt, self.PrimaryAttackVector, self.PropelForwardSpeed )
	self:AfterAttack(self.GrenadeWep)
end

function SWEP:SecondaryAttack()
	self:PrepareAttack()	
	self:DuringAttack(self.GrenadeEnt, self.SecondaryAttackVector, self.DropOnSpot )
	self:AfterAttack(self.GrenadeWep)
end

function SWEP:PrepareAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
	self.Weapon:SendWeaponAnim( ACT_VM_THROW ) 		// View model animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
end

function SWEP:DuringAttack(name, vec, speed)
	if SERVER then
		local ent = ents.Create(name)
		
		ent.GrenadeOwner = self.Owner
		ent:SetPos(self.Owner:GetShootPos())
		ent:SetAngles(Angle(1,0,0))
		ent:Spawn()
				
		local phys = ent:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * speed)
		phys:AddAngleVelocity(vec)		

		local entOwner = self.Owner
			
		timer.Simple(3, 
			function() 
				if !ent then return end	
				if !IsValid(ent) then return end
				if !SERVER then return end
				
				if entOwner:IsSwarm() then					
					ent:Remove()
				else
					ent:Explode()
				end
			end)
	end
	
	self:ThrowSound()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:AfterAttack(wepName)
	if self.Weapon:Clip1() < 1 && SERVER then
		self.Owner:StripWeapon(wepName)
	end
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	
	if CLIENT then	
		-- // Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels
		
		-- // init view model bone build function
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
			if self.Owner:Alive() then
				local vm = self.Owner:GetViewModel()
				if IsValid(vm) then
					self:ResetBonePositions(vm)
					-- // Init viewmodel visibility
					if (self.ShowViewModel == nil or self.ShowViewModel) then
						vm:SetColor(Color(255,255,255,255))
					else
						-- // however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
						vm:SetMaterial("Debug/hsv")			
					end
				end				
			end
		end		
	end	
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
	return false
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/

function SWEP:GetCapabilities()
	return CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1
end

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	return true
end

function SWEP:Holster()
	if CLIENT and IsValid(self.Owner) and not self.Owner:IsNPC() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	return true
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) and not self.Owner:IsNPC() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
end

---------------------------------------------------------
/*---------------------------------------------------------
GetViewModelPosition
---------------------------------------------------------*/
function SWEP:GetViewModelPosition(pos, ang)
	return pos, ang
end

function SWEP:Ammo1()
   return ValidEntity(self.Owner) and self.Owner:GetAmmoCount(self.Primary.Ammo) or false
end


function SWEP:PreDrop()
   if SERVER and ValidEntity(self.Owner) and self.Primary.Ammo != "none" then
      local ammo = self:Ammo1()

      -- Do not drop ammo if we have another gun that uses this type
      for _, w in pairs(self.Owner:GetWeapons()) do
         if ValidEntity(w) and w != self and w:GetPrimaryAmmoType() == self:GetPrimaryAmmoType() then
            ammo = 0
         end
      end
      
      self.StoredAmmo = ammo

      if ammo > 0 then
         self.Owner:RemoveAmmo(ammo, self.Primary.Ammo)
      end
   end
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

   if SERVER and ValidEntity(newowner) and self.StoredAmmo > 0 and self.Primary.Ammo != "none" then
      local ammo = newowner:GetAmmoCount(self.Primary.Ammo)
      local given = math.min(self.StoredAmmo, (self.Primary.ClipSize*3) - ammo)

      newowner:GiveAmmo( given, self.Primary.Ammo)
      self.StoredAmmo = 0
   end
end

function SWEP:IsEquipment()
   return WEPS.IsEquipment(self)
end



if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			-- // we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				-- //model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()

		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end

		local tgt = LocalPlayer():GetObserverTarget()
		if (self.Owner == tgt) && (LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE) then return end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			-- // when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				-- //model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			-- // Technically, if there exists an element with the same name as a bone
			-- // you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r --// Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		-- // Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				-- // make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			-- // !! WORKAROUND !! --//
			-- // We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			//!! ----------- !! --
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				-- // !! WORKAROUND !! --//
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				//!! ----------- !! --
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	-- // Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	-- // Does not copy entities of course, only copies their reference.
	-- // WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) --// recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end