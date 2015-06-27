require "base/internal/ui/reflexcore"
madhudspeed =
{
};

function madhudspeed:initialize()
	self.userData = loadUserData();
	CheckSetDefaultValue(self, "userData", "table", {});
	CheckSetDefaultValue(self.userData, "bAlpha", "number", 180);
end

function clampToNoDecimal(n)
	return math.floor(n * 1) / 1;
end

function madhudspeed:drawOptions(x, y)

	uiLabel("Bar Alpha:", x, y);
	local sliderWidth = 200;
	local sliderStart = 140;
	local user = self.userData;

	user.bAlpha = clampToNoDecimal(uiSlider(x + sliderStart, y, sliderWidth, 0, 255, user.bAlpha));
	user.bAlpha = clampToNoDecimal(uiEditBox(user.bAlpha, x + sliderStart + sliderWidth + 10, y, 60));
	saveUserData(user);

end

registerWidget("madhudspeed");
testspeed = 0

function madhudspeed:draw() --A lot of this stuff probably should be before draw()
	if not shouldShowHUD() or not isRaceMode() then return end;
	local speedscale = 1 --scale the Y stuff

	--Make these available in the widget prefs
	local topy = 400 * speedscale--Bounding Box  --self.userData.topy
	local bottomy = 0 --Bounding Box (always 0?)
	local speedmeteralpha = self.userData.bAlpha
	local speedmetercolor = Color(125,255,125,speedmeteralpha)
	local yoffset = topy/2 --center the bars on the y axis
	local bartotextxoffset = 5
	local lerpspeedscale = 30
	local lerpspeed = clamp(lerpspeedscale * deltaTimeRaw, 0.0001, 1) --I think frame dependant animation has been fixed.
	-- make the first number in lerpspeed a widget pref

	-- maybe add easing, like fast in slow out?

	--precision speed text indicator box params
	local boxheight = 20
	local boxwidth = 51.5 -- maybe make this dynamic or scissor it for 9999+
	local boxoffset = 10

	--static helpers
	local player = getPlayer()
	local speed = math.ceil(player.speed)
	testspeed = lerp(testspeed, speed, lerpspeed)
	local lerpdspeed = round(testspeed)
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

--Thanks to Qualx, AliasedFrog, Bonuspunkt and other dudes I forgot to mention in #reflex for helping me with lua questions.
