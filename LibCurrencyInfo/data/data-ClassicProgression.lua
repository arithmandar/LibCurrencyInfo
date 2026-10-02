--[[
Name: LibCurrencyInfo
Revision: $Rev: 88 $
Maintainers: Arith
Website: https://www.wowace.com/projects/libcurrencyinfo
Dependencies: None
License: MIT

This library provide the ability to get currency's corresponding category, 
get currency category's localized name, and get currency's description if available. 
It will also returtn the info for those you can get from GetCurrencyInfo, that way 
you only need to call one function to get everything you want.
]]
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

-- Functions
local _G = getfenv(0)
local GetBuildInfo = _G.GetBuildInfo

-- Determine WoW client family
local _, _, _, interfaceVersion = GetBuildInfo()
local projectID = WOW_PROJECT_ID

local PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local PROJECT_CLASSIC = WOW_PROJECT_CLASSIC
local PROJECT_TBC = WOW_PROJECT_BURNING_CRUSADE_CLASSIC
local PROJECT_CATA = WOW_PROJECT_CATACLYSM_CLASSIC
local PROJECT_MISTS = WOW_PROJECT_MISTS_CLASSIC

-- Beta-only fallback:
-- Replace these bounds with values verified from the actual Forever client.
local isForeverBeta = projectID == PROJECT_MAINLINE and interfaceVersion >= 10000 and interfaceVersion < 20000

local isRetail = projectID == PROJECT_MAINLINE and not isForeverBeta
local isClassicEra = projectID == PROJECT_CLASSIC
local isAnniversaryTBC = PROJECT_TBC ~= nil and projectID == PROJECT_TBC
local isCataclysmClassic = PROJECT_CATA ~= nil and projectID == PROJECT_CATA
local isMistsClassic = PROJECT_MISTS ~= nil and projectID == PROJECT_MISTS
local isProgressionClassic = isCataclysmClassic or isMistsClassic
local isClassicForever = isForeverBeta
local isAnyClassic = isClassicEra or isAnniversaryTBC or isProgressionClassic or isClassicForever

if (isProgressionClassic) then
	local data = {}

	data.CurrencyCategories = {
		[1] = { enUS="Miscellaneous",deDE="Verschiedenes",esES="Miscelánea",esMX="Miscelánea",frFR="Divers",itIT="Miscellaneous",koKR="기타",ptBR="Diversos",ruRU="Разное",zhCN="其它",zhTW="雜項", },
		[2] = { enUS="Player vs. Player",deDE="Spieler gegen Spieler",esES="Jugador contra Jugador",esMX="Jugador contra Jugador",frFR="JcJ",itIT="Player vs. Player",koKR="플레이어 대 플레이어",ptBR="Jogador x Jogador",ruRU="PvP",zhCN="PvP",zhTW="玩家對玩家", },
		[3] = { enUS="Unused",deDE="Unbenutzt",esES="No las uso",esMX="No las uso",frFR="Inutilisées",itIT="Unused",koKR="미사용",ptBR="Não usado",ruRU="Неактивно",zhCN="未使用",zhTW="未使用", hide=true, },
		[4] = { enUS="Classic",deDE="Classic",esES="Clásico",esMX="Clásico",frFR="Classique",itIT="Classic",koKR="오리지널",ptBR="Clássico",ruRU="World of Warcraft",zhCN="经典旧世",zhTW="艾澤拉斯", },
		[21] = { enUS="Wrath of the Lich King",deDE="Wrath of the Lich King",esES="Wrath of the Lich King",esMX="Wrath of the Lich King",frFR="Wrath of the Lich King",itIT="Wrath of the Lich King",koKR="리치 왕의 분노",ptBR="Wrath of the Lich King",ruRU="Wrath of the Lich King",zhCN="巫妖王之怒",zhTW="巫妖王之怒", },
		[22] = { enUS="Dungeon and Raid",deDE="Dungeon und Schlachtzug",esES="Mazmorra y banda",esMX="Calabozo y banda",frFR="Donjons & Raids",itIT="Dungeon and Raid",koKR="던전 및 공격대",ptBR="Masmorras e Raides",ruRU="Подземелья и рейды",zhCN="地下城与团队",zhTW="地城與團隊", },
		[23] = { enUS="Burning Crusade",deDE="Burning Crusade",esES="Burning Crusade",esMX="Burning Crusade",frFR="Burning Crusade",itIT="Burning Crusade",koKR="불타는 성전",ptBR="Burning Crusade",ruRU="Burning Crusade",zhCN="燃烧的远征",zhTW="燃燒的遠征", },
		[41] = { enUS="Test",deDE="Test",esES="Prueba",esMX="Prueba",frFR="Test",itIT="Test",koKR="Test용",ptBR="Teste",ruRU="Test",zhCN="测试",zhTW="測試", hide=true, },
		[81] = { enUS="Cataclysm",deDE="Cataclysm",esES="Cataclysm",esMX="Cataclysm",frFR="Cataclysm",itIT="Cataclysm",koKR="대격변",ptBR="Cataclysm",ruRU="Cataclysm",zhCN="大地的裂变",zhTW="浩劫與重生", },
		[82] = { enUS="Archaeology",deDE="Archäologie",esES="Arqueología",esMX="Arqueología",frFR="Archéologie",itIT="Archaeology",koKR="고고학",ptBR="Arqueologia",ruRU="Археология",zhCN="考古学",zhTW="考古學", },
		[89] = { enUS="Meta",deDE="Meta",esES="Meta",esMX="Meta",frFR="Méta",itIT="Meta",koKR="점수 구분",ptBR="Meta",ruRU="Особое",zhCN="征服点数变量",zhTW="變量", },
		[133] = { enUS="Mists of Pandaria",deDE="Mists of Pandaria",esES="Mists of Pandaria",esMX="Mists of Pandaria",frFR="Mists of Pandaria",itIT="Mists of Pandaria",koKR="판다리아의 안개",ptBR="Mists of Pandaria",ruRU="Mists of Pandaria",zhCN="熊猫人之谜",zhTW="潘達利亞之謎", },
		[247] = { enUS="Player vs. Player",deDE="Spieler gegen Spieler",esES="Jugador contra Jugador",esMX="Jugador contra Jugador",frFR="Joueur contre Joueur",itIT="Player vs. Player",koKR="플레이어 대 플레이어",ptBR="Jogador x Jogador",ruRU="Режим PvP",zhCN="PvP",zhTW="玩家對玩家", },
	}

	data.CurrencyByCategory = {
		[1] = { -- Miscellaneous
	--		1, -- Currency Token Test Token 4
	--		2, -- Currency Token Test Token 2
	--		4, -- Currency Token Test Token 5
			42, -- Badge of Justice
			61, -- Dalaran Jewelcrafter's Token
			81, -- Epicurean's Award
			241, -- Champion's Seal
			402, -- Ironpaw Token
			416, -- Mark of the World Tree
			515, -- Darkmoon Prize Ticket
			3097, -- Emblem of Homecoming
			3311, -- Emblem of Final Stand
		},
		[2] = { -- Player vs. Player
	--		103, -- 
	--		104, -- Honor Points DEPRECATED
			121, -- Alterac Valley Mark of Honor
			122, -- Arathi Basin Mark of Honor
			123, -- Eye of the Storm Mark of Honor
			124, -- Strand of the Ancients Mark of Honor
			125, -- Warsong Gulch Mark of Honor
			126, -- Wintergrasp Mark of Honor
			161, -- Stone Keeper's Shard
	--		181, -- Honor Points DEPRECATED2
			201, -- Venture Coin
			321, -- Isle of Conquest Mark of Honor
			390, -- Conquest Points
			391, -- Tol Barad Commendation
	--		392, -- Honor Deprecated 3
			1900, -- Arena Points
			1901, -- Honor Points
		},
		[22] = { -- Dungeon and Raid
			101, -- Emblem of Heroism
			102, -- Emblem of Valor
			221, -- Emblem of Conquest
			301, -- Emblem of Triumph
			341, -- Emblem of Frost
			395, -- Justice Points
			396, -- Valor Points
			614, -- Mote of Darkness
			615, -- Essence of Corrupted Deathwing
			2589, -- Sidereal Essence
			2711, -- Defiler's Scourgestone
			3148, -- Fissure Stone Fragment
			3281, -- Obsidian Fragment
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
			384, -- Dwarf Archaeology Fragment
			385, -- Troll Archaeology Fragment
			393, -- Fossil Archaeology Fragment
			394, -- Night Elf Archaeology Fragment
			397, -- Orc Archaeology Fragment
			398, -- Draenei Archaeology Fragment
			399, -- Vrykul Archaeology Fragment
			400, -- Nerubian Archaeology Fragment
			401, -- Tol'vir Archaeology Fragment
			676, -- Pandaren Archaeology Fragment
			677, -- Mogu Archaeology Fragment
			754, -- Mantid Archaeology Fragment
		},
		[89] = { -- Meta
			483, -- Conquest Arena Meta
			484, -- Conquest BG Meta
			692, -- Conquest Random BG Meta
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
		[1] = { id=1, category=1, hide=true }, -- Currency Token Test Token 4, Miscellaneous
		[2] = { id=2, category=1, hide=true }, -- Currency Token Test Token 2, Miscellaneous
		[4] = { id=4, category=1, hide=true }, -- Currency Token Test Token 5, Miscellaneous
		[42] = { id=42, category=1 }, -- Badge of Justice, Miscellaneous
		[61] = { id=61, category=1 }, -- Dalaran Jewelcrafter's Token, Miscellaneous
		[81] = { id=81, category=1 }, -- Epicurean's Award, Miscellaneous
		[101] = { id=101, category=22 }, -- Emblem of Heroism, Dungeon and Raid
		[102] = { id=102, category=22 }, -- Emblem of Valor, Dungeon and Raid
		[103] = { id=103, category=2, hide=true }, -- , Player vs. Player
		[104] = { id=104, category=2, hide=true }, -- Honor Points DEPRECATED, Player vs. Player
		[121] = { id=121, category=2 }, -- Alterac Valley Mark of Honor, Player vs. Player
		[122] = { id=122, category=2 }, -- Arathi Basin Mark of Honor, Player vs. Player
		[123] = { id=123, category=2 }, -- Eye of the Storm Mark of Honor, Player vs. Player
		[124] = { id=124, category=2 }, -- Strand of the Ancients Mark of Honor, Player vs. Player
		[125] = { id=125, category=2 }, -- Warsong Gulch Mark of Honor, Player vs. Player
		[126] = { id=126, category=2 }, -- Wintergrasp Mark of Honor, Player vs. Player
		[161] = { id=161, category=2 }, -- Stone Keeper's Shard, Player vs. Player
		[181] = { id=181, category=2, hide=true }, -- Honor Points DEPRECATED2, Player vs. Player
		[201] = { id=201, category=2 }, -- Venture Coin, Player vs. Player
		[221] = { id=221, category=22 }, -- Emblem of Conquest, Dungeon and Raid
		[241] = { id=241, category=1 }, -- Champion's Seal, Miscellaneous
		[301] = { id=301, category=22 }, -- Emblem of Triumph, Dungeon and Raid
		[321] = { id=321, category=2 }, -- Isle of Conquest Mark of Honor, Player vs. Player
		[341] = { id=341, category=22 }, -- Emblem of Frost, Dungeon and Raid
		[361] = { id=361, category=81 }, -- Illustrious Jewelcrafter's Token, Cataclysm
		[384] = { id=384, category=82 }, -- Dwarf Archaeology Fragment, Archaeology
		[385] = { id=385, category=82 }, -- Troll Archaeology Fragment, Archaeology
		[390] = { id=390, category=2 }, -- Conquest Points, Player vs. Player
		[391] = { id=391, category=2 }, -- Tol Barad Commendation, Player vs. Player
		[392] = { id=392, category=2, hide=true }, -- Honor Deprecated 3, Player vs. Player
		[393] = { id=393, category=82 }, -- Fossil Archaeology Fragment, Archaeology
		[394] = { id=394, category=82 }, -- Night Elf Archaeology Fragment, Archaeology
		[395] = { id=395, category=22 }, -- Justice Points, Dungeon and Raid
		[396] = { id=396, category=22 }, -- Valor Points, Dungeon and Raid
		[397] = { id=397, category=82 }, -- Orc Archaeology Fragment, Archaeology
		[398] = { id=398, category=82 }, -- Draenei Archaeology Fragment, Archaeology
		[399] = { id=399, category=82 }, -- Vrykul Archaeology Fragment, Archaeology
		[400] = { id=400, category=82 }, -- Nerubian Archaeology Fragment, Archaeology
		[401] = { id=401, category=82 }, -- Tol'vir Archaeology Fragment, Archaeology
		[402] = { id=402, category=1 }, -- Ironpaw Token, Miscellaneous
		[416] = { id=416, category=1 }, -- Mark of the World Tree, Miscellaneous
		[483] = { id=483, category=89 }, -- Conquest Arena Meta, Meta
		[484] = { id=484, category=89 }, -- Conquest BG Meta, Meta
		[515] = { id=515, category=1 }, -- Darkmoon Prize Ticket, Miscellaneous
		[614] = { id=614, category=22 }, -- Mote of Darkness, Dungeon and Raid
		[615] = { id=615, category=22 }, -- Essence of Corrupted Deathwing, Dungeon and Raid
		[676] = { id=676, category=82 }, -- Pandaren Archaeology Fragment, Archaeology
		[677] = { id=677, category=82 }, -- Mogu Archaeology Fragment, Archaeology
		[692] = { id=692, category=89 }, -- Conquest Random BG Meta, Meta
		[697] = { id=697, category=133 }, -- Elder Charm of Good Fortune, Mists of Pandaria
		[698] = { id=698, category=81 }, -- Zen Jewelcrafter's Token, Cataclysm
		[738] = { id=738, category=133 }, -- Lesser Charm of Good Fortune, Mists of Pandaria
		[752] = { id=752, category=133 }, -- Mogu Rune of Fate, Mists of Pandaria
		[754] = { id=754, category=82 }, -- Mantid Archaeology Fragment, Archaeology
		[776] = { id=776, category=133 }, -- Warforged Seal, Mists of Pandaria
		[777] = { id=777, category=133 }, -- Timeless Coin, Mists of Pandaria
		[789] = { id=789, category=133 }, -- Bloody Coin, Mists of Pandaria
		[1900] = { id=1900, category=2 }, -- Arena Points, Player vs. Player
		[1901] = { id=1901, category=2 }, -- Honor Points, Player vs. Player
		[2589] = { id=2589, category=22 }, -- Sidereal Essence, Dungeon and Raid
		[2711] = { id=2711, category=22 }, -- Defiler's Scourgestone, Dungeon and Raid
		[3097] = { id=3097, category=1 }, -- Emblem of Homecoming, Miscellaneous
		[3148] = { id=3148, category=22 }, -- Fissure Stone Fragment, Dungeon and Raid
		[3281] = { id=3281, category=22 }, -- Obsidian Fragment, Dungeon and Raid
		[3311] = { id=3311, category=1 }, -- Emblem of Final Stand, Miscellaneous
		[3350] = { id=3350, category=22 }, -- August Stone Fragment, Dungeon and Raid
		[3407] = { id=3407, category=22 }, -- Platinum Coins, Dungeon and Raid
		[3414] = { id=3414, category=22 }, -- August Stone Shard, Dungeon and Raid
		[3416] = { id=3416, category=22 }, -- August Stone Cluster, Dungeon and Raid
	}

	private.data = data
end

