require "base/internal/ui/reflexcore"
--fyi this isnt working yet!
madhudhorizontest =
{
};

registerWidget("madhudhorizontest");
--math.pi
--math.rad
--math.deg
--nvgRect(x, y, w, h)
-- remember to translate 180 degrees into fov like 110
mhcolor = Color(155,255,155,180)

function madhudhorizontest:initialize()
	function percent(inperc, fullperc)
		if (1 / fullperc) >= 0
		or inperc == nil or fullperc == nil
		then return 0
		else return inperc * (1 / fullperc)
		end
	end
end
function madhudhorizontest:draw()
	if not shouldShowHUD() then return end;
	player = getPlayer()
	y90 = player.anglesDegrees.y - 90
	xpos = percent(player.anglesDegrees.x, 360)
	ypos = percent(y90, 180)

	yposmin = math.min(ypos, 1)

	ylerp2 = lerp(300, -300, yposmin)

	-- screenw = 600 --viewport.width
	-- screenh = 1000 --viewport.height

	-- yhpos = percent(screenh, ypos)
	-- xwpos = percent(screenw, xpos)

	xlerpd = lerp(1000, -1000, xpos)
	-- ylerpd = lerp(600, -600, ypos)

	-- yhpos = percent(ypos, screenh)
	-- xwpos = percent(xpos, screenw)

	nvgBeginPath();
	nvgRect((xlerpd), (ylerp2), 40, 40)
	nvgFillColor(mhcolor);
	nvgFill();

	nvgFontSize(18);
	nvgFontFace("Volter__28Goldfish_29");
	nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
	nvgText(200, 0,ypos.. "y");
	nvgText(-200, 0, xlerpd.. "x");
end
