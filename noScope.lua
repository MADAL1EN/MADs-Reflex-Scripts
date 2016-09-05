require "base/internal/ui/reflexcore"

--TODO
--Make Z value so that it draws way behind every other hud element?
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
	if not shouldShowHUD() or consoleGetVariable("r_fov") >= 65 then return end;

	local nvgOffSetX = 1920/2
	local nvgOffSetY = 1080/2
	local fixWindageOffSetY = 8 -- Lol

	local scopeColor = Color(0, 0, 0, 255)
	local scopeColorTest = Color(255, 0, 0, 255)

	--------------------

	--Outer Scope
	nvgBeginPath();
	nvgRect(-viewport.width/2, -viewport.height/2, viewport.width, viewport.height);
	nvgCircle(0,0, 880/2);
	nvgPathWinding(NVG_HOLE);
	nvgFillColor(Color(0, 0, 0, 255));
	nvgFill();
	--------------------

	--Mini Tick Horizontal 1
	local TickX = 90
	local TickXOffSet = 30

	nvgBeginPath();
	nvgMoveTo(-TickX, 5);
	nvgLineTo(-TickX, -5);
	nvgStrokeColor(scopeColor);
	nvgStrokeWidth(2);
	nvgStroke();

	--Mini Tick Horizontal 2
	local TickX = TickX - TickXOffSet;
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 3
	local TickX = TickX - TickXOffSet
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 4
	local TickX = TickX - TickXOffSet*2
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 5
	local TickX = TickX - TickXOffSet
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 6
	local TickX = TickX - TickXOffSet
	nvgBeginPath()
	nvgMoveTo(-TickX, 5)
	nvgLineTo(-TickX, -5)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--------------------

	local TickY = 90
	local TickYOffSet = 30

	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 2
	local TickY = TickY - TickYOffSet
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 3
	local TickY = TickY - TickYOffSet
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 4
	local TickY = TickY - TickYOffSet*2
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 5
	local TickY = TickY - TickYOffSet
	nvgBeginPath()
	nvgMoveTo(5, TickY)
	nvgLineTo(-5, TickY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	--Mini Tick Horizontal 6
	local TickY = TickY - TickYOffSet
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

	local windageYOffSet = 48
	local windageY = 655.5 - nvgOffSetY + fixWindageOffSetY

	--windage Top

	nvgBeginPath()
	nvgMoveTo(520 - nvgOffSetX, windageY)
	nvgLineTo(880 + 520 - nvgOffSetX, windageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()


	--windage 01

	local windageY = windageY + windageYOffSet
	nvgBeginPath()
	nvgMoveTo(780 - nvgOffSetX, windageY)
	nvgLineTo(1140 - nvgOffSetX, windageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()


	--windage 02

	local windageY = windageY + windageYOffSet
	nvgBeginPath()
	nvgMoveTo(816 - nvgOffSetX, windageY)
	nvgLineTo(816 + 288 - nvgOffSetX, windageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()


	--windage 03

	local windageY = windageY + windageYOffSet
	nvgBeginPath()
	nvgMoveTo(844 - nvgOffSetX, windageY)
	nvgLineTo(1076 - nvgOffSetX, windageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()


	--windage 04

	local windageY = windageY + windageYOffSet
	nvgBeginPath()
	nvgMoveTo(862 - nvgOffSetX, windageY)
	nvgLineTo(862 + 198 - nvgOffSetX, windageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()


	--windage 05

	local windageY = windageY + windageYOffSet
	nvgBeginPath()
	nvgMoveTo(870 - nvgOffSetX, windageY)
	nvgLineTo(870 + 180 -nvgOffSetX, windageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()


	--windage Bottom

	local windageY = windageY + windageYOffSet
	nvgBeginPath()
	nvgMoveTo(780 - nvgOffSetX, windageY)
	nvgLineTo(1140 - nvgOffSetX, windageY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(6)
	nvgStroke()

	--------------------

	--Bezier

	nvgBeginPath()
	nvgMoveTo(730 - nvgOffSetX, 655.5 - nvgOffSetY + fixWindageOffSetY)
	nvgBezierTo(849 - nvgOffSetX, 756.8 - nvgOffSetY + fixWindageOffSetY, 870.84 - nvgOffSetX, 851.2 - nvgOffSetY + fixWindageOffSetY, 875 - nvgOffSetX, 945 - nvgOffSetY + fixWindageOffSetY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()

	nvgBeginPath()
	nvgMoveTo(1190 - nvgOffSetX, 655.5 - nvgOffSetY + fixWindageOffSetY)
	nvgBezierTo(1070 - nvgOffSetX, 756.8 - nvgOffSetY + fixWindageOffSetY, 1049.16 - nvgOffSetX, 851.2 - nvgOffSetY + fixWindageOffSetY, 1045 - nvgOffSetX, 945 - nvgOffSetY + fixWindageOffSetY)
	nvgStrokeColor(scopeColor)
	nvgStrokeWidth(2)
	nvgStroke()
end -- Before you ask why, ask your self why not?
