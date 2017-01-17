-- This widget was originally based on code By DeLift but has since been re-written.

require "base/internal/ui/reflexcore"
MGForce = {
  canPosition = true
}
registerWidget("MGForce")

local gForce = 0
local playerSpeed = 0
local playerSpeedOld = 0
local playerSpeedOldOld = 0
local gForceBarHeight = 1
local gForceBarWidthMax = 350
local gForceAlpha = 125
local gForceColor = Color(12.5, 255, 12.5, 255)
local gForceBarWidth = 0
local gForceArray = {}

function MGForce:initialize()
  self.userData = loadUserData()
  CheckSetDefaultValue(self, "userData", "table", {})
  CheckSetDefaultValue(self.userData, "gForceAlpha", "number", 150)
  CheckSetDefaultValue(self.userData, "gForceMaxWidth", "number", 250)

  for i=0, 100 do
    gForceArray[i] = 0
  end
end

function MGForce:drawOptions(x, y)
  local optargs = {}
  optargs.intensity = intensity
  local user = self.userData

  user.gForceAlpha = ui2RowSliderEditBox0Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Transparency", user.gForceAlpha, 1, 255, optargs)

  local y = y + 60
  user.gForceMaxWidth = ui2RowSliderEditBox0Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Max Bar Width", user.gForceMaxWidth, 15, 500, optargs)

  saveUserData(user)
end

--TODO if spectate, update at 75hz and average inbetween updates.

function MGForce:draw()
  if not shouldShowStatus() then return end
  local player = getPlayer()
  if not player or not player.connected or not isRaceMode() then return end

  local user = self.userData

  playerSpeedOldOld = playerSpeedOld
  playerSpeedOld = player.speed
  local gForce = playerSpeedOldOld - playerSpeedOld

  -- Get User Pref stuff
  local gForceAlpha = user.gForceAlpha
  local gForceMaxWidth = user.gForceMaxWidth * 0.5

  -- pop last and push the new gForce info to the array

  table.remove(gForceArray)
  table.insert(gForceArray, 0, gForce)

  -- GForce
  local i = 0
  for key, forcePairs in pairs(gForceArray) do

    if (forcePairs < 0) then
      -- Draw Green
      gForceBarWidth = (((-forcePairs*10000)^(1/3))*2)
      gForceColor = Color(12.5, 255, 12.5, gForceAlpha)
    elseif (forcePairs > 0) then
      -- Draw Red
      gForceBarWidth = (((forcePairs*10000)^(1/3))*2)
      gForceColor = Color(255, 12.5, 12.5, gForceAlpha)
    else
      -- Draw Yellow
      gForceBarWidth = 1
      gForceColor = Color(255, 255, 25, gForceAlpha)
    end

    if gForceBarWidth > gForceMaxWidth then
      gForceBarWidth = gForceMaxWidth
    end

    nvgBeginPath()
    nvgRect(-gForceBarWidth, i + gForceBarHeight, gForceBarWidth *2, gForceBarHeight)
    i = i + gForceBarHeight
    nvgFillColor(gForceColor)
    nvgFill()
  end

end
