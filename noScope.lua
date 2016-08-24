require "base/internal/ui/reflexcore"

--TODO
--make function if fov>75 draw scope
--X Hitmarker
-- +420 on kill

noScope =
{
};

registerWidget("noScope");

--[[
function noScope:initialize()
-- load data stored in engine
self.userData = loadUserData();
-- ensure it has what we need
CheckSetDefaultValue(self, "userData", "table", {});
end
--]]

function noScope:draw()
	if not shouldShowHUD() then return end;
	local nvgOffsetX = 1920/2
	local nvgOffsetY = 1080/2

	local svgName = "internal/ui/icons/cod4_scope_wip";
	local scopeColor = Color(0, 0, 0, 255)
	local scopeColorTest = Color(255, 0, 0, 255)

	nvgBeginPath();
	nvgSvg(svgName, 0, 0, 1000);

	--------------------
	--Outer Scope
	nvgBeginPath()
	nvgRect(-1920/2, -1080/2, 1920, 1080);
	nvgCircle(0,0, 884/2);
	nvgPathWinding(NVG_HOLE);
	nvgFillColor(Color(0, 0, 0, 255));
	nvgFill();

	--------------------

	--Mini Tick Horizontal 1
	local TickX = 90
	local TickXOffset = 30

	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 2
	local TickX = TickX - TickXOffset
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 3
	local TickX = TickX - TickXOffset
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 4
	local TickX = TickX - TickXOffset*2
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 5
	local TickX = TickX - TickXOffset
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 6
	local TickX = TickX - TickXOffset
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--------------------

	local TickY = 90
	local TickYOffset = 30

	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 2
	local TickY = TickY - TickYOffset
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 3
	local TickY = TickY - TickYOffset
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 4
	local TickY = TickY - TickYOffset*2
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 5
	local TickY = TickY - TickYOffset
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 6
	local TickY = TickY - TickYOffset
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--------------------

	--Thin Cross
	nvgBeginPath()
	nvgMoveTo(-248/2, 0)
	nvgLineTo(248/2, 0)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(1.25)
	nvgStroke()

	nvgBeginPath()
	nvgMoveTo(0, 248/2)
	nvgLineTo(0, -884/2)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(1.25)
	nvgStroke()

	--Thick Cross
	nvgBeginPath()
	nvgMoveTo(248/2, 0)
	nvgLineTo(884/2, 0)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(8)
	nvgStroke()

	nvgBeginPath()
	nvgMoveTo(-248/2, 0)
	nvgLineTo(-884/2, 0)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(8)
	nvgStroke()

	nvgBeginPath()
	nvgMoveTo(0, 248/2)
	nvgLineTo(0, 884/2)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(8)
	nvgStroke()

	--------------------

	local WindageYOffset = 40

	--Windage Top
	local WindageY = 248/2
	nvgBeginPath()
	nvgMoveTo(-860/2, WindageY)
	nvgLineTo(860/2, WindageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Windage 01
	local WindageY = WindageY + WindageYOffset
	nvgBeginPath()
	nvgMoveTo(-400/2, WindageY)
	nvgLineTo(400/2, WindageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Windage 02
	local WindageY = WindageY + WindageYOffset
	nvgBeginPath()
	nvgMoveTo(-320/2, WindageY)
	nvgLineTo(320/2, WindageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Windage 03
	local WindageY = WindageY + WindageYOffset
	nvgBeginPath()
	nvgMoveTo(-300/2, WindageY)
	nvgLineTo(300/2, WindageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Windage 04
	local WindageY = WindageY + WindageYOffset
	nvgBeginPath()
	nvgMoveTo(-255/2, WindageY)
	nvgLineTo(255/2, WindageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Windage 05
	local WindageY = WindageY + WindageYOffset
	nvgBeginPath()
	nvgMoveTo(-222/2, WindageY)
	nvgLineTo(222/2, WindageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Windage 06
	local WindageY = WindageY + WindageYOffset
	nvgBeginPath()
	nvgMoveTo(-200/2, WindageY)
	nvgLineTo(200/2, WindageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Windage Bottom
	nvgBeginPath()
	nvgMoveTo(-300/2, -120+(1080/2))
	nvgLineTo(300/2, -120+(1080/2))
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(6)
	nvgStroke()

--------------------

--Bezier

--nvgBezierTo(c1x, c1y, c2x, c2y, x, y)
--d="M 730.01079,655.50918 C 849.02183,756.80291 870.83956,851.22334 874.99935,944.98585"

nvgBeginPath()
nvgMoveTo(730 - nvgOffsetX, 655.5 - nvgOffsetY)
nvgBezierTo(849 - nvgOffsetX, 756.8 - nvgOffsetY, 870.84 - nvgOffsetX, 851.2 - nvgOffsetY, 875 - nvgOffsetX, 945 - nvgOffsetY)
nvgStrokeColor(scopeColorTest)
nvgStrokeWidth(2)
nvgStroke()

--TODO

--SVG grid starts from corner and grows to the top right
--NVG grid starts from center and uses -/+
-- Subtract the nvgOffsetX or Y from the SVG numbers for exact results?

end
