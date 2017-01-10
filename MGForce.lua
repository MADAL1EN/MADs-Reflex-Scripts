require "base/internal/ui/reflexcore"
--------------------------------------------------------------------------------
-- Graph code By DeLift
--------------------------------------------------------------------------------
MGForce = {
  canPosition = true
}
registerWidget("MGForce")
local gTimer = 0
local gForce = 0
local animationTimer = 0
local frameThickness = 2
local playerSpeed = 0
local playerSpeedOld = 0
local playerSpeedOldOld = 0
local rectHeight = 5
local rectWidth = 20

local player
local x = 0
local y = 0
local h = 100
local w = 300
--local maxPing = 150
local maxPacketLoss = 200

--local pingArray = {}
local packetLossArray = {}

function MGForce:initialize()
  widgetCreateConsoleVariable("MGForceWidth", "int", 300)
  widgetCreateConsoleVariable("MGForceHeight", "int", 100)
  --widgetCreateConsoleVariable("MGForceMaxPing", "int", 150)
  widgetCreateConsoleVariable("MGForceMaxPacketLoss", "int", 200)

  for i=0, 100 do
    --pingArray[i] = 0
    packetLossArray[i] = 0
  end
end

function MGForce:draw()
  if not shouldShowStatus() then return end
  local player = getPlayer()
  if not player or not player.connected then return end

  w = widgetGetConsoleVariable("MGForceWidth")
  h = widgetGetConsoleVariable("MGForceHeight")
  --maxPing = widgetGetConsoleVariable("MGForceMaxPing")
  maxPacketLoss = widgetGetConsoleVariable("MGForceMaxPacketLoss")

  playerSpeedOldOld = playerSpeedOld
  playerSpeedOld = player.speed
  local playerSpeed = playerSpeedOldOld - playerSpeedOld
  gForce = playerSpeed

  if playerSpeed >= 0 then
    gForceWidth = ((playerSpeed*10000)^(1/3))
  else
    gForceWidth = ((playerSpeed*10000 * -1)^(1/3))
  end

  -- pop last and push the new ping info to the arrays
  local packetLoss = gForceWidth
  local latency = player.speed
  --table.remove(pingArray)
  --table.insert(pingArray, 0, latency)
  table.remove(packetLossArray)
  table.insert(packetLossArray, 0, packetLoss)
  --[[

  --Ping background
  nvgBeginPath()
  nvgMoveTo(x, y+h)
  local i = 0
  for key,ping in pairs(pingArray) do
  if (ping >= maxPing) then
  ping = maxPing
end
nvgLineTo(x + (i*(w/100)), (h-y-(ping*(h/maxPing))))
i = i + 1
end
nvgLineTo(x+w, y+h)
nvgFillColor(GetPingColor(latency, Color(140,255,140,100)))
nvgFill()
--Ping line
nvgBeginPath()
local j = 0
for key,ping in pairs(pingArray) do
if (ping >= maxPing) then
ping = maxPing
end
if (j == 0) then
nvgMoveTo(x, (h-y-(ping*(h/maxPing))))
end
nvgLineTo(x + (j*(w/100)), (h-y-(ping*(h/maxPing))))
j = j + 1
end
nvgStrokeColor(Color(255,0,0,255))
nvgStroke()

--]]
--PacketLoss
nvgBeginPath()
nvgMoveTo(x, y+h)
local i = 0
for key,packet in pairs(packetLossArray) do
  --if (packet >= maxPacketLoss) then
  -- packet = maxPacketLoss
  --end
  nvgLineTo(x + (i*(w/100)), (h-y-(packet*(h/maxPacketLoss))))
  i = i + 1
end
nvgLineTo(x+w, y+h)

if (gForce <= 0.001) then
  -- Draw Green
  nvgFillColor(Color(12.5,255,12.5,255))
elseif (gForce >= 0.001) then
  -- Draw Red
  nvgFillColor(Color(255,12.5,12.5,255))
else
  -- Draw Yellow
  nvgFillColor(Color(255,255,25,255))
end

nvgFill()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function MGForce:drawOptions(x, y, intensity)
  local optargs = {}
  optargs.intensity = intensity

  local lagWidth = widgetGetConsoleVariable("MGForceWidth")
  widgetSetConsoleVariable("MGForceWidth", ui2RowSliderEditBox2Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Window Width", lagWidth, 1, 500, optargs))
  y = y + 60

  local lagHeight = widgetGetConsoleVariable("MGForceHeight")
  widgetSetConsoleVariable("MGForceHeight", ui2RowSliderEditBox2Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Window Height", lagHeight, 1, 500, optargs))
  y = y + 60

--  local lagMaxPing = widgetGetConsoleVariable("MGForceMaxPing")
--  widgetSetConsoleVariable("MGForceMaxPing", ui2RowSliderEditBox2Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Max Ping", lagMaxPing, 50, 300, optargs))
--  y = y + 60

  local lagMaxPacketLoss = widgetGetConsoleVariable("MGForceMaxPacketLoss")
  widgetSetConsoleVariable("MGForceMaxPacketLoss", ui2RowSliderEditBox2Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Max PacketLoss", lagMaxPacketLoss, 50, 300, optargs))
  y = y + 60
end
