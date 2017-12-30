local GlowMaterial = CreateMaterial( "mb/glow", "UnlitGeneric", {
	[ "$basetexture" ]      = "sprites/light_glow01",
	[ "$additive" ]         = "1",
	[ "$vertexcolor" ]      = "1",
	[ "$vertexalpha" ]      = "1",
} )    

function EFFECT:Init( data )
	self.Weapon = data:GetEntity()
        
	self.Entity:SetRenderBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	self.Entity:SetParent( self.Weapon )
        
	self.LifeTime = math.Rand( 0.25, 0.35 )
	self.DieTime = CurTime() + self.LifeTime
	self.Size = math.Rand( 5, 15 )
        
	local pos, ang = GetMuzzlePosition( self.Weapon, data:GetAttachment() )
        
	local light = DynamicLight( self.Weapon:EntIndex() )
	light.Pos               = pos
	light.Size              = 200
	light.Decay             = 400
	light.R                 = 255
	light.G                 = 255
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
		render.DrawSprite( pos, self.Size, self.Size, Color( 155, 155, 155, alpha ) )
		render.StartBeam( 2 )
		render.AddBeam( pos - ang:Forward() * 12, 16, 0, Color( 155, 155, 155, alpha ) )
		render.AddBeam( pos + ang:Forward() * 12, 16, 1, Color( 155, 155, 155, 0 ) )
		render.EndBeam()
	end
end

function GetMuzzlePosition( weapon, attachment )
    if( !IsValid( weapon ) ) then
        return vector_origin, Angle( 0, 0, 0 );
    end

    local origin = weapon:GetPos();
    local angle = weapon:GetAngles();
    
    // if we're not in a camera and we're being carried by the local player
    // use their view model instead.
    if( weapon:IsWeapon() && weapon:IsCarriedByLocalPlayer() ) then
    
        local owner = weapon:GetOwner();
        if( IsValid( owner ) && GetViewEntity() == owner ) then
        
            local viewmodel = owner:GetViewModel();
            if( IsValid( viewmodel ) ) then
                weapon = viewmodel;
            end
            
        end
    
    end

    // get the attachment
    local attachment = weapon:GetAttachment( attachment or 1 );
    if( !attachment ) then
        return origin, angle;
    end
    
    return attachment.Pos, attachment.Ang;
end