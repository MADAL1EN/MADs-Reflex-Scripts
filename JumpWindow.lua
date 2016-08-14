require "base/internal/ui/reflexcore"
local nvg = (function()
  -- inlined ../nvg
  -- wrapper for exposed nanoVG
  return {

    ------------------------------------------------------------------------------
    -- nano constants
    ------------------------------------------------------------------------------
    const = {
      hAlign = {
        left = _G.NVG_ALIGN_LEFT,
        center = _G.NVG_ALIGN_CENTER,
        right = _G.NVG_ALIGN_RIGHT
      },
      vAlign = {
        baseline = _G.NVG_ALIGN_BASELINE,
        top = _G.NVG_ALIGN_TOP,
        middle = _G.NVG_ALIGN_MIDDLE,
        bottom = _G.NVG_ALIGN_BOTTOM
      },
      solidity = {
        solid = _G.NVG_SOLID,
        hole = _G.NVG_HOLE
      },
      winding = {
        ccw = _G.NVG_CCW,
        cw = _G.NVG_CW
      }
    },


    -- State
    save = _G.nvgSave,
    restore = _G.nvgRestore,

    -- Font
    fontSize = _G.nvgFontSize,
    fontFace = _G.nvgFontFace,
    fontBlur = _G.nvgFontBlur,
    textWidth = _G.nvgTextWidth,

    -- returns table { minx, miny, maxx, maxy }
    textBounds = _G.nvgTextBounds,

    -- Fill
    fillColor = _G.nvgFillColor,
    fillLinearGradient = _G.nvgFillLinearGradient,
    fillBoxGradient = _G.nvgFillBoxGradient,
    fillRadialGradient = _G.nvgFillRadialGradient,
    fill = _G.nvgFill,

    -- Stroke
    strokeColor = _G.nvgStrokeColor,
    strokeLinearGradient = _G.nvgStrokeLinearGradient,
    strokeBoxGradient = _G.nvgStrokeBoxGradient,
    strokeRadialGradient = _G.nvgStrokeRadialGradient,
    strokeWidth = _G.nvgStrokeWidth,
    stroke = _G.nvgStroke,

    -- Text
    textAlign = _G.nvgTextAlign,
    text = _G.nvgText,

    -- Paths
    beginPath = _G.nvgBeginPath,
    moveTo = _G.nvgMoveTo,
    lineTo = _G.nvgLineTo,
    bezierTo = _G.nvgBezierTo,
    quadTo = _G.nvgQuadTo,
    arcTo = _G.nvgArcTo,
    closePath = _G.nvgClosePath,
    pathWinding = _G.nvgPathWinding,

    -- Primitives
    arc = _G.nvgArc,
    rect = _G.nvgRect,
    roundedRect = _G.nvgRoundedRect,
    ellipse = _G.nvgEllipse,
    circle = _G.nvgCircle,

    -- Scissoring
    scissor = _G.nvgScissor,
    intersectScissor = _G.nvgIntersectScissor,
    resetScissor = _G.nvgResetScissor,

    -- Transform
    translate = _G.nvgTranslate,
    rotate = _G.nvgRotate,
    skewX = _G.nvgSkewX,
    skewY = _G.nvgSkewY,
    scale = _G.nvgScale,

    ------------------------------------------------------------------------------------------------
    --SVG BINDINGS
    ------------------------------------------------------------------------------------------------
    -- NOTE: swapped param names position to be inline with other functions
    svg = function(x, y, name, rad)
      _G.nvgSvg(name, x, y, rad)
    end,

  }

end)()
local ui = (function()
  -- inlined ../ui
  require "base/internal/ui/reflexcore"

  return {
    -- stuff from reflexCore
    window = _G.uiWindow,
    button = _G.uiButton,
    buttonVertical = _G.uiButtonVertical,
    slider = _G.uiSlider,
    progressBar = _G.uiProgressBar,
    scrollBar = _G.uiScrollBar,
    subHeader = _G.uiSubHeader,
    toolTip = _G.uiToolTip,
    checkBox = _G.uiCheckBox,
    editBox = _G.uiEditBox,
    label = _G.uiLabel,
    comboBox = _G.uiComboBox,
    colorPicker = _G.uiColorPicker,

    scrollSelection = _G.uiScrollSelection,
    scrollSelectionItem = _G.uiScrollSelectionItem
  }

end)()
local userData = (function()
  -- inlined ../userData
  return {
    load = _G.loadUserData,
    save = _G.saveUserData
  }

end)()
local color = (function()
  -- inlined ../lib/color
  require "base/internal/ui/reflexcore"

  local lerp = function(a, b, k)
    return a * (1 - k) + b * k;
  end

  local Color = _G.Color

  return {
    new = function(r,g,b,a)
      return Color(r,g,b,a)
    end,

    lerp = function(colorA, colorB, k)
      return Color(
      lerp(colorA.r, colorB.r, k),
      lerp(colorA.g, colorB.g, k),
      lerp(colorA.b, colorB.b, k),
      lerp(colorA.a, colorB.a, k)
      )
    end
  }
end)()

local config;
_G.JumpWindow = {
  initialize = function()
    config = config or userData.load() or {}
    if not config.height then config.height = 20 end
  end,

  drawOptions = function(_, x, y)

    ui.label("Height:", x, y);
    config.height = math.floor(ui.slider(x + 80, y, 200, 1, 120, config.height));
    config.height = math.floor(ui.editBox(config.height, x + 290, y, 80));

    userData.save(config)

  end,
--TODO CLAMP the prefrences to minimum of 1 height!
  draw = function()
    local player = _G.getPlayer()
    if not player or not _G.shouldShowHUD() or not _G.isRaceMode() then return end;

    -- calculating values
    local height = config.height or 20
    local halfHeight = height/2
    local barHeight = height + 20

    -- calculate height
    local jumpTimer = player.jumpTimer
    if jumpTimer >= 400 then jumpTimer = 0 end
    local barWidth = jumpTimer * 0.5;

    if jumpTimer > 0 then
      nvg.beginPath()
      --      nvg.rect(barWidth -200, -height, barWidth, barHeight)

      nvg.rect(-200, -height, barWidth, barHeight)
      nvg.rect(200, height, -barWidth, -barHeight)
      nvg.fillColor(color.new(255,255,255));
      nvg.fill()
    end
  end,
};
_G.registerWidget("JumpWindow");
