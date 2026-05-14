rating_table = {
	F=40, D=50, C=60, B=70,
	A=80, ["A+"]=90, AA=100, ["AA+"]=105,
	AAA=110, ["AAA+"]=115,
	S=120, ["S+"]=126, SS=132, ["SS+"]=138,
	SSS=144, ["SSS+"]=150,
}

tier_names = {
	-- short translations for the co-op tier names.
	-- I'd leave them as is but that'd involve figuring out how to get TeX to actually render the words
	["입문"] = "Intro",
	["하"] = "Low",
	["중하"] = "Low-Mid",
	["중"] = "Mid",
	["중상"] = "Mid-High",
	["상"] = "High",
	["최상"] = "Very High",
	["보스"] = "Boss",
	["회전"] = "Spin",
}

my_scores = {
	D19 = {
		["Get Up (and go)"]={rank="AAA+", xx=true},
		["Jonathan's Dream"]={rank="AAA", xx=true},
		Overblow={rank="AAA"},
		Desaparecer={rank="AAA", xx=true},
		Mopemope={rank="AA+", xx=true},
		["King of Sales"]={xx=true}, -- I have HJ and a 3-miss on this but since the chart's gone in Phoenix I can't give it a Phoenix grade
		["Papa Gonzales"]={rank="AA"}, -- AA+ in XX
		["The Revolution"]={rank="AA"}, -- I *think* I just forgot to mark this as XX? it has no hold-tick changes in Phoenix, but it's not on my card
		["Pump me Amadeus"]={rank="A+"},
		["CO5MIC R4ILR0AD"]={rank="AA", xx=true}, -- of course, the song doesn't exist in XX, but .xx now has the legacy meaning of "not on my card" and this was done on SP1+
		["Pop Sequence"]={rank="AAA", xx=true}, -- how did I not realize earlier that this one existed, I even watched stepzwa's video about Phoenix removing charts like the D22
		["Witch Doctor"]={rank="AA", xx=true},
	},
	S20 = {
		["8 6"]={rank="SS", xx=true},
		Overblow={rank="AA+"},
		["X-Tree"]={rank="AA+", xx=true},
		Desaparecer={rank="AA", xx=true},
		GLORIA={rank="AA", xx=true},
		["Vacuum Cleaner"]={rank="A+", xx=true},
		Winter={rank="A+", xx=true}, -- also a 19 in XX
		["Mr. Larpus"]={rank="A+", xx=true},
	},
	D20 = {
		STAGER={rank="AAA"},
		Accident={rank="AA+"},
		Gargoyle={rank="A+"},
		Moonlight={rank="AA", xx=true},
		Tepris={rank="AA", xx=true}, -- I have an HJ clear on this with 19 gauge (because it's D19 in XX). that's... something?
		["DJ Otada"]={xx=true},
		Cleaner={rank="AAA", xx=true},
		["Vacuum Cleaner"]={rank="AA+", xx=true},
		["X-Tree"]={rank="A+", xx=true}, -- 899397 is still A+ :(
		["Pumptris Quattro"]={rank="AA+", xx=true},
		["Baroque Virus - FULL SONG"]={rank="AA+", xx=true},
		["Full Moon"]={rank="AA", xx=true},
	},
	S21 = {
		["Gargoyle - FULL SONG"]={rank="AA+", xx=true}, -- EXC's chart
		Paradoxx={rank="A+", xx=true},
		["Beethoven Virus"]={rank="A+", xx=true}, -- XX chart, with runs instead of spins
	},
	D21 = {
		["Twist of Fate"]={rank="AA+"},
	},
}

my_coop_scores = {
	-- actually, the tier list *is* important for co-ops, though...
	-- also unlike the others, this includes only scores actually on my card
	Campanella={tier="입문", rank="AAA+"},
	["Pumptris 8Bit ver."]={tier="하", rank="AAA+"},
	Chimera={tier="하", rank="AA+"},
	["You again my love"]={tier="입문", rank="AA+"},
}

function stylechart(style, diff, dry_run)
	local base = 100 + 5 * (diff - 10) * (diff - 9)
	local key = style .. diff
	local scores = my_scores[key]
	local total_rating = 0
	if not dry_run then tex.print("\\frenchspacing\\begin{tabular}{r l c r}") end
	for song, score in pairs(scores) do
		local rating = (base * rating_table[score.rank or "A"] + 50) // 100
		if not dry_run then
			tex.write(song)
			tex.print("& " .. key .. " & " .. (score.rank or "?") .. " & " .. rating .. "\\\\")
		end
		total_rating = total_rating + rating
	end
	if not dry_run then
		tex.print("\\hline")
		tex.print("Total & & & " .. total_rating)
		tex.print("\\end{tabular}\\nonfrenchspacing")
	end
	tex.setcount("totalrating", total_rating)
end

function singlechart(diff, dry_run) return stylechart("S", diff, dry_run) end
function doublechart(diff, dry_run) return stylechart("D", diff, dry_run) end

function fullchart(diff, dry_run)
	local base = 100 + 5 * (diff - 10) * (diff - 9)
	local scores = {}
	for song, score in pairs(my_scores["S" .. diff]) do
		score.song = song; score.diff = "S" .. diff
		table.insert(scores, score)
	end
	for song, score in pairs(my_scores["D" .. diff]) do
		score.song = song; score.diff = "D" .. diff
		table.insert(scores, score)
	end
	local total_rating = 0
	if not dry_run then tex.print("\\frenchspacing\\begin{tabular}{r l c r}") end
	for _, score in pairs(scores) do
		local rating = (base * rating_table[score.rank or "A"] + 50) // 100
		if not dry_run then
			tex.write(score.song)
			tex.print("& " .. score.diff .. " & " .. (score.rank or "?") .. " & " .. rating .. "\\\\")
		end
		total_rating = total_rating + rating
	end
	if not dry_run then
		tex.print("\\hline")
		tex.print("Total & & & " .. total_rating)
		tex.print("\\end{tabular}\\nonfrenchspacing")
	end
	tex.setcount("totalrating", total_rating)
end

function coopchart(dry_run)
	local base = 2000
	local total_rating = 0
	if not dry_run then tex.print("\\frenchspacing\\begin{tabular}{r c c r}") end
	for song, score in pairs(my_coop_scores) do
		local rating = (base * rating_table[score.rank or "A"] + 50) // 100
		if not dry_run then
			tex.write(song)
			tex.print("& " .. tier_names[score.tier] .. " & " .. (score.rank or "?") .. " & " .. rating .. "\\\\")
		end
		total_rating = total_rating + rating
	end
	if not dry_run then
		tex.print("\\hline")
		tex.print("Total & & & " .. total_rating)
		tex.print("\\end{tabular}\\nonfrenchspacing")
	end
	tex.setcount("totalrating", total_rating)
end
