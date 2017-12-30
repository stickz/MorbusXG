// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
/*--------------------------------------------
MORBUS CLIENT COMMUNICATION
--------------------------------------------*/

local tex = surface.GetTextureID("morbus/voiceicon")

function VoiceIndicators(ply)
  for k,v in pairs(player.GetAll()) do
    if v:IsSpeaking() and v != ply then
      local distance = v:GetPos():Distance(ply:GetPos())
      if distance < 750 || (ply:IsSpec() && distance < 2000) then
        local pos = v:GetPos() + Vector(0,0,70)
        local toscreen = BindToScreen(pos)
        local size = math.Clamp(25 + (750*15)/( distance + 31),24,90)
        //MsgN(size)
        surface.SetTexture(tex)
        surface.SetDrawColor(255,255,255,200)
        surface.DrawTexturedRect( toscreen.x - size/2,toscreen.y - size/2, size, size )
      end
    end
  end
end