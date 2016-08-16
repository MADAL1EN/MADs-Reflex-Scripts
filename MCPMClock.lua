--------------------------------------------------------------------------------
-- Most of this code is from the Timer.lua official Reflex script.
--------------------------------------------------------------------------------

require "base/internal/ui/reflexcore"

MCPMClock =
{
};
registerWidget("MCPMClock");

function MCPMClock:initialize()
	self.userData = loadUserData();
	CheckSetDefaultValue(self, "userData", "table", {});
	CheckSetDefaultValue(self.userData, "countDirectionUpPref", "boolean", false);
	CheckSetDefaultValue(self.userData, "cPMStylePref", "boolean", true);
end

function MCPMClock:drawOptions(x, y, intensity)
	local optargs = {};
	optargs.intensity = intensity;

	local user = self.userData;
	local sliderWidth = 200;
	local sliderStart = 140;

	user.countDirectionUpPref = ui2RowCheckbox(x, y, WIDGET_PROPERTIES_COL_INDENT, "Count Direction Up", user.countDirectionUpPref, optargs);

	y=y+60
	user.cPMStylePref = ui2RowCheckbox(x, y, WIDGET_PROPERTIES_COL_INDENT, "CPM style seconds", user.cPMStylePref, optargs);


	saveUserData(user);
end;

local function sortDescending(a, b)
	return a.score > b.score;
end

--------------------------------------------------------------------------------
local function GetDeltaColorAndText()
	local textColor = Color(255,255,255,255);
	local frameColor = Color(48,48,48,255);
	local deltaScore = 0;

	-- team game?
	local gameMode = gamemodes[world.gameModeIndex];
	if gameMode.hasTeams then
		local teamToDisplayFrom;

		-- displaying from a player POV or global POV?
		if (playerIndexCameraAttachedTo > 0) and (players[playerIndexCameraAttachedTo].state == PLAYER_STATE_INGAME) then
			-- displaying from this players POV
			teamToDisplayFrom = players[playerIndexCameraAttachedTo].team;
		else
			-- display from winners POV
			teamToDisplayFrom = world.teams[1].score > world.teams[2].score and 1 or 2;
		end

		-- displaying from this players POV
		frameColor = teamColors[teamToDisplayFrom];
		deltaScore = world.teams[1].score - world.teams[2].score;
		if (teamToDisplayFrom == 2) then
			deltaScore = -deltaScore;
		end

	else

		local playersSorted = {};
		local playersSortedCount = 0;

		-- gather players that are connected & their score
		local playerCount = 0;
		for k, v in pairs(players) do
			playerCount = playerCount + 1;
		end
		for playerIndex = 1, playerCount do
			local player = players[playerIndex];
			if player.connected and (player.state == PLAYER_STATE_INGAME) then
				--consolePrint(v.score);
				playersSortedCount = playersSortedCount + 1;
				playersSorted[playersSortedCount] = {};
				playersSorted[playersSortedCount].score = player.score;
				playersSorted[playersSortedCount].index = playerIndex;
			end
		end

		-- sort accordingly
		table.sort(playersSorted, sortDescending);

		-- displaying from a player POV or global POV?
		if (playerIndexCameraAttachedTo > 0) and (players[playerIndexCameraAttachedTo].state == PLAYER_STATE_INGAME) then

			-- displaying from this players POV
			local playerScore = players[playerIndexCameraAttachedTo].score;
			if playersSorted[1].index == playerIndexCameraAttachedTo then
				-- winning..
				if playersSortedCount > 1 then
					-- by how much..?
					deltaScore = playerScore - playersSorted[2].score;
				end
			else
				deltaScore = playerScore - playersSorted[1].score;
			end

		else

			-- display from winners POV
			if playersSortedCount > 1 then
				deltaScore = playersSorted[1].score - playersSorted[2].score;
			end

		end
	end

	-- format nicely
	if deltaScore == -0 then deltaScore = 0 end;
	if deltaScore > 0 then
		deltaScore = "+"..deltaScore;
	end

	-- don't show score in racemode, as it's time, and doesn't fit, and racemode needs love :)
	if gameMode.shortName == "race" then
		deltaScore = "-";
	end

	-- set light/dark text color based on adaptive luminance
	local a = 1 - ( 0.299 * frameColor.r + 0.587 * frameColor.g + 0.114 * frameColor.b) / 255;

	if (a < 0.5) then
		textColor = Color(0,0,0,255);
	else
		textColor = Color(255,255,255,255);
	end

	return textColor, frameColor, deltaScore;
end

--------------------------------------------------------------------------------
local function GetTimeColorAndText()
	local localPlayer = getLocalPlayer();
	local gameMode = gamemodes[world.gameModeIndex];
	local frameColor = Color(0,0,0,64);
	local textColor = Color(255,255,255,255);
	local text = "";
	local size = 52;

	if (world.gameState == GAME_STATE_ACTIVE) or (world.gameState == GAME_STATE_ROUNDACTIVE) then

		if countDirectionUpPref then
			timeRemaining = world.gameTime;
		else
			timeRemaining = world.gameTimeLimit - world.gameTime;
		end

		if timeRemaining < 0 then
			timeRemaining = 0;
		end;

		local t = FormatTime(timeRemaining);
		local lowTime = 30000; -- in milliseconds

		if timeRemaining > 5940000 then
			text = string.format("-"); -- if time left is over 99 minutes show a - instead
		elseif timeRemaining > lowTime and gameMode.shortName == "1v1" and localPlayer.state == PLAYER_STATE_INGAME and cPMStylePref then
			text = string.format("%d:××", t.minutes); --only show the cpm style xx if we are playing in a 1v1 and 30 seconds is not remaining and were in game and the user setting is enabled.
		else
			text = string.format("%d:%02d", t.minutes, t.seconds);
		end;

--TODO FIX the 30 seconds XX doesnt work on count up!

		if timeRemaining < lowTime then
			frameColor = Color(200,0,0,64);
			textColor = Color(255,255,255,255);
		end;

	else
		text = "Warmup";
		size = 36;
	end;

	return textColor, frameColor, text, size;
end;

--------------------------------------------------------------------------------
function MCPMClock:draw()

	-- Early out if HUD shouldn't be shown.
	if not shouldShowHUD() then return end;
	local user = self.userData
	countDirectionUpPref = user.countDirectionUpPref
	cPMStylePref = user.cPMStylePref

	local timeColor, timeFrameColor, timeText, timeSize = GetTimeColorAndText();
	local deltaColor, deltaFrameColor, deltaText = GetDeltaColorAndText();

	local fontSize = 52;
	local frameX = 0;
	local frameY = 0;

	-- background time
	nvgBeginPath();
	nvgRect(-fontSize*1.5, 0, fontSize * 2, fontSize);
	nvgFillColor(timeFrameColor);
	nvgFill();

	-- background delta
	nvgBeginPath();
	nvgRect(fontSize*.5, 0, fontSize, fontSize);
	nvgFillColor(deltaFrameColor);
	nvgFill();

	-- Text
	nvgFontFace("TitilliumWeb-Bold");
	nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
	nvgFontBlur(0);

	nvgFontSize(timeSize);
	nvgFillColor(timeColor);
	nvgText(-fontSize*.5, fontSize*.5, timeText);

	nvgFontSize(fontSize);
	nvgFillColor(deltaColor);
	nvgText(fontSize, fontSize*.5, deltaText);
end;
