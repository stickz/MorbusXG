// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

pScoreBoard = nil

local ShowScoreboard = false

function GM:CreateScoreboard()
	pScoreBoard = vgui.Create("MScoreboard")
end

function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true

	gui.EnableScreenClicker(true)

	SB_status = true	

	if not pScoreBoard then
		self:CreateScoreboard()
	end

	pScoreBoard.Status = true
	pScoreBoard:SetVisible(true)
end

function GM:ScoreboardHide()

	GAMEMODE.ShowScoreboard = false
	
	SB_status = false

	gui.EnableScreenClicker(false)

	if pScoreBoard then
		pScoreBoard.Status = false
		pScoreBoard:SetVisible(false)
	end
end

function GM:GetScoreboardPanel()
	if pScoreBoard then
		return pScoreBoard
	end
end

function GM:HUDDrawScoreBoard()
	return false
end

function GM:PostRenderVGUI()
end


