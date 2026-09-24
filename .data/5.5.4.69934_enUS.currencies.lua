	data.CurrencyByCategory = {
		[1] = { -- Miscellaneous
			1, -- Currency Token Test Token 4
	--		2, -- Currency Token Test Token 2
	--		4, -- Currency Token Test Token 5
	--		42, -- Badge of Justice
			61, -- Dalaran Jewelcrafter's Token
			81, -- Epicurean's Award
			241, -- Champion's Seal
			402, -- Ironpaw Token
			416, -- Mark of the World Tree
			515, -- Darkmoon Prize Ticket
	--		3097, -- Emblem of Homecoming
	--		3311, -- Emblem of Final Stand
		},
		[2] = { -- Player vs. Player
	--		103, -- 
			104, -- Honor Points DEPRECATED
	--		121, -- Alterac Valley Mark of Honor
	--		122, -- Arathi Basin Mark of Honor
	--		123, -- Eye of the Storm Mark of Honor
	--		124, -- Strand of the Ancients Mark of Honor
	--		125, -- Warsong Gulch Mark of Honor
	--		126, -- Wintergrasp Mark of Honor
	--		161, -- Stone Keeper's Shard
			181, -- Honor Points DEPRECATED2
	--		201, -- Venture Coin
	--		321, -- Isle of Conquest Mark of Honor
			390, -- Conquest Points
			391, -- Tol Barad Commendation
			392, -- Honor Deprecated 3
			1900, -- Arena Points
			1901, -- Honor Points
		},
		[22] = { -- Dungeon and Raid
	--		101, -- Emblem of Heroism
	--		102, -- Emblem of Valor
	--		221, -- Emblem of Conquest
	--		301, -- Emblem of Triumph
	--		341, -- Emblem of Frost
			395, -- Justice Points
			396, -- Valor Points
			614, -- Mote of Darkness
			615, -- Essence of Corrupted Deathwing
	--		2589, -- Sidereal Essence
	--		2711, -- Defiler's Scourgestone
	--		3148, -- Fissure Stone Fragment
	--		3281, -- Obsidian Fragment
			3350, -- August Stone Fragment
			3407, -- Platinum Coins
			3414, -- August Stone Shard
			3416, -- August Stone Cluster
		},
		[81] = { -- Cataclysm
			361, -- Illustrious Jewelcrafter's Token
			698, -- Zen Jewelcrafter's Token
		},
		[82] = { -- Archaeology
	--		384, -- Dwarf Archaeology Fragment
	--		385, -- Troll Archaeology Fragment
	--		393, -- Fossil Archaeology Fragment
	--		394, -- Night Elf Archaeology Fragment
	--		397, -- Orc Archaeology Fragment
	--		398, -- Draenei Archaeology Fragment
	--		399, -- Vrykul Archaeology Fragment
	--		400, -- Nerubian Archaeology Fragment
	--		401, -- Tol'vir Archaeology Fragment
	--		676, -- Pandaren Archaeology Fragment
	--		677, -- Mogu Archaeology Fragment
	--		754, -- Mantid Archaeology Fragment
		},
		[89] = { -- Meta
	--		483, -- Conquest Arena Meta
	--		484, -- Conquest BG Meta
	--		692, -- Conquest Random BG Meta
		},
		[133] = { -- Mists of Pandaria
			697, -- Elder Charm of Good Fortune
			738, -- Lesser Charm of Good Fortune
			752, -- Mogu Rune of Fate
			776, -- Warforged Seal
			777, -- Timeless Coin
			789, -- Bloody Coin
		},
	}

	data.Currencies = {
		[1] = { id=1, category=1 }, -- Currency Token Test Token 4, Miscellaneous
		[2] = { id=2, category=1, hide=true }, -- Currency Token Test Token 2, Miscellaneous
		[4] = { id=4, category=1, hide=true }, -- Currency Token Test Token 5, Miscellaneous
		[42] = { id=42, category=1, hide=true }, -- Badge of Justice, Miscellaneous
		[61] = { id=61, category=1 }, -- Dalaran Jewelcrafter's Token, Miscellaneous
		[81] = { id=81, category=1 }, -- Epicurean's Award, Miscellaneous
		[101] = { id=101, category=22, hide=true }, -- Emblem of Heroism, Dungeon and Raid
		[102] = { id=102, category=22, hide=true }, -- Emblem of Valor, Dungeon and Raid
		[103] = { id=103, category=2, hide=true }, -- , Player vs. Player
		[104] = { id=104, category=2 }, -- Honor Points DEPRECATED, Player vs. Player
		[121] = { id=121, category=2, hide=true }, -- Alterac Valley Mark of Honor, Player vs. Player
		[122] = { id=122, category=2, hide=true }, -- Arathi Basin Mark of Honor, Player vs. Player
		[123] = { id=123, category=2, hide=true }, -- Eye of the Storm Mark of Honor, Player vs. Player
		[124] = { id=124, category=2, hide=true }, -- Strand of the Ancients Mark of Honor, Player vs. Player
		[125] = { id=125, category=2, hide=true }, -- Warsong Gulch Mark of Honor, Player vs. Player
		[126] = { id=126, category=2, hide=true }, -- Wintergrasp Mark of Honor, Player vs. Player
		[161] = { id=161, category=2, hide=true }, -- Stone Keeper's Shard, Player vs. Player
		[181] = { id=181, category=2 }, -- Honor Points DEPRECATED2, Player vs. Player
		[201] = { id=201, category=2, hide=true }, -- Venture Coin, Player vs. Player
		[221] = { id=221, category=22, hide=true }, -- Emblem of Conquest, Dungeon and Raid
		[241] = { id=241, category=1 }, -- Champion's Seal, Miscellaneous
		[301] = { id=301, category=22, hide=true }, -- Emblem of Triumph, Dungeon and Raid
		[321] = { id=321, category=2, hide=true }, -- Isle of Conquest Mark of Honor, Player vs. Player
		[341] = { id=341, category=22, hide=true }, -- Emblem of Frost, Dungeon and Raid
		[361] = { id=361, category=81 }, -- Illustrious Jewelcrafter's Token, Cataclysm
		[384] = { id=384, category=82, hide=true }, -- Dwarf Archaeology Fragment, Archaeology
		[385] = { id=385, category=82, hide=true }, -- Troll Archaeology Fragment, Archaeology
		[390] = { id=390, category=2 }, -- Conquest Points, Player vs. Player
		[391] = { id=391, category=2 }, -- Tol Barad Commendation, Player vs. Player
		[392] = { id=392, category=2 }, -- Honor Deprecated 3, Player vs. Player
		[393] = { id=393, category=82, hide=true }, -- Fossil Archaeology Fragment, Archaeology
		[394] = { id=394, category=82, hide=true }, -- Night Elf Archaeology Fragment, Archaeology
		[395] = { id=395, category=22 }, -- Justice Points, Dungeon and Raid
		[396] = { id=396, category=22 }, -- Valor Points, Dungeon and Raid
		[397] = { id=397, category=82, hide=true }, -- Orc Archaeology Fragment, Archaeology
		[398] = { id=398, category=82, hide=true }, -- Draenei Archaeology Fragment, Archaeology
		[399] = { id=399, category=82, hide=true }, -- Vrykul Archaeology Fragment, Archaeology
		[400] = { id=400, category=82, hide=true }, -- Nerubian Archaeology Fragment, Archaeology
		[401] = { id=401, category=82, hide=true }, -- Tol'vir Archaeology Fragment, Archaeology
		[402] = { id=402, category=1 }, -- Ironpaw Token, Miscellaneous
		[416] = { id=416, category=1 }, -- Mark of the World Tree, Miscellaneous
		[483] = { id=483, category=89, hide=true }, -- Conquest Arena Meta, Meta
		[484] = { id=484, category=89, hide=true }, -- Conquest BG Meta, Meta
		[515] = { id=515, category=1 }, -- Darkmoon Prize Ticket, Miscellaneous
		[614] = { id=614, category=22 }, -- Mote of Darkness, Dungeon and Raid
		[615] = { id=615, category=22 }, -- Essence of Corrupted Deathwing, Dungeon and Raid
		[676] = { id=676, category=82, hide=true }, -- Pandaren Archaeology Fragment, Archaeology
		[677] = { id=677, category=82, hide=true }, -- Mogu Archaeology Fragment, Archaeology
		[692] = { id=692, category=89, hide=true }, -- Conquest Random BG Meta, Meta
		[697] = { id=697, category=133 }, -- Elder Charm of Good Fortune, Mists of Pandaria
		[698] = { id=698, category=81 }, -- Zen Jewelcrafter's Token, Cataclysm
		[738] = { id=738, category=133 }, -- Lesser Charm of Good Fortune, Mists of Pandaria
		[752] = { id=752, category=133 }, -- Mogu Rune of Fate, Mists of Pandaria
		[754] = { id=754, category=82, hide=true }, -- Mantid Archaeology Fragment, Archaeology
		[776] = { id=776, category=133 }, -- Warforged Seal, Mists of Pandaria
		[777] = { id=777, category=133 }, -- Timeless Coin, Mists of Pandaria
		[789] = { id=789, category=133 }, -- Bloody Coin, Mists of Pandaria
		[1900] = { id=1900, category=2 }, -- Arena Points, Player vs. Player
		[1901] = { id=1901, category=2 }, -- Honor Points, Player vs. Player
		[2589] = { id=2589, category=22, hide=true }, -- Sidereal Essence, Dungeon and Raid
		[2711] = { id=2711, category=22, hide=true }, -- Defiler's Scourgestone, Dungeon and Raid
		[3097] = { id=3097, category=1, hide=true }, -- Emblem of Homecoming, Miscellaneous
		[3148] = { id=3148, category=22, hide=true }, -- Fissure Stone Fragment, Dungeon and Raid
		[3281] = { id=3281, category=22, hide=true }, -- Obsidian Fragment, Dungeon and Raid
		[3311] = { id=3311, category=1, hide=true }, -- Emblem of Final Stand, Miscellaneous
		[3350] = { id=3350, category=22 }, -- August Stone Fragment, Dungeon and Raid
		[3407] = { id=3407, category=22 }, -- Platinum Coins, Dungeon and Raid
		[3414] = { id=3414, category=22 }, -- August Stone Shard, Dungeon and Raid
		[3416] = { id=3416, category=22 }, -- August Stone Cluster, Dungeon and Raid
	}
