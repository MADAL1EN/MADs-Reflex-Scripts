require "base/internal/ui/reflexcore"
GG =
{
  canPosition = false,
};

registerWidget("GG")

function GG:initialize()
  oldGameState = world.gameState
  glhfSaid = 0
  ggSaid = 0
  messageTimerActive = false
  ggTimer = 0
  delayTime = 2
  messageToSend = "test gg"
  countDown = 0
end

function GG:draw()
  if replayActive or clientGameState ~= STATE_CONNECTED or loading.loadScreenVisible then return end
  local player = getLocalPlayer()
  if player == nil or player.state ~= PLAYER_STATE_INGAME then return end
  local gameMode = gamemodes[world.gameModeIndex]
  if world == nil then return end
  if gameMode.shortName ~= "tdm" and gameMode.shortName ~= "ctf" and gameMode.shortName ~= "1v1" and gameMode.shortName ~= "ffa" then return end

  if messageTimerActive then
  local ggTimer = ggTimer + deltaTimeRaw
  end

  if world.timerActive then
  local countDown = countDown + deltaTimeRaw
  else countDown = 0
  end

  if countDown < delayTime and world.gameState == GAME_STATE_WARMUP and glhfSaid == 0 then
  local messageToSend = "glhf"
  local glhfSaid = 1
  local timerActive = true
  local ggTimer = 0
    --Maybe use GAME_STATE_GAMEOVER instead of GAME_STATE_ROUNDCOOLDOWN_SOMEONEWON
  elseif oldGameState == GAME_STATE_ROUNDACTIVE and world.gameState == GAME_STATE_GAMEOVER and ggSaid == 0 then
  local messageToSend = "gg"
  local ggSaid = 1
  local messageTimerActive = true
  local ggTimer = 0
  end
  local oldGameState = world.gameState

  if ggTimer >= delayTime  then
    consolePrint("say "..messageToSend)
  local glhfSaid = 0
  local ggSaid = 0
  local messageTimerActive = false
  local ggTimer = 0
  end
end
