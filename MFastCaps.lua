require "base/internal/ui/reflexcore"

MFastCaps =
{
};
registerWidget("MFastCaps");

function MFastCaps:initialize()
	self.userData = loadUserData();
end;

local savedTime = 0;
local timeHeld = 0;
local hadFlag = false;

function MFastCaps:draw()
	if not shouldShowHUD()
	then return end;

	local user = self.userData;
	local player = getPlayer();

	local frameColor = Color(0,0,0,128);
	local frameWidth = 180;
	local frameHeight = 35;
	local fontSize = frameHeight * 1.15;

	if player == nil
	-- or not world.gameState == 3
	-- or not world.gameState == 6
	or not gamemodes[world.gameModeIndex].hasTeams
	then return end;

	if hadFlag then
		timeHeld = (timeHeld + deltaTime);
		savedTime = timeHeld;
	end;

	if player.hasFlag and not hadFlag then
		hadFlag = true;
	end;

	if player.hasFlag == false and hadFlag == true then
		timeHeld = 0;
		hadFlag = false;
	end;

--frame
	nvgBeginPath();
	nvgRoundedRect(-frameWidth/2, -frameHeight/2, frameWidth, frameHeight, 5);
	nvgFillColor(frameColor);
	nvgFill();
--time held
	if hadFlag then
		nvgFontSize(fontSize);
		nvgFontFace(FONT_TEXT2_BOLD);
		nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
		nvgFontBlur(0);
		nvgFillColor(Color(255,255,255));
		nvgText(0, -1, FormatTimeToDecimalTime(timeHeld*1000));
	else
		nvgFontSize(fontSize);
		nvgFontFace(FONT_TEXT2_BOLD);
		nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
		nvgFontBlur(0);
		nvgFillColor(Color(255,255,255));
		nvgText(0, -1, FormatTimeToDecimalTime(savedTime*1000));
	end;
end;
