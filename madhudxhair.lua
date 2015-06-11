require "base/internal/ui/reflexcore"

-- NVGlineCap () Maybe use this?
-- 	NVG_BUTT,
-- 	NVG_ROUND,
-- 	NVG_SQUARE,
-- 	NVG_BEVEL,
-- 	NVG_MITER,


--revisit the use of math.pi it might be unnesesary on some parts and cause a gap

madhudxhair =
{
};
registerWidget("madhudxhair");

function madhudxhair:draw()
	if not shouldShowHUD() then return end;

	local crosshairSize = 6
	local crosshairWeight = 2
	local crosshairFillColor = Color(155,255,155,180)
	local crosshairStrokeWeight = 4
	local crosshairHalfSize = crosshairSize/2
	local crosshairHalfWeight = crosshairWeight/2

	nvgBeginPath();
	nvgCircle(0, 0, crosshairSize, 255)
	nvgStrokeColor(crosshairFillColor)
	nvgFillColor(crosshairFillColor);
	nvgStrokeWidth(crosshairStrokeWeight/math.pi*2);
	nvgStroke();

	nvgBeginPath();
	nvgRect(-crosshairSize -crosshairStrokeWeight/math.pi, crosshairHalfWeight, -crosshairSize*2, -crosshairWeight) -- horizontal left
	nvgRect(crosshairSize + crosshairStrokeWeight/math.pi, -crosshairHalfWeight, crosshairSize*2, crosshairWeight) -- horizontal right
	nvgRect(-crosshairHalfWeight, -crosshairSize -crosshairStrokeWeight/math.pi, crosshairWeight, -crosshairSize) -- vertical

	nvgFillColor(crosshairFillColor);
	nvgFill();

end
