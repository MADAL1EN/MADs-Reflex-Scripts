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

  math.randomseed(epochTime + deltaTimeRaw)
  messageDelayTime = (0.5 + (math.random() * 3.5)) * 1000 -- This has to be here or it gets called before random is seeded.
end
-----------------------------
local oldTimerActive = nil
local oldGameState = nil
local weWon = false
local arenaWeWon = false
local weStart = false
local arenaWeStart = false

function GG:drawOptions(x, y)
  local optargs = {};
  optargs.intensity = intensity
  local user = self.userData

  ui2Label("GG Message", x, y, optargs)
  user.ggMessage = string.format("%s", ui2EditBox(user.ggMessage, 25, y, 125, optargs))

  local y = y + 60
  ui2Label("GLHF Message", x, y, optargs)
  user.glhfMessage = string.format("%s", ui2EditBox(user.glhfMessage, 25, y, 125, optargs))

  if not user.ggMessage or user.ggMessage == "" then
    user.ggMessage = "gg"
  end
  if not user.glhfMessage or user.glhfMessage == "" then
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

  -------------------GG-------------------
  if not weWon and not arenaWeWon then --TODO Should this be and OR or?
    if world.gameState == GAME_STATE_GAMEOVER and oldGameState ~= GAME_STATE_GAMEOVER then
      if oldGameState == GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON then
        --consolePrint(string.format("1: arenaWeWon MDT: %s WGT: %s", messageDelayTime, world.gameTime))
        arenaWeWon = true
      else
        --consolePrint(string.format("1: weWon MDT: %s WGT: %s", messageDelayTime, world.gameTime))
        weWon = true
      end
    end
  end

  if weWon then
    if world.gameTime > messageDelayTime then
      consolePerformCommand(string.format("say %s", user.ggMessage))
      --consolePrint(string.format("2: weWon MDT: %s WGT: %s", messageDelayTime, world.gameTime))
      weWon = false
    end
  end

  if arenaWeWon then
    if world.gameTime > messageDelayTime then
      consolePerformCommand(string.format("say %s", user.ggMessage))
      --consolePrint(string.format("2: arenaWeWon MDT: %s WGT: %s", messageDelayTime, world.gameTime))
      arenaWeWon = false
    end
  end

  -------------------GLHF-------------------
  if not arenaWeStart then
    if world.gameState == GAME_STATE_ROUNDPREPARE and oldGameState == GAME_STATE_WARMUP then
      --consolePrint(string.format("1: arenaWeStart MDT: %s WGT: %s", messageDelayTime, world.gameTime))
      arenaWeStart = true
    end
  end

  if arenaWeStart then
    if world.gameTime > messageDelayTime then
      consolePerformCommand(string.format("say %s", user.glhfMessage))
      --consolePrint(string.format("2: arenaWeStart MDT: %s WGT: %s", messageDelayTime, world.gameTime))
      arenaWeStart = false
    end
  end

  if not weStart then
    if world.gameState == GAME_STATE_WARMUP and not oldTimerActive and world.timerActive then
      --consolePrint(string.format("1: weStart MDT: %s WGT: %s", messageDelayTime, world.gameTime))
      weStart = true
    end
  end

  if weStart then
    if world.gameTime > messageDelayTime then
      consolePerformCommand(string.format("say %s", user.glhfMessage))
      --consolePrint(string.format("2: weStart MDT: %s WGT: %s", messageDelayTime, world.gameTime))
      weStart = false
    end
  end

  --consolePrint(world.gameTime)
  --consolePrint(world.gameState)
  oldTimerActive = world.timerActive
  oldGameState = world.gameState
end
