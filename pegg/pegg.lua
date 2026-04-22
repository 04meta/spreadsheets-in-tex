closures = dofile("dow.lua")
date = os.time({year=2023, month=9, day=29})
letter = "R"
succession = {R="S", S="T", T="V", V="W", W="X", X="Y", Y="Z"} -- todo: add Æ and Б
base = 1977326743 -- 7^11
increment = base * 100 -- closures["2023-09-29"] ends in a 0
value = 20000000000000 - increment -- start on the day before the R era
denominator = 10000000000000
uncertainty = 0
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
	-- algorithm taken from Winning Ways (Berlekamp, Conway, Guy) chapter 24
	-- honestly, you should get that book anyway, it's peak.
	-- all three of its authors died in 2019 or 2020, RIP
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

function realchart()
	repeat
		date = date + 24*60*60
		local key = os.date("%Y-%m-%d", date)
		value = value + increment
		
		tex.write(key)
		tex.print(("& %s &"):format(letter))
		tex.write(("%.4f"):format(value / denominator))
		tex.print("&")
		tex.write(("(+%.6f)"):format(increment / denominator))
		tex.print("\\\\")
		
		if closures[key] then
			increment = math.tointeger((math.floor(closures[key] * 100 + 0.1) % 10)^2 * base)
			if increment == 0 then increment = 100 * base end -- handle 0's properly
		end
	until date > latest_data and not is_closed(date)
end

function speculativechart(end_year, end_month, end_day)
	local target = os.time({year=end_year, month=end_month, day=end_day})
	local closed_multiplier = 1 -- goes up with each day closed to account for dependence
	repeat
		date = date + 24*60*60
		local key = os.date("%Y-%m-%d", date)
		value = value + base * 38.5
		uncertainty = uncertainty + (base/denominator)^2 * 1051.05 * closed_multiplier
		if is_closed(date) then
			closed_multiplier = closed_multiplier + 2
		else
			closed_multiplier = 1
		end
		
		if value >= 10 * denominator then
			value = value * 7.0 - 50.0*denominator
			uncertainty = uncertainty * 0.49
			denominator = denominator * 10.0
			base = base * 7.0
			letter = succession[letter]
		end
		
		tex.write(key)
		tex.print(("& %s &"):format(letter))
		tex.write(("%.4f"):format(value / denominator))
		tex.print("& \\pm &")
		tex.write(("%.4f"):format(math.sqrt(uncertainty)))
		tex.print("\\\\")
	until date >= target
end
