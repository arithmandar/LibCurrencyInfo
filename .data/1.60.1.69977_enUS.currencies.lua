	data.CurrencyByCategory = {
		[1] = { -- Miscellaneous
			515, -- Darkmoon Prize Ticket
		},
		[2] = { -- Player vs. Player
			1792, -- Honor Points
			3468, -- Rank Points
		},
		[22] = { -- Dungeon and Raid
			3469, -- Tarnished Undermine Real
		},
		[142] = { -- Hidden
			3473, -- Renown - PvP Rank
	--		3485, -- Renown - Legacy Rank
			3498, -- [DNT] Class Talent Reset
			3499, -- [DNT] Legacy Talent Reset
		},
		[273] = { -- Professions & Tradeskills
			3402, -- Merchant's Favor
		},
	}

	data.Currencies = {
		[515] = { id=515, category=1 }, -- Darkmoon Prize Ticket, Miscellaneous
		[1792] = { id=1792, category=2 }, -- Honor Points, Player vs. Player
		[3402] = { id=3402, category=273 }, -- Merchant's Favor, Professions & Tradeskills
		[3468] = { id=3468, category=2 }, -- Rank Points, Player vs. Player
		[3469] = { id=3469, category=22 }, -- Tarnished Undermine Real, Dungeon and Raid
		[3473] = { id=3473, category=142 }, -- Renown - PvP Rank, Hidden
		[3485] = { id=3485, category=142, hide=true }, -- Renown - Legacy Rank, Hidden
		[3498] = { id=3498, category=142 }, -- [DNT] Class Talent Reset, Hidden
		[3499] = { id=3499, category=142 }, -- [DNT] Legacy Talent Reset, Hidden
	}
