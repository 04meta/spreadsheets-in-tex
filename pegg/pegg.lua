closures = dofile("dow.lua")
date = os.time({year=2023, month=9, day=29})
base = 1977326743 -- 7^11
increment = base * 100 -- closures["2023-09-29"] ends in a 0
value = 20000000000000 - increment -- start on the day before the R era
current_date = os.time()

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
until date >= current_date
