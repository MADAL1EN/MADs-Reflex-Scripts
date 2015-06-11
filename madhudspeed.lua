require "base/internal/ui/reflexcore"
madhudspeed =
{
};
registerWidget("madhudspeed");

function madhudspeed:draw() --A lot of this stuff probably should be before draw
	if not shouldShowHUD() or not isRaceMode() then return end;

	local speedscale = .5 --unused, meant to scale the speed to the bar size

	--Once scaling etc is working make these available in the widget prefs
	local topy = 400 --Bounding Box
	local bottomy = 0 --Bounding Box (always 0?)
	local speedmetercolor = Color(125,255,125,180)
	local yoffset = topy/2 --center the bars on the y axis
	local bartotextxoffset = 5

	--precision speed text indicator box params
	local boxheight = 20
	local boxwidth = 51.5
	local boxoffset = 10

	--static helpers
	local player = getPlayer()
	local speed = math.ceil(player.speed)

	--the Y location changes by speed
	local ylocation = speed --?shouldnt it be speed * speedscale?
	local linewidth = 25
	local linewidthhalf = linewidth/2 --used to centre lines on the x axis
	local lineheight = 2.5
	local upsincrement = 50 --?shouldnt it be upsincrement * speedscale?

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
		if (speed - bardrawloop) <= topy and (speed - bardrawloop) >= bottomy then do
			nvgBeginPath();
			nvgRect(-linewidthhalf, (speed + -yoffset - bardrawloop), linewidth, 0);
			nvgStrokeColor(speedmetercolor);
			nvgStrokeWidth(lineheight);
			nvgStroke();

			nvgFontSize(18);
			nvgFontFace("Volter__28Goldfish_29");
			nvgTextAlign(NVG_ALIGN_RIGHT, NVG_ALIGN_MIDDLE);
			nvgText(-linewidthhalf + -bartotextxoffset, (speed + -yoffset - bardrawloop), bardrawloop + yoffset);
		end
	end
end
end
