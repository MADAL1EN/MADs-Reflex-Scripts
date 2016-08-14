require "base/internal/ui/reflexcore"

Date_and_Time = {
	canPosition = true;
};
function ifFunc(k,str,str1)
	if k == 0 then return "" end
	return str .. k .. (str1 or "")
end
local tabIndexOverflow = function(seed, table) -- function "borrowed from stackoverflow"
	-- This subtracts values from the table from seed until an overflow :thinking:
	for i = 1, #table do
		if seed - table[i] <= 0 then
			return i, seed
		end;
		seed = seed - table[i]
	end;
end;

function clampToNoDecimal(n)
	return math.floor(n * 1) / 1;
end;

--Number to Ordinal (Thanks Quelax)
local function getNumericOrdinal(number)
	local d1 = number % 10
	local d2 = (number % 100 - d1)/10
	if number <= 0 then
		return tostring(number)
	elseif d1 == 1 and d2 ~= 1 then
		return string.format("%dst", number)
	elseif d1 == 2 and d2 ~= 1 then
		return string.format("%dnd", number)
	elseif d1 == 3 and d2 ~= 1 then
		return string.format("%drd", number)
	else
		return string.format("%dth", number)
	end
end

function Date_and_Time:initialize()
	self.userData = loadUserData();
	CheckSetDefaultValue(self, "userData", "table", {});
	CheckSetDefaultValue(self.userData, "UDTpref", "number", 0);
	CheckSetDefaultValue(self.userData, "DSTpref", "boolean", false);
	CheckSetDefaultValue(self.userData, "MilitaryTime", "boolean", false);
	CheckSetDefaultValue(self.userData, "InvertColours", "boolean", false);
end;

function Date_and_Time:drawOptions(x, y, intensity)
	local optargs = {};
	optargs.intensity = intensity;

	local user = self.userData;
	local sliderWidth = 200;
	local sliderStart = 140;

	user.InvertColours = ui2RowCheckbox(x, y, WIDGET_PROPERTIES_COL_INDENT, "Invert Colours", user.InvertColours, optargs);

	local y = y + 60;
	user.DSTpref = ui2RowCheckbox(x, y, WIDGET_PROPERTIES_COL_INDENT, "Daylight Savings Time", user.DSTpref, optargs);

	local y = y + 60;
	user.MilitaryTime = ui2RowCheckbox(x, y, WIDGET_PROPERTIES_COL_INDENT, "Military Time", user.MilitaryTime, optargs);

	local y = y + 60;
	user.UDTpref = ui2RowSliderEditBox0Decimals(x, y, WIDGET_PROPERTIES_COL_INDENT, WIDGET_PROPERTIES_COL_WIDTH, 80, "Time Zone", 	user.UDTpref, -12, 14, optargs);

	saveUserData(user);
end


--==============================================================================
--TODO
-- Add toggle background/frame option
-- Add option to change ordering maybe?
--==============================================================================



registerWidget("Date_and_Time")
function Date_and_Time:draw()
	if replayName == "menu" or isInMenu() then -- Only draw when menu open
		local user = self.userData;

		local TTC = user.InvertColours;

		if TTC then timeTextColor = Color(255,255,255,255);
		else timeTextColor = Color(0,0,0,255);
		end;


		local isMilTime = user.MilitaryTime;
		local DST = user.DSTpref;
		local UDT = user.UDTpref;


		if DST then DSTp = 1;
		else DSTp = 0;
		end;

--epochTimeAdjusted = epochTime + (user.UDTpref + DSTp)

		local milHours = math.floor(((epochTime / 3600 + (user.UDTpref + DSTp)) % 24));
		local hours = math.floor(((epochTime / 3600 + (UDT + DSTp)) % 12));
		local min =  math.floor((epochTime % 3600) / 60);
		local sec = math.floor((epochTime % 3600) % 60);
		local dayCount, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(epochTime/86400) --Leap years
		while days >= dayCount(year) do days = days - dayCount(year) year = year + 1
		end; -- Calculate year and days into that year


		local month, days = tabIndexOverflow(days, {31,(dayCount(year) == 366 and 29 or 28),31,30,31,30,31,31,30,31,30,31}); -- Subtract from days to find current month and leftover days
		local hours = hours > 12 and hours - 12 or hours == 0 and 12 or hours; -- Change to proper am or pm time


		if milHours >= 12
		then period = "pm";
		else period = "am";
		end;


		-- Format time with zeros
		if isMilTime then
			timestr = ("%02d:%02d:%02d"):format(milHours,min,sec);
		else
			timestr = ("%2d:%02d:%02d %s"):format(hours,min,sec,period);
		end;

		local DSEC=24*60*60; --How many seconds in a day?
		local BASE_DOW = 4; --Day of the week offset
		local dayOfTheWeek= math.ceil(((epochTime/DSEC)+BASE_DOW)%7);

		local longDays = {
			"Sunday",
			"Monday",
			"Tuesday",
			"Wednesday",
			"Thursday",
			"Friday",
			"Saturday",
		};

		local longMonths = {
			"January",
			"Febuary",
			"March",
			"April",
			"May",
			"June",
			"July",
			"August",
			"September",
			"October",
			"November",
			"December"
		};

		--[[
		local frameColor = Color(0,0,0,128);
		local frameWidth = 450;
		local frameHeight = 35;
		local fontSize = frameHeight * 1.15;
		-- Frame
		nvgBeginPath();
		nvgRoundedRect(-frameWidth/2, -frameHeight/2, frameWidth, frameHeight, 5);
		nvgFillColor(frameColor);
		nvgFill();
		--]]

		-- Text
		nvgFontBlur(0.325);
		nvgFontFace(FONT_TEXT2);
		nvgFontSize(40);
		nvgFillColor(timeTextColor);
		nvgTextAlign(NVG_ALIGN_CENTER,NVG_ALIGN_MIDDLE);
		nvgText(0,0,(longDays[dayOfTheWeek] .. ", " .. longMonths[month] .. ", " .. getNumericOrdinal(days) .. ", " .. timestr));
	end;
end
