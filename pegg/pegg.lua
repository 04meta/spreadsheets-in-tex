closures = dofile("dow.lua")
date = os.time({year=2023, month=9, day=29})
base = 1977326743 -- 7^11
increment = base * 100 -- closures["2023-09-29"] ends in a 0
value = 20000000000000 - increment -- start on the day before the R era
latest_data = os.time(closures.latest_data)

function is_closed(date)
	--[[
		calculates whether the DJIA won't have a new closure on this date,
		which happens on weekends and on certain holidays.
		this is required to calculate the uncertainty for future values,
		as just adding up the variance only works if everything is independent.
		
		does not account for 2025-01-09, when the market was closed
		for the purpose of mourning Jimmy Carter
	]]
	local d = os.date("*t", date)
	if d.wday == 1 or d.wday == 7 then return true end
	
	-- New Year's Day
	if d.month == 1 and d.day == 1 then return true end
	if d.month == 1 and d.day == 2 and d.wday == 2 then return true end
	if d.month == 12 and d.day == 31 and d.wday == 6 then return true end
	
	-- Juneteenth
	if d.month == 6 and d.day == 19 then return true end
	if d.month == 6 and d.day == 20 and d.wday == 2 then return true end
	if d.month == 6 and d.day == 18 and d.wday == 6 then return true end
	
	-- American Independence Day
	if d.month == 7 and d.day == 4 then return true end
	if d.month == 7 and d.day == 5 and d.wday == 2 then return true end
	if d.month == 7 and d.day == 3 and d.wday == 6 then return true end
	
	-- Christmas (secularly)
	if d.month == 12 and d.day == 25 then return true end
	if d.month == 12 and d.day == 26 and d.wday == 2 then return true end
	if d.month == 12 and d.day == 24 and d.wday == 6 then return true end
	
	-- MLK Day, Presidents' Day, Memorial Day, Labor Day, Thanksgiving
	-- these happen on specific days of the week, so there's no
	-- "if it's on a Saturday, use the Friday before it" nonsense
	if d.month <= 2 and 15 <= d.day and d.day <= 21 and d.wday == 2 then return true end
	if d.month == 5 and d.day >= 25 and d.wday == 2 then return true end
	if d.month == 9 and d.day <= 7 and d.wday == 2 then return true end
	if d.month == 11 and 22 <= d.day and d.day <= 28 and d.wday == 5 then return true end
	
	-- only one left is Good Friday
	if d.wday ~= 6 then return false end -- not a Friday
	d = os.date("*t", date + 2*24*60*60) -- use the Sunday after it
	if d.month >= 5 or d.month <= 2 then return false end -- Good Friday never lands in February or May
	local golden_number = d.year % 19 + 1
	local c = (d.year//100)
	local correction = -c + (c//4) + (8*(c+11))//25
	local full_moon = 50 - (11*golden_number+correction)%30
	if full_moon == 49 and golden_number >= 12 then full_moon = 48 end
	if full_moon == 50 then full_moon = 49 end
	if d.month == 4 then full_moon = full_moon - 31 end
	local difference = d.day - full_moon
	return 1 <= difference and difference <= 7
end

repeat
	date = date + 24*60*60
	local key = os.date("%Y-%m-%d", date)
	value = value + increment
	
	tex.write(key)
	tex.print("& R &")
	tex.write(("%.4f"):format(value / 10^13))
	tex.print("&")
	tex.write(("(+%.6f)"):format(increment / 10^13))
	tex.print("\\\\")
	
	if closures[key] then
		increment = math.tointeger((math.floor(closures[key] * 100 + 0.1) % 10)^2 * base)
		if increment == 0 then increment = 100 * base end -- handle 0's properly
	end
until date > latest_data and not is_closed(date)
