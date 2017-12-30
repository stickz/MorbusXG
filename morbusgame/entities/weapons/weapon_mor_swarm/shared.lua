SWEP.PrintName = "Alien"

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.PrintName      = "Swarm Alien"

if (CLIENT) then
	SWEP.PrintName 		= "Alien"
    SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= false
    SWEP.DrawCrosshair  = true 
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "y"

end
SWEP.Base 				= "weapon_mor_melee"
SWEP.Slot = 0
SWEP.SlotPos = 1
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
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

sound.Add({
    name =          "swarm.swing",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "npc/vort/claw_swing2.wav"
})

sound.Add({
    name =          "swarm.hit",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "pinky/hit_01.wav"
})

sound.Add({
    name =          "swarm.spit",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "alien/acid_spit.wav"
})

SWEP.SwingSound = Sound("swarm.swing")
SWEP.HitSound = Sound("swarm.hit")
SWEP.SpitSound = Sound("swarm.spit")

SWEP.Delay      = 0.65
SWEP.Range      = 75
SWEP.Damage     = 8
SWEP.Kind = WEAPON_ROLE
SWEP.AutoSpawnable  = false
SWEP.Destructing    = 0
SWEP.Beep       = CurTime() + 1
SWEP.refire     = 3
SWEP.Remotes    = 0
SWEP.attackType = "spit"

SWEP.FlameEffect    = "swep_flamethrower_flame2"
SWEP.FlameExpl      = "swep_flamethrower_explosion"

SWEP.spitBall = "sent_spitball"

SWEP.HoldType = "melee"

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	
    if self.Weapon:GetNextSecondaryFire() < CurTime() + 1 then	
        self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
    end
    
    local vec = Vector(1,1,1)
	local shotPos = self.Owner:GetShootPos()
	local aimVec = (self.Owner:GetAimVector()*self.Range)
	local shotEnd = shotPos + aimVec
	
	-- Start lag compensate for traces.
    self.Owner:LagCompensation(true)
	
	local trace = util.TraceHull( {
		start = shotPos,
		endpos = shotEnd,
		filter = self.Owner,
		mins = vec * -14,
		maxs = vec * 14,
		mask = CONTENTS_MONSTER + CONTENTS_HITBOX + CONTENTS_DEBRIS
    } )

    local trace2 = util.TraceHull( {
		start = shotPos,
		endpos = shotEnd,
		filter = self.Owner,
		mins = vec * -12,
		maxs = vec * 12
	} )

    -- End lag compensate after traces.
    self.Owner:LagCompensation(false)

    if trace2.Fraction*1.3 < trace.Fraction then
        if SERVER then self.Owner:EmitSound(self.SwingSound,200,100) end
        trace = util.TraceLine( {
			start = shotPos,
			endpos = shotEnd,
			filter = self.Owner
		} )

        if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity && !trace.Entity:IsPlayer() then
            if SERVER then
                trace.Entity:TakeDamage( self.Damage * 2, self.Owner, self.Weapon )
                self.Owner:EmitSound(self.HitSound,200,100)
            end
        end
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        return 
    end


    if SERVER then self.Owner:EmitSound(self.SwingSound) end

	if trace.Fraction < 1 && trace.HitNonWorld then
		local isPlayer = trace.Entity:IsPlayer()
		
		if isPlayer && SERVER then
			trace.Entity:TakeDamage( self.Damage, self.Owner, self.Weapon )
			self.Owner:EmitSound(self.HitSound,200,100)
			
		elseif trace.Entity && !isPlayer && trace.Entity:GetClass() == "prop_ragdoll" then
			self.Owner:EmitSound(self.HitSound,200,100)
		end	
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:Reload()
    self:RemoteDet()
end

function SWEP:RemoteDet()
    self.Remotes = 0
    for k, v in pairs ( ents.FindByClass( "sent_spitball_remote" ) ) do  
        if v:GetNWEntity( "Owner" ) == self.Owner then
            v.Exploded = 1
        end
    end 
end

SetSecondaryAttack = {
	[0] = 	function (self)
				self.spitBall = "sent_spitball"
				self.attackType = "spit"
				self.refire = 3		
				return
			end,
			
	[1] =	function (self)
				self.spitBall = "sent_spitball_fire"
				self.attackType = "spit"
				self.refire = 3		
				return
			end,
			
	[2] =	function (self)
				self.spitBall = "sent_spitball_ice"
				self.attackType = "spit"
				self.refire = 3	
				return
			end,
			
	[3] =	function (self)
				self.spitBall = "sent_spitball_storm"
				self.attackType = "spit"
				self.refire = 3
				return
			end,
			
	[4] = 	function (self)
				self.spitBall = "sent_spitball_demon"
				self.attackType = "spit"
				self.refire = 3
				return
			end,
	
	[5] = 	function (self)
				self.spitBall = "sent_spitball"
				self.attackType = "spit"
				self.refire = 3
				return
			end,

	[6] = 	function (self)
				self.spitBall = "sent_spitball_blood"
				self.attackType = "spit"
				self.refire = 3
				return
			end,

	[7] = 	function (self)
				self.spitBall = "sent_spitball_timed"
				self.attackType = "spit"
				self.refire = 3
				return
			end,
			
	[8] = 	function (self)
				self.spitBall = "sent_spitball_remote"
				self.attackType = "spit"
				self.refire = 1.5
				return
			end,

	[9] = 	function (self)
				self.spitBall = "spikes"
				self.attackType = "bullet"
				self.refire = 3
				return
			end,

	[10] = 	function (self)
				self.spitBall = "leap"
				self.attackType = "special"
				self.refire = 3
				return
			end,

	[11] = 	function (self)
				self.spitBall = "destruct"
				self.attackType = "special"
				self.refire = 10
				return
			end,

	[12] = 	function (self)
				self.spitBall = "sent_spitball_acid"
				self.attackType = "spit"
				self.refire = 3
				return
			end,
			
	[13] = 	function (self)
				self.spitBall = "sent_spitball_magma"
				self.attackType = "spit"
				self.refire = 3
				return
			end
}


function SWEP:SecondaryAttack()

    local sType = self.Owner:GetSwarmMod()
	SetSecondaryAttack[sType](self)
    
    self.Weapon:SetNextSecondaryFire( CurTime() + ( self.refire ))

    if self.attackType == "spit" then
    	local tr = self.Owner:GetEyeTrace()
    	    local ent      = ents.Create( self.spitBall )
    		local aim     = self.Owner:GetAimVector()
    		local side    = aim:Cross( Vector( 0, 0, 1 ) )
    		local up      = side:Cross( aim )

    	if SERVER then
         	ent:SetPos( self.Owner:GetShootPos() +  aim * 24 + side * 8 + up * -15 )
        	ent:SetOwner( self.Owner )
        	ent:SetAngles( self.Owner:EyeAngles() )
        	ent.SpitOwner = self.Owner

            -- Remote Det
            if sType == 8 then
                ent:SetNWEntity("Owner", self.Owner)
                if self.Remotes == 4 then
                    self:RemoteDet()
                end
                self.Remotes = self.Remotes + 1
            end

        	ent:Spawn()
            self.Owner:EmitSound( self.SpitSound, 200, 100 )
         
        	local phys = ent:GetPhysicsObject()
        	phys:ApplyForceCenter( aim + self.Owner:GetForward( Vector( math.random( -255, 255 ), math.random( -255, 255 ), 0) ) * 2100 )
        	phys:SetVelocity( phys:GetVelocity() + self.Owner:GetVelocity() )
        	phys:EnableGravity( true )
    	end
    	
    	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    	self.Owner:SetAnimation( PLAYER_ATTACK1 )

    -- Spikes
    elseif self.attackType == "bullet" then

        self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        self:ShootBullet()

    -- Special Abilities
    elseif self.attackType == "special" then

        -- Swarm Leap
        if self.spitBall == "leap" then
            self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
            self.Owner:SetAnimation( PLAYER_ATTACK1 )
            self.Owner:SetVelocity( self.Owner:GetForward() * 300 + Vector( 0, 0, 400 ) )
            if SERVER then
                self.Owner:EmitSound( self.SpitSound, 100, 100 )
            end

        -- Self Destruct
        elseif self.spitBall == "destruct" then
            if SERVER then
                self.Weapon:SetNextSecondaryFire(CurTime() + 10)
                self.Owner:EmitSound( self.SpitSound, 200, 100 )
                self.Destructing = 1
                
				local vec = Vector( 0, 0, 50 )
				local ang = Angle(0, 0, 0)
				
				timer.Simple( 0.8, function()
                    ParticleEffect( "spit_blast", self:GetPos() + vec, ang, nil )
                    self.Owner:EmitSound( self.SpitSound, 200, 100 )
                end)
                timer.Simple( 1.6, function()
                    ParticleEffect( "spit_blast", self:GetPos() + vec, ang, nil )
                    self.Owner:EmitSound( self.SpitSound, 200, 100 )
                end)

                timer.Simple( 2.4, function()
                    if IsValid(self.Owner) && self.Owner:Alive() then
                        -- SFX
                        ParticleEffect( "destruct_blast", self:GetPos() + vec, ang, nil )
                        self.Owner:EmitSound( "weapons/demon/explosion.wav", 100, math.random(95,125) );

                        -- Damage in sphere
                        for _, v in ipairs(ents.FindInSphere( self:GetPos(), 250 )) do
                            local dmginfo = DamageInfo()
                            dmginfo:SetAttacker( self.Owner )
                            dmginfo:SetInflictor( self.Weapon )
                            dmginfo:SetDamage( 40 )
                            v:TakeDamageInfo( dmginfo )
                        end

                        self.Owner:Kill()
                    end
                end)
            end
        end
    end
    -- End of Self Destruct

	if ( self.Owner:IsNPC() ) then return end
end

-- Spikes
function SWEP:ShootBullet( damage, num_bullets, aimcone )

        local bullet = {}
            bullet.Num          = 8
            bullet.Src          = self.Owner:GetShootPos()
            bullet.Dir          = self.Owner:GetAimVector()
            bullet.Spread       = Vector( 0.02, 0.02, 0 )
            bullet.Tracer       = 8
            bullet.TracerName   = "Tracer"
            bullet.Force        = 355
            bullet.Damage       = 2

            self.Owner:FireBullets(bullet)
            self.Owner:EmitSound( "alien/acid_spit.wav", 100, 120 )
            self:ShootEffects()

end

function SWEP:DoImpactEffect( tr, dmgtype )

    if( tr.HitSky ) then return true; end
    
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

        local effect = EffectData();
        effect:SetOrigin( tr.HitPos );
        effect:SetNormal( tr.HitNormal );
        ParticleEffect( "l_energy_imp_o", tr.HitPos, Angle(0, 0, 0), nil )
        util.Effect( "GaussImpact", effect );

    end

    return true;

end