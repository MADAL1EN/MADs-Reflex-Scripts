require "base/internal/ui/reflexcore"

MGForce =
{
  canPosition = true
};
registerWidget("MGForce")

function MGForce:initialize()
  self.userData = loadUserData()
  CheckSetDefaultValue(self, "userData", "table", {})
  CheckSetDefaultValue(self.userData, "ShowBackground", "boolean", false)
  CheckSetDefaultValue(self.userData, "Transparency", "number", 125)
  gTimer = 0
  gForce = 0
  animationTimer = 0
  frameThickness = 2
  playerSpeed = 0
  playerSpeedOld = 0
  playerSpeedOldOld = 0
  rectHeight = 5
  rectWidth = 20

  -- Colors
  frameColor = Color(0, 0, 0, transparency)
  SpeedColor1 = Color(255, 15, 15, transparency) -- Red (Bad)
  SpeedColor2 = Color(15, 255, 15, transparency) -- Green (Good)
  SpeedColor3 = Color(255, 255, 15, transparency) -- Yellow (Neutral)
end

function MGForce:drawOptions(x, y, intensity)
  local optargs = {}
  optargs.intensity = intensity

  local user = self.userData
  local sliderWidth = 200
  local sliderStart = 140

  user.Transparency = ui2RowSliderEditBox0Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Transparency", user.Transparency, 0, 255, optargs)

  saveUserData(user)
end
-------------------------------
function animationUpdate()
  if animationTimer > gTimer then
    return end
    animationTimer = gTimer +0.01
    local player = getPlayer()


    playerSpeedOldOld = playerSpeedOld
    playerSpeedOld = player.speed
    local playerSpeed = playerSpeedOldOld - playerSpeedOld
    gForce = playerSpeed

    if playerSpeed >= 0 then
      gForceWidth = ((playerSpeed*10000)^(1/3))
    else
      gForceWidth = ((playerSpeed*10000 * -1)^(1/3))
    end
  end
-------------------------------
  function MGForce:draw()
    if not shouldShowHUD() then return end
    local user = self.userData
    local transparency = user.Transparency
-------------------------------
    local player = getPlayer()
    if player == nil then return end
    -------------------------------
    gTimer = gTimer + deltaTimeRaw
    animationUpdate()
-------------------------------
    if (gForce == 0) then
      -- Draw Yellow
      nvgBeginPath()
      nvgRect(-rectWidth *0.5, -rectHeight *0.5, rectWidth, rectHeight)
      nvgFillColor(SpeedColor3)
      nvgFill()
    elseif (gForce > 0) then
      -- Draw Red
      nvgBeginPath()
      nvgRect((-gForceWidth - rectWidth) *0.5, -rectHeight *0.5, gForceWidth + rectWidth, rectHeight)
      nvgFillColor(SpeedColor1)
      nvgFill()
    else
      -- Draw Green
      nvgBeginPath()
      nvgRect((-gForceWidth - rectWidth) *0.5, -rectHeight *0.5, gForceWidth + rectWidth, rectHeight)
      nvgFillColor(SpeedColor2)
      nvgFill()
    end
  end
