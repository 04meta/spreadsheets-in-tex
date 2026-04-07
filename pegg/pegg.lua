closures = dofile("dow.lua")
date = {year=2023, month=9, day=29}
base = 1977326743 -- 7^11
increment = base * 100 -- closures["2023-09-29"] ends in a 0
value = 20000000000000 - increment -- start on the day before the R era
current_date = os.date("%Y-%m-%d")

function days_per_month(year, month)
	if month == 9 or month == 4 or month == 6 or month == 11 then return 30 end
	if month ~= 2 then return 31 end
	if year % 400 == 0 then return 29 end
	if year % 100 == 0 then return 28 end -- yes, this is a rule and has been since somewhere between 1582 and 1923
	if year % 4 == 0 then return 29 end
	return 28
end

function next_date(date)
	if date.day ~= days_per_month(date.year, date.month) then
		date.day = date.day + 1
		return
	end
	date.day = 1
	if date.month ~= 12 then
		date.month = date.month + 1
	else
		date.month = 1
		date.year = date.year + 1
	end
end

function date_to_key(date)
	return ("%04d-%02d-%02d"):format(date.year, date.month, date.day)
end

repeat
	next_date(date)
	local key = date_to_key(date)
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
until key == current_date