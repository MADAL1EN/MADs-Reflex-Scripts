-- This widget was originally based on graph code By DeLift but has since been re-written.

require "base/internal/ui/reflexcore"
SpeedPulse = {
  canPosition = true
}
registerWidget("SpeedPulse")

function SpeedPulse:initialize()
  self.speedPulse = 0
  self.playerSpeedOld = 0
  self.playerSpeedOldOld = 0
  self.speedPulseBarHeight = 1
  self.speedPulseColor = Color(12.5, 255, 12.5, 255)
  self.speedPulseBarWidth = 0
  self.speedPulseArray = {}
  self.clock = 0
  self.smoothingCounter = 0

  self.userData = loadUserData()
  CheckSetDefaultValue(self, "userData", "table", {})
  CheckSetDefaultValue(self.userData, "pulseRate", "number", 120)
  CheckSetDefaultValue(self.userData, "speedPulseAlpha", "number", 150)
  CheckSetDefaultValue(self.userData, "widthFactor", "number", 2.5)
  CheckSetDefaultValue(self.userData, "widthLimit", "number", 0.75)

  for i=0, 100 do
    self.speedPulseArray[i] = 0
  end
end

function SpeedPulse:drawOptions(x, y)
  local optargs = {}
  optargs.intensity = intensity
  local user = self.userData

  user.pulseRate = ui2RowSliderEditBox2Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Pulse Rate (hz)", user.pulseRate, 20, 500, optargs)
  ui2TooltipBox("The frequency at which speed data is updated.", WIDGET_PROPERTIES_COL_INDENT + 10, y, 200, optargs)

  local y = y + 60
  user.speedPulseAlpha = ui2RowSliderEditBox0Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Transparency", user.speedPulseAlpha, 1, 255, optargs)

  local y = y + 60
  user.widthFactor = ui2RowSliderEditBox2Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Bar Width Multiplier", user.widthFactor, 2, 4, optargs)

  ui2TooltipBox("A smaller number creates a wider bar.", WIDGET_PROPERTIES_COL_INDENT + 10, y, 200, optargs)

  local y = y + 60
  user.widthLimit = ui2RowSliderEditBox2Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Bar Width Limit", user.widthLimit, 0.15, 1, optargs)

  ui2TooltipBox("A value of 1 uses the whole screen while a value of 0.5 uses half.", WIDGET_PROPERTIES_COL_INDENT + 10, y, 200, optargs)

  saveUserData(user)
end

function SpeedPulse:draw()
  if not shouldShowStatus() then return end
  local player = getPlayer()
  if not isRaceMode() or not shouldShowHUD() then return end

  local user = self.userData

  self.playerSpeedOldOld = self.playerSpeedOld
  self.playerSpeedOld = player.speed
  self.speedPulse = self.playerSpeedOldOld - self.playerSpeedOld

  self.speedPulseMaxWidth = (viewport.width * user.widthLimit * 0.5)

  -- Get User Pref stuff
  self.widthFactor = user.widthFactor
  self.speedPulseAlpha = user.speedPulseAlpha
  self.pulseRate = user.pulseRate

  -- Only update speedPulse every refresh but still keep data from inbetween refreshes.
  self.clock = self.clock + deltaTimeRaw
  self.speedPulse = self.speedPulse + self.speedPulse
  self.smoothingCounter = self.smoothingCounter + 1

  if self.clock > (1/self.pulseRate) then
    self.speedPulse = self.speedPulse / self.smoothingCounter
    self.clock = 0
    self.smoothingCounter = 0

    -- pop last and push the new speedPulse info to the array

    table.remove(self.speedPulseArray)
    table.insert(self.speedPulseArray, 0, self.speedPulse)
  end

  local i = 0
  for key, pulsePairs in pairs(self.speedPulseArray) do

    if (pulsePairs < 0) then
      -- Draw Green
      self.speedPulseBarWidth = (((-pulsePairs*10000)^(1/self.widthFactor))*2)
      self.speedPulseColor = Color(12.5, 255, 12.5, self.speedPulseAlpha)
    elseif (pulsePairs > 0) then
      -- Draw Red
      self.speedPulseBarWidth = (((pulsePairs*10000)^(1/self.widthFactor))*2)
      self.speedPulseColor = Color(255, 12.5, 12.5, self.speedPulseAlpha)
    else
      -- Draw Yellow
      self.speedPulseBarWidth = 1
      self.speedPulseColor = Color(255, 255, 25, self.speedPulseAlpha)
    end

    if self.speedPulseBarWidth > self.speedPulseMaxWidth then
      self.speedPulseBarWidth = self.speedPulseMaxWidth
    end

    i = i + self.speedPulseBarHeight

    nvgBeginPath()
    nvgMoveTo(-self.speedPulseBarWidth, i + self.speedPulseBarHeight * 0.5)
    nvgLineTo(self.speedPulseBarWidth, i + self.speedPulseBarHeight * 0.5)
    nvgStrokeColor(self.speedPulseColor)
    nvgStrokeWidth(self.speedPulseBarHeight)
    nvgStroke()
  end
end

-- MAD: Feel free to let me know if some of this code is not optimal or could be improved, I would like to learn.
