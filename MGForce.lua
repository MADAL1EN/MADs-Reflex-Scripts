-- This widget was originally based on code By DeLift but has since been re-written.

require "base/internal/ui/reflexcore"
MGForce = {
  canPosition = true
}
registerWidget("MGForce")

function MGForce:initialize()
  self.gForce = 0
  self.playerSpeedOld = 0
  self.playerSpeedOldOld = 0
  self.gForceBarHeight = 1
  self.gForceColor = Color(12.5, 255, 12.5, 255)
  self.gForceBarWidth = 0
  self.gForceArray = {}

  self.userData = loadUserData()
  CheckSetDefaultValue(self, "userData", "table", {})
  CheckSetDefaultValue(self.userData, "gForceAlpha", "number", 150)
  CheckSetDefaultValue(self.userData, "gForceMaxWidth", "number", 250)
  CheckSetDefaultValue(self.userData, "widthFactor", "number", 2.5)

  for i=0, 100 do
    self.gForceArray[i] = 0
  end
end

function MGForce:drawOptions(x, y)
  local optargs = {}
  optargs.intensity = intensity
  local user = self.userData

  user.gForceAlpha = ui2RowSliderEditBox0Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Transparency", user.gForceAlpha, 1, 255, optargs)

  local y = y + 60
  user.gForceMaxWidth = ui2RowSliderEditBox0Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Maximum Bar Width", user.gForceMaxWidth, 15, 500, optargs)

  local y = y + 60
  user.widthFactor = ui2RowSliderEditBox2Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Bar Width Multiplier", user.widthFactor, 1.5, 4, optargs)

  ui2TooltipBox("A smaller number creates a wider bar.", WIDGET_PROPERTIES_COL_INDENT + 20, y, 200, optargs)

  saveUserData(user)
end

function MGForce:draw()
  if not shouldShowStatus() then return end
  local player = getPlayer()
  if not player or not player.connected or not isRaceMode() then return end

  local user = self.userData

  self.playerSpeedOldOld = self.playerSpeedOld
  self.playerSpeedOld = player.speed
  self.gForce = self.playerSpeedOldOld - self.playerSpeedOld

  -- Get User Pref stuff
  self.widthFactor = user.widthFactor
  self.gForceAlpha = user.gForceAlpha
  self.gForceMaxWidth = user.gForceMaxWidth * 0.5

  -- pop last and push the new gForce info to the array

  table.remove(self.gForceArray)
  table.insert(self.gForceArray, 0, self.gForce)

  -- GForce
  local i = 0
  for key, forcePairs in pairs(self.gForceArray) do

    if (forcePairs < 0) then
      -- Draw Green
      self.gForceBarWidth = (((-forcePairs*10000)^(1/self.widthFactor))*2)
      self.gForceColor = Color(12.5, 255, 12.5, self.gForceAlpha)
    elseif (forcePairs > 0) then
      -- Draw Red
      self.gForceBarWidth = (((forcePairs*10000)^(1/self.widthFactor))*2)
      self.gForceColor = Color(255, 12.5, 12.5, self.gForceAlpha)
    else
      -- Draw Yellow
      self.gForceBarWidth = 1
      self.gForceColor = Color(255, 255, 25, self.gForceAlpha)
    end

    if self.gForceBarWidth > self.gForceMaxWidth then
      self.gForceBarWidth = self.gForceMaxWidth
    end

    nvgBeginPath()
    nvgRect(-(self.gForceBarWidth), (i + self.gForceBarHeight), (self.gForceBarWidth *2), (self.gForceBarHeight))
    i = i + self.gForceBarHeight
    nvgFillColor(self.gForceColor)
    nvgFill()
  end

end
