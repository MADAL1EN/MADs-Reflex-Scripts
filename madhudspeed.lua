require "base/internal/ui/reflexcore"
madhudspeed =
{
};
registerWidget("madhudspeed");

function madhudspeed:draw() --A lot of this stuff probably should be before draw
	if not shouldShowHUD() then return end; --get rid of second not

	local speedscale = 1 --scale the Y stuff

	--Once scaling etc is working make these available in the widget prefs
	local topy = 400 * speedscale--Bounding Box
	local bottomy = 0 --Bounding Box (always 0?)
	local speedmetercolor = Color(125,255,125,180)
	local yoffset = topy/2 --center the bars on the y axis
	local bartotextxoffset = 5

	--precision speed text indicator box params
	local boxheight = 20
	local boxwidth = 51.5 -- maybe make this dynamic or scissor it
	local boxoffset = 10

	--static helpers
	local player = getPlayer()
	local speed = math.ceil(player.speed)
	_G.speed = lerp(_G.speed, speed, 0.05) --last number should be in widget prefs for smoothing scale
	local lerpdspeed = round(_G.speed)
	--the Y location changes by speed
	local ylocation = lerpdspeed * speedscale
	local linewidth = 25
	local linewidthhalf = linewidth/2 --used to centre lines on the x axis
	local lineheight = 2.5
	local upsincrement = 50 * speedscale

	nvgBeginPath();
	nvgRect(linewidth/2 + boxoffset, -boxheight/2, boxwidth, boxheight);
	nvgStrokeColor(speedmetercolor);
	nvgStrokeWidth(lineheight);
	nvgStroke();

	--text inside speed indicator box
	nvgFontSize(18);
	nvgFontFace("Volter__28Goldfish_29");
	nvgTextAlign(NVG_ALIGN_RIGHT, NVG_ALIGN_MIDDLE);
	nvgText(linewidth * 2 + linewidthhalf + boxoffset, 0, speed);

	--draw the moving bars loop
	for bardrawloop = (bottomy + -topy), ylocation, upsincrement do
		if (ylocation - bardrawloop) <= topy and (ylocation - bardrawloop) >= bottomy then do
			nvgBeginPath();
			nvgRect(-linewidthhalf, (ylocation + -yoffset - bardrawloop), linewidth, 0);
			nvgStrokeColor(speedmetercolor);
			nvgStrokeWidth(lineheight);
			nvgStroke();

			nvgFontSize(18);
			nvgFontFace("Volter__28Goldfish_29");
			nvgTextAlign(NVG_ALIGN_RIGHT, NVG_ALIGN_MIDDLE);
			nvgText(-linewidthhalf + -bartotextxoffset, (ylocation + -yoffset - bardrawloop), bardrawloop + yoffset);
		end
	end
end
end
