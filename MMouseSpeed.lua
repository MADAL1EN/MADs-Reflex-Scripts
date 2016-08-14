require "base/internal/ui/reflexcore"

MMouseSpeed =
{
};
registerWidget("MMouseSpeed");

function MMouseSpeed:draw()
	if not shouldShowHUD() then return end;

	-------
	local rawx, rawy = mouseGetAverageRawInput();
	-------

	if rawx >= 0 then
		mouseSpeed = rawx
	else
		mouseSpeed = (rawx * -1)
	end;

	fillSpeed = mouseSpeed;

	local rectWidth = 50;
	local rectHeight = 5;

	-- Colors
	local transparency = 120;
	local SpeedColor1 = Color(255,15,15,transparency); -- Red (Bad)
	local SpeedColor2 = Color(15,255,15,transparency); -- Green (Good)

	if (mouseSpeed <= 0) then
		-- Draw Red
		nvgBeginPath();
		nvgRect(-rectWidth/2, -rectHeight/2, rectWidth, rectHeight)
		nvgFillColor(SpeedColor1);
		nvgFill();
	else
		-- Draw Green
		nvgBeginPath();
		nvgRect(-rectWidth/2, -rectHeight/2, rectWidth, fillSpeed + rectHeight)
		nvgFillColor(SpeedColor2);
		nvgFill();
	end;
end;
