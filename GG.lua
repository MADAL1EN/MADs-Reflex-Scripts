require "base/internal/ui/reflexcore"
GG =
{
  canPosition = false,
}

registerWidget("GG")

function GG:initialize()
  self.userData = loadUserData()
  CheckSetDefaultValue(self, "userData", "table", {})
  CheckSetDefaultValue(self.userData, "ggMessage", "string", "gg")
  CheckSetDefaultValue(self.userData, "glhfMessage", "string", "glhf")
  -----------------------------
  oldGameState = 0
  glhfSaid = false
  ggSaid = false
  messageTimerActive = false
  ggTimer = 0
  delayTime = 2
  messageToSend = "nil"
  countDown = 0
end

function GG:drawOptions(x, y)
  local optargs = {};
  optargs.intensity = intensity
  local user = self.userData

  ui2Label("GG Message", x, y, optargs)
  user.ggMessage = string.format("%s", ui2EditBox(user.ggMessage, 25, y, 125, optargs))

  local y = y + 60

  ui2Label("GLHF Message", x, y, optargs)
  user.glhfMessage = string.format("%s", ui2EditBox(user.glhfMessage, 25, y, 125, optargs))

  if user.ggMessage == nil or user.ggMessage == "" then
    user.ggMessage = "gg"
  elseif user.glhfMessage == nil or user.glhfMessage == "" then
    user.glhfMessage = "glhf"
  end

  saveUserData(user)
end

function GG:draw()
  if replayActive or clientGameState ~= STATE_CONNECTED or loading.loadScreenVisible then return end
  local player = getLocalPlayer()
  if player == nil or player.state ~= PLAYER_STATE_INGAME then return end
  local gameMode = gamemodes[world.gameModeIndex]
  if world == nil then return end
  if gameMode.shortName ~= "tdm" and gameMode.shortName ~= "ctf" and gameMode.shortName ~= "1v1" and gameMode.shortName ~= "ffa" then return end
  local user = self.userData

  -----------------------------
  if messageTimerActive then
    ggTimer = ggTimer + deltaTimeRaw
  else ggTimer = 0
  end
  -----------------------------
  if world.timerActive then
    countDown = countDown + deltaTimeRaw
  else countDown = 0
  end
  -----------------------------

  if countDown > 0 and countDown < delayTime and world.gameState == GAME_STATE_WARMUP and glhfSaid == false then
    messageToSend = string.format("say %s", user.glhfMessage)
    glhfSaid = true
    messageTimerActive = true
  end

  if oldGameState == GAME_STATE_ACTIVE and world.gameState == GAME_STATE_GAMEOVER and ggSaid == false then
    messageToSend = string.format("say %s", user.ggMessage)
    ggSaid = true
    messageTimerActive = true
  end

  oldGameState = world.gameState

  if ggTimer >= delayTime then
    consolePerformCommand(messageToSend)
    glhfSaid = false
    ggSaid = false
    messageTimerActive = false
    ggTimer = 0
  end
end
