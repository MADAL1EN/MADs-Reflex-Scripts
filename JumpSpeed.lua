require "base/internal/ui/reflexcore";
JumpSpeed =
{
};
registerWidget("JumpSpeed");

function JumpSpeed:initialize()
end;
TheJumpSpeed =
{
};
jjumpTimer = 0;
ffframes = 0;
jjumpspeedtxt = 0;
TheJumpSpeed.old = 0;

function JumpSpeed:draw()
  if not shouldShowHUD() or not isRaceMode() then return end;
  local player = getPlayer();
  local speed = math.ceil(player.speed);
  local jjumpTimer = math.ceil(player.jumpTimer);

  ffframes = ffframes + 1

  if ffframes >= 1
  then
    if jjumpTimer <= 20
    then jjumpspeedtxt = speed
    else TheJumpSpeed.old = jjumpspeedtxt
    end;
    ffframes = 0

    nvgFontSize(60);
    nvgFontFace("Volter__28Goldfish_29");
    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
    nvgFontBlur(0);
    nvgText(0, 0, TheJumpSpeed.old);
    nvgFillColor(Color(255,255,255,255));
  end;
end
