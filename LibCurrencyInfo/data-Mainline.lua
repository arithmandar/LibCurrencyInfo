--[[
Name: LibCurrencyInfo
Revision: $Rev$
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

-- Beta-only fallback:
-- Replace these bounds with values verified from the actual Forever client.
local isForeverBeta = projectID == PROJECT_MAINLINE and interfaceVersion >= 10000 and interfaceVersion < 20000

local isRetail = projectID == PROJECT_MAINLINE and not isForeverBeta


if (isRetail) then
	local data = {}

	data.CurrencyCategories = {
		[1] = { enUS="Miscellaneous",deDE="Verschiedenes",esES="Miscelánea",esMX="Miscelánea",frFR="Divers",itIT="Varie",koKR="기타",ptBR="Diversos",ruRU="Разное",zhTW="雜項",znCN="其它", },
		[2] = { enUS="Player vs. Player",deDE="Spieler gegen Spieler",esES="Jugador contra Jugador",esMX="Jugador contra Jugador",frFR="JcJ",itIT="Personaggio vs Personaggio",koKR="플레이어 간 전투",ptBR="Jogador x Jogador",ruRU="PvP",zhTW="玩家對玩家",znCN="PvP", },
		[3] = { enUS="Unused",deDE="Unbenutzt",esES="No las uso",esMX="No las uso",frFR="Inutilisées",itIT="Non usato",koKR="미사용",ptBR="Não usado",ruRU="Неактивно",zhTW="未使用",znCN="未使用", hide=true, },
		[4] = { enUS="Classic",deDE="Classic",esES="Clásico",esMX="Clásico",frFR="Classique",itIT="Classico",koKR="오리지널",ptBR="Clássico",ruRU="World of Warcraft",zhTW="艾澤拉斯",znCN="经典旧世", },
		[21] = { enUS="Wrath of the Lich King",deDE="Wrath of the Lich King",esES="Wrath of the Lich King",esMX="Wrath of the Lich King",frFR="Wrath of the Lich King",itIT="Wrath of the Lich King",koKR="리치 왕의 분노",ptBR="Wrath of the Lich King",ruRU="Wrath of the Lich King",zhTW="巫妖王之怒",znCN="巫妖王之怒", },
		[22] = { enUS="Dungeon and Raid",deDE="Dungeon und Schlachtzug",esES="Mazmorra y banda",esMX="Calabozo y banda",frFR="Donjons & Raids",itIT="Spedizioni e Incursioni",koKR="던전 및 공격대",ptBR="Masmorras e Raides",ruRU="Подземелья и рейды",zhTW="地城與團隊",znCN="地下城与团队副本", },
		[23] = { enUS="Burning Crusade",deDE="Burning Crusade",esES="Burning Crusade",esMX="Burning Crusade",frFR="Burning Crusade",itIT="Burning Crusade",koKR="불타는 성전",ptBR="Burning Crusade",ruRU="Burning Crusade",zhTW="燃燒的遠征",znCN="燃烧的远征", },
		[41] = { enUS="Test",deDE="Test",esES="Prueba",esMX="Prueba",frFR="Test",itIT="Prova",koKR="Test용",ptBR="Teste",ruRU="Test",zhTW="測試",znCN="测试", hide=true, },
		[81] = { enUS="Cataclysm",deDE="Cataclysm",esES="Cataclysm",esMX="Cataclysm",frFR="Cataclysm",itIT="Cataclysm",koKR="대격변",ptBR="Cataclysm",ruRU="Cataclysm",zhTW="浩劫與重生",znCN="大地的裂变", },
		[82] = { enUS="Archaeology",deDE="Archäologie",esES="Arqueología",esMX="Arqueología",frFR="Archéologie",itIT="Archeologia",koKR="고고학",ptBR="Arqueologia",ruRU="Археология",zhTW="考古學",znCN="考古学", },
		[89] = { enUS="Meta",deDE="Meta",esES="Meta",esMX="Meta",frFR="Méta",itIT="Meta",koKR="점수 구분",ptBR="Meta",ruRU="Особое",zhTW="變量",znCN="征服点数变量", },
		[133] = { enUS="Mists of Pandaria",deDE="Mists of Pandaria",esES="Mists of Pandaria",esMX="Mists of Pandaria",frFR="Mists of Pandaria",itIT="Mists of Pandaria",koKR="판다리아의 안개",ptBR="Mists of Pandaria",ruRU="Mists of Pandaria",zhTW="潘達利亞之謎",znCN="熊猫人之谜", },
		[137] = { enUS="Warlords of Draenor",deDE="Warlords of Draenor",esES="Warlords of Draenor",esMX="Warlords of Draenor",frFR="Warlords of Draenor",itIT="Warlords of Draenor",koKR="드레노어의 전쟁군주",ptBR="Warlords of Draenor",ruRU="Warlords of Draenor",zhTW="德拉諾之霸",znCN="德拉诺之王", },
		[141] = { enUS="Legion",deDE="Legion",esES="Legion",esMX="Legion",frFR="Legion",itIT="Legion",koKR="군단",ptBR="Legion",ruRU="Legion",zhTW="軍團",znCN="军团再临", },
		[142] = { enUS="Hidden",deDE="Hidden",esES="Hidden",esMX="Hidden",frFR="Hidden",itIT="Nascosto",koKR="Hidden",ptBR="Hidden",ruRU="Hidden",zhTW="Hidden",znCN="Hidden", },
		[143] = { enUS="Battle for Azeroth",deDE="Battle for Azeroth",esES="Battle for Azeroth",esMX="Battle for Azeroth",frFR="Battle for Azeroth",itIT="Battle for Azeroth",koKR="격전의 아제로스",ptBR="Battle for Azeroth",ruRU="Battle for Azeroth",zhTW="決戰艾澤拉斯",znCN="争霸艾泽拉斯", },
		[144] = { enUS="Virtual",deDE="Virtuell",esES="Virtual",esMX="Virtual",frFR="Virtuelle",itIT="Virtuale",koKR="가상",ptBR="Virtual",ruRU="Виртуальная валюта",zhTW="虛擬",znCN="虚拟", },
		[245] = { enUS="Shadowlands",deDE="Shadowlands",esES="Shadowlands",esMX="Shadowlands",frFR="Shadowlands",itIT="Shadowlands",koKR="어둠땅",ptBR="Shadowlands",ruRU="Shadowlands",zhTW="暗影之境",znCN="暗影国度", },
		[246] = { enUS="Debug",deDE="Debug",esES="Depurar",esMX="Debug",frFR="Débogage",itIT="Debug",koKR="디버그",ptBR="Depuração",ruRU="Настройка",zhTW="除蟲",znCN="调试", hide=true, },
		[248] = { enUS="Torghast UI (Hidden)",deDE="Torghast UI (Hidden)",esES="Torghast UI (Hidden)",esMX="Torghast UI (Hidden)",frFR="Torghast UI (Hidden)",itIT="Torghast UI (Hidden)",koKR="Torghast UI (Hidden)",ptBR="Torghast UI (Hidden)",ruRU="Torghast UI (Hidden)",zhTW="Torghast UI (Hidden)",znCN="Torghast UI (Hidden)", },
		[250] = { enUS="Dragonflight",deDE="Dragonflight",esES="Dragonflight",esMX="Dragonflight",frFR="Dragonflight",itIT="Dragonflight",koKR="용군단",ptBR="Revoada Dragônica",ruRU="Dragonflight",zhTW="巨龍軍團",znCN="巨龙时代", },
		[251] = { enUS="Dragon Racing UI (Hidden)",deDE="Dragon Racing UI (Hidden)",esES="Dragon Racing UI (Hidden)",esMX="Dragon Racing UI (Hidden)",frFR="Dragon Racing UI (Hidden)",itIT="Dragon Racing UI (Hidden)",koKR="Dragon Racing UI (Hidden)",ptBR="Dragon Racing UI (Hidden)",ruRU="Dragon Racing UI (Hidden)",zhTW="Dragon Racing UI (Hidden)",znCN="Dragon Racing UI (Hidden)", hide=true, },
		[252] = { enUS="Tuskarr - Fishing Nets (Hidden)",deDE="Tuskarr - Fischernetze (verborgen)",esES="Colmillarr - Redes de pesca (oculto)",esMX="Colmillarr - Redes de pesca (Oculto)",frFR="Roharts – filets de pêche (cachés)",itIT="Tuskarr - Reti da pesca (Nascosto)",koKR="투스카르 - 낚시 그물 (숨겨짐)",ptBR="Morsanos – Redes de Pesca (Escondidas)",ruRU="Клыкарры – рыболовные сети (скрыто)",zhTW="巨牙海民 - 漁網（隱藏）",znCN="Tuskarr - Fishing Nets (Hidden)", hide=true, },
		[253] = { enUS="Test Subcategory 1",deDE="Test Subcategory 1",esES="Test Subcategory 1",esMX="Test Subcategory 1",frFR="Test Subcategory 1",itIT="Test Subcategory 1",koKR="Test Subcategory 1",ptBR="Test Subcategory 1",ruRU="Test Subcategory 1",zhTW="Test Subcategory 1",znCN="Test Subcategory 1", hide=true, },
		[254] = { enUS="Test Subcategory 2",deDE="Test Subcategory 2",esES="Test Subcategory 2",esMX="Test Subcategory 2",frFR="Test Subcategory 2",itIT="Test Subcategory 2",koKR="Test Subcategory 2",ptBR="Test Subcategory 2",ruRU="Test Subcategory 2",zhTW="Test Subcategory 2",znCN="Test Subcategory 2", hide=true, },
		[255] = { enUS="Test Subcategory 3",deDE="Test Subcategory 3",esES="Test Subcategory 3",esMX="Test Subcategory 3",frFR="Test Subcategory 3",itIT="Test Subcategory 3",koKR="Test Subcategory 3",ptBR="Test Subcategory 3",ruRU="Test Subcategory 3",zhTW="Test Subcategory 3",znCN="Test Subcategory 3", hide=true, },
		[256] = { enUS="Test Subcategory 4",deDE="Test Subcategory 4",esES="Test Subcategory 4",esMX="Test Subcategory 4",frFR="Test Subcategory 4",itIT="Test Subcategory 4",koKR="Test Subcategory 4",ptBR="Test Subcategory 4",ruRU="Test Subcategory 4",zhTW="Test Subcategory 4",znCN="Test Subcategory 4", hide=true, },
		[257] = { enUS="Legacy",deDE="Vermächtnis",esES="Antigua",esMX="Legado",frFR="Héritage",itIT="Oggetto del passato",koKR="옛 재화",ptBR="Legado",ruRU="Классические",zhTW="遺物",znCN="旧版", },
		[260] = { enUS="War Within",deDE="War Within",esES="The War Within",esMX="War Within",frFR="The War Within",itIT="War Within",koKR="내부 전쟁",ptBR="The War Within",ruRU="War Within",zhTW="地心之戰",znCN="地心之战", },
		[263] = { enUS="Season 2",deDE="Saison 2",esES="Temporada 2",esMX="Temporada 2",frFR="Saison 2",itIT="Stagione 2",koKR="2 시즌",ptBR="Série 2",ruRU="2-й сезон",zhTW="第2季",znCN="第2赛季" },
		[264] = { enUS="Midnight",deDE="Midnight",esES="Midnight",esMX="Midnight",frFR="Midnight",itIT="Midnight",koKR="한밤",ptBR="Midnight",ruRU="Midnight",zhTW="至暗之夜",znCN="至暗之夜", },
		[265] = { enUS="Season 3",deDE="Saison 3",esES="Temporada 3",esMX="Temporada 3",frFR="Saison 3",itIT="Stagione 3",koKR="3 시즌",ptBR="Série 3",ruRU="3-й сезон",zhTW="第3季",znCN="第3赛季" },
		[266] = { enUS="Timerunning",deDE="Zeitläufer",esES="Asalto temporal",esMX="Cronotravesía",frFR="Cours du temps",itIT="Corse nel Tempo",koKR="시간질주",ptBR="Trilha Temporal",ruRU="Путешествия во времени",zhTW="時光奔走",znCN="时空奔行", },
		[268] = { enUS="Season 1",deDE="Saison 1",esES="Temporada 1",esMX="Temporada 1",frFR="Saison 1",itIT="Stagione 1",koKR="1 시즌",ptBR="Série 1",ruRU="1-й сезон",zhTW="第1季",znCN="第1赛季", },
		[277] = { enUS="Season 2",deDE="Saison 2",esES="Temporada 2",esMX="Temporada 2",frFR="Saison 2",itIT="Stagione 2",koKR="2 시즌",ptBR="Série 2",ruRU="2-й сезон",zhTW="第2賽季",znCN="第2赛季", },
		[278] = { enUS="Sites Score UI (Hidden)",deDE="Stättenwertungs-UI (Versteckt)",esES="IU de puntuación de lugares (oculta)",esMX="Interfaz de puntaje de sitios (oculto)",frFR="Interface de score de site (cachée)",itIT="Interfaccia Punteggio Siti (Nascosta)",koKR="지점 점수 사용자 인터페이스 (숨겨짐)",ptBR="IU de pontuação do local (oculto)",ruRU="Интерфейс счета ритуалов (скрыто)",zhTW="地點分數介面（隱藏）",znCN="场地得分界面（隐藏）", hide=true, },
		[280] = { enUS="Professions",deDE="Berufe",esES="Profesiones",esMX="Profesiones",frFR="Métiers",itIT="Professioni",koKR="전문 기술",ptBR="Profissões",ruRU="Профессии",zhTW="專業技能",znCN="专业", },
		[281] = { enUS="Delves",deDE="Tiefen",esES="Profundidades",esMX="Abismos",frFR="Gouffres",itIT="Scorribande",koKR="구렁",ptBR="Imersões",ruRU="Вылазки",zhTW="探究",znCN="地下堡", },
		[282] = { enUS="Crests",deDE="Wappen",esES="Blasones",esMX="Emblemas",frFR="Écus",itIT="Emblemi",koKR="문장",ptBR="Brasões",ruRU="Гербы",zhTW="紋章",znCN="纹章", },
		[283] = { enUS="Zones",deDE="Zonen",esES="Zonas",esMX="Zonas",frFR="Régions",itIT="Zone",koKR="지역",ptBR="Áreas",ruRU="Зоны",zhTW="區域",znCN="区域", },
		[284] = { enUS="Features",deDE="Features",esES="Destacados",esMX="Características",frFR="Détails",itIT="Funzionalità",koKR="특징",ptBR="Características",ruRU="Особенности",zhTW="功能",znCN="特色", },
	}

	data.CurrencyByCategory = {
		[1] = { -- Miscellaneous
	--		42, -- Badge of Justice
			81, -- Epicurean's Award
			402, -- Ironpaw Token
			515, -- Darkmoon Prize Ticket
			1379, -- Trial of Style Token
			1388, -- Armor Scraps
			1401, -- Stronghold Supplies
	--		2005, -- Druid Talent Points (DNT)
	--		2006, -- Restoration Talent Points (DNT)
	--		2012, -- Death Knight Talent Points (DNT)
	--		2013, -- Frost Talent Points (DNT)
	--		2014, -- Unholy Talent Points (DNT)
	--		2015, -- Blood Talent Points (DNT)
			2032, -- Trader's Tender
			2588, -- Riders of Azeroth Badge
			2778, -- Bronze
			3100, -- Bronze Celebration Token
			3309, -- Hellstone Shard
			3363, -- Community Coupons
			3508, -- Salty Pet Charms
		},
		[2] = { -- Player vs. Player
	--		103, -- Arena Points
	--		121, -- Alterac Valley Mark of Honor
	--		122, -- Arathi Basin Mark of Honor
	--		123, -- Eye of the Storm Mark of Honor
	--		124, -- Strand of the Ancients Mark of Honor
	--		125, -- Warsong Gulch Mark of Honor
	--		126, -- Wintergrasp Mark of Honor
	--		161, -- Stone Keeper's Shard
	--		201, -- Venture Coin
	--		321, -- Isle of Conquest Mark of Honor
			391, -- Tol Barad Commendation
			1602, -- Conquest
			1792, -- Honor
			2123, -- Bloody Tokens
			2797, -- Trophy of Strife
		},
		[21] = { -- Wrath of the Lich King
			61, -- Dalaran Jewelcrafter's Token
			241, -- Champion's Seal
	--		3351, -- Social Meter
		},
		[22] = { -- Dungeon and Raid
	--		101, -- Emblem of Heroism
	--		102, -- Emblem of Valor
	--		221, -- Emblem of Conquest
	--		301, -- Emblem of Triumph
	--		341, -- Emblem of Frost
			1166, -- Timewarped Badge
		},
		[23] = { -- Burning Crusade
			1704, -- Spirit Shard
		},
		[81] = { -- Cataclysm
			361, -- Illustrious Jewelcrafter's Token
			416, -- Mark of the World Tree
			614, -- Mote of Darkness
			615, -- Essence of Corrupted Deathwing
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
	--		821, -- Draenor Clans Archaeology Fragment
	--		828, -- Ogre Archaeology Fragment
	--		829, -- Arakkoa Archaeology Fragment
	--		830, -- n/a
	--		1172, -- Highborne Archaeology Fragment
	--		1173, -- Highmountain Tauren Archaeology Fragment
	--		1174, -- Demonic Archaeology Fragment
	--		1534, -- Zandalari Archaeology Fragment
	--		1535, -- Drust Archaeology Fragment
		},
		[89] = { -- Meta
	--		483, -- Conquest Arena Meta
	--		484, -- Conquest Rated BG Meta
	--		692, -- Conquest Random BG Meta
		},
		[133] = { -- Mists of Pandaria
			697, -- Elder Charm of Good Fortune
			698, -- Zen Jewelcrafter's Token
			738, -- Lesser Charm of Good Fortune
			752, -- Mogu Rune of Fate
			776, -- Warforged Seal
			777, -- Timeless Coin
			789, -- Bloody Coin
			810, -- Black Iron Fragment
		},
		[137] = { -- Warlords of Draenor
			823, -- Apexis Crystal
			824, -- Garrison Resources
	--		897, -- UNUSED
			910, -- Secret of Draenor Alchemy
			944, -- Artifact Fragment
			980, -- Dingy Iron Coins
			994, -- Seal of Tempered Fate
			999, -- Secret of Draenor Tailoring
			1008, -- Secret of Draenor Jewelcrafting
			1017, -- Secret of Draenor Leatherworking
			1020, -- Secret of Draenor Blacksmithing
			1101, -- Oil
			1129, -- Seal of Inevitable Fate
		},
		[141] = { -- Legion
			1149, -- Sightless Eye
			1154, -- Shadowy Coins
			1155, -- Ancient Mana
			1220, -- Order Resources
			1226, -- Nethershard
			1268, -- Timeworn Artifact
			1273, -- Seal of Broken Fate
			1275, -- Curious Coin
			1314, -- Lingering Soul Fragment
			1342, -- Legionfall War Supplies
			1355, -- Felessence
			1356, -- Echoes of Battle
			1357, -- Echoes of Domination
			1416, -- Coins of Air
			1508, -- Veiled Argunite
			1533, -- Wakening Essence
		},
		[142] = { -- Hidden
			395, -- Justice Points
			396, -- Valor Points
			1171, -- Artifact Knowledge
			1191, -- Valor
			1324, -- Horde Qiraji Commendation
			1325, -- Alliance Qiraji Commendation
	--		1347, -- Legionfall Building - Personal Tracker - Mage Tower (Hidden)
	--		1349, -- Legionfall Building - Personal Tracker - Command Tower (Hidden)
	--		1350, -- Legionfall Building - Personal Tracker - Nether Tower (Hidden)
			1501, -- Writhing Essence
			1506, -- Argus Waystone
			1540, -- Wood
			1541, -- Iron
			1559, -- Essence of Storms
			1579, -- Champions of Azeroth
			1592, -- Order of Embers
			1593, -- Proudmoore Admiralty
			1594, -- Storm's Wake
			1595, -- Talanji's Expedition
			1596, -- Voldunai
			1597, -- Zandalari Empire
			1598, -- Tortollan Seekers
			1599, -- 7th Legion
			1600, -- Honorbound
	--		1703, -- PVP Season Rated Participation Currency
	--		1705, -- Warfronts - Personal Tracker - Iron in Chest (Hidden)
	--		1714, -- Warfronts - Personal Tracker - Wood in Chest (Hidden)
			1722, -- Azerite Ore
			1723, -- Lumber
			1728, -- Phantasma
			1738, -- Unshackled
			1739, -- Ankoan
			1740, -- Rustbolt Resistance (Hidden)
			1742, -- Rustbolt Resistance
	--		1744, -- Corrupted Memento
			1745, -- Nazjatar Ally - Neri Sharpfin
			1746, -- Nazjatar Ally - Vim Brineheart
			1747, -- Nazjatar Ally - Poen Gillbrack
			1748, -- Nazjatar Ally - Bladesman Inowari
			1749, -- Nazjatar Ally - Hunter Akana
			1750, -- Nazjatar Ally - Farseer Ori
			1752, -- Honeyback Hive
			1757, -- Uldum Accord
			1758, -- Rajani
			1761, -- Enemy Damage
			1762, -- Enemy Health
			1763, -- Deaths
	--		1769, -- Quest Experience (Standard, Hidden)
			1794, -- Atonement Anima
			1804, -- Ascended
			1805, -- Undying Army
			1806, -- Wild Hunt
			1807, -- Court of Harvesters
			1808, -- Channeled Anima
			1810, -- Redeemed Soul
			1822, -- Renown
			1837, -- The Ember Court
			1838, -- The Countess
			1839, -- Rendle and Cudgelface
			1840, -- Stonehead
			1841, -- Cryptkeeper Kassir
			1842, -- Baroness Vashj
			1843, -- Plague Deviser Marileth
			1844, -- Grandmaster Vole
			1845, -- Alexandros Mograine
			1846, -- Sika
			1847, -- Kleia and Pelegos
			1848, -- Polemarch Adrestes
			1849, -- Mikanikos
			1850, -- Choofa
			1851, -- Droman Aliothe
			1852, -- Hunt-Captain Korayn
			1853, -- Lady Moonberry
	--		1877, -- Bonus Experience
			1878, -- Stitchmasters
			1880, -- Ve'nari
			1883, -- Soulbind Conduit Energy
			1884, -- The Avowed
			1887, -- Court of Night
			1888, -- Marasmius
			1889, -- Adventure Campaign Progress
	--		1891, -- Honor from Rated
	--		1902, -- 9.1 - Torghast XP - Prototype - LJS
			1903, -- Invisible Reward
			1907, -- Death's Advance
			1947, -- Bonus Valor
			1982, -- The Enlightened
	--		1986, -- Players Remaining
			1997, -- Archivists' Codex
	--		2000, -- Motes of Fate
			2002, -- Renown-Maruuk Centaur
			2021, -- Renown-Dragonscale Expedition
			2023, -- Dragon Isles Blacksmithing Knowledge
			2024, -- Dragon Isles Alchemy Knowledge
			2025, -- Dragon Isles Leatherworking Knowledge
			2026, -- Dragon Isles Tailoring Knowledge
			2027, -- Dragon Isles Engineering Knowledge
			2028, -- Dragon Isles Inscription Knowledge
			2029, -- Dragon Isles Jewelcrafting Knowledge
			2030, -- Dragon Isles Enchanting Knowledge
			2031, -- Dragonscale Expedition
			2033, -- Dragon Isles Skinning Knowledge
			2034, -- Dragon Isles Herbalism Knowledge
			2035, -- Dragon Isles Mining Knowledge
			2036, -- Ancient Waygate Energy
			2087, -- Renown-Iskaara Tuskarr
			2088, -- Renown-Valdrakken
			2094, -- [DNT] AC Major Faction Test Renown
			2106, -- Valdrakken Accord
			2107, -- Artisan's Consortium - Dragon Isles Branch
			2108, -- Maruuk Centaur
			2109, -- Iskaara Tuskarr
	--		2148, -- Red Whelp (Fire Shot)
	--		2149, -- Red Whelp (Lobbing Fire Nova)
	--		2150, -- Red Whelp (Curing Whiff)
	--		2151, -- Red Whelp (Mending Breath)
	--		2152, -- Red Whelp (Sleepy Ruby Warmth)
	--		2153, -- Red Whelp (Under Red Wings)
	--		2165, -- Profession - Public Order Capacity - Blacksmithing
			2166, -- Renascent Lifeblood
			2167, -- Catalyst Charges
	--		2169, -- Profession - Public Order Capacity - Leatherworking
	--		2170, -- Profession - Public Order Capacity - Alchemy
	--		2171, -- Profession - Public Order Capacity - Tailoring
	--		2172, -- Profession - Public Order Capacity - Engineering
	--		2173, -- Profession - Public Order Capacity - Enchanting
	--		2174, -- Profession - Public Order Capacity - Jewelcrafting
	--		2175, -- Profession - Public Order Capacity - Inscription
	--		2231, -- Players
	--		2244, -- Forbidden Reach Return - Renown Dailies Completed
	--		2264, -- Account HWM - Helm [DNT]
	--		2265, -- Account HWM - Neck [DNT]
	--		2266, -- Account HWM - Shoulders [DNT]
	--		2267, -- Account HWM - Chest [DNT]
	--		2268, -- Account HWM - Waist [DNT]
	--		2269, -- Account HWM - Legs [DNT]
	--		2270, -- Account HWM - Feet [DNT]
	--		2271, -- Account HWM - Wrist [DNT]
	--		2272, -- Account HWM - Hands [DNT]
	--		2273, -- Account HWM - Ring [DNT]
	--		2274, -- Account HWM - Trinket [DNT]
	--		2275, -- Account HWM - Cloak [DNT]
	--		2276, -- Account HWM - Two Hand [DNT]
	--		2277, -- Account HWM - Main Hand [DNT]
	--		2278, -- Account HWM - One Hand [DNT]
	--		2279, -- Account HWM - One Hand (Second) [DNT]
	--		2280, -- Account HWM - Off Hand [DNT]
			2402, -- Renown - Loamm Niffen
			2408, -- Bonus Flightstones
			2409, -- Whelpling Crest Fragment Tracker [DNT]
			2410, -- Drake Crest Fragment Tracker [DNT]
			2411, -- Wyrm Crest Fragment Tracker [DNT]
			2412, -- Aspect Crest Fragment Tracker [DNT]
	--		2413, -- 10.1 Professions - Personal Tracker - S2 Spark Drops (Hidden)
	--		2419, -- Test Currency Main [DNT]
			2420, -- Loamm Niffen
			2533, -- Renascent Shadowflame
			2645, -- Soridormi's Recognition
			2649, -- [DNT] The Currency Formerly Named Dream Ephemera
			2652, -- Dream Wardens
			2653, -- Renown - Dream Wardens
			2655, -- Revives
			2706, -- Whelpling's Dreaming Crest
			2707, -- Drake's Dreaming Crest
			2708, -- Wyrm's Dreaming Crest
			2709, -- Aspect's Dreaming Crest
			2710, -- Study of Shadowflame
			2715, -- Whelpling's Dreaming Crests
			2716, -- Drake's Dreaming Crests
			2717, -- Wyrm's Dreaming Crests
			2718, -- Aspect's Dreaming Crests
	--		2774, -- 10.2 Professions - Personal Tracker - S3 Spark Drops (Hidden)
			2780, -- Echoed Ephemera Tracker [DNT]
	--		2784, -- 10.2 Legendary - Progressive Advance - Tracker
			2785, -- Khaz Algar Alchemy Knowledge
			2786, -- Khaz Algar Blacksmithing Knowledge
			2787, -- Khaz Algar Enchanting Knowledge
			2788, -- Khaz Algar Engineering Knowledge
			2789, -- Khaz Algar Herbalism Knowledge
			2790, -- Khaz Algar Inscription Knowledge
			2791, -- Khaz Algar Jewelcrafting Knowledge
			2792, -- Khaz Algar Leatherworking Knowledge
			2793, -- Khaz Algar Mining Knowledge
			2794, -- Khaz Algar Skinning Knowledge
			2795, -- Khaz Algar Tailoring Knowledge
			2796, -- Renascent Dream
			2799, -- [DNT] Beetle Ranch Invisible Currency
	--		2800, -- 10.2.6 Professions - Personal Tracker - S4 Spark Drops (Hidden)
			2805, -- Whelpling's Awakened Crest
			2808, -- Drake's Awakened Crest
			2810, -- Wyrm's Awakened Crest
			2811, -- Aspect's Awakened Crest
			2813, -- Harmonized Silk
			2814, -- Renown-Keg Leg's Crew
			2819, -- Azerothian Archives
			2853, -- 10.2.7 Timewalking Season - Artifact - Cloak - Primary
			2854, -- 10.2.7 Timewalking Season - Artifact - Cloak - Stamina
			2855, -- 10.2.7 Timewalking Season - Artifact - Cloak - Critical Strike
			2856, -- 10.2.7 Timewalking Season - Artifact - Cloak - Haste
			2857, -- 10.2.7 Timewalking Season - Artifact - Cloak - Leech
			2858, -- 10.2.7 Timewalking Season - Artifact - Cloak - Mastery
			2859, -- 10.2.7 Timewalking Season - Artifact - Cloak - Speed
			2860, -- 10.2.7 Timewalking Season - Artifact - Cloak - Versatility
			2861, -- 10.2.7 Timewalking Season - Artifact - Head - Aberration
			2862, -- 10.2.7 Timewalking Season - Artifact - Head - Beast
			2863, -- 10.2.7 Timewalking Season - Artifact - Head - Demon
			2864, -- 10.2.7 Timewalking Season - Artifact - Head - Dragonkin
			2865, -- 10.2.7 Timewalking Season - Artifact - Head - Elemental
			2866, -- 10.2.7 Timewalking Season - Artifact - Head - Giant
			2867, -- 10.2.7 Timewalking Season - Artifact - Head - Humanoid
			2868, -- 10.2.7 Timewalking Season - Artifact - Head - Mechanical
			2869, -- 10.2.7 Timewalking Season - Artifact - Head - Undead
			2870, -- 10.2.7 Timewalking Season - Artifact - Waist - Physical
			2871, -- 10.2.7 Timewalking Season - Artifact - Waist - Arcane
			2872, -- 10.2.7 Timewalking Season - Artifact - Waist - Fire
			2873, -- 10.2.7 Timewalking Season - Artifact - Waist - Frost
			2874, -- 10.2.7 Timewalking Season - Artifact - Waist - Holy
			2875, -- 10.2.7 Timewalking Season - Artifact - Waist - Shadow
			2876, -- 10.2.7 Timewalking Season - Artifact - Waist - Nature
	--		2878, -- 10.2 Professions - Personal Tracker - Legendary - Restored Leaf
			2897, -- Council of Dornogal
			2898, -- Renown - The Assembly of the Deeps
			2899, -- Hallowfall Arathi
			2900, -- Renown - Council of Dornogal
			2901, -- Renown - Hallowfall Arathi
			2902, -- The Assembly of the Deeps
			2903, -- The Severed Threads
			2904, -- Renown - The Severed Threads
			2906, -- Plunder
	--		2907, -- Pirate Booty Visual
			2908, -- Dominance Offensive
			2909, -- Operation: Shieldwall
			2910, -- The Klaxxi
			2911, -- Order of the Cloud Serpent
			2912, -- Renascent Awakening
			2913, -- Shado-Pan
			2914, -- Weathered Harbinger Crest
			2915, -- Carved Harbinger Crest
			2916, -- Runed Harbinger Crest
			2917, -- Gilded Harbinger Crest
			2918, -- Weathered Harbinger Crest
			2919, -- Carved Harbinger Crest
			2920, -- Runed Harbinger Crest
			2921, -- Gilded Harbinger Crest
			2922, -- Plunder
			3000, -- 10.2.7 Timewalking Season - Random Gem Counter
			3001, -- 10.2.7 Timewalking Season - Artifact - Cloak - Experience Gain
			3002, -- The Weaver (Notoriety)
			3003, -- The General (Notoriety)
			3004, -- The Vizier (Notoriety)
			3005, -- The General (Notoriety)
			3006, -- The Vizier (Notoriety)
			3007, -- The Weaver (Notoriety)
			3008, -- Valorstones
			3009, -- Bonus Valorstones
	--		3010, -- 10.2.6 Rewards - Personal Tracker - S4 Dinar Drops (Hidden)
			3011, -- Plunder
	--		3013, -- Jewelcrafting Concentration
			3022, -- Renown - Season 1 Delves
	--		3023, -- 11.0 Professions - Personal Tracker - S1 Spark Drops (Hidden)
	--		3024, -- Cosmetic
	--		3025, -- Cosmetic
	--		3026, -- Cosmetic
	--		3027, -- Cosmetic
	--		3040, -- Blacksmithing Concentration
	--		3041, -- Tailoring Concentration
	--		3042, -- Leatherworking Concentration
	--		3043, -- Inscription Concentration
	--		3044, -- Engineering Concentration
	--		3045, -- Alchemy Concentration
	--		3046, -- Enchanting Concentration
	--		3047, -- Jewelcrafting Concentration
	--		3048, -- Tailoring Concentration
	--		3049, -- Leatherworking Concentration
	--		3050, -- Blacksmithing Concentration
	--		3051, -- Enchanting Concentration
	--		3052, -- Engineering Concentration
	--		3053, -- Inscription Concentration
	--		3054, -- Alchemy Concentration
	--		3057, -- 11.0 Professions - Tracker - Weekly Alchemy Knowledge
	--		3058, -- 11.0 Professions - Tracker - Weekly Blacksmithing Knowledge
	--		3059, -- 11.0 Professions - Tracker - Weekly Enchanting Knowledge
	--		3060, -- 11.0 Professions - Tracker - Weekly Engineering Knowledge
	--		3061, -- 11.0 Professions - Tracker - Weekly Herbalism Knowledge
	--		3062, -- 11.0 Professions - Tracker - Weekly Inscription Knowledge
	--		3063, -- 11.0 Professions - Tracker - Weekly Jewelcrafting Knowledge
	--		3064, -- 11.0 Professions - Tracker - Weekly Leatherworking Knowledge
	--		3065, -- 11.0 Professions - Tracker - Weekly Mining Knowledge
	--		3066, -- 11.0 Professions - Tracker - Weekly Skinning Knowledge
	--		3067, -- 11.0 Professions - Tracker - Weekly Tailoring Knowledge
			3068, -- Delver's Journey
			3069, -- 11.0 Professions - Tailoring - Fishing - Khaz Algar - Skill
			3070, -- 11.0 Professions - Fishing - Algari Weaverthread - Perception
			3071, -- 11.0 Professions - Fishing - Algari Weaverthread - Skill
			3072, -- Everburning Ignition Refund
	--		3073, -- 11.0 Professions - Tracker - Insc Book - Tailoring Knowledge
	--		3074, -- 11.0 Professions - Tracker - Insc Book - Skinning Knowledge
	--		3075, -- 11.0 Professions - Tracker - Insc Book - Mining Knowledge
	--		3076, -- 11.0 Professions - Tracker - Insc Book - Leatherworking Know.
	--		3077, -- 11.0 Professions - Tracker - Insc Book - Jewelcrafting Knowledge
	--		3078, -- 11.0 Professions - Tracker - Insc Book - Inscription Knowledge
	--		3079, -- 11.0 Professions - Tracker - Insc Book - Herbalism Knowledge
	--		3080, -- 11.0 Professions - Tracker - Insc Book - Engineering Knowledge
	--		3081, -- 11.0 Professions - Tracker - Insc Book - Enchanting Knowledge
	--		3082, -- 11.0 Professions - Tracker - Insc Book - Blacksmithing Knowledge
	--		3083, -- 11.0 Professions - Tracker - Insc Book - Alchemy Knowledge
	--		3084, -- 11.0 Professions - Tracker - Insc Book - Inscription Knowledge
	--		3085, -- 11.0 Delves - Personal Tracker - S1 Weekly Elise Turn-In(Hidden)
	--		3086, -- DPS
	--		3087, -- Tank
	--		3088, -- Healer
	--		3094, -- 11.0 Raid - Nerubian - Account Quest Complete Tracker (Hidden)
	--		3099, -- 11.0 Raid - Nerubian - Nerubar Finery Tracking Currency (Hidden)
			3102, -- Bronze Celebration Token
	--		3103, -- 11.0 Delves - System - Seasonal Affix - Events Active
	--		3104, -- 11.0 Delves - System - Seasonal Affix - Events Maximum
			3107, -- Weathered Undermine Crest
			3108, -- Carved Undermine Crest
			3109, -- Runed Undermine Crest
			3110, -- Gilded Undermine Crest
			3111, -- Weathered Undermine Crest
			3112, -- Carved Undermine Crest
			3113, -- Runed Undermine Crest
			3114, -- Gilded Undermine Crest
			3115, -- [DNT] Worldsoul Memory Score
			3116, -- Essence of Kaja'mite
			3118, -- The Cartels of Undermine
			3120, -- The Cartels of Undermine
			3128, -- Renown - The K'aresh Trust
			3129, -- The K'aresh Trust
			3130, -- Renown - Season 2 Delves
			3131, -- Delver's Journey
	--		3132, -- 11.1 Professions - Personal Tracker - S2 Spark Drops (Hidden)
	--		3135, -- 11.1 Delves - Personal Tracker - S2 Weekly Elise Turn-In(Hidden)
			3136, -- Gallagio Loyalty Rewards Club
			3137, -- Renown - Gallagio Loyalty Rewards Club
	--		3139, -- Plunder
			3140, -- 11.1.5 Arathi - Renown Rank
			3141, -- Starlight Spark Dust
			3142, -- EVERGREEN Delves - Tracker - EoD Account Rewards - Weekly Cap
	--		3143, -- 11.0 Delves - Bountiful Tracker - Delver's Journey Cap
	--		3144, -- 11.0.5 20th Anniversary - Tracker
	--		3145, -- 11.0.5 20th Anniversary - Tracker
	--		3146, -- 11.0.5 20th Anniversary - Tracker
	--		3147, -- 11.0 Delves - Vendor - Bountiful Key Tracker - Cap
			3150, -- Midnight Alchemy Knowledge
			3151, -- Midnight Blacksmithing Knowledge
			3152, -- Midnight Enchanting Knowledge
			3153, -- Midnight Engineering Knowledge
			3154, -- Midnight Herbalism Knowledge
			3155, -- Midnight Inscription Knowledge
			3156, -- Midnight Jewelcrafting Knowledge
			3157, -- Midnight Leatherworking Knowledge
			3158, -- Midnight Mining Knowledge
			3159, -- Midnight Skinning Knowledge
			3160, -- Midnight Tailoring Knowledge
	--		3161, -- Alchemy Concentration
	--		3162, -- Blacksmithing Concentration
	--		3163, -- Enchanting Concentration
	--		3164, -- Engineering Concentration
	--		3165, -- Inscription Concentration
	--		3166, -- Jewelcrafting Concentration
	--		3167, -- Leatherworking Concentration
	--		3168, -- Tailoring Concentration
			3169, -- The Bilgewater Cartel
			3170, -- The Bilgewater Cartel
			3171, -- The Blackwater Cartel
			3172, -- The Blackwater Cartel
			3173, -- The Steamwheedle Cartel
			3174, -- The Steamwheedle Cartel
			3175, -- The Venture Company
			3176, -- Venture Company
			3177, -- Darkfuse Solutions
			3178, -- Darkfuse Solutions
	--		3189, -- 12.x Professions - Tracker - Weekly Alchemy Knowledge
	--		3190, -- 12.x Professions - Tracker - Weekly Tailoring Knowledge
	--		3191, -- 12.x Professions - Tracker - Weekly Skinning Knowledge
	--		3192, -- 12.x Professions - Tracker - Weekly Mining Knowledge
	--		3193, -- 12.x Professions - Tracker - Weekly Leatherworking Knowledge
	--		3194, -- 12.x Professions - Tracker - Weekly Jewelcrafting Knowledge
	--		3195, -- 12.x Professions - Tracker - Weekly Inscription Knowledge
	--		3196, -- 12.x Professions - Tracker - Weekly Herbalism Knowledge
	--		3197, -- 12.x Professions - Tracker - Weekly Engineering Knowledge
	--		3198, -- 12.x Professions - Tracker - Weekly Enchanting Knowledge
	--		3199, -- 12.x Professions - Tracker - Weekly Blacksmithing Knowledge
	--		3200, -- 12.x Professions - Tracker - Insc Book - Tailoring Knowledge
	--		3201, -- 12.x Professions - Tracker - Insc Book - Skinning Knowledge
	--		3202, -- 12.x Professions - Tracker - Insc Book - Mining Knowledge
	--		3203, -- 12.x Professions - Tracker - Insc Book - Leatherworking Know.
	--		3204, -- 12.x Professions - Tracker - Insc Book - Jewelcrafting Knowledge
	--		3205, -- 12.x Professions - Tracker - Insc Book - Inscription Knowledge
	--		3206, -- 12.x Professions - Tracker - Insc Book - Inscription Knowledge
	--		3207, -- 12.x Professions - Tracker - Insc Book - Herbalism Knowledge
	--		3208, -- 12.x Professions - Tracker - Insc Book - Engineering Knowledge
	--		3209, -- 12.x Professions - Tracker - Insc Book - Enchanting Knowledge
	--		3210, -- 12.x Professions - Tracker - Insc Book - Blacksmithing Knowledge
	--		3211, -- 12.x Professions - Tracker - Insc Book - Alchemy Knowledge
			3212, -- Radiant Spark Dust
			3221, -- Goblin Cartels Reputation
	--		3224, -- [DNT] NAK Test Currency
	--		3225, -- Blacksmithing Specialization Reset
	--		3227, -- Alchemy Specialization Reset
	--		3228, -- Enchanting Specialization Reset
	--		3229, -- Engineering Specialization Reset
	--		3230, -- Herbalism Specialization Reset
	--		3231, -- Inscription Specialization Reset
	--		3232, -- Jewelcrafting Specialization Reset
	--		3233, -- Leatherworking Specialization Reset
	--		3234, -- Mining Specialization Reset
	--		3235, -- Skinning Specialization Reset
	--		3236, -- Tailoring Specialization Reset
	--		3238, -- Alchemy Specialization Reset
	--		3239, -- Enchanting Specialization Reset
	--		3240, -- Engineering Specialization Reset
	--		3241, -- Herbalism Specialization Reset
	--		3242, -- Inscription Specialization Reset
	--		3243, -- Jewelcrafting Specialization Reset
	--		3244, -- Leatherworking Specialization Reset
	--		3245, -- Mining Specialization Reset
	--		3246, -- Skinning Specialization Reset
	--		3247, -- Tailoring Specialization Reset
	--		3248, -- Blacksmithing Specialization Reset
			3250, -- Faceted Crystalline Fel
			3253, -- EVERGREEN Delves - Tracker - Mislaid Curiosity - Weekly Cap
	--		3254, -- Chase's Test Currency [DNT]
			3267, -- Felforged Bronze
			3269, -- Ethereal Voidsplinter
	--		3270, -- 11.2 Delves - Personal Tracker - S3 Weekly Elise Turn-In(Hidden)
			3271, -- Renown - Season 3 Delves
			3272, -- Delver's Journey
			3278, -- Ethereal Strands
	--		3279, -- 11. Raid Renown - Gallagio - Raid Buff Acct Tracker
	--		3280, -- 11. Raid Renown - Gallagio - Speed Buff Acct Tracker
			3282, -- Gallagio Loyalty Rewards Club
			3283, -- Flame's Radiance
			3284, -- Weathered Ethereal Crest
			3285, -- Weathered Ethereal Crest
			3286, -- Carved Ethereal Crest
			3287, -- Carved Ethereal Crest
			3288, -- Runed Ethereal Crest
			3289, -- Runed Ethereal Crest
			3290, -- Gilded Ethereal Crest
			3291, -- Gilded Ethereal Crest
			3304, -- Manaforge Vandals
			3305, -- Renown - Manaforge Vandals
			3306, -- Manaforge Vandals
	--		3307, -- 11.2 Raid Renown - Manaforge - Raid Buff Acct Tracker
	--		3308, -- 11.2 Raid Renown - Manaforge Speed Buff Acct Tracker
	--		3313, -- 11. Raid Renown - Gallagio - Raid Buff Acct Tracker
	--		3314, -- 11. Raid Renown - Gallagio - Speed Buff Acct Tracker
			3315, -- Renown - Gallagio Loyalty Rewards Club
			3317, -- Renown - Season 1 Delves
			3318, -- Delver's Journey
			3341, -- Veteran Dawncrest
			3342, -- Veteran Dawncrest
			3343, -- Champion Dawncrest
			3344, -- Champion Dawncrest
			3345, -- Hero Dawncrest
			3346, -- Hero Dawncrest
			3347, -- Myth Dawncrest
			3348, -- Myth Dawncrest
			3354, -- The Amani Tribe
			3355, -- Renown - The Amani Tribe
	--		3360, -- [DNT] 11.1.5 Midseason - Turbo-Boost Quest Turn-In Tracker
	--		3364, -- [DNT] 11.2.5 Midseason - Turbo-Boost Quest Turn-In Tracker
			3365, -- Silvermoon Court
			3369, -- Renown - The Hara'ti
			3370, -- The Hara'ti
			3371, -- Renown - Silvermoon Court
			3372, -- Bronze
			3375, -- [DNT] Moth Hunt Tracking Currency
			3378, -- Dawnlight Manaflux
			3383, -- Adventurer Dawncrest
			3385, -- Luminous Dust
			3386, -- Renown - Prey
			3387, -- Preyseeker's Journey
			3388, -- Renown - The Singularity
			3389, -- The Singularity
			3390, -- Farstriders
			3391, -- Adventurer Dawncrest
			3396, -- Shades of the Row
			3397, -- Magisters
			3398, -- Blood Knights
	--		3401, -- 12.0 Delves - Personal Tracker - S1 Weekly Turn-In (Hidden)
	--		3409, -- [DNT] 12.0 Midseason - Voidforge Unlock - Turn-In Tracker
			3410, -- Slayer's Duellum
	--		3419, -- [DNT] 12.0.5 Midseason - Voidforge Upgrade - Turn-In Tracker
	--		3420, -- [DNT] Nebulous Voidcore Turn-In Tracker
			3428, -- Renown - Ritual Sites
			3429, -- Ritual Site Knowledge
			3437, -- Adventurer Mistcrest
			3438, -- Veteran Mistcrest
			3439, -- Champion Mistcrest
			3440, -- Hero Mistcrest
			3441, -- Myth Mistcrest
			3464, -- Renown - Season 2 Delves
			3471, -- Renown - Zul'jarra's Forces
	--		3474, -- Bonus Experience
			3479, -- Spoils
			3480, -- Deaths
			3483, -- Delver's Journey
	--		3487, -- Tailoring Specialization Reset
	--		3488, -- Skinning Specialization Reset
	--		3489, -- Mining Specialization Reset
	--		3490, -- Leatherworking Specialization Reset
	--		3491, -- Jewelcrafting Specialization Reset
	--		3492, -- Inscription Specialization Reset
	--		3493, -- Herbalism Specialization Reset
	--		3494, -- Engineering Specialization Reset
	--		3495, -- Enchanting Specialization Reset
	--		3496, -- Blacksmithing Specialization Reset
	--		3497, -- Alchemy Specialization Reset
			3504, -- Zul'jarra's Forces
	--		3505, -- [DNT] Diver Score
	--		3506, -- [DNT] Diver Display Currency
			3513, -- Nebulous Voidcore
			3514, -- Renown - Prey Season 2
			3515, -- Preyseeker's Journey
	--		3532, -- 12.1 Delves - Personal Tracker - S2 Weekly Turn-In (Hidden)
			3536, -- Renown - Season 2 Labyrinth
			3537, -- Kindo'jan's Labyrinth Journey
			3540, -- Captain Tokka
			3544, -- Aqir Research Enclave
			3545, -- Renown - Season 3 Delves
	--		3568, -- Contained Corruption
	--		3569, -- Cleansing Multiplier
	--		3570, -- Wave Multiplier
			3574, -- PMM Currency 1
			3575, -- PMM Currency 2
	--		3592, -- 12.1.5 Labyrinth - Personal Tracker - S2 Weekly Turn-In (Hidden)
			3606, -- Soul
		},
		[143] = { -- Battle for Azeroth
			1299, -- Brawler's Gold
			1560, -- War Resources
			1565, -- Rich Azerite Fragment
			1580, -- Seal of Wartorn Fate
			1587, -- War Supplies
			1710, -- Seafarer's Dubloon
			1715, -- Progenitor Shard
			1716, -- Honorbound Service Medal
			1717, -- 7th Legion Service Medal
			1718, -- Titan Residuum
			1719, -- Corrupted Mementos
			1721, -- Prismatic Manapearl
			1755, -- Coalescing Visions
			1803, -- Echoes of Ny'alotha
		},
		[144] = { -- Virtual
			1553, -- Azerite
			1585, -- Warband Wide Honor
			1586, -- Honor Level
	--		2001, -- Paden Test Currency
			2230, -- Darkmoon Prize Ticket (Void)
			2822, -- [DNT] Corgi Cache
			3180, -- Weekly Limit Test Currency
		},
		[245] = { -- Shadowlands
			1743, -- Fake Anima for Quest Tracking
			1754, -- Argent Commendation
			1767, -- Stygia
			1802, -- Shadowlands PvP Weekly Reward Progress
	--		1811, -- zzoldSanctum Architect
	--		1812, -- zzoldSanctum Anima Weaver
			1813, -- Reservoir Anima
			1816, -- Sinstone Fragments
			1819, -- Medallion of Service
			1820, -- Infused Ruby
			1828, -- Soul Ash
			1829, -- Renown-Kyrian
			1830, -- Renown-Venthyr
			1831, -- Renown-NightFae
			1832, -- Renown-Necrolord
	--		1859, -- Reservoir Anima-Kyrian
	--		1860, -- Reservoir Anima-Venthyr
	--		1861, -- Reservoir Anima-Night Fae
	--		1862, -- Reservoir Anima-Necrolord
	--		1863, -- Redeemed Soul-Kyrian
	--		1864, -- Redeemed Soul-Venthyr
	--		1865, -- Redeemed Soul-Night Fae
	--		1866, -- Redeemed Soul-Necrolord
	--		1867, -- Sanctum Architect-Kyrian
	--		1868, -- Sanctum Architect-Venthyr
	--		1869, -- Sanctum Architect-Night Fae
	--		1870, -- Sanctum Architect-Necrolord
	--		1871, -- Sanctum Anima Weaver-Kyrian
	--		1872, -- Sanctum Anima Weaver-Venthyr
	--		1873, -- Sanctum Anima Weaver-Night Fae
	--		1874, -- Sanctum Anima Weaver-Necrolord
			1885, -- Grateful Offering
			1904, -- Tower Knowledge
			1906, -- Soul Cinders
			1931, -- Cataloged Research
			1977, -- Stygian Ember
			1979, -- Cyphers of the First Ones
			2009, -- Cosmic Flux
		},
		[248] = { -- Torghast UI (Hidden)
	--		1909, -- Torghast - Scoreboard - Clear Percent
	--		1910, -- Torghast - Scoreboard - Souls Percent
	--		1911, -- Torghast - Scoreboard - Urns Percent
	--		1912, -- Torghast - Scoreboard - Hot Streak Percent
	--		1913, -- Torghast - Scoreboard - Total Time
	--		1914, -- Torghast - Scoreboard - Par Time
	--		1915, -- Torghast - Scoreboard - Deaths Excess Count
	--		1916, -- Torghast - Scoreboard - Deaths Start Count
	--		1917, -- Torghast - Scoreboard - Floor Reached
	--		1918, -- Torghast - Scoreboard - Toast Display - Time Score
	--		1919, -- Torghast - Scoreboard - Toast Display - Hot Streak Score
	--		1920, -- Torghast - Scoreboard - Toast Display - Deaths Excess Score
	--		1921, -- Torghast - Scoreboard - Toast Display - Total Score
	--		1922, -- Torghast - Scoreboard - Toast Display - Total Rewards
	--		1923, -- Torghast - Scoreboard - Toast Display - Bonus - Souls Rescued
	--		1924, -- Torghast - Scoreboard - Toast Display - Bonus - Urns Broken
	--		1925, -- Torghast - Scoreboard - Toast Display - Deaths Zero
	--		1926, -- Torghast - Scoreboard - Toast Display - Stars
	--		1932, -- Torghast - Scoreboard - Toast Display - Boss Killed
	--		1933, -- Torghast - Scoreboard - Toast Display - Bonus - Chests Opened
	--		1934, -- Torghast - Scoreboard - Toast Display - Bonus - Escorts Complete
	--		1935, -- Torghast - Scoreboard - Toast Display - Bonus - No Trap Damage
	--		1936, -- Torghast - Scoreboard - Toast Display - Bonus - Kill Boss Fast
	--		1937, -- Torghast - Scoreboard - Toast Display - Bonus - Single Stacks
	--		1938, -- Torghast - Scoreboard - Toast Display - Bonus - 5 Stacks
	--		1939, -- Torghast - Scoreboard - Toast Display - Bonus - Broker Killer
	--		1940, -- Torghast - Scoreboard - Toast Display - Bonus - Elite Slayer
	--		1941, -- Torghast - Scoreboard - Toast Display - Bonus - 1000 Phantasma
	--		1942, -- Torghast - Scoreboard - Toast Display - Bonus - 500 Phant Left
	--		1943, -- Torghast - Scoreboard - Toast Display - Bonus - No Deaths
	--		1944, -- Torghast - Scoreboard - Toast Display - Bonus - No Epics
	--		1945, -- Torghast - Scoreboard - Toast Display - Bonus - Elite Unnatural
	--		1946, -- Torghast - Scoreboard - Toast Display - Total Rewards - AV Bonus
	--		1948, -- Torghast - Scoreboard - Toast Display - Bonus - Kill Boss Faster
	--		1949, -- Torghast - Scoreboard - Toast Display - Bonus - 30+ Count
	--		1950, -- Torghast - Scoreboard - Toast Display - 1 Star Value
	--		1951, -- Torghast - Scoreboard - Toast Display - 2 Star Value
	--		1952, -- Torghast - Scoreboard - Toast Display - 3 Star Value
	--		1953, -- Torghast - Scoreboard - Toast Display - 4 Star Value
	--		1954, -- Torghast - Scoreboard - Toast Display - 5 Star Value
	--		1955, -- Torghast - Scoreboard - Toast Display - Points While Empowered
	--		1956, -- Torghast - Scoreboard - Toast Display - Points Empowered Score
	--		1957, -- Torghast - Scoreboard - Floor Clear Percent Floor 1
	--		1958, -- Torghast - Scoreboard - Floor Clear Percent Floor 2
	--		1959, -- Torghast - Scoreboard - Floor Clear Percent Floor 3
	--		1960, -- Torghast - Scoreboard - Floor Clear Percent Floor 4
	--		1961, -- Torghast - Scoreboard - Floor Empowered Percent Floor 1
	--		1962, -- Torghast - Scoreboard - Floor Empowered Percent Floor 2
	--		1963, -- Torghast - Scoreboard - Floor Empowered Percent Floor 3
	--		1964, -- Torghast - Scoreboard - Floor Empowered Percent Floor 4
	--		1965, -- Torghast - Scoreboard - Floor Time Floor 1
	--		1966, -- Torghast - Scoreboard - Floor Time Floor 2
	--		1967, -- Torghast - Scoreboard - Floor Time Floor 3
	--		1968, -- Torghast - Scoreboard - Floor Time Floor 4
	--		1969, -- Torghast - Scoreboard - Floor Par Time Floor 1
	--		1970, -- Torghast - Scoreboard - Floor Par Time Floor 2
	--		1971, -- Torghast - Scoreboard - Floor Par Time Floor 3
	--		1972, -- Torghast - Scoreboard - Floor Par Time Floor 4
	--		1976, -- Torghast - Scoreboard - Toast Display - Bonus - Phant Left Group
	--		1980, -- Torghast - Scoreboard - Run Layer
	--		1981, -- Torghast - Scoreboard - Run ID
		},
		[250] = { -- Dragonflight
			2003, -- Dragon Isles Supplies
			2011, -- Effigy Adornments
			2045, -- Dragon Glyph Embers
			2105, -- Purified Arcane Energy
			2118, -- Elemental Overflow
			2122, -- Storm Sigil
			2134, -- Cobalt Assembly
			2245, -- Flightstones
			2531, -- zzOLD Delving Gems
			2590, -- Lost Transcripts
			2591, -- 11.0 Delves - Score Inside
			2592, -- 11.0 Delves - Reputation Score
			2594, -- Paracausal Flakes
			2650, -- Emerald Dewdrop
			2651, -- Seedbloom
			2657, -- Mysterious Fragment
			2777, -- Dream Infusion
			2806, -- Whelpling's Awakened Crest
			2807, -- Drake's Awakened Crest
			2809, -- Wyrm's Awakened Crest
			2812, -- Aspect's Awakened Crest
		},
		[251] = { -- Dragon Racing UI (Hidden)
	--		2016, -- Dragon Racing - Scoreboard - Race Complete Time
	--		2017, -- Dragon Racing - Scoreboard - Race Complete Time - Fraction 1
	--		2018, -- Dragon Racing - Temp Storage - Race Quest ID
	--		2019, -- Dragon Racing - Scoreboard - Race Complete Time - Silver
	--		2020, -- Dragon Racing - Scoreboard - Race Complete Time - Gold
	--		2022, -- Dragon Racing - Multiplayer Race Placement
	--		2037, -- Dragon Racing - Scoreboard - Race Complete Time -Silver Fract 1
	--		2038, -- Dragon Racing - Scoreboard - Race Complete Time - Gold Fract 1
	--		2039, -- Dragon Racing - Scoreboard - Personal Best - Waking Shores 1
	--		2040, -- Dragon Racing - Scoreboard - Personal Best Time
	--		2041, -- Dragon Racing - Scoreboard - Personal Best Time - Fraction 1
	--		2042, -- Dragon Racing - Personal Best Record - Waking Shores 01 Easy
	--		2043, -- Dragon Racing - Personal Best Record - Waking Shores 01 Medium
	--		2044, -- Dragon Racing - Personal Best Record - Waking Shores 01 Hard
	--		2046, -- Dragon Racing - Personal Best Record - Waking Shores 07 Easy
	--		2047, -- Dragon Racing - Personal Best Record - Waking Shores 07 Hard
	--		2048, -- Dragon Racing - Personal Best Record - Waking Shores 02 Easy
	--		2049, -- Dragon Racing - Personal Best Record - Waking Shores 02 Hard
	--		2050, -- Dragon Racing - Personal Best Record - Waking Shores 08 Easy
	--		2051, -- Dragon Racing - Personal Best Record - Waking Shores 08 Hard
	--		2052, -- Dragon Racing - Personal Best Record - Waking Shores 03 Easy
	--		2053, -- Dragon Racing - Personal Best Record - Waking Shores 03 Hard
	--		2054, -- Dragon Racing - Personal Best Record - Waking Shores 04 Easy
	--		2055, -- Dragon Racing - Personal Best Record - Waking Shores 04 Hard
	--		2056, -- Dragon Racing - Personal Best Record - Waking Shores 05 Easy
	--		2057, -- Dragon Racing - Personal Best Record - Waking Shores 05 Hard
	--		2058, -- Dragon Racing - Personal Best Record - Waking Shores 06 Easy
	--		2059, -- Dragon Racing - Personal Best Record - Waking Shores 06 Hard
	--		2060, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 01 Easy
	--		2061, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 01 Hard
	--		2062, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 02 Easy
	--		2063, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 02 Hard
	--		2064, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 03 Easy
	--		2065, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 03 Hard
	--		2066, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 04 Easy
	--		2067, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 04 Hard
	--		2069, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains D05 Easy
	--		2070, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains D06 Easy
	--		2074, -- Dragon Racing - Personal Best Record - Azure Span 01 Easy
	--		2075, -- Dragon Racing - Personal Best Record - Azure Span 01 Hard
	--		2076, -- Dragon Racing - Personal Best Record - Azure Span 02 Easy
	--		2077, -- Dragon Racing - Personal Best Record - Azure Span 02 Hard
	--		2078, -- Dragon Racing - Personal Best Record - Azure Span 03 Easy
	--		2079, -- Dragon Racing - Personal Best Record - Azure Span 03 Hard
	--		2080, -- Dragon Racing - Personal Best Record - Thaldraszus 01 Easy
	--		2081, -- Dragon Racing - Personal Best Record - Thaldraszus 01 Hard
	--		2082, -- Dragon Racing - Personal Best Record - Waking Shores MP 1
	--		2083, -- Dragon Racing - Personal Best Record - Azure Span 04 Easy
	--		2084, -- Dragon Racing - Personal Best Record - Azure Span 04 Hard
	--		2085, -- Dragon Racing - Personal Best Record - Azure Span 05 Easy
	--		2086, -- Dragon Racing - Personal Best Record - Azure Span 05 Hard
	--		2089, -- Dragon Racing - Personal Best Record - Azure Span 06 Easy
	--		2090, -- Dragon Racing - Personal Best Record - Azure Span 06 Hard
	--		2091, -- Dragon Racing - Tracking [DNT]
	--		2092, -- Dragon Racing - Personal Best Record - Thaldraszus 02 Easy
	--		2093, -- Dragon Racing - Personal Best Record - Thaldraszus 02 Hard
	--		2095, -- Dragon Racing - Personal Best Record - Thaldraszus MP 1
	--		2096, -- Dragon Racing - Personal Best Record - Thaldraszus 03 Easy
	--		2097, -- Dragon Racing - Personal Best Record - Thaldraszus 03 Hard
	--		2098, -- Dragon Racing - Personal Best Record - Thaldraszus 04 Easy
	--		2099, -- Dragon Racing - Personal Best Record - Thaldraszus 04 Hard
	--		2100, -- Dragon Racing - Versioning [DNT]
	--		2101, -- Dragon Racing - Personal Best Record - Thaldraszus 05 Easy
	--		2102, -- Dragon Racing - Personal Best Record - Thaldraszus 05 Hard
	--		2103, -- Dragon Racing - Personal Best Record - Thaldraszus 06 Easy
	--		2104, -- Dragon Racing - Personal Best Record - Thaldraszus 06 Hard
	--		2110, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains MP 1
	--		2111, -- Dragon Racing - Personal Best Record - Azure Span MP 1
	--		2119, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 07 Easy
	--		2120, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 07 Hard
	--		2124, -- Dragon Racing - Scoreboard - Race Complete Time - Fraction 10
	--		2125, -- Dragon Racing - Scoreboard - Race Complete Time - Fraction 100
	--		2126, -- Dragon Racing - Scoreboard - Race Complete Time -Silver Fract 10
	--		2128, -- Dragon Racing - Scoreboard - Race Complete Time -Silver Fract100
	--		2129, -- Dragon Racing - Scoreboard - Race Complete Time - Gold Fract 10
	--		2130, -- Dragon Racing - Scoreboard - Race Complete Time - Gold Fract 100
	--		2131, -- Dragon Racing - Scoreboard - Personal Best Time - Fraction 10
	--		2132, -- Dragon Racing - Scoreboard - Personal Best Time - Fraction 100
	--		2133, -- Dragonriding - Accepting Passengers [DNT]
	--		2154, -- Dragon Racing - Personal Best Record - Waking Shores 01 Reverse
	--		2155, -- Dragon Racing - Best Time Display - Whole
	--		2156, -- Dragon Racing - Best Time Display - Fraction 1
	--		2157, -- Dragon Racing - Best Time Display - Fraction 10
	--		2158, -- Dragon Racing - Best Time Display - Fraction 100
	--		2159, -- Dragon Racing - Best Time Display - Advanced - Whole
	--		2160, -- Dragon Racing - Best Time Display - Advanced - Fraction 1
	--		2161, -- Dragon Racing - Best Time Display - Advanced - Fraction 10
	--		2162, -- Dragon Racing - Best Time Display - Advanced - Fraction 100
	--		2176, -- Dragon Racing - Personal Best Record - Waking Shores 02 Reverse
	--		2177, -- Dragon Racing - Personal Best Record - Waking Shores 03 Reverse
	--		2178, -- Dragon Racing - Personal Best Record - Waking Shores 04 Reverse
	--		2179, -- Dragon Racing - Personal Best Record - Waking Shores 05 Reverse
	--		2180, -- Dragon Racing - Personal Best Record - Waking Shores 06 Reverse
	--		2181, -- Dragon Racing - Personal Best Record - Waking Shores 07 Reverse
	--		2182, -- Dragon Racing - Personal Best Record - Waking Shores 08 Reverse
	--		2183, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains01Reverse
	--		2184, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains02Reverse
	--		2185, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains03Reverse
	--		2186, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains04Reverse
	--		2187, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains07Reverse
	--		2188, -- Dragon Racing - Personal Best Record - Azure Span 01 Reverse
	--		2189, -- Dragon Racing - Personal Best Record - Azure Span 02 Reverse
	--		2190, -- Dragon Racing - Personal Best Record - Azure Span 03 Reverse
	--		2191, -- Dragon Racing - Personal Best Record - Azure Span 04 Reverse
	--		2192, -- Dragon Racing - Personal Best Record - Azure Span 05 Reverse
	--		2193, -- Dragon Racing - Personal Best Record - Azure Span 06 Reverse
	--		2194, -- Dragon Racing - Personal Best Record - Thaldraszus 01 Reverse
	--		2195, -- Dragon Racing - Personal Best Record - Thaldraszus 02 Reverse
	--		2196, -- Dragon Racing - Personal Best Record - Thaldraszus 03 Reverse
	--		2197, -- Dragon Racing - Personal Best Record - Thaldraszus 04 Reverse
	--		2198, -- Dragon Racing - Personal Best Record - Thaldraszus 05 Reverse
	--		2199, -- Dragon Racing - Personal Best Record - Thaldraszus 06 Reverse
	--		2201, -- Dragon Racing - Personal Best Record - F Reach 01
	--		2202, -- Dragon Racing - Personal Best Record - F Reach 02
	--		2203, -- Dragon Racing - Personal Best Record - F Reach 03
	--		2204, -- Dragon Racing - Personal Best Record - F Reach 04
	--		2205, -- Dragon Racing - Personal Best Record - F Reach 05
	--		2206, -- Dragon Racing - Personal Best Record - F Reach 06
	--		2207, -- Dragon Racing - Personal Best Record - F Reach 01 Advanced
	--		2208, -- Dragon Racing - Personal Best Record - F Reach 02 Advanced
	--		2209, -- Dragon Racing - Personal Best Record - F Reach 03 Advanced
	--		2210, -- Dragon Racing - Personal Best Record - F Reach 04 Advanced
	--		2211, -- Dragon Racing - Personal Best Record - F Reach 05 Advanced
	--		2212, -- Dragon Racing - Personal Best Record - F Reach 06 Advanced
	--		2213, -- Dragon Racing - Personal Best Record - F Reach 01 Reverse
	--		2214, -- Dragon Racing - Personal Best Record - F Reach 02 Reverse
	--		2215, -- Dragon Racing - Personal Best Record - F Reach 03 Reverse
	--		2216, -- Dragon Racing - Personal Best Record - F Reach 04 Reverse
	--		2217, -- Dragon Racing - Personal Best Record - F Reach 05 Reverse
	--		2218, -- Dragon Racing - Personal Best Record - F Reach 06 Reverse
	--		2224, -- Dragon Racing - Best Time Display - Reverse - Whole
	--		2225, -- Dragon Racing - Best Time Display - Reverse - Fraction 1
	--		2226, -- Dragon Racing - Best Time Display - Reverse - Fraction 10
	--		2227, -- Dragon Racing - Best Time Display - Reverse - Fraction 100
	--		2235, -- 10.0 Dragonrider PVP - Whirling Surge Dismounts 10.0.2 [DNT]
	--		2236, -- Dragon Racing - Scoreboard - Race Complete Time MS
	--		2237, -- 10.0 Dragonrider PVP - Whirling Surge Dismounts 10.0.5 [DNT]
	--		2246, -- Dragon Racing - Personal Best Record - Z Cavern 01
	--		2247, -- Dragon Racing - Personal Best Record - Z Cavern 02
	--		2248, -- Dragon Racing - Personal Best Record - Z Cavern 03
	--		2249, -- Dragon Racing - Personal Best Record - Z Cavern 04
	--		2250, -- Dragon Racing - Personal Best Record - Z Cavern 05
	--		2251, -- Dragon Racing - Personal Best Record - Z Cavern 06
	--		2252, -- Dragon Racing - Personal Best Record - Z Cavern 01 Advanced
	--		2253, -- Dragon Racing - Personal Best Record - Z Cavern 02 Advanced
	--		2254, -- Dragon Racing - Personal Best Record - Z Cavern 03 Advanced
	--		2255, -- Dragon Racing - Personal Best Record - Z Cavern 04 Advanced
	--		2256, -- Dragon Racing - Personal Best Record - Z Cavern 05 Advanced
	--		2257, -- Dragon Racing - Personal Best Record - Z Cavern 06 Advanced
	--		2258, -- Dragon Racing - Personal Best Record - Z Cavern 01 Reverse
	--		2259, -- Dragon Racing - Personal Best Record - Z Cavern 02 Reverse
	--		2260, -- Dragon Racing - Personal Best Record - Z Cavern 03 Reverse
	--		2261, -- Dragon Racing - Personal Best Record - Z Cavern 04 Reverse
	--		2262, -- Dragon Racing - Personal Best Record - Z Cavern 05 Reverse
	--		2263, -- Dragon Racing - Personal Best Record - Z Cavern 06 Reverse
	--		2281, -- Dragon Racing - Personal Best Record - Test
	--		2312, -- Dragon Racing - Personal Best Record - Kalimdor 01
	--		2313, -- Dragon Racing - Personal Best Record - Kalimdor 02
	--		2314, -- Dragon Racing - Personal Best Record - Kalimdor 03
	--		2315, -- Dragon Racing - Personal Best Record - Kalimdor 04
	--		2316, -- Dragon Racing - Personal Best Record - Kalimdor 05
	--		2317, -- Dragon Racing - Personal Best Record - Kalimdor 06
	--		2318, -- Dragon Racing - Personal Best Record - Kalimdor 07
	--		2319, -- Dragon Racing - Personal Best Record - Kalimdor 08
	--		2320, -- Dragon Racing - Personal Best Record - Kalimdor 09
	--		2321, -- Dragon Racing - Personal Best Record - Kalimdor 10
	--		2322, -- Dragon Racing - Personal Best Record - Kalimdor 11
	--		2323, -- Dragon Racing - Personal Best Record - Kalimdor 12
	--		2324, -- Dragon Racing - Personal Best Record - Kalimdor 13
	--		2325, -- Dragon Racing - Personal Best Record - Kalimdor 14
	--		2326, -- Dragon Racing - Personal Best Record - Kalimdor 15
	--		2327, -- Dragon Racing - Personal Best Record - Kalimdor 16
	--		2328, -- Dragon Racing - Personal Best Record - Kalimdor 17
	--		2329, -- Dragon Racing - Personal Best Record - Kalimdor 18
	--		2330, -- Dragon Racing - Personal Best Record - Kalimdor 19
	--		2331, -- Dragon Racing - Personal Best Record - Kalimdor 20
	--		2332, -- Dragon Racing - Personal Best Record - Kalimdor 21
	--		2333, -- Dragon Racing - Personal Best Record - Kalimdor 22
	--		2334, -- Dragon Racing - Personal Best Record - Kalimdor 23
	--		2335, -- Dragon Racing - Personal Best Record - Kalimdor 24
	--		2336, -- Dragon Racing - Personal Best Record - Kalimdor 25
	--		2337, -- Dragon Racing - Personal Best Record - Kalimdor 26
	--		2338, -- Dragon Racing - Personal Best Record - Kalimdor 27
	--		2339, -- Dragon Racing - Personal Best Record - Kalimdor 28
	--		2340, -- Dragon Racing - Personal Best Record - Kalimdor 29
	--		2341, -- Dragon Racing - Personal Best Record - Kalimdor 30
	--		2342, -- Dragon Racing - Personal Best Record - Kalimdor 01 Advanced
	--		2343, -- Dragon Racing - Personal Best Record - Kalimdor 02 Advanced
	--		2344, -- Dragon Racing - Personal Best Record - Kalimdor 03 Advanced
	--		2345, -- Dragon Racing - Personal Best Record - Kalimdor 04 Advanced
	--		2346, -- Dragon Racing - Personal Best Record - Kalimdor 05 Advanced
	--		2347, -- Dragon Racing - Personal Best Record - Kalimdor 06 Advanced
	--		2348, -- Dragon Racing - Personal Best Record - Kalimdor 07 Advanced
	--		2349, -- Dragon Racing - Personal Best Record - Kalimdor 08 Advanced
	--		2350, -- Dragon Racing - Personal Best Record - Kalimdor 09 Advanced
	--		2351, -- Dragon Racing - Personal Best Record - Kalimdor 10 Advanced
	--		2352, -- Dragon Racing - Personal Best Record - Kalimdor 11 Advanced
	--		2353, -- Dragon Racing - Personal Best Record - Kalimdor 12 Advanced
	--		2354, -- Dragon Racing - Personal Best Record - Kalimdor 13 Advanced
	--		2355, -- Dragon Racing - Personal Best Record - Kalimdor 14 Advanced
	--		2356, -- Dragon Racing - Personal Best Record - Kalimdor 15 Advanced
	--		2357, -- Dragon Racing - Personal Best Record - Kalimdor 16 Advanced
	--		2358, -- Dragon Racing - Personal Best Record - Kalimdor 17 Advanced
	--		2359, -- Dragon Racing - Personal Best Record - Kalimdor 18 Advanced
	--		2360, -- Dragon Racing - Personal Best Record - Kalimdor 19 Advanced
	--		2361, -- Dragon Racing - Personal Best Record - Kalimdor 20 Advanced
	--		2362, -- Dragon Racing - Personal Best Record - Kalimdor 21 Advanced
	--		2363, -- Dragon Racing - Personal Best Record - Kalimdor 22 Advanced
	--		2364, -- Dragon Racing - Personal Best Record - Kalimdor 23 Advanced
	--		2365, -- Dragon Racing - Personal Best Record - Kalimdor 24 Advanced
	--		2366, -- Dragon Racing - Personal Best Record - Kalimdor 25 Advanced
	--		2367, -- Dragon Racing - Personal Best Record - Kalimdor 26 Advanced
	--		2368, -- Dragon Racing - Personal Best Record - Kalimdor 27 Advanced
	--		2369, -- Dragon Racing - Personal Best Record - Kalimdor 28 Advanced
	--		2370, -- Dragon Racing - Personal Best Record - Kalimdor 29 Advanced
	--		2371, -- Dragon Racing - Personal Best Record - Kalimdor 30 Advanced
	--		2372, -- Dragon Racing - Personal Best Record - Kalimdor 01 Reverse
	--		2373, -- Dragon Racing - Personal Best Record - Kalimdor 02 Reverse
	--		2374, -- Dragon Racing - Personal Best Record - Kalimdor 03 Reverse
	--		2375, -- Dragon Racing - Personal Best Record - Kalimdor 04 Reverse
	--		2376, -- Dragon Racing - Personal Best Record - Kalimdor 05 Reverse
	--		2377, -- Dragon Racing - Personal Best Record - Kalimdor 06 Reverse
	--		2378, -- Dragon Racing - Personal Best Record - Kalimdor 07 Reverse
	--		2379, -- Dragon Racing - Personal Best Record - Kalimdor 08 Reverse
	--		2380, -- Dragon Racing - Personal Best Record - Kalimdor 09 Reverse
	--		2381, -- Dragon Racing - Personal Best Record - Kalimdor 10 Reverse
	--		2382, -- Dragon Racing - Personal Best Record - Kalimdor 11 Reverse
	--		2383, -- Dragon Racing - Personal Best Record - Kalimdor 12 Reverse
	--		2384, -- Dragon Racing - Personal Best Record - Kalimdor 13 Reverse
	--		2385, -- Dragon Racing - Personal Best Record - Kalimdor 14 Reverse
	--		2386, -- Dragon Racing - Personal Best Record - Kalimdor 15 Reverse
	--		2387, -- Dragon Racing - Personal Best Record - Kalimdor 16 Reverse
	--		2388, -- Dragon Racing - Personal Best Record - Kalimdor 17 Reverse
	--		2389, -- Dragon Racing - Personal Best Record - Kalimdor 18 Reverse
	--		2390, -- Dragon Racing - Personal Best Record - Kalimdor 19 Reverse
	--		2391, -- Dragon Racing - Personal Best Record - Kalimdor 20 Reverse
	--		2392, -- Dragon Racing - Personal Best Record - Kalimdor 21 Reverse
	--		2393, -- Dragon Racing - Personal Best Record - Kalimdor 22 Reverse
	--		2394, -- Dragon Racing - Personal Best Record - Kalimdor 23 Reverse
	--		2395, -- Dragon Racing - Personal Best Record - Kalimdor 24 Reverse
	--		2396, -- Dragon Racing - Personal Best Record - Kalimdor 25 Reverse
	--		2397, -- Dragon Racing - Personal Best Record - Kalimdor 26 Reverse
	--		2398, -- Dragon Racing - Personal Best Record - Kalimdor 27 Reverse
	--		2399, -- Dragon Racing - Personal Best Record - Kalimdor 28 Reverse
	--		2400, -- Dragon Racing - Personal Best Record - Kalimdor 29 Reverse
	--		2401, -- Dragon Racing - Personal Best Record - Kalimdor 30 Reverse
	--		2414, -- 10.1.5 Whelp Daycare - Whelp Racing - Black - 001 (OJF)
	--		2415, -- 10.1.5 Whelp Daycare - Whelp Racing - Blue - 001 (OJF)
	--		2416, -- 10.1.5 Whelp Daycare - Whelp Racing - Bronze - 001 (OJF)
	--		2417, -- 10.1.5 Whelp Daycare - Whelp Racing - Green - 001 (OJF)
	--		2418, -- 10.1.5 Whelp Daycare - Whelp Racing - Red - 001 (OJF)
	--		2421, -- Dragon Racing - Personal Best Record - Waking Shores 01 Challeng
	--		2422, -- Dragon Racing - Personal Best Record - Waking Shores 01 ChallenR
	--		2423, -- Dragon Racing - Personal Best Record - Waking Shores 02 Challeng
	--		2424, -- Dragon Racing - Personal Best Record - Waking Shores 02 ChallenR
	--		2425, -- Dragon Racing - Personal Best Record - Waking Shores 03 Challeng
	--		2426, -- Dragon Racing - Personal Best Record - Waking Shores 03 ChallenR
	--		2427, -- Dragon Racing - Personal Best Record - Waking Shores 04 Challeng
	--		2428, -- Dragon Racing - Personal Best Record - Waking Shores 04 ChallenR
	--		2429, -- Dragon Racing - Personal Best Record - Waking Shores 05 Challeng
	--		2430, -- Dragon Racing - Personal Best Record - Waking Shores 05 ChallenR
	--		2431, -- Dragon Racing - Personal Best Record - Waking Shores 06 Challeng
	--		2432, -- Dragon Racing - Personal Best Record - Waking Shores 06 ChallenR
	--		2433, -- Dragon Racing - Personal Best Record - Waking Shores 07 Challeng
	--		2434, -- Dragon Racing - Personal Best Record - Waking Shores 07 ChallenR
	--		2435, -- Dragon Racing - Personal Best Record - Waking Shores 08 Challeng
	--		2436, -- Dragon Racing - Personal Best Record - Waking Shores 08 ChallenR
	--		2437, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 01 Chall
	--		2439, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 01 ChalR
	--		2440, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 02 Chall
	--		2441, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 02 ChalR
	--		2442, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 03 Chall
	--		2443, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 03 ChalR
	--		2444, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 04 Chall
	--		2445, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 04 ChalR
	--		2446, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 05 Chall
	--		2447, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 06 Chall
	--		2448, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 07 Chall
	--		2449, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 07 ChalR
	--		2450, -- Dragon Racing - Personal Best Record - Azure Span 01 Challenge
	--		2451, -- Dragon Racing - Personal Best Record - Azure Span 01 Challenge R
	--		2452, -- Dragon Racing - Personal Best Record - Azure Span 02 Challenge
	--		2453, -- Dragon Racing - Personal Best Record - Azure Span 02 Challenge R
	--		2454, -- Dragon Racing - Personal Best Record - Azure Span 03 Challenge
	--		2455, -- Dragon Racing - Personal Best Record - Azure Span 03 Challenge R
	--		2456, -- Dragon Racing - Personal Best Record - Azure Span 04 Challenge
	--		2457, -- Dragon Racing - Personal Best Record - Azure Span 04 Challenge R
	--		2458, -- Dragon Racing - Personal Best Record - Azure Span 05 Challenge
	--		2459, -- Dragon Racing - Personal Best Record - Azure Span 05 Challenge R
	--		2460, -- Dragon Racing - Personal Best Record - Azure Span 06 Challenge
	--		2461, -- Dragon Racing - Personal Best Record - Azure Span 06 Challenge R
	--		2462, -- Dragon Racing - Personal Best Record - Thaldraszus 01 Challenge
	--		2463, -- Dragon Racing - Personal Best Record - Thaldraszus 01 ChallengeR
	--		2464, -- Dragon Racing - Personal Best Record - Thaldraszus 02 Challenge
	--		2465, -- Dragon Racing - Personal Best Record - Thaldraszus 02 ChallengeR
	--		2466, -- Dragon Racing - Personal Best Record - Thaldraszus 03 Challenge
	--		2467, -- Dragon Racing - Personal Best Record - Thaldraszus 03 ChallengeR
	--		2468, -- Dragon Racing - Personal Best Record - Thaldraszus 04 Challenge
	--		2469, -- Dragon Racing - Personal Best Record - Thaldraszus 04 ChallengeR
	--		2470, -- Dragon Racing - Personal Best Record - Thaldraszus 05 Challenge
	--		2471, -- Dragon Racing - Personal Best Record - Thaldraszus 05 ChallengeR
	--		2472, -- Dragon Racing - Personal Best Record - Thaldraszus 06 Challenge
	--		2473, -- Dragon Racing - Personal Best Record - Thaldraszus 06 ChallengeR
	--		2474, -- Dragon Racing - Personal Best Record - F Reach 01 Challenge
	--		2475, -- Dragon Racing - Personal Best Record - F Reach 01 Challenge R
	--		2476, -- Dragon Racing - Personal Best Record - F Reach 02 Challenge
	--		2477, -- Dragon Racing - Personal Best Record - F Reach 02 Challenge R
	--		2478, -- Dragon Racing - Personal Best Record - F Reach 03 Challenge
	--		2479, -- Dragon Racing - Personal Best Record - F Reach 03 Challenge R
	--		2480, -- Dragon Racing - Personal Best Record - F Reach 04 Challenge
	--		2481, -- Dragon Racing - Personal Best Record - F Reach 04 Challenge R
	--		2482, -- Dragon Racing - Personal Best Record - F Reach 05 Challenge
	--		2483, -- Dragon Racing - Personal Best Record - F Reach 05 Challenge R
	--		2484, -- Dragon Racing - Personal Best Record - F Reach 06 Challenge
	--		2485, -- Dragon Racing - Personal Best Record - F Reach 06 Challenge R
	--		2486, -- Dragon Racing - Personal Best Record - Z Cavern 01 Challenge
	--		2487, -- Dragon Racing - Personal Best Record - Z Cavern 01 Challenge R
	--		2488, -- Dragon Racing - Personal Best Record - Z Cavern 02 Challenge
	--		2489, -- Dragon Racing - Personal Best Record - Z Cavern 02 Challenge R
	--		2490, -- Dragon Racing - Personal Best Record - Z Cavern 03 Challenge
	--		2491, -- Dragon Racing - Personal Best Record - Z Cavern 03 Challenge R
	--		2492, -- Dragon Racing - Personal Best Record - Z Cavern 04 Challenge
	--		2493, -- Dragon Racing - Personal Best Record - Z Cavern 04 Challenge R
	--		2494, -- Dragon Racing - Personal Best Record - Z Cavern 05 Challenge
	--		2495, -- Dragon Racing - Personal Best Record - Z Cavern 05 Challenge R
	--		2496, -- Dragon Racing - Personal Best Record - Z Cavern 06 Challenge
	--		2497, -- Dragon Racing - Personal Best Record - Z Cavern 06 Challenge R
	--		2498, -- Dragon Racing - Personal Best Record - Kalimdor 01 Challenge
	--		2499, -- Dragon Racing - Personal Best Record - Kalimdor 01 Challenge R
	--		2500, -- Dragon Racing - Personal Best Record - Kalimdor 02 Challenge
	--		2501, -- Dragon Racing - Personal Best Record - Kalimdor 02 Challenge R
	--		2502, -- Dragon Racing - Personal Best Record - Kalimdor 03 Challenge
	--		2503, -- Dragon Racing - Personal Best Record - Kalimdor 03 Challenge R
	--		2504, -- Dragon Racing - Personal Best Record - Kalimdor 04 Challenge
	--		2505, -- Dragon Racing - Personal Best Record - Kalimdor 04 Challenge R
	--		2506, -- Dragon Racing - Personal Best Record - Kalimdor 05 Challenge
	--		2507, -- Dragon Racing - Personal Best Record - Kalimdor 05 Challenge R
	--		2508, -- Dragon Racing - Personal Best Record - Kalimdor 06 Challenge
	--		2509, -- Dragon Racing - Personal Best Record - Kalimdor 06 Challenge R
	--		2510, -- Dragon Racing - Personal Best Record - Kalimdor 07 Challenge
	--		2511, -- Dragon Racing - Personal Best Record - Kalimdor 07 Challenge R
	--		2512, -- Dragon Racing - Personal Best Record - Kalimdor 08 Challenge
	--		2513, -- Dragon Racing - Personal Best Record - Kalimdor 08 Challenge R
	--		2514, -- Dragon Racing - Personal Best Record - Kalimdor 09 Challenge
	--		2515, -- Dragon Racing - Personal Best Record - Kalimdor 09 Challenge R
	--		2516, -- Dragon Racing - Personal Best Record - Kalimdor 10 Challenge
	--		2517, -- Dragon Racing - Personal Best Record - Kalimdor 10 Challenge R
	--		2518, -- Dragon Racing - Personal Best Record - Kalimdor 11 Challenge
	--		2519, -- Dragon Racing - Personal Best Record - Kalimdor 11 Challenge R
	--		2520, -- Dragon Racing - Personal Best Record - Kalimdor 12 Challenge
	--		2521, -- Dragon Racing - Personal Best Record - Kalimdor 12 Challenge R
	--		2522, -- Dragon Racing - Personal Best Record - Kalimdor 13 Challenge
	--		2523, -- Dragon Racing - Personal Best Record - Kalimdor 13 Challenge R
	--		2524, -- Dragon Racing - Personal Best Record - Kalimdor 14 Challenge
	--		2525, -- Dragon Racing - Personal Best Record - Kalimdor 14 Challenge R
	--		2526, -- Dragon Racing - Personal Best Record - Kalimdor 15 Challenge
	--		2527, -- Dragon Racing - Personal Best Record - Kalimdor 15 Challenge R
	--		2528, -- Dragon Racing - Personal Best Record - Kalimdor 16 Challenge
	--		2529, -- Dragon Racing - Personal Best Record - Kalimdor 16 Challenge R
	--		2536, -- Dragon Racing - Personal Best Record - E Kingdoms 01
	--		2537, -- Dragon Racing - Personal Best Record - E Kingdoms 02
	--		2538, -- Dragon Racing - Personal Best Record - E Kingdoms 03
	--		2539, -- Dragon Racing - Personal Best Record - E Kingdoms 04
	--		2540, -- Dragon Racing - Personal Best Record - E Kingdoms 05
	--		2541, -- Dragon Racing - Personal Best Record - E Kingdoms 06
	--		2542, -- Dragon Racing - Personal Best Record - E Kingdoms 07
	--		2543, -- Dragon Racing - Personal Best Record - E Kingdoms 08
	--		2544, -- Dragon Racing - Personal Best Record - E Kingdoms 09
	--		2545, -- Dragon Racing - Personal Best Record - E Kingdoms 10
	--		2546, -- Dragon Racing - Personal Best Record - E Kingdoms 11
	--		2547, -- Dragon Racing - Personal Best Record - E Kingdoms 12
	--		2548, -- Dragon Racing - Personal Best Record - E Kingdoms 13
	--		2549, -- Dragon Racing - Personal Best Record - E Kingdoms 14
	--		2550, -- Dragon Racing - Personal Best Record - E Kingdoms 15
	--		2551, -- Dragon Racing - Personal Best Record - E Kingdoms 16
	--		2552, -- Dragon Racing - Personal Best Record - E Kingdoms 01 Advanced
	--		2553, -- Dragon Racing - Personal Best Record - E Kingdoms 02 Advanced
	--		2554, -- Dragon Racing - Personal Best Record - E Kingdoms 03 Advanced
	--		2555, -- Dragon Racing - Personal Best Record - E Kingdoms 04 Advanced
	--		2556, -- Dragon Racing - Personal Best Record - E Kingdoms 05 Advanced
	--		2557, -- Dragon Racing - Personal Best Record - E Kingdoms 06 Advanced
	--		2558, -- Dragon Racing - Personal Best Record - E Kingdoms 07 Advanced
	--		2559, -- Dragon Racing - Personal Best Record - E Kingdoms 08 Advanced
	--		2560, -- Dragon Racing - Personal Best Record - E Kingdoms 09 Advanced
	--		2561, -- Dragon Racing - Personal Best Record - E Kingdoms 10 Advanced
	--		2562, -- Dragon Racing - Personal Best Record - E Kingdoms 11 Advanced
	--		2563, -- Dragon Racing - Personal Best Record - E Kingdoms 12 Advanced
	--		2564, -- Dragon Racing - Personal Best Record - E Kingdoms 13 Advanced
	--		2565, -- Dragon Racing - Personal Best Record - E Kingdoms 14 Advanced
	--		2566, -- Dragon Racing - Personal Best Record - E Kingdoms 15 Advanced
	--		2567, -- Dragon Racing - Personal Best Record - E Kingdoms 16 Advanced
	--		2568, -- Dragon Racing - Personal Best Record - E Kingdoms 01 Reverse
	--		2569, -- Dragon Racing - Personal Best Record - E Kingdoms 02 Reverse
	--		2570, -- Dragon Racing - Personal Best Record - E Kingdoms 03 Reverse
	--		2571, -- Dragon Racing - Personal Best Record - E Kingdoms 04 Reverse
	--		2572, -- Dragon Racing - Personal Best Record - E Kingdoms 05 Reverse
	--		2573, -- Dragon Racing - Personal Best Record - E Kingdoms 06 Reverse
	--		2574, -- Dragon Racing - Personal Best Record - E Kingdoms 07 Reverse
	--		2575, -- Dragon Racing - Personal Best Record - E Kingdoms 08 Reverse
	--		2576, -- Dragon Racing - Personal Best Record - E Kingdoms 09 Reverse
	--		2577, -- Dragon Racing - Personal Best Record - E Kingdoms 10 Reverse
	--		2578, -- Dragon Racing - Personal Best Record - E Kingdoms 11 Reverse
	--		2579, -- Dragon Racing - Personal Best Record - E Kingdoms 12 Reverse
	--		2580, -- Dragon Racing - Personal Best Record - E Kingdoms 13 Reverse
	--		2581, -- Dragon Racing - Personal Best Record - E Kingdoms 14 Reverse
	--		2582, -- Dragon Racing - Personal Best Record - E Kingdoms 15 Reverse
	--		2583, -- Dragon Racing - Personal Best Record - E Kingdoms 16 Reverse
	--		2595, -- Dragon Racing - Medal Widget - Normal [DNT]
	--		2596, -- Dragon Racing - Medal Widget - Advanced [DNT]
	--		2597, -- Dragon Racing - Medal Widget - Reverse [DNT]
	--		2598, -- Dragon Racing - Medal Widget - Temp [DNT]
	--		2599, -- Dragon Racing - Medal Widget - Temp2 [DNT]
	--		2600, -- Dragon Racing - Personal Best Record - Outland 01
	--		2601, -- Dragon Racing - Personal Best Record - Outland 02
	--		2602, -- Dragon Racing - Personal Best Record - Outland 03
	--		2603, -- Dragon Racing - Personal Best Record - Outland 04
	--		2604, -- Dragon Racing - Personal Best Record - Outland 05
	--		2605, -- Dragon Racing - Personal Best Record - Outland 06
	--		2606, -- Dragon Racing - Personal Best Record - Outland 07
	--		2607, -- Dragon Racing - Personal Best Record - Outland 08
	--		2608, -- Dragon Racing - Personal Best Record - Outland 09
	--		2609, -- Dragon Racing - Personal Best Record - Outland 10
	--		2610, -- Dragon Racing - Personal Best Record - Outland 11
	--		2611, -- Dragon Racing - Personal Best Record - Outland 12
	--		2612, -- Dragon Racing - Personal Best Record - Outland 13
	--		2613, -- Dragon Racing - Personal Best Record - Outland 14
	--		2614, -- Dragon Racing - Personal Best Record - Outland 15
	--		2615, -- Dragon Racing - Personal Best Record - Outland 01 Advanced
	--		2616, -- Dragon Racing - Personal Best Record - Outland 02 Advanced
	--		2617, -- Dragon Racing - Personal Best Record - Outland 03 Advanced
	--		2618, -- Dragon Racing - Personal Best Record - Outland 04 Advanced
	--		2619, -- Dragon Racing - Personal Best Record - Outland 05 Advanced
	--		2620, -- Dragon Racing - Personal Best Record - Outland 06 Advanced
	--		2621, -- Dragon Racing - Personal Best Record - Outland 07 Advanced
	--		2622, -- Dragon Racing - Personal Best Record - Outland 08 Advanced
	--		2623, -- Dragon Racing - Personal Best Record - Outland 09 Advanced
	--		2624, -- Dragon Racing - Personal Best Record - Outland 10 Advanced
	--		2625, -- Dragon Racing - Personal Best Record - Outland 11 Advanced
	--		2626, -- Dragon Racing - Personal Best Record - Outland 12 Advanced
	--		2627, -- Dragon Racing - Personal Best Record - Outland 13 Advanced
	--		2628, -- Dragon Racing - Personal Best Record - Outland 14 Advanced
	--		2629, -- Dragon Racing - Personal Best Record - Outland 15 Advanced
	--		2630, -- Dragon Racing - Personal Best Record - Outland 01 Reverse
	--		2631, -- Dragon Racing - Personal Best Record - Outland 02 Reverse
	--		2632, -- Dragon Racing - Personal Best Record - Outland 03 Reverse
	--		2633, -- Dragon Racing - Personal Best Record - Outland 04 Reverse
	--		2634, -- Dragon Racing - Personal Best Record - Outland 05 Reverse
	--		2635, -- Dragon Racing - Personal Best Record - Outland 06 Reverse
	--		2636, -- Dragon Racing - Personal Best Record - Outland 07 Reverse
	--		2637, -- Dragon Racing - Personal Best Record - Outland 08 Reverse
	--		2638, -- Dragon Racing - Personal Best Record - Outland 09 Reverse
	--		2639, -- Dragon Racing - Personal Best Record - Outland 10 Reverse
	--		2640, -- Dragon Racing - Personal Best Record - Outland 11 Reverse
	--		2641, -- Dragon Racing - Personal Best Record - Outland 12 Reverse
	--		2642, -- Dragon Racing - Personal Best Record - Outland 13 Reverse
	--		2643, -- Dragon Racing - Personal Best Record - Outland 14 Reverse
	--		2644, -- Dragon Racing - Personal Best Record - Outland 15 Reverse
	--		2654, -- Dragon Racing - Kalimdor Cup Preferred Mount
	--		2658, -- Dragon Racing - Personal Best Record - Outland 16
	--		2659, -- Dragon Racing - Personal Best Record - Outland 17
	--		2660, -- Dragon Racing - Personal Best Record - Outland 18
	--		2661, -- Dragon Racing - Personal Best Record - Outland 19
	--		2662, -- Dragon Racing - Personal Best Record - Outland 20
	--		2663, -- Dragon Racing - Personal Best Record - Outland 21
	--		2664, -- Dragon Racing - Personal Best Record - Outland 16 Advanced
	--		2665, -- Dragon Racing - Personal Best Record - Outland 17 Advanced
	--		2666, -- Dragon Racing - Personal Best Record - Outland 18 Advanced
	--		2667, -- Dragon Racing - Personal Best Record - Outland 19 Advanced
	--		2668, -- Dragon Racing - Personal Best Record - Outland 20 Advanced
	--		2669, -- Dragon Racing - Personal Best Record - Outland 21 Advanced
	--		2670, -- Dragon Racing - Personal Best Record - Outland 16 Reverse
	--		2671, -- Dragon Racing - Personal Best Record - Outland 17 Reverse
	--		2672, -- Dragon Racing - Personal Best Record - Outland 18 Reverse
	--		2673, -- Dragon Racing - Personal Best Record - Outland 19 Reverse
	--		2674, -- Dragon Racing - Personal Best Record - Outland 20 Reverse
	--		2675, -- Dragon Racing - Personal Best Record - Outland 21 Reverse
	--		2676, -- Dragon Racing - Personal Best Record - Emerald Dream 01
	--		2677, -- Dragon Racing - Personal Best Record - Emerald Dream 02
	--		2678, -- Dragon Racing - Personal Best Record - Emerald Dream 03
	--		2679, -- Dragon Racing - Personal Best Record - Emerald Dream 04
	--		2680, -- Dragon Racing - Personal Best Record - Emerald Dream 05
	--		2681, -- Dragon Racing - Personal Best Record - Emerald Dream 06
	--		2682, -- Dragon Racing - Personal Best Record - Emerald Dream 01 Advanced
	--		2683, -- Dragon Racing - Personal Best Record - Emerald Dream 02 Advanced
	--		2684, -- Dragon Racing - Personal Best Record - Emerald Dream 03 Advanced
	--		2685, -- Dragon Racing - Personal Best Record - Emerald Dream 04 Advanced
	--		2686, -- Dragon Racing - Personal Best Record - Emerald Dream 05 Advanced
	--		2687, -- Dragon Racing - Personal Best Record - Emerald Dream 06 Advanced
	--		2688, -- Dragon Racing - Personal Best Record - Emerald Dream 01 Reverse
	--		2689, -- Dragon Racing - Personal Best Record - Emerald Dream 02 Reverse
	--		2690, -- Dragon Racing - Personal Best Record - Emerald Dream 03 Reverse
	--		2691, -- Dragon Racing - Personal Best Record - Emerald Dream 04 Reverse
	--		2692, -- Dragon Racing - Personal Best Record - Emerald Dream 05 Reverse
	--		2693, -- Dragon Racing - Personal Best Record - Emerald Dream 06 Reverse
	--		2694, -- Dragon Racing - Personal Best Record - ED 01 Challenge
	--		2695, -- Dragon Racing - Personal Best Record - ED 01 Challenge R
	--		2696, -- Dragon Racing - Personal Best Record - ED 02 Challenge
	--		2697, -- Dragon Racing - Personal Best Record - ED 02 Challenge R
	--		2698, -- Dragon Racing - Personal Best Record - ED 03 Challenge
	--		2699, -- Dragon Racing - Personal Best Record - ED 03 Challenge R
	--		2700, -- Dragon Racing - Personal Best Record - ED 04 Challenge
	--		2701, -- Dragon Racing - Personal Best Record - ED 04 Challenge R
	--		2702, -- Dragon Racing - Personal Best Record - ED 05 Challenge
	--		2703, -- Dragon Racing - Personal Best Record - ED 05 Challenge R
	--		2704, -- Dragon Racing - Personal Best Record - ED 06 Challenge
	--		2705, -- Dragon Racing - Personal Best Record - ED 06 Challenge R
	--		2720, -- Dragon Racing - Personal Best Record - Northrend 01
	--		2721, -- Dragon Racing - Personal Best Record - Northrend 02
	--		2722, -- Dragon Racing - Personal Best Record - Northrend 03
	--		2723, -- Dragon Racing - Personal Best Record - Northrend 04
	--		2724, -- Dragon Racing - Personal Best Record - Northrend 05
	--		2725, -- Dragon Racing - Personal Best Record - Northrend 06
	--		2726, -- Dragon Racing - Personal Best Record - Northrend 07
	--		2727, -- Dragon Racing - Personal Best Record - Northrend 08
	--		2728, -- Dragon Racing - Personal Best Record - Northrend 09
	--		2729, -- Dragon Racing - Personal Best Record - Northrend 10
	--		2730, -- Dragon Racing - Personal Best Record - Northrend 11
	--		2731, -- Dragon Racing - Personal Best Record - Northrend 12
	--		2732, -- Dragon Racing - Personal Best Record - Northrend 13
	--		2733, -- Dragon Racing - Personal Best Record - Northrend 14
	--		2734, -- Dragon Racing - Personal Best Record - Northrend 15
	--		2735, -- Dragon Racing - Personal Best Record - Northrend 16
	--		2736, -- Dragon Racing - Personal Best Record - Northrend 17
	--		2737, -- Dragon Racing - Personal Best Record - Northrend 18
	--		2738, -- Dragon Racing - Personal Best Record - Northrend 01 Advanced
	--		2739, -- Dragon Racing - Personal Best Record - Northrend 02 Advanced
	--		2740, -- Dragon Racing - Personal Best Record - Northrend 03 Advanced
	--		2741, -- Dragon Racing - Personal Best Record - Northrend 04 Advanced
	--		2742, -- Dragon Racing - Personal Best Record - Northrend 05 Advanced
	--		2743, -- Dragon Racing - Personal Best Record - Northrend 06 Advanced
	--		2744, -- Dragon Racing - Personal Best Record - Northrend 07 Advanced
	--		2745, -- Dragon Racing - Personal Best Record - Northrend 08 Advanced
	--		2746, -- Dragon Racing - Personal Best Record - Northrend 09 Advanced
	--		2747, -- Dragon Racing - Personal Best Record - Northrend 10 Advanced
	--		2748, -- Dragon Racing - Personal Best Record - Northrend 11 Advanced
	--		2749, -- Dragon Racing - Personal Best Record - Northrend 12 Advanced
	--		2750, -- Dragon Racing - Personal Best Record - Northrend 13 Advanced
	--		2751, -- Dragon Racing - Personal Best Record - Northrend 14 Advanced
	--		2752, -- Dragon Racing - Personal Best Record - Northrend 15 Advanced
	--		2753, -- Dragon Racing - Personal Best Record - Northrend 16 Advanced
	--		2754, -- Dragon Racing - Personal Best Record - Northrend 17 Advanced
	--		2755, -- Dragon Racing - Personal Best Record - Northrend 18 Advanced
	--		2756, -- Dragon Racing - Personal Best Record - Northrend 01 Reverse
	--		2757, -- Dragon Racing - Personal Best Record - Northrend 02 Reverse
	--		2758, -- Dragon Racing - Personal Best Record - Northrend 03 Reverse
	--		2759, -- Dragon Racing - Personal Best Record - Northrend 04 Reverse
	--		2760, -- Dragon Racing - Personal Best Record - Northrend 05 Reverse
	--		2761, -- Dragon Racing - Personal Best Record - Northrend 06 Reverse
	--		2762, -- Dragon Racing - Personal Best Record - Northrend 07 Reverse
	--		2763, -- Dragon Racing - Personal Best Record - Northrend 08 Reverse
	--		2764, -- Dragon Racing - Personal Best Record - Northrend 09 Reverse
	--		2765, -- Dragon Racing - Personal Best Record - Northrend 10 Reverse
	--		2766, -- Dragon Racing - Personal Best Record - Northrend 11 Reverse
	--		2767, -- Dragon Racing - Personal Best Record - Northrend 12 Reverse
	--		2768, -- Dragon Racing - Personal Best Record - Northrend 13 Reverse
	--		2769, -- Dragon Racing - Personal Best Record - Northrend 14 Reverse
	--		2770, -- Dragon Racing - Personal Best Record - Northrend 15 Reverse
	--		2771, -- Dragon Racing - Personal Best Record - Northrend 16 Reverse
	--		2772, -- Dragon Racing - Personal Best Record - Northrend 17 Reverse
	--		2773, -- Dragon Racing - Personal Best Record - Northrend 18 Reverse
	--		2923, -- Dragon Racing - Personal Best Record - 11 Z1 R1 Easy
	--		2924, -- Dragon Racing - Personal Best Record - 11 Z1 R2 Easy
	--		2925, -- Dragon Racing - Personal Best Record - 11 Z1 R3 Easy
	--		2926, -- Dragon Racing - Personal Best Record - 11 Z1 R4 Easy
	--		2927, -- Dragon Racing - Personal Best Record - 11 Z1 R5 Easy
	--		2928, -- Dragon Racing - Personal Best Record - 11 Z1 R6 Easy
	--		2929, -- Dragon Racing - Personal Best Record - 11 Z1 R1 Advanced
	--		2930, -- Dragon Racing - Personal Best Record - 11 Z1 R2 Advanced
	--		2931, -- Dragon Racing - Personal Best Record - 11 Z1 R3 Advanced
	--		2932, -- Dragon Racing - Personal Best Record - 11 Z1 R4 Advanced
	--		2933, -- Dragon Racing - Personal Best Record - 11 Z1 R5 Advanced
	--		2934, -- Dragon Racing - Personal Best Record - 11 Z1 R6 Advanced
	--		2935, -- Dragon Racing - Personal Best Record - 11 Z1 R1 Reverse
	--		2936, -- Dragon Racing - Personal Best Record - 11 Z1 R2 Reverse
	--		2937, -- Dragon Racing - Personal Best Record - 11 Z1 R3 Reverse
	--		2938, -- Dragon Racing - Personal Best Record - 11 Z1 R4 Reverse
	--		2939, -- Dragon Racing - Personal Best Record - 11 Z1 R5 Reverse
	--		2940, -- Dragon Racing - Personal Best Record - 11 Z1 R6 Reverse
	--		2941, -- Dragon Racing - Personal Best Record - 11 Z2 R1 Easy
	--		2942, -- Dragon Racing - Personal Best Record - 11 Z2 R2 Easy
	--		2943, -- Dragon Racing - Personal Best Record - 11 Z2 R3 Easy
	--		2944, -- Dragon Racing - Personal Best Record - 11 Z2 R4 Easy
	--		2945, -- Dragon Racing - Personal Best Record - 11 Z2 R5 Easy
	--		2946, -- Dragon Racing - Personal Best Record - 11 Z2 R6 Easy
	--		2947, -- Dragon Racing - Personal Best Record - 11 Z2 R1 Advanced
	--		2948, -- Dragon Racing - Personal Best Record - 11 Z2 R2 Advanced
	--		2949, -- Dragon Racing - Personal Best Record - 11 Z2 R3 Advanced
	--		2950, -- Dragon Racing - Personal Best Record - 11 Z2 R4 Advanced
	--		2951, -- Dragon Racing - Personal Best Record - 11 Z2 R5 Advanced
	--		2952, -- Dragon Racing - Personal Best Record - 11 Z2 R6 Advanced
	--		2953, -- Dragon Racing - Personal Best Record - 11 Z2 R1 Reverse
	--		2954, -- Dragon Racing - Personal Best Record - 11 Z2 R2 Reverse
	--		2955, -- Dragon Racing - Personal Best Record - 11 Z2 R3 Reverse
	--		2956, -- Dragon Racing - Personal Best Record - 11 Z2 R4 Reverse
	--		2957, -- Dragon Racing - Personal Best Record - 11 Z2 R5 Reverse
	--		2958, -- Dragon Racing - Personal Best Record - 11 Z2 R6 Reverse
	--		2959, -- Dragon Racing - Personal Best Record - 11 Z3 R1 Easy
	--		2960, -- Dragon Racing - Personal Best Record - 11 Z3 R2 Easy
	--		2961, -- Dragon Racing - Personal Best Record - 11 Z3 R3 Easy
	--		2962, -- Dragon Racing - Personal Best Record - 11 Z3 R4 Easy
	--		2963, -- Dragon Racing - Personal Best Record - 11 Z3 R5 Easy
	--		2964, -- Dragon Racing - Personal Best Record - 11 Z3 R6 Easy
	--		2965, -- Dragon Racing - Personal Best Record - 11 Z3 R1 Advanced
	--		2966, -- Dragon Racing - Personal Best Record - 11 Z3 R2 Advanced
	--		2967, -- Dragon Racing - Personal Best Record - 11 Z3 R3 Advanced
	--		2968, -- Dragon Racing - Personal Best Record - 11 Z3 R4 Advanced
	--		2969, -- Dragon Racing - Personal Best Record - 11 Z3 R5 Advanced
	--		2970, -- Dragon Racing - Personal Best Record - 11 Z3 R6 Advanced
	--		2971, -- Dragon Racing - Personal Best Record - 11 Z3 R1 Reverse
	--		2972, -- Dragon Racing - Personal Best Record - 11 Z3 R2 Reverse
	--		2973, -- Dragon Racing - Personal Best Record - 11 Z3 R3 Reverse
	--		2974, -- Dragon Racing - Personal Best Record - 11 Z3 R4 Reverse
	--		2975, -- Dragon Racing - Personal Best Record - 11 Z3 R5 Reverse
	--		2976, -- Dragon Racing - Personal Best Record - 11 Z3 R6 Reverse
	--		2977, -- Dragon Racing - Personal Best Record - 11 Z5 R1 Easy
	--		2978, -- Dragon Racing - Personal Best Record - 11 Z5 R2 Easy
	--		2979, -- Dragon Racing - Personal Best Record - 11 Z5 R3 Easy
	--		2980, -- Dragon Racing - Personal Best Record - 11 Z5 R4 Easy
	--		2981, -- Dragon Racing - Personal Best Record - 11 Z5 R5 Easy
	--		2982, -- Dragon Racing - Personal Best Record - 11 Z5 R6 Easy
	--		2983, -- Dragon Racing - Personal Best Record - 11 Z5 R1 Advanced
	--		2984, -- Dragon Racing - Personal Best Record - 11 Z5 R2 Advanced
	--		2985, -- Dragon Racing - Personal Best Record - 11 Z5 R3 Advanced
	--		2986, -- Dragon Racing - Personal Best Record - 11 Z5 R4 Advanced
	--		2987, -- Dragon Racing - Personal Best Record - 11 Z5 R5 Advanced
	--		2988, -- Dragon Racing - Personal Best Record - 11 Z5 R6 Advanced
	--		2989, -- Dragon Racing - Personal Best Record - 11 Z5 R1 Reverse
	--		2990, -- Dragon Racing - Personal Best Record - 11 Z5 R2 Reverse
	--		2991, -- Dragon Racing - Personal Best Record - 11 Z5 R3 Reverse
	--		2992, -- Dragon Racing - Personal Best Record - 11 Z5 R4 Reverse
	--		2993, -- Dragon Racing - Personal Best Record - 11 Z5 R5 Reverse
	--		2994, -- Dragon Racing - Personal Best Record - 11 Z5 R6 Reverse
	--		3119, -- Dragon Racing - Personal Best Record - 11 Z6 R1 Easy
	--		3121, -- Dragon Racing - Personal Best Record - 11 Z6 R1 Reverse
	--		3122, -- Dragon Racing - Personal Best Record - 11 Z6 R2 Easy
	--		3123, -- Dragon Racing - Personal Best Record - 11 Z6 R2 Reverse
	--		3124, -- Dragon Racing - Personal Best Record - 11 Z6 R3 Easy
	--		3125, -- Dragon Racing - Personal Best Record - 11 Z6 R3 Reverse
	--		3126, -- Dragon Racing - Personal Best Record - 11 Z6 R4 Easy
	--		3127, -- Dragon Racing - Personal Best Record - 11 Z6 R4 Reverse
	--		3181, -- Dragon Racing - Personal Best Record - 11 Z6 R5 Easy
	--		3182, -- Dragon Racing - Personal Best Record - 11 Z6 R5 Reverse
	--		3183, -- Dragon Racing - Personal Best Record - 11 Z6 R6 Easy
	--		3184, -- Dragon Racing - Personal Best Record - 11 Z6 R6 Reverse
	--		3185, -- Dragon Racing - Personal Best Record - 11 Z6 R7 Easy
	--		3186, -- Dragon Racing - Personal Best Record - 11 Z6 R7 Reverse
	--		3187, -- Dragon Racing - Personal Best Record - 11 Z6 R8 Easy
	--		3188, -- Dragon Racing - Personal Best Record - 11 Z6 R8 Reverse
	--		3213, -- Dragon Racing - Personal Best Record - 112 Hope's R1 Easy
	--		3214, -- Dragon Racing - Personal Best Record - 112 Hope's R1 Advanced
	--		3215, -- Dragon Racing - Personal Best Record - 112 Hope's R1 Reverse
	--		3431, -- Housing - Going Postal - Personal Best Record - Alliance - Rt1
	--		3432, -- Housing - Going Postal - Personal Best Record - Alliance - Rt2
	--		3433, -- Housing - Going Postal - Personal Best Record - Alliance - Rt3
	--		3434, -- Housing - Going Postal - Personal Best Record - Horde - Rt1
	--		3435, -- Housing - Going Postal - Personal Best Record - Horde - Rt2
	--		3436, -- Housing - Going Postal - Personal Best Record - Horde - Rt3
	--		3583, -- Housing - Going Postal - Personal Best Record - Alliance - Rt1
	--		3584, -- Housing - Going Postal - Personal Best Record - Alliance - Rt1
		},
		[252] = { -- Tuskarr - Fishing Nets (Hidden)
	--		2113, -- Tuskarr - Fishing Net - Location 01 - Net 01 - Loot
	--		2114, -- Tuskarr - Fishing Net - Location 01 - Net 04 (Quest) - Loot
	--		2115, -- Tuskarr - Fishing Net - Location 01 - Net 02 - Loot
	--		2116, -- Tuskarr - Fishing Net - Location 01 - Net 03 - Loot
	--		2135, -- Tuskarr - Fishing Net - Location 02 - Net 01 - Loot
	--		2136, -- Tuskarr - Fishing Net - Location 02 - Net 02 - Loot
	--		2137, -- Tuskarr - Fishing Net - Location 03 - Net 01 - Loot
	--		2138, -- Tuskarr - Fishing Net - Location 03 - Net 02 - Loot
	--		2139, -- Tuskarr - Fishing Net - Location 04 - Net 01 - Loot
	--		2140, -- Tuskarr - Fishing Net - Location 04 - Net 02 - Loot
	--		2141, -- Tuskarr - Fishing Net - Location 05 - Net 01 - Loot
	--		2142, -- Tuskarr - Fishing Net - Location 05 - Net 02 - Loot
	--		2228, -- Tuskarr - Fishing Net - Location 06 - Net 01 - Loot
		},
		[260] = { -- War Within
			2815, -- Resonance Crystals
	--		2839, -- [DNT] Awakening Currency
			3055, -- Mereldar Derby Mark
			3056, -- Kej
			3089, -- Residual Memories
			3090, -- Flame-Blessed Iron
			3093, -- Nerub-ar Finery
			3149, -- Displaced Corrupted Mementos
			3216, -- Bounty's Remnants
			3218, -- Empty Kaja'Cola Can
			3220, -- Vintage Kaja'Cola Can
			3223, -- Titan Disc
			3226, -- Market Research
			3303, -- Untethered Coin
		},
		[264] = { -- Midnight
			3316, -- Voidlight Marl
			3349, -- [DNT] [PH] Evergreen Initiative Currency
	--		3352, -- Party Favor
			3418, -- Nebulous Voidcore
			3509, -- Tidal Spark Dust
		},
		[266] = { -- Timerunning
			3251, -- Felforged Bronze
			3293, -- Epoch Memento
		},
		[268] = { -- Season 1
			3543, -- Test Myth Dawncrest
		},
		[277] = { -- Season 2
			3465, -- Venomblight Manaflux
			3511, -- [DNT, Unused] Venomous Voidcore
		},
		[278] = { -- Sites Score UI (Hidden)
	--		3449, -- Total Score
	--		3450, -- Sites Tier
	--		3451, -- Sites Treasure
	--		3452, -- Total Multiplier
	--		3453, -- Tier Multiplier
	--		3454, -- Challenge - Tendrils
	--		3455, -- Challenge - Manifestations
	--		3456, -- Challenge - Magical Alarm Bells
	--		3457, -- Challenge - Shrines Portals Obelisks
	--		3458, -- Challenge - Tainted Corpses
	--		3459, -- Challenge - Reinforced
	--		3460, -- Challenge - Patrols
	--		3461, -- Challenge - Banners
	--		3462, -- Sites Bosses
	--		3466, -- Sites Deaths
	--		3467, -- Sites Deaths Dues
	--		3477, -- Sites Rares
	--		3481, -- Sites Death Percent
	--		3482, -- Sites Subtotal
		},
		[280] = { -- Professions
			3256, -- Artisan Alchemist's Moxie
			3257, -- Artisan Blacksmith's Moxie
			3258, -- Artisan Enchanter's Moxie
			3259, -- Artisan Engineer's Moxie
			3260, -- Artisan Herbalist's Moxie
			3261, -- Artisan Scribe's Moxie
			3262, -- Artisan Jewelcrafter's Moxie
			3263, -- Artisan Leatherworker's Moxie
			3264, -- Artisan Miner's Moxie
			3265, -- Artisan Skinner's Moxie
			3266, -- Artisan Tailor's Moxie
			3546, -- Coiled Filament
		},
		[281] = { -- Delves
			2803, -- Undercoin
			3028, -- Restored Coffer Key
			3310, -- Coffer Key Shards
			3356, -- Untainted Mana-Crystals
		},
		[282] = { -- Crests
			3442, -- Adventurer Mistcrest
			3443, -- Veteran Mistcrest
			3444, -- Champion Mistcrest
			3445, -- Hero Mistcrest
			3446, -- Myth Mistcrest
		},
		[283] = { -- Zones
			3373, -- Angler Pearls
			3376, -- Shard of Dundun
			3377, -- Unalloyed Abundance
			3379, -- Brimming Arcana
			3400, -- Uncontaminated Void Sample
			3448, -- Corrosive Coin
		},
		[284] = { -- Features
			3319, -- Twilight's Blade Insignia
			3392, -- Remnant of Anguish
			3393, -- Illusionary Coin
			3405, -- Field Accolade
		},
	}

	data.Currencies = {
		[42] = { id=42, category=1, hide=true }, -- Badge of Justice, Miscellaneous
		[61] = { id=61, category=21 }, -- Dalaran Jewelcrafter's Token, Wrath of the Lich King
		[81] = { id=81, category=1 }, -- Epicurean's Award, Miscellaneous
		[101] = { id=101, category=22, hide=true }, -- Emblem of Heroism, Dungeon and Raid
		[102] = { id=102, category=22, hide=true }, -- Emblem of Valor, Dungeon and Raid
		[103] = { id=103, category=2, hide=true }, -- Arena Points, Player vs. Player
		[121] = { id=121, category=2, hide=true }, -- Alterac Valley Mark of Honor, Player vs. Player
		[122] = { id=122, category=2, hide=true }, -- Arathi Basin Mark of Honor, Player vs. Player
		[123] = { id=123, category=2, hide=true }, -- Eye of the Storm Mark of Honor, Player vs. Player
		[124] = { id=124, category=2, hide=true }, -- Strand of the Ancients Mark of Honor, Player vs. Player
		[125] = { id=125, category=2, hide=true }, -- Warsong Gulch Mark of Honor, Player vs. Player
		[126] = { id=126, category=2, hide=true }, -- Wintergrasp Mark of Honor, Player vs. Player
		[161] = { id=161, category=2, hide=true }, -- Stone Keeper's Shard, Player vs. Player
		[201] = { id=201, category=2, hide=true }, -- Venture Coin, Player vs. Player
		[221] = { id=221, category=22, hide=true }, -- Emblem of Conquest, Dungeon and Raid
		[241] = { id=241, category=21 }, -- Champion's Seal, Wrath of the Lich King
		[301] = { id=301, category=22, hide=true }, -- Emblem of Triumph, Dungeon and Raid
		[321] = { id=321, category=2, hide=true }, -- Isle of Conquest Mark of Honor, Player vs. Player
		[341] = { id=341, category=22, hide=true }, -- Emblem of Frost, Dungeon and Raid
		[361] = { id=361, category=81 }, -- Illustrious Jewelcrafter's Token, Cataclysm
		[384] = { id=384, category=82, hide=true }, -- Dwarf Archaeology Fragment, Archaeology
		[385] = { id=385, category=82, hide=true }, -- Troll Archaeology Fragment, Archaeology
		[391] = { id=391, category=2 }, -- Tol Barad Commendation, Player vs. Player
		[393] = { id=393, category=82, hide=true }, -- Fossil Archaeology Fragment, Archaeology
		[394] = { id=394, category=82, hide=true }, -- Night Elf Archaeology Fragment, Archaeology
		[395] = { id=395, category=142 }, -- Justice Points, Hidden
		[396] = { id=396, category=142 }, -- Valor Points, Hidden
		[397] = { id=397, category=82, hide=true }, -- Orc Archaeology Fragment, Archaeology
		[398] = { id=398, category=82, hide=true }, -- Draenei Archaeology Fragment, Archaeology
		[399] = { id=399, category=82, hide=true }, -- Vrykul Archaeology Fragment, Archaeology
		[400] = { id=400, category=82, hide=true }, -- Nerubian Archaeology Fragment, Archaeology
		[401] = { id=401, category=82, hide=true }, -- Tol'vir Archaeology Fragment, Archaeology
		[402] = { id=402, category=1 }, -- Ironpaw Token, Miscellaneous
		[416] = { id=416, category=81 }, -- Mark of the World Tree, Cataclysm
		[483] = { id=483, category=89, hide=true }, -- Conquest Arena Meta, Meta
		[484] = { id=484, category=89, hide=true }, -- Conquest Rated BG Meta, Meta
		[515] = { id=515, category=1 }, -- Darkmoon Prize Ticket, Miscellaneous
		[614] = { id=614, category=81 }, -- Mote of Darkness, Cataclysm
		[615] = { id=615, category=81 }, -- Essence of Corrupted Deathwing, Cataclysm
		[676] = { id=676, category=82, hide=true }, -- Pandaren Archaeology Fragment, Archaeology
		[677] = { id=677, category=82, hide=true }, -- Mogu Archaeology Fragment, Archaeology
		[692] = { id=692, category=89, hide=true }, -- Conquest Random BG Meta, Meta
		[697] = { id=697, category=133 }, -- Elder Charm of Good Fortune, Mists of Pandaria
		[698] = { id=698, category=133 }, -- Zen Jewelcrafter's Token, Mists of Pandaria
		[738] = { id=738, category=133 }, -- Lesser Charm of Good Fortune, Mists of Pandaria
		[752] = { id=752, category=133 }, -- Mogu Rune of Fate, Mists of Pandaria
		[754] = { id=754, category=82, hide=true }, -- Mantid Archaeology Fragment, Archaeology
		[776] = { id=776, category=133 }, -- Warforged Seal, Mists of Pandaria
		[777] = { id=777, category=133 }, -- Timeless Coin, Mists of Pandaria
		[789] = { id=789, category=133 }, -- Bloody Coin, Mists of Pandaria
		[810] = { id=810, category=133 }, -- Black Iron Fragment, Mists of Pandaria
		[821] = { id=821, category=82, hide=true }, -- Draenor Clans Archaeology Fragment, Archaeology
		[823] = { id=823, category=137 }, -- Apexis Crystal, Warlords of Draenor
		[824] = { id=824, category=137 }, -- Garrison Resources, Warlords of Draenor
		[828] = { id=828, category=82, hide=true }, -- Ogre Archaeology Fragment, Archaeology
		[829] = { id=829, category=82, hide=true }, -- Arakkoa Archaeology Fragment, Archaeology
		[830] = { id=830, category=82, hide=true }, -- n/a, Archaeology
		[897] = { id=897, category=137, hide=true }, -- UNUSED, Warlords of Draenor
		[910] = { id=910, category=137 }, -- Secret of Draenor Alchemy, Warlords of Draenor
		[944] = { id=944, category=137 }, -- Artifact Fragment, Warlords of Draenor
		[980] = { id=980, category=137 }, -- Dingy Iron Coins, Warlords of Draenor
		[994] = { id=994, category=137 }, -- Seal of Tempered Fate, Warlords of Draenor
		[999] = { id=999, category=137 }, -- Secret of Draenor Tailoring, Warlords of Draenor
		[1008] = { id=1008, category=137 }, -- Secret of Draenor Jewelcrafting, Warlords of Draenor
		[1017] = { id=1017, category=137 }, -- Secret of Draenor Leatherworking, Warlords of Draenor
		[1020] = { id=1020, category=137 }, -- Secret of Draenor Blacksmithing, Warlords of Draenor
		[1101] = { id=1101, category=137 }, -- Oil, Warlords of Draenor
		[1129] = { id=1129, category=137 }, -- Seal of Inevitable Fate, Warlords of Draenor
		[1149] = { id=1149, category=141 }, -- Sightless Eye, Legion
		[1154] = { id=1154, category=141 }, -- Shadowy Coins, Legion
		[1155] = { id=1155, category=141 }, -- Ancient Mana, Legion
		[1166] = { id=1166, category=22 }, -- Timewarped Badge, Dungeon and Raid
		[1171] = { id=1171, category=142 }, -- Artifact Knowledge, Hidden
		[1172] = { id=1172, category=82, hide=true }, -- Highborne Archaeology Fragment, Archaeology
		[1173] = { id=1173, category=82, hide=true }, -- Highmountain Tauren Archaeology Fragment, Archaeology
		[1174] = { id=1174, category=82, hide=true }, -- Demonic Archaeology Fragment, Archaeology
		[1191] = { id=1191, category=142 }, -- Valor, Hidden
		[1220] = { id=1220, category=141 }, -- Order Resources, Legion
		[1226] = { id=1226, category=141 }, -- Nethershard, Legion
		[1268] = { id=1268, category=141 }, -- Timeworn Artifact, Legion
		[1273] = { id=1273, category=141 }, -- Seal of Broken Fate, Legion
		[1275] = { id=1275, category=141 }, -- Curious Coin, Legion
		[1299] = { id=1299, category=143 }, -- Brawler's Gold, Battle for Azeroth
		[1314] = { id=1314, category=141 }, -- Lingering Soul Fragment, Legion
		[1324] = { id=1324, category=142 }, -- Horde Qiraji Commendation, Hidden
		[1325] = { id=1325, category=142 }, -- Alliance Qiraji Commendation, Hidden
		[1342] = { id=1342, category=141 }, -- Legionfall War Supplies, Legion
		[1347] = { id=1347, category=142, hide=true }, -- Legionfall Building - Personal Tracker - Mage Tower (Hidden), Hidden
		[1349] = { id=1349, category=142, hide=true }, -- Legionfall Building - Personal Tracker - Command Tower (Hidden), Hidden
		[1350] = { id=1350, category=142, hide=true }, -- Legionfall Building - Personal Tracker - Nether Tower (Hidden), Hidden
		[1355] = { id=1355, category=141 }, -- Felessence, Legion
		[1356] = { id=1356, category=141 }, -- Echoes of Battle, Legion
		[1357] = { id=1357, category=141 }, -- Echoes of Domination, Legion
		[1379] = { id=1379, category=1 }, -- Trial of Style Token, Miscellaneous
		[1388] = { id=1388, category=1 }, -- Armor Scraps, Miscellaneous
		[1401] = { id=1401, category=1 }, -- Stronghold Supplies, Miscellaneous
		[1416] = { id=1416, category=141 }, -- Coins of Air, Legion
		[1501] = { id=1501, category=142 }, -- Writhing Essence, Hidden
		[1506] = { id=1506, category=142 }, -- Argus Waystone, Hidden
		[1508] = { id=1508, category=141 }, -- Veiled Argunite, Legion
		[1533] = { id=1533, category=141 }, -- Wakening Essence, Legion
		[1534] = { id=1534, category=82, hide=true }, -- Zandalari Archaeology Fragment, Archaeology
		[1535] = { id=1535, category=82, hide=true }, -- Drust Archaeology Fragment, Archaeology
		[1540] = { id=1540, category=142 }, -- Wood, Hidden
		[1541] = { id=1541, category=142 }, -- Iron, Hidden
		[1553] = { id=1553, category=144 }, -- Azerite, Virtual
		[1559] = { id=1559, category=142 }, -- Essence of Storms, Hidden
		[1560] = { id=1560, category=143 }, -- War Resources, Battle for Azeroth
		[1565] = { id=1565, category=143 }, -- Rich Azerite Fragment, Battle for Azeroth
		[1579] = { id=1579, category=142 }, -- Champions of Azeroth, Hidden
		[1580] = { id=1580, category=143 }, -- Seal of Wartorn Fate, Battle for Azeroth
		[1585] = { id=1585, category=144 }, -- Warband Wide Honor, Virtual
		[1586] = { id=1586, category=144 }, -- Honor Level, Virtual
		[1587] = { id=1587, category=143 }, -- War Supplies, Battle for Azeroth
		[1592] = { id=1592, category=142 }, -- Order of Embers, Hidden
		[1593] = { id=1593, category=142 }, -- Proudmoore Admiralty, Hidden
		[1594] = { id=1594, category=142 }, -- Storm's Wake, Hidden
		[1595] = { id=1595, category=142 }, -- Talanji's Expedition, Hidden
		[1596] = { id=1596, category=142 }, -- Voldunai, Hidden
		[1597] = { id=1597, category=142 }, -- Zandalari Empire, Hidden
		[1598] = { id=1598, category=142 }, -- Tortollan Seekers, Hidden
		[1599] = { id=1599, category=142 }, -- 7th Legion, Hidden
		[1600] = { id=1600, category=142 }, -- Honorbound, Hidden
		[1602] = { id=1602, category=2 }, -- Conquest, Player vs. Player
		[1703] = { id=1703, category=142, hide=true }, -- PVP Season Rated Participation Currency, Hidden
		[1704] = { id=1704, category=23 }, -- Spirit Shard, Burning Crusade
		[1705] = { id=1705, category=142, hide=true }, -- Warfronts - Personal Tracker - Iron in Chest (Hidden), Hidden
		[1710] = { id=1710, category=143 }, -- Seafarer's Dubloon, Battle for Azeroth
		[1714] = { id=1714, category=142, hide=true }, -- Warfronts - Personal Tracker - Wood in Chest (Hidden), Hidden
		[1715] = { id=1715, category=143 }, -- Progenitor Shard, Battle for Azeroth
		[1716] = { id=1716, category=143 }, -- Honorbound Service Medal, Battle for Azeroth
		[1717] = { id=1717, category=143 }, -- 7th Legion Service Medal, Battle for Azeroth
		[1718] = { id=1718, category=143 }, -- Titan Residuum, Battle for Azeroth
		[1719] = { id=1719, category=143 }, -- Corrupted Mementos, Battle for Azeroth
		[1721] = { id=1721, category=143 }, -- Prismatic Manapearl, Battle for Azeroth
		[1722] = { id=1722, category=142 }, -- Azerite Ore, Hidden
		[1723] = { id=1723, category=142 }, -- Lumber, Hidden
		[1728] = { id=1728, category=142 }, -- Phantasma, Hidden
		[1738] = { id=1738, category=142 }, -- Unshackled, Hidden
		[1739] = { id=1739, category=142 }, -- Ankoan, Hidden
		[1740] = { id=1740, category=142 }, -- Rustbolt Resistance (Hidden), Hidden
		[1742] = { id=1742, category=142 }, -- Rustbolt Resistance, Hidden
		[1743] = { id=1743, category=245 }, -- Fake Anima for Quest Tracking, Shadowlands
		[1744] = { id=1744, category=142, hide=true }, -- Corrupted Memento, Hidden
		[1745] = { id=1745, category=142 }, -- Nazjatar Ally - Neri Sharpfin, Hidden
		[1746] = { id=1746, category=142 }, -- Nazjatar Ally - Vim Brineheart, Hidden
		[1747] = { id=1747, category=142 }, -- Nazjatar Ally - Poen Gillbrack, Hidden
		[1748] = { id=1748, category=142 }, -- Nazjatar Ally - Bladesman Inowari, Hidden
		[1749] = { id=1749, category=142 }, -- Nazjatar Ally - Hunter Akana, Hidden
		[1750] = { id=1750, category=142 }, -- Nazjatar Ally - Farseer Ori, Hidden
		[1752] = { id=1752, category=142 }, -- Honeyback Hive, Hidden
		[1754] = { id=1754, category=245 }, -- Argent Commendation, Shadowlands
		[1755] = { id=1755, category=143 }, -- Coalescing Visions, Battle for Azeroth
		[1757] = { id=1757, category=142 }, -- Uldum Accord, Hidden
		[1758] = { id=1758, category=142 }, -- Rajani, Hidden
		[1761] = { id=1761, category=142 }, -- Enemy Damage, Hidden
		[1762] = { id=1762, category=142 }, -- Enemy Health, Hidden
		[1763] = { id=1763, category=142 }, -- Deaths, Hidden
		[1767] = { id=1767, category=245 }, -- Stygia, Shadowlands
		[1769] = { id=1769, category=142, hide=true }, -- Quest Experience (Standard, Hidden), Hidden
		[1792] = { id=1792, category=2 }, -- Honor, Player vs. Player
		[1794] = { id=1794, category=142 }, -- Atonement Anima, Hidden
		[1802] = { id=1802, category=245 }, -- Shadowlands PvP Weekly Reward Progress, Shadowlands
		[1803] = { id=1803, category=143 }, -- Echoes of Ny'alotha, Battle for Azeroth
		[1804] = { id=1804, category=142 }, -- Ascended, Hidden
		[1805] = { id=1805, category=142 }, -- Undying Army, Hidden
		[1806] = { id=1806, category=142 }, -- Wild Hunt, Hidden
		[1807] = { id=1807, category=142 }, -- Court of Harvesters, Hidden
		[1808] = { id=1808, category=142 }, -- Channeled Anima, Hidden
		[1810] = { id=1810, category=142 }, -- Redeemed Soul, Hidden
		[1811] = { id=1811, category=245, hide=true }, -- zzoldSanctum Architect, Shadowlands
		[1812] = { id=1812, category=245, hide=true }, -- zzoldSanctum Anima Weaver, Shadowlands
		[1813] = { id=1813, category=245 }, -- Reservoir Anima, Shadowlands
		[1816] = { id=1816, category=245 }, -- Sinstone Fragments, Shadowlands
		[1819] = { id=1819, category=245 }, -- Medallion of Service, Shadowlands
		[1820] = { id=1820, category=245 }, -- Infused Ruby, Shadowlands
		[1822] = { id=1822, category=142 }, -- Renown, Hidden
		[1828] = { id=1828, category=245 }, -- Soul Ash, Shadowlands
		[1829] = { id=1829, category=245 }, -- Renown-Kyrian, Shadowlands
		[1830] = { id=1830, category=245 }, -- Renown-Venthyr, Shadowlands
		[1831] = { id=1831, category=245 }, -- Renown-NightFae, Shadowlands
		[1832] = { id=1832, category=245 }, -- Renown-Necrolord, Shadowlands
		[1837] = { id=1837, category=142 }, -- The Ember Court, Hidden
		[1838] = { id=1838, category=142 }, -- The Countess, Hidden
		[1839] = { id=1839, category=142 }, -- Rendle and Cudgelface, Hidden
		[1840] = { id=1840, category=142 }, -- Stonehead, Hidden
		[1841] = { id=1841, category=142 }, -- Cryptkeeper Kassir, Hidden
		[1842] = { id=1842, category=142 }, -- Baroness Vashj, Hidden
		[1843] = { id=1843, category=142 }, -- Plague Deviser Marileth, Hidden
		[1844] = { id=1844, category=142 }, -- Grandmaster Vole, Hidden
		[1845] = { id=1845, category=142 }, -- Alexandros Mograine, Hidden
		[1846] = { id=1846, category=142 }, -- Sika, Hidden
		[1847] = { id=1847, category=142 }, -- Kleia and Pelegos, Hidden
		[1848] = { id=1848, category=142 }, -- Polemarch Adrestes, Hidden
		[1849] = { id=1849, category=142 }, -- Mikanikos, Hidden
		[1850] = { id=1850, category=142 }, -- Choofa, Hidden
		[1851] = { id=1851, category=142 }, -- Droman Aliothe, Hidden
		[1852] = { id=1852, category=142 }, -- Hunt-Captain Korayn, Hidden
		[1853] = { id=1853, category=142 }, -- Lady Moonberry, Hidden
		[1859] = { id=1859, category=245, hide=true }, -- Reservoir Anima-Kyrian, Shadowlands
		[1860] = { id=1860, category=245, hide=true }, -- Reservoir Anima-Venthyr, Shadowlands
		[1861] = { id=1861, category=245, hide=true }, -- Reservoir Anima-Night Fae, Shadowlands
		[1862] = { id=1862, category=245, hide=true }, -- Reservoir Anima-Necrolord, Shadowlands
		[1863] = { id=1863, category=245, hide=true }, -- Redeemed Soul-Kyrian, Shadowlands
		[1864] = { id=1864, category=245, hide=true }, -- Redeemed Soul-Venthyr, Shadowlands
		[1865] = { id=1865, category=245, hide=true }, -- Redeemed Soul-Night Fae, Shadowlands
		[1866] = { id=1866, category=245, hide=true }, -- Redeemed Soul-Necrolord, Shadowlands
		[1867] = { id=1867, category=245, hide=true }, -- Sanctum Architect-Kyrian, Shadowlands
		[1868] = { id=1868, category=245, hide=true }, -- Sanctum Architect-Venthyr, Shadowlands
		[1869] = { id=1869, category=245, hide=true }, -- Sanctum Architect-Night Fae, Shadowlands
		[1870] = { id=1870, category=245, hide=true }, -- Sanctum Architect-Necrolord, Shadowlands
		[1871] = { id=1871, category=245, hide=true }, -- Sanctum Anima Weaver-Kyrian, Shadowlands
		[1872] = { id=1872, category=245, hide=true }, -- Sanctum Anima Weaver-Venthyr, Shadowlands
		[1873] = { id=1873, category=245, hide=true }, -- Sanctum Anima Weaver-Night Fae, Shadowlands
		[1874] = { id=1874, category=245, hide=true }, -- Sanctum Anima Weaver-Necrolord, Shadowlands
		[1877] = { id=1877, category=142, hide=true }, -- Bonus Experience, Hidden
		[1878] = { id=1878, category=142 }, -- Stitchmasters, Hidden
		[1880] = { id=1880, category=142 }, -- Ve'nari, Hidden
		[1883] = { id=1883, category=142 }, -- Soulbind Conduit Energy, Hidden
		[1884] = { id=1884, category=142 }, -- The Avowed, Hidden
		[1885] = { id=1885, category=245 }, -- Grateful Offering, Shadowlands
		[1887] = { id=1887, category=142 }, -- Court of Night, Hidden
		[1888] = { id=1888, category=142 }, -- Marasmius, Hidden
		[1889] = { id=1889, category=142 }, -- Adventure Campaign Progress, Hidden
		[1891] = { id=1891, category=142, hide=true }, -- Honor from Rated, Hidden
		[1902] = { id=1902, category=142, hide=true }, -- 9.1 - Torghast XP - Prototype - LJS, Hidden
		[1903] = { id=1903, category=142 }, -- Invisible Reward, Hidden
		[1904] = { id=1904, category=245 }, -- Tower Knowledge, Shadowlands
		[1906] = { id=1906, category=245 }, -- Soul Cinders, Shadowlands
		[1907] = { id=1907, category=142 }, -- Death's Advance, Hidden
		[1909] = { id=1909, category=248, hide=true }, -- Torghast - Scoreboard - Clear Percent, Torghast UI (Hidden)
		[1910] = { id=1910, category=248, hide=true }, -- Torghast - Scoreboard - Souls Percent, Torghast UI (Hidden)
		[1911] = { id=1911, category=248, hide=true }, -- Torghast - Scoreboard - Urns Percent, Torghast UI (Hidden)
		[1912] = { id=1912, category=248, hide=true }, -- Torghast - Scoreboard - Hot Streak Percent, Torghast UI (Hidden)
		[1913] = { id=1913, category=248, hide=true }, -- Torghast - Scoreboard - Total Time, Torghast UI (Hidden)
		[1914] = { id=1914, category=248, hide=true }, -- Torghast - Scoreboard - Par Time, Torghast UI (Hidden)
		[1915] = { id=1915, category=248, hide=true }, -- Torghast - Scoreboard - Deaths Excess Count, Torghast UI (Hidden)
		[1916] = { id=1916, category=248, hide=true }, -- Torghast - Scoreboard - Deaths Start Count, Torghast UI (Hidden)
		[1917] = { id=1917, category=248, hide=true }, -- Torghast - Scoreboard - Floor Reached, Torghast UI (Hidden)
		[1918] = { id=1918, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Time Score, Torghast UI (Hidden)
		[1919] = { id=1919, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Hot Streak Score, Torghast UI (Hidden)
		[1920] = { id=1920, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Deaths Excess Score, Torghast UI (Hidden)
		[1921] = { id=1921, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Total Score, Torghast UI (Hidden)
		[1922] = { id=1922, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Total Rewards, Torghast UI (Hidden)
		[1923] = { id=1923, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Souls Rescued, Torghast UI (Hidden)
		[1924] = { id=1924, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Urns Broken, Torghast UI (Hidden)
		[1925] = { id=1925, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Deaths Zero, Torghast UI (Hidden)
		[1926] = { id=1926, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Stars, Torghast UI (Hidden)
		[1931] = { id=1931, category=245 }, -- Cataloged Research, Shadowlands
		[1932] = { id=1932, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Boss Killed, Torghast UI (Hidden)
		[1933] = { id=1933, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Chests Opened, Torghast UI (Hidden)
		[1934] = { id=1934, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Escorts Complete, Torghast UI (Hidden)
		[1935] = { id=1935, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - No Trap Damage, Torghast UI (Hidden)
		[1936] = { id=1936, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Kill Boss Fast, Torghast UI (Hidden)
		[1937] = { id=1937, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Single Stacks, Torghast UI (Hidden)
		[1938] = { id=1938, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - 5 Stacks, Torghast UI (Hidden)
		[1939] = { id=1939, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Broker Killer, Torghast UI (Hidden)
		[1940] = { id=1940, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Elite Slayer, Torghast UI (Hidden)
		[1941] = { id=1941, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - 1000 Phantasma, Torghast UI (Hidden)
		[1942] = { id=1942, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - 500 Phant Left, Torghast UI (Hidden)
		[1943] = { id=1943, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - No Deaths, Torghast UI (Hidden)
		[1944] = { id=1944, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - No Epics, Torghast UI (Hidden)
		[1945] = { id=1945, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Elite Unnatural, Torghast UI (Hidden)
		[1946] = { id=1946, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Total Rewards - AV Bonus, Torghast UI (Hidden)
		[1947] = { id=1947, category=142 }, -- Bonus Valor, Hidden
		[1948] = { id=1948, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Kill Boss Faster, Torghast UI (Hidden)
		[1949] = { id=1949, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - 30+ Count, Torghast UI (Hidden)
		[1950] = { id=1950, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - 1 Star Value, Torghast UI (Hidden)
		[1951] = { id=1951, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - 2 Star Value, Torghast UI (Hidden)
		[1952] = { id=1952, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - 3 Star Value, Torghast UI (Hidden)
		[1953] = { id=1953, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - 4 Star Value, Torghast UI (Hidden)
		[1954] = { id=1954, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - 5 Star Value, Torghast UI (Hidden)
		[1955] = { id=1955, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Points While Empowered, Torghast UI (Hidden)
		[1956] = { id=1956, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Points Empowered Score, Torghast UI (Hidden)
		[1957] = { id=1957, category=248, hide=true }, -- Torghast - Scoreboard - Floor Clear Percent Floor 1, Torghast UI (Hidden)
		[1958] = { id=1958, category=248, hide=true }, -- Torghast - Scoreboard - Floor Clear Percent Floor 2, Torghast UI (Hidden)
		[1959] = { id=1959, category=248, hide=true }, -- Torghast - Scoreboard - Floor Clear Percent Floor 3, Torghast UI (Hidden)
		[1960] = { id=1960, category=248, hide=true }, -- Torghast - Scoreboard - Floor Clear Percent Floor 4, Torghast UI (Hidden)
		[1961] = { id=1961, category=248, hide=true }, -- Torghast - Scoreboard - Floor Empowered Percent Floor 1, Torghast UI (Hidden)
		[1962] = { id=1962, category=248, hide=true }, -- Torghast - Scoreboard - Floor Empowered Percent Floor 2, Torghast UI (Hidden)
		[1963] = { id=1963, category=248, hide=true }, -- Torghast - Scoreboard - Floor Empowered Percent Floor 3, Torghast UI (Hidden)
		[1964] = { id=1964, category=248, hide=true }, -- Torghast - Scoreboard - Floor Empowered Percent Floor 4, Torghast UI (Hidden)
		[1965] = { id=1965, category=248, hide=true }, -- Torghast - Scoreboard - Floor Time Floor 1, Torghast UI (Hidden)
		[1966] = { id=1966, category=248, hide=true }, -- Torghast - Scoreboard - Floor Time Floor 2, Torghast UI (Hidden)
		[1967] = { id=1967, category=248, hide=true }, -- Torghast - Scoreboard - Floor Time Floor 3, Torghast UI (Hidden)
		[1968] = { id=1968, category=248, hide=true }, -- Torghast - Scoreboard - Floor Time Floor 4, Torghast UI (Hidden)
		[1969] = { id=1969, category=248, hide=true }, -- Torghast - Scoreboard - Floor Par Time Floor 1, Torghast UI (Hidden)
		[1970] = { id=1970, category=248, hide=true }, -- Torghast - Scoreboard - Floor Par Time Floor 2, Torghast UI (Hidden)
		[1971] = { id=1971, category=248, hide=true }, -- Torghast - Scoreboard - Floor Par Time Floor 3, Torghast UI (Hidden)
		[1972] = { id=1972, category=248, hide=true }, -- Torghast - Scoreboard - Floor Par Time Floor 4, Torghast UI (Hidden)
		[1976] = { id=1976, category=248, hide=true }, -- Torghast - Scoreboard - Toast Display - Bonus - Phant Left Group, Torghast UI (Hidden)
		[1977] = { id=1977, category=245 }, -- Stygian Ember, Shadowlands
		[1979] = { id=1979, category=245 }, -- Cyphers of the First Ones, Shadowlands
		[1980] = { id=1980, category=248, hide=true }, -- Torghast - Scoreboard - Run Layer, Torghast UI (Hidden)
		[1981] = { id=1981, category=248, hide=true }, -- Torghast - Scoreboard - Run ID, Torghast UI (Hidden)
		[1982] = { id=1982, category=142 }, -- The Enlightened, Hidden
		[1986] = { id=1986, category=142, hide=true }, -- Players Remaining, Hidden
		[1997] = { id=1997, category=142 }, -- Archivists' Codex, Hidden
		[2000] = { id=2000, category=142, hide=true }, -- Motes of Fate, Hidden
		[2001] = { id=2001, category=144, hide=true }, -- Paden Test Currency, Virtual
		[2002] = { id=2002, category=142 }, -- Renown-Maruuk Centaur, Hidden
		[2003] = { id=2003, category=250 }, -- Dragon Isles Supplies, Dragonflight
		[2005] = { id=2005, category=1, hide=true }, -- Druid Talent Points (DNT), Miscellaneous
		[2006] = { id=2006, category=1, hide=true }, -- Restoration Talent Points (DNT), Miscellaneous
		[2009] = { id=2009, category=245 }, -- Cosmic Flux, Shadowlands
		[2011] = { id=2011, category=250 }, -- Effigy Adornments, Dragonflight
		[2012] = { id=2012, category=1, hide=true }, -- Death Knight Talent Points (DNT), Miscellaneous
		[2013] = { id=2013, category=1, hide=true }, -- Frost Talent Points (DNT), Miscellaneous
		[2014] = { id=2014, category=1, hide=true }, -- Unholy Talent Points (DNT), Miscellaneous
		[2015] = { id=2015, category=1, hide=true }, -- Blood Talent Points (DNT), Miscellaneous
		[2016] = { id=2016, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time, Dragon Racing UI (Hidden)
		[2017] = { id=2017, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time - Fraction 1, Dragon Racing UI (Hidden)
		[2018] = { id=2018, category=251, hide=true }, -- Dragon Racing - Temp Storage - Race Quest ID, Dragon Racing UI (Hidden)
		[2019] = { id=2019, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time - Silver, Dragon Racing UI (Hidden)
		[2020] = { id=2020, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time - Gold, Dragon Racing UI (Hidden)
		[2021] = { id=2021, category=142 }, -- Renown-Dragonscale Expedition, Hidden
		[2022] = { id=2022, category=251, hide=true }, -- Dragon Racing - Multiplayer Race Placement, Dragon Racing UI (Hidden)
		[2023] = { id=2023, category=142 }, -- Dragon Isles Blacksmithing Knowledge, Hidden
		[2024] = { id=2024, category=142 }, -- Dragon Isles Alchemy Knowledge, Hidden
		[2025] = { id=2025, category=142 }, -- Dragon Isles Leatherworking Knowledge, Hidden
		[2026] = { id=2026, category=142 }, -- Dragon Isles Tailoring Knowledge, Hidden
		[2027] = { id=2027, category=142 }, -- Dragon Isles Engineering Knowledge, Hidden
		[2028] = { id=2028, category=142 }, -- Dragon Isles Inscription Knowledge, Hidden
		[2029] = { id=2029, category=142 }, -- Dragon Isles Jewelcrafting Knowledge, Hidden
		[2030] = { id=2030, category=142 }, -- Dragon Isles Enchanting Knowledge, Hidden
		[2031] = { id=2031, category=142 }, -- Dragonscale Expedition, Hidden
		[2032] = { id=2032, category=1 }, -- Trader's Tender, Miscellaneous
		[2033] = { id=2033, category=142 }, -- Dragon Isles Skinning Knowledge, Hidden
		[2034] = { id=2034, category=142 }, -- Dragon Isles Herbalism Knowledge, Hidden
		[2035] = { id=2035, category=142 }, -- Dragon Isles Mining Knowledge, Hidden
		[2036] = { id=2036, category=142 }, -- Ancient Waygate Energy, Hidden
		[2037] = { id=2037, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time -Silver Fract 1, Dragon Racing UI (Hidden)
		[2038] = { id=2038, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time - Gold Fract 1, Dragon Racing UI (Hidden)
		[2039] = { id=2039, category=251, hide=true }, -- Dragon Racing - Scoreboard - Personal Best - Waking Shores 1, Dragon Racing UI (Hidden)
		[2040] = { id=2040, category=251, hide=true }, -- Dragon Racing - Scoreboard - Personal Best Time, Dragon Racing UI (Hidden)
		[2041] = { id=2041, category=251, hide=true }, -- Dragon Racing - Scoreboard - Personal Best Time - Fraction 1, Dragon Racing UI (Hidden)
		[2042] = { id=2042, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 01 Easy, Dragon Racing UI (Hidden)
		[2043] = { id=2043, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 01 Medium, Dragon Racing UI (Hidden)
		[2044] = { id=2044, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 01 Hard, Dragon Racing UI (Hidden)
		[2045] = { id=2045, category=250 }, -- Dragon Glyph Embers, Dragonflight
		[2046] = { id=2046, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 07 Easy, Dragon Racing UI (Hidden)
		[2047] = { id=2047, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 07 Hard, Dragon Racing UI (Hidden)
		[2048] = { id=2048, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 02 Easy, Dragon Racing UI (Hidden)
		[2049] = { id=2049, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 02 Hard, Dragon Racing UI (Hidden)
		[2050] = { id=2050, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 08 Easy, Dragon Racing UI (Hidden)
		[2051] = { id=2051, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 08 Hard, Dragon Racing UI (Hidden)
		[2052] = { id=2052, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 03 Easy, Dragon Racing UI (Hidden)
		[2053] = { id=2053, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 03 Hard, Dragon Racing UI (Hidden)
		[2054] = { id=2054, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 04 Easy, Dragon Racing UI (Hidden)
		[2055] = { id=2055, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 04 Hard, Dragon Racing UI (Hidden)
		[2056] = { id=2056, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 05 Easy, Dragon Racing UI (Hidden)
		[2057] = { id=2057, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 05 Hard, Dragon Racing UI (Hidden)
		[2058] = { id=2058, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 06 Easy, Dragon Racing UI (Hidden)
		[2059] = { id=2059, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 06 Hard, Dragon Racing UI (Hidden)
		[2060] = { id=2060, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 01 Easy, Dragon Racing UI (Hidden)
		[2061] = { id=2061, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 01 Hard, Dragon Racing UI (Hidden)
		[2062] = { id=2062, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 02 Easy, Dragon Racing UI (Hidden)
		[2063] = { id=2063, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 02 Hard, Dragon Racing UI (Hidden)
		[2064] = { id=2064, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 03 Easy, Dragon Racing UI (Hidden)
		[2065] = { id=2065, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 03 Hard, Dragon Racing UI (Hidden)
		[2066] = { id=2066, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 04 Easy, Dragon Racing UI (Hidden)
		[2067] = { id=2067, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 04 Hard, Dragon Racing UI (Hidden)
		[2069] = { id=2069, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains D05 Easy, Dragon Racing UI (Hidden)
		[2070] = { id=2070, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains D06 Easy, Dragon Racing UI (Hidden)
		[2074] = { id=2074, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 01 Easy, Dragon Racing UI (Hidden)
		[2075] = { id=2075, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 01 Hard, Dragon Racing UI (Hidden)
		[2076] = { id=2076, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 02 Easy, Dragon Racing UI (Hidden)
		[2077] = { id=2077, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 02 Hard, Dragon Racing UI (Hidden)
		[2078] = { id=2078, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 03 Easy, Dragon Racing UI (Hidden)
		[2079] = { id=2079, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 03 Hard, Dragon Racing UI (Hidden)
		[2080] = { id=2080, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 01 Easy, Dragon Racing UI (Hidden)
		[2081] = { id=2081, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 01 Hard, Dragon Racing UI (Hidden)
		[2082] = { id=2082, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores MP 1, Dragon Racing UI (Hidden)
		[2083] = { id=2083, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 04 Easy, Dragon Racing UI (Hidden)
		[2084] = { id=2084, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 04 Hard, Dragon Racing UI (Hidden)
		[2085] = { id=2085, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 05 Easy, Dragon Racing UI (Hidden)
		[2086] = { id=2086, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 05 Hard, Dragon Racing UI (Hidden)
		[2087] = { id=2087, category=142 }, -- Renown-Iskaara Tuskarr, Hidden
		[2088] = { id=2088, category=142 }, -- Renown-Valdrakken, Hidden
		[2089] = { id=2089, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 06 Easy, Dragon Racing UI (Hidden)
		[2090] = { id=2090, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 06 Hard, Dragon Racing UI (Hidden)
		[2091] = { id=2091, category=251, hide=true }, -- Dragon Racing - Tracking [DNT], Dragon Racing UI (Hidden)
		[2092] = { id=2092, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 02 Easy, Dragon Racing UI (Hidden)
		[2093] = { id=2093, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 02 Hard, Dragon Racing UI (Hidden)
		[2094] = { id=2094, category=142 }, -- [DNT] AC Major Faction Test Renown, Hidden
		[2095] = { id=2095, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus MP 1, Dragon Racing UI (Hidden)
		[2096] = { id=2096, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 03 Easy, Dragon Racing UI (Hidden)
		[2097] = { id=2097, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 03 Hard, Dragon Racing UI (Hidden)
		[2098] = { id=2098, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 04 Easy, Dragon Racing UI (Hidden)
		[2099] = { id=2099, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 04 Hard, Dragon Racing UI (Hidden)
		[2100] = { id=2100, category=251, hide=true }, -- Dragon Racing - Versioning [DNT], Dragon Racing UI (Hidden)
		[2101] = { id=2101, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 05 Easy, Dragon Racing UI (Hidden)
		[2102] = { id=2102, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 05 Hard, Dragon Racing UI (Hidden)
		[2103] = { id=2103, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 06 Easy, Dragon Racing UI (Hidden)
		[2104] = { id=2104, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 06 Hard, Dragon Racing UI (Hidden)
		[2105] = { id=2105, category=250 }, -- Purified Arcane Energy, Dragonflight
		[2106] = { id=2106, category=142 }, -- Valdrakken Accord, Hidden
		[2107] = { id=2107, category=142 }, -- Artisan's Consortium - Dragon Isles Branch, Hidden
		[2108] = { id=2108, category=142 }, -- Maruuk Centaur, Hidden
		[2109] = { id=2109, category=142 }, -- Iskaara Tuskarr, Hidden
		[2110] = { id=2110, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains MP 1, Dragon Racing UI (Hidden)
		[2111] = { id=2111, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span MP 1, Dragon Racing UI (Hidden)
		[2113] = { id=2113, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 01 - Net 01 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2114] = { id=2114, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 01 - Net 04 (Quest) - Loot, Tuskarr - Fishing Nets (Hidden)
		[2115] = { id=2115, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 01 - Net 02 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2116] = { id=2116, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 01 - Net 03 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2118] = { id=2118, category=250 }, -- Elemental Overflow, Dragonflight
		[2119] = { id=2119, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 07 Easy, Dragon Racing UI (Hidden)
		[2120] = { id=2120, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 07 Hard, Dragon Racing UI (Hidden)
		[2122] = { id=2122, category=250 }, -- Storm Sigil, Dragonflight
		[2123] = { id=2123, category=2 }, -- Bloody Tokens, Player vs. Player
		[2124] = { id=2124, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time - Fraction 10, Dragon Racing UI (Hidden)
		[2125] = { id=2125, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time - Fraction 100, Dragon Racing UI (Hidden)
		[2126] = { id=2126, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time -Silver Fract 10, Dragon Racing UI (Hidden)
		[2128] = { id=2128, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time -Silver Fract100, Dragon Racing UI (Hidden)
		[2129] = { id=2129, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time - Gold Fract 10, Dragon Racing UI (Hidden)
		[2130] = { id=2130, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time - Gold Fract 100, Dragon Racing UI (Hidden)
		[2131] = { id=2131, category=251, hide=true }, -- Dragon Racing - Scoreboard - Personal Best Time - Fraction 10, Dragon Racing UI (Hidden)
		[2132] = { id=2132, category=251, hide=true }, -- Dragon Racing - Scoreboard - Personal Best Time - Fraction 100, Dragon Racing UI (Hidden)
		[2133] = { id=2133, category=251, hide=true }, -- Dragonriding - Accepting Passengers [DNT], Dragon Racing UI (Hidden)
		[2134] = { id=2134, category=250 }, -- Cobalt Assembly, Dragonflight
		[2135] = { id=2135, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 02 - Net 01 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2136] = { id=2136, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 02 - Net 02 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2137] = { id=2137, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 03 - Net 01 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2138] = { id=2138, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 03 - Net 02 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2139] = { id=2139, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 04 - Net 01 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2140] = { id=2140, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 04 - Net 02 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2141] = { id=2141, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 05 - Net 01 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2142] = { id=2142, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 05 - Net 02 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2148] = { id=2148, category=142, hide=true }, -- Red Whelp (Fire Shot), Hidden
		[2149] = { id=2149, category=142, hide=true }, -- Red Whelp (Lobbing Fire Nova), Hidden
		[2150] = { id=2150, category=142, hide=true }, -- Red Whelp (Curing Whiff), Hidden
		[2151] = { id=2151, category=142, hide=true }, -- Red Whelp (Mending Breath), Hidden
		[2152] = { id=2152, category=142, hide=true }, -- Red Whelp (Sleepy Ruby Warmth), Hidden
		[2153] = { id=2153, category=142, hide=true }, -- Red Whelp (Under Red Wings), Hidden
		[2154] = { id=2154, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 01 Reverse, Dragon Racing UI (Hidden)
		[2155] = { id=2155, category=251, hide=true }, -- Dragon Racing - Best Time Display - Whole, Dragon Racing UI (Hidden)
		[2156] = { id=2156, category=251, hide=true }, -- Dragon Racing - Best Time Display - Fraction 1, Dragon Racing UI (Hidden)
		[2157] = { id=2157, category=251, hide=true }, -- Dragon Racing - Best Time Display - Fraction 10, Dragon Racing UI (Hidden)
		[2158] = { id=2158, category=251, hide=true }, -- Dragon Racing - Best Time Display - Fraction 100, Dragon Racing UI (Hidden)
		[2159] = { id=2159, category=251, hide=true }, -- Dragon Racing - Best Time Display - Advanced - Whole, Dragon Racing UI (Hidden)
		[2160] = { id=2160, category=251, hide=true }, -- Dragon Racing - Best Time Display - Advanced - Fraction 1, Dragon Racing UI (Hidden)
		[2161] = { id=2161, category=251, hide=true }, -- Dragon Racing - Best Time Display - Advanced - Fraction 10, Dragon Racing UI (Hidden)
		[2162] = { id=2162, category=251, hide=true }, -- Dragon Racing - Best Time Display - Advanced - Fraction 100, Dragon Racing UI (Hidden)
		[2165] = { id=2165, category=142, hide=true }, -- Profession - Public Order Capacity - Blacksmithing, Hidden
		[2166] = { id=2166, category=142 }, -- Renascent Lifeblood, Hidden
		[2167] = { id=2167, category=142 }, -- Catalyst Charges, Hidden
		[2169] = { id=2169, category=142, hide=true }, -- Profession - Public Order Capacity - Leatherworking, Hidden
		[2170] = { id=2170, category=142, hide=true }, -- Profession - Public Order Capacity - Alchemy, Hidden
		[2171] = { id=2171, category=142, hide=true }, -- Profession - Public Order Capacity - Tailoring, Hidden
		[2172] = { id=2172, category=142, hide=true }, -- Profession - Public Order Capacity - Engineering, Hidden
		[2173] = { id=2173, category=142, hide=true }, -- Profession - Public Order Capacity - Enchanting, Hidden
		[2174] = { id=2174, category=142, hide=true }, -- Profession - Public Order Capacity - Jewelcrafting, Hidden
		[2175] = { id=2175, category=142, hide=true }, -- Profession - Public Order Capacity - Inscription, Hidden
		[2176] = { id=2176, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 02 Reverse, Dragon Racing UI (Hidden)
		[2177] = { id=2177, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 03 Reverse, Dragon Racing UI (Hidden)
		[2178] = { id=2178, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 04 Reverse, Dragon Racing UI (Hidden)
		[2179] = { id=2179, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 05 Reverse, Dragon Racing UI (Hidden)
		[2180] = { id=2180, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 06 Reverse, Dragon Racing UI (Hidden)
		[2181] = { id=2181, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 07 Reverse, Dragon Racing UI (Hidden)
		[2182] = { id=2182, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 08 Reverse, Dragon Racing UI (Hidden)
		[2183] = { id=2183, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains01Reverse, Dragon Racing UI (Hidden)
		[2184] = { id=2184, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains02Reverse, Dragon Racing UI (Hidden)
		[2185] = { id=2185, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains03Reverse, Dragon Racing UI (Hidden)
		[2186] = { id=2186, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains04Reverse, Dragon Racing UI (Hidden)
		[2187] = { id=2187, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains07Reverse, Dragon Racing UI (Hidden)
		[2188] = { id=2188, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 01 Reverse, Dragon Racing UI (Hidden)
		[2189] = { id=2189, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 02 Reverse, Dragon Racing UI (Hidden)
		[2190] = { id=2190, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 03 Reverse, Dragon Racing UI (Hidden)
		[2191] = { id=2191, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 04 Reverse, Dragon Racing UI (Hidden)
		[2192] = { id=2192, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 05 Reverse, Dragon Racing UI (Hidden)
		[2193] = { id=2193, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 06 Reverse, Dragon Racing UI (Hidden)
		[2194] = { id=2194, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 01 Reverse, Dragon Racing UI (Hidden)
		[2195] = { id=2195, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 02 Reverse, Dragon Racing UI (Hidden)
		[2196] = { id=2196, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 03 Reverse, Dragon Racing UI (Hidden)
		[2197] = { id=2197, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 04 Reverse, Dragon Racing UI (Hidden)
		[2198] = { id=2198, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 05 Reverse, Dragon Racing UI (Hidden)
		[2199] = { id=2199, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 06 Reverse, Dragon Racing UI (Hidden)
		[2201] = { id=2201, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 01, Dragon Racing UI (Hidden)
		[2202] = { id=2202, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 02, Dragon Racing UI (Hidden)
		[2203] = { id=2203, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 03, Dragon Racing UI (Hidden)
		[2204] = { id=2204, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 04, Dragon Racing UI (Hidden)
		[2205] = { id=2205, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 05, Dragon Racing UI (Hidden)
		[2206] = { id=2206, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 06, Dragon Racing UI (Hidden)
		[2207] = { id=2207, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 01 Advanced, Dragon Racing UI (Hidden)
		[2208] = { id=2208, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 02 Advanced, Dragon Racing UI (Hidden)
		[2209] = { id=2209, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 03 Advanced, Dragon Racing UI (Hidden)
		[2210] = { id=2210, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 04 Advanced, Dragon Racing UI (Hidden)
		[2211] = { id=2211, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 05 Advanced, Dragon Racing UI (Hidden)
		[2212] = { id=2212, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 06 Advanced, Dragon Racing UI (Hidden)
		[2213] = { id=2213, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 01 Reverse, Dragon Racing UI (Hidden)
		[2214] = { id=2214, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 02 Reverse, Dragon Racing UI (Hidden)
		[2215] = { id=2215, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 03 Reverse, Dragon Racing UI (Hidden)
		[2216] = { id=2216, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 04 Reverse, Dragon Racing UI (Hidden)
		[2217] = { id=2217, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 05 Reverse, Dragon Racing UI (Hidden)
		[2218] = { id=2218, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 06 Reverse, Dragon Racing UI (Hidden)
		[2224] = { id=2224, category=251, hide=true }, -- Dragon Racing - Best Time Display - Reverse - Whole, Dragon Racing UI (Hidden)
		[2225] = { id=2225, category=251, hide=true }, -- Dragon Racing - Best Time Display - Reverse - Fraction 1, Dragon Racing UI (Hidden)
		[2226] = { id=2226, category=251, hide=true }, -- Dragon Racing - Best Time Display - Reverse - Fraction 10, Dragon Racing UI (Hidden)
		[2227] = { id=2227, category=251, hide=true }, -- Dragon Racing - Best Time Display - Reverse - Fraction 100, Dragon Racing UI (Hidden)
		[2228] = { id=2228, category=252, hide=true }, -- Tuskarr - Fishing Net - Location 06 - Net 01 - Loot, Tuskarr - Fishing Nets (Hidden)
		[2230] = { id=2230, category=144 }, -- Darkmoon Prize Ticket (Void), Virtual
		[2231] = { id=2231, category=142, hide=true }, -- Players, Hidden
		[2235] = { id=2235, category=251, hide=true }, -- 10.0 Dragonrider PVP - Whirling Surge Dismounts 10.0.2 [DNT], Dragon Racing UI (Hidden)
		[2236] = { id=2236, category=251, hide=true }, -- Dragon Racing - Scoreboard - Race Complete Time MS, Dragon Racing UI (Hidden)
		[2237] = { id=2237, category=251, hide=true }, -- 10.0 Dragonrider PVP - Whirling Surge Dismounts 10.0.5 [DNT], Dragon Racing UI (Hidden)
		[2244] = { id=2244, category=142, hide=true }, -- Forbidden Reach Return - Renown Dailies Completed, Hidden
		[2245] = { id=2245, category=250 }, -- Flightstones, Dragonflight
		[2246] = { id=2246, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 01, Dragon Racing UI (Hidden)
		[2247] = { id=2247, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 02, Dragon Racing UI (Hidden)
		[2248] = { id=2248, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 03, Dragon Racing UI (Hidden)
		[2249] = { id=2249, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 04, Dragon Racing UI (Hidden)
		[2250] = { id=2250, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 05, Dragon Racing UI (Hidden)
		[2251] = { id=2251, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 06, Dragon Racing UI (Hidden)
		[2252] = { id=2252, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 01 Advanced, Dragon Racing UI (Hidden)
		[2253] = { id=2253, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 02 Advanced, Dragon Racing UI (Hidden)
		[2254] = { id=2254, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 03 Advanced, Dragon Racing UI (Hidden)
		[2255] = { id=2255, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 04 Advanced, Dragon Racing UI (Hidden)
		[2256] = { id=2256, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 05 Advanced, Dragon Racing UI (Hidden)
		[2257] = { id=2257, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 06 Advanced, Dragon Racing UI (Hidden)
		[2258] = { id=2258, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 01 Reverse, Dragon Racing UI (Hidden)
		[2259] = { id=2259, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 02 Reverse, Dragon Racing UI (Hidden)
		[2260] = { id=2260, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 03 Reverse, Dragon Racing UI (Hidden)
		[2261] = { id=2261, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 04 Reverse, Dragon Racing UI (Hidden)
		[2262] = { id=2262, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 05 Reverse, Dragon Racing UI (Hidden)
		[2263] = { id=2263, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 06 Reverse, Dragon Racing UI (Hidden)
		[2264] = { id=2264, category=142, hide=true }, -- Account HWM - Helm [DNT], Hidden
		[2265] = { id=2265, category=142, hide=true }, -- Account HWM - Neck [DNT], Hidden
		[2266] = { id=2266, category=142, hide=true }, -- Account HWM - Shoulders [DNT], Hidden
		[2267] = { id=2267, category=142, hide=true }, -- Account HWM - Chest [DNT], Hidden
		[2268] = { id=2268, category=142, hide=true }, -- Account HWM - Waist [DNT], Hidden
		[2269] = { id=2269, category=142, hide=true }, -- Account HWM - Legs [DNT], Hidden
		[2270] = { id=2270, category=142, hide=true }, -- Account HWM - Feet [DNT], Hidden
		[2271] = { id=2271, category=142, hide=true }, -- Account HWM - Wrist [DNT], Hidden
		[2272] = { id=2272, category=142, hide=true }, -- Account HWM - Hands [DNT], Hidden
		[2273] = { id=2273, category=142, hide=true }, -- Account HWM - Ring [DNT], Hidden
		[2274] = { id=2274, category=142, hide=true }, -- Account HWM - Trinket [DNT], Hidden
		[2275] = { id=2275, category=142, hide=true }, -- Account HWM - Cloak [DNT], Hidden
		[2276] = { id=2276, category=142, hide=true }, -- Account HWM - Two Hand [DNT], Hidden
		[2277] = { id=2277, category=142, hide=true }, -- Account HWM - Main Hand [DNT], Hidden
		[2278] = { id=2278, category=142, hide=true }, -- Account HWM - One Hand [DNT], Hidden
		[2279] = { id=2279, category=142, hide=true }, -- Account HWM - One Hand (Second) [DNT], Hidden
		[2280] = { id=2280, category=142, hide=true }, -- Account HWM - Off Hand [DNT], Hidden
		[2281] = { id=2281, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Test, Dragon Racing UI (Hidden)
		[2312] = { id=2312, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 01, Dragon Racing UI (Hidden)
		[2313] = { id=2313, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 02, Dragon Racing UI (Hidden)
		[2314] = { id=2314, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 03, Dragon Racing UI (Hidden)
		[2315] = { id=2315, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 04, Dragon Racing UI (Hidden)
		[2316] = { id=2316, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 05, Dragon Racing UI (Hidden)
		[2317] = { id=2317, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 06, Dragon Racing UI (Hidden)
		[2318] = { id=2318, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 07, Dragon Racing UI (Hidden)
		[2319] = { id=2319, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 08, Dragon Racing UI (Hidden)
		[2320] = { id=2320, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 09, Dragon Racing UI (Hidden)
		[2321] = { id=2321, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 10, Dragon Racing UI (Hidden)
		[2322] = { id=2322, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 11, Dragon Racing UI (Hidden)
		[2323] = { id=2323, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 12, Dragon Racing UI (Hidden)
		[2324] = { id=2324, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 13, Dragon Racing UI (Hidden)
		[2325] = { id=2325, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 14, Dragon Racing UI (Hidden)
		[2326] = { id=2326, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 15, Dragon Racing UI (Hidden)
		[2327] = { id=2327, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 16, Dragon Racing UI (Hidden)
		[2328] = { id=2328, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 17, Dragon Racing UI (Hidden)
		[2329] = { id=2329, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 18, Dragon Racing UI (Hidden)
		[2330] = { id=2330, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 19, Dragon Racing UI (Hidden)
		[2331] = { id=2331, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 20, Dragon Racing UI (Hidden)
		[2332] = { id=2332, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 21, Dragon Racing UI (Hidden)
		[2333] = { id=2333, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 22, Dragon Racing UI (Hidden)
		[2334] = { id=2334, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 23, Dragon Racing UI (Hidden)
		[2335] = { id=2335, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 24, Dragon Racing UI (Hidden)
		[2336] = { id=2336, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 25, Dragon Racing UI (Hidden)
		[2337] = { id=2337, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 26, Dragon Racing UI (Hidden)
		[2338] = { id=2338, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 27, Dragon Racing UI (Hidden)
		[2339] = { id=2339, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 28, Dragon Racing UI (Hidden)
		[2340] = { id=2340, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 29, Dragon Racing UI (Hidden)
		[2341] = { id=2341, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 30, Dragon Racing UI (Hidden)
		[2342] = { id=2342, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 01 Advanced, Dragon Racing UI (Hidden)
		[2343] = { id=2343, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 02 Advanced, Dragon Racing UI (Hidden)
		[2344] = { id=2344, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 03 Advanced, Dragon Racing UI (Hidden)
		[2345] = { id=2345, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 04 Advanced, Dragon Racing UI (Hidden)
		[2346] = { id=2346, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 05 Advanced, Dragon Racing UI (Hidden)
		[2347] = { id=2347, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 06 Advanced, Dragon Racing UI (Hidden)
		[2348] = { id=2348, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 07 Advanced, Dragon Racing UI (Hidden)
		[2349] = { id=2349, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 08 Advanced, Dragon Racing UI (Hidden)
		[2350] = { id=2350, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 09 Advanced, Dragon Racing UI (Hidden)
		[2351] = { id=2351, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 10 Advanced, Dragon Racing UI (Hidden)
		[2352] = { id=2352, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 11 Advanced, Dragon Racing UI (Hidden)
		[2353] = { id=2353, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 12 Advanced, Dragon Racing UI (Hidden)
		[2354] = { id=2354, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 13 Advanced, Dragon Racing UI (Hidden)
		[2355] = { id=2355, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 14 Advanced, Dragon Racing UI (Hidden)
		[2356] = { id=2356, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 15 Advanced, Dragon Racing UI (Hidden)
		[2357] = { id=2357, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 16 Advanced, Dragon Racing UI (Hidden)
		[2358] = { id=2358, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 17 Advanced, Dragon Racing UI (Hidden)
		[2359] = { id=2359, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 18 Advanced, Dragon Racing UI (Hidden)
		[2360] = { id=2360, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 19 Advanced, Dragon Racing UI (Hidden)
		[2361] = { id=2361, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 20 Advanced, Dragon Racing UI (Hidden)
		[2362] = { id=2362, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 21 Advanced, Dragon Racing UI (Hidden)
		[2363] = { id=2363, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 22 Advanced, Dragon Racing UI (Hidden)
		[2364] = { id=2364, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 23 Advanced, Dragon Racing UI (Hidden)
		[2365] = { id=2365, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 24 Advanced, Dragon Racing UI (Hidden)
		[2366] = { id=2366, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 25 Advanced, Dragon Racing UI (Hidden)
		[2367] = { id=2367, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 26 Advanced, Dragon Racing UI (Hidden)
		[2368] = { id=2368, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 27 Advanced, Dragon Racing UI (Hidden)
		[2369] = { id=2369, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 28 Advanced, Dragon Racing UI (Hidden)
		[2370] = { id=2370, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 29 Advanced, Dragon Racing UI (Hidden)
		[2371] = { id=2371, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 30 Advanced, Dragon Racing UI (Hidden)
		[2372] = { id=2372, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 01 Reverse, Dragon Racing UI (Hidden)
		[2373] = { id=2373, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 02 Reverse, Dragon Racing UI (Hidden)
		[2374] = { id=2374, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 03 Reverse, Dragon Racing UI (Hidden)
		[2375] = { id=2375, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 04 Reverse, Dragon Racing UI (Hidden)
		[2376] = { id=2376, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 05 Reverse, Dragon Racing UI (Hidden)
		[2377] = { id=2377, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 06 Reverse, Dragon Racing UI (Hidden)
		[2378] = { id=2378, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 07 Reverse, Dragon Racing UI (Hidden)
		[2379] = { id=2379, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 08 Reverse, Dragon Racing UI (Hidden)
		[2380] = { id=2380, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 09 Reverse, Dragon Racing UI (Hidden)
		[2381] = { id=2381, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 10 Reverse, Dragon Racing UI (Hidden)
		[2382] = { id=2382, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 11 Reverse, Dragon Racing UI (Hidden)
		[2383] = { id=2383, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 12 Reverse, Dragon Racing UI (Hidden)
		[2384] = { id=2384, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 13 Reverse, Dragon Racing UI (Hidden)
		[2385] = { id=2385, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 14 Reverse, Dragon Racing UI (Hidden)
		[2386] = { id=2386, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 15 Reverse, Dragon Racing UI (Hidden)
		[2387] = { id=2387, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 16 Reverse, Dragon Racing UI (Hidden)
		[2388] = { id=2388, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 17 Reverse, Dragon Racing UI (Hidden)
		[2389] = { id=2389, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 18 Reverse, Dragon Racing UI (Hidden)
		[2390] = { id=2390, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 19 Reverse, Dragon Racing UI (Hidden)
		[2391] = { id=2391, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 20 Reverse, Dragon Racing UI (Hidden)
		[2392] = { id=2392, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 21 Reverse, Dragon Racing UI (Hidden)
		[2393] = { id=2393, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 22 Reverse, Dragon Racing UI (Hidden)
		[2394] = { id=2394, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 23 Reverse, Dragon Racing UI (Hidden)
		[2395] = { id=2395, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 24 Reverse, Dragon Racing UI (Hidden)
		[2396] = { id=2396, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 25 Reverse, Dragon Racing UI (Hidden)
		[2397] = { id=2397, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 26 Reverse, Dragon Racing UI (Hidden)
		[2398] = { id=2398, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 27 Reverse, Dragon Racing UI (Hidden)
		[2399] = { id=2399, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 28 Reverse, Dragon Racing UI (Hidden)
		[2400] = { id=2400, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 29 Reverse, Dragon Racing UI (Hidden)
		[2401] = { id=2401, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 30 Reverse, Dragon Racing UI (Hidden)
		[2402] = { id=2402, category=142 }, -- Renown - Loamm Niffen, Hidden
		[2408] = { id=2408, category=142 }, -- Bonus Flightstones, Hidden
		[2409] = { id=2409, category=142 }, -- Whelpling Crest Fragment Tracker [DNT], Hidden
		[2410] = { id=2410, category=142 }, -- Drake Crest Fragment Tracker [DNT], Hidden
		[2411] = { id=2411, category=142 }, -- Wyrm Crest Fragment Tracker [DNT], Hidden
		[2412] = { id=2412, category=142 }, -- Aspect Crest Fragment Tracker [DNT], Hidden
		[2413] = { id=2413, category=142, hide=true }, -- 10.1 Professions - Personal Tracker - S2 Spark Drops (Hidden), Hidden
		[2414] = { id=2414, category=251, hide=true }, -- 10.1.5 Whelp Daycare - Whelp Racing - Black - 001 (OJF), Dragon Racing UI (Hidden)
		[2415] = { id=2415, category=251, hide=true }, -- 10.1.5 Whelp Daycare - Whelp Racing - Blue - 001 (OJF), Dragon Racing UI (Hidden)
		[2416] = { id=2416, category=251, hide=true }, -- 10.1.5 Whelp Daycare - Whelp Racing - Bronze - 001 (OJF), Dragon Racing UI (Hidden)
		[2417] = { id=2417, category=251, hide=true }, -- 10.1.5 Whelp Daycare - Whelp Racing - Green - 001 (OJF), Dragon Racing UI (Hidden)
		[2418] = { id=2418, category=251, hide=true }, -- 10.1.5 Whelp Daycare - Whelp Racing - Red - 001 (OJF), Dragon Racing UI (Hidden)
		[2419] = { id=2419, category=142, hide=true }, -- Test Currency Main [DNT], Hidden
		[2420] = { id=2420, category=142 }, -- Loamm Niffen, Hidden
		[2421] = { id=2421, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 01 Challeng, Dragon Racing UI (Hidden)
		[2422] = { id=2422, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 01 ChallenR, Dragon Racing UI (Hidden)
		[2423] = { id=2423, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 02 Challeng, Dragon Racing UI (Hidden)
		[2424] = { id=2424, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 02 ChallenR, Dragon Racing UI (Hidden)
		[2425] = { id=2425, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 03 Challeng, Dragon Racing UI (Hidden)
		[2426] = { id=2426, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 03 ChallenR, Dragon Racing UI (Hidden)
		[2427] = { id=2427, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 04 Challeng, Dragon Racing UI (Hidden)
		[2428] = { id=2428, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 04 ChallenR, Dragon Racing UI (Hidden)
		[2429] = { id=2429, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 05 Challeng, Dragon Racing UI (Hidden)
		[2430] = { id=2430, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 05 ChallenR, Dragon Racing UI (Hidden)
		[2431] = { id=2431, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 06 Challeng, Dragon Racing UI (Hidden)
		[2432] = { id=2432, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 06 ChallenR, Dragon Racing UI (Hidden)
		[2433] = { id=2433, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 07 Challeng, Dragon Racing UI (Hidden)
		[2434] = { id=2434, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 07 ChallenR, Dragon Racing UI (Hidden)
		[2435] = { id=2435, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 08 Challeng, Dragon Racing UI (Hidden)
		[2436] = { id=2436, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Waking Shores 08 ChallenR, Dragon Racing UI (Hidden)
		[2437] = { id=2437, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 01 Chall, Dragon Racing UI (Hidden)
		[2439] = { id=2439, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 01 ChalR, Dragon Racing UI (Hidden)
		[2440] = { id=2440, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 02 Chall, Dragon Racing UI (Hidden)
		[2441] = { id=2441, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 02 ChalR, Dragon Racing UI (Hidden)
		[2442] = { id=2442, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 03 Chall, Dragon Racing UI (Hidden)
		[2443] = { id=2443, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 03 ChalR, Dragon Racing UI (Hidden)
		[2444] = { id=2444, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 04 Chall, Dragon Racing UI (Hidden)
		[2445] = { id=2445, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 04 ChalR, Dragon Racing UI (Hidden)
		[2446] = { id=2446, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 05 Chall, Dragon Racing UI (Hidden)
		[2447] = { id=2447, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 06 Chall, Dragon Racing UI (Hidden)
		[2448] = { id=2448, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 07 Chall, Dragon Racing UI (Hidden)
		[2449] = { id=2449, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Ohn'ahran Plains 07 ChalR, Dragon Racing UI (Hidden)
		[2450] = { id=2450, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 01 Challenge, Dragon Racing UI (Hidden)
		[2451] = { id=2451, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 01 Challenge R, Dragon Racing UI (Hidden)
		[2452] = { id=2452, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 02 Challenge, Dragon Racing UI (Hidden)
		[2453] = { id=2453, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 02 Challenge R, Dragon Racing UI (Hidden)
		[2454] = { id=2454, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 03 Challenge, Dragon Racing UI (Hidden)
		[2455] = { id=2455, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 03 Challenge R, Dragon Racing UI (Hidden)
		[2456] = { id=2456, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 04 Challenge, Dragon Racing UI (Hidden)
		[2457] = { id=2457, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 04 Challenge R, Dragon Racing UI (Hidden)
		[2458] = { id=2458, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 05 Challenge, Dragon Racing UI (Hidden)
		[2459] = { id=2459, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 05 Challenge R, Dragon Racing UI (Hidden)
		[2460] = { id=2460, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 06 Challenge, Dragon Racing UI (Hidden)
		[2461] = { id=2461, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Azure Span 06 Challenge R, Dragon Racing UI (Hidden)
		[2462] = { id=2462, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 01 Challenge, Dragon Racing UI (Hidden)
		[2463] = { id=2463, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 01 ChallengeR, Dragon Racing UI (Hidden)
		[2464] = { id=2464, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 02 Challenge, Dragon Racing UI (Hidden)
		[2465] = { id=2465, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 02 ChallengeR, Dragon Racing UI (Hidden)
		[2466] = { id=2466, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 03 Challenge, Dragon Racing UI (Hidden)
		[2467] = { id=2467, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 03 ChallengeR, Dragon Racing UI (Hidden)
		[2468] = { id=2468, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 04 Challenge, Dragon Racing UI (Hidden)
		[2469] = { id=2469, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 04 ChallengeR, Dragon Racing UI (Hidden)
		[2470] = { id=2470, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 05 Challenge, Dragon Racing UI (Hidden)
		[2471] = { id=2471, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 05 ChallengeR, Dragon Racing UI (Hidden)
		[2472] = { id=2472, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 06 Challenge, Dragon Racing UI (Hidden)
		[2473] = { id=2473, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Thaldraszus 06 ChallengeR, Dragon Racing UI (Hidden)
		[2474] = { id=2474, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 01 Challenge, Dragon Racing UI (Hidden)
		[2475] = { id=2475, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 01 Challenge R, Dragon Racing UI (Hidden)
		[2476] = { id=2476, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 02 Challenge, Dragon Racing UI (Hidden)
		[2477] = { id=2477, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 02 Challenge R, Dragon Racing UI (Hidden)
		[2478] = { id=2478, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 03 Challenge, Dragon Racing UI (Hidden)
		[2479] = { id=2479, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 03 Challenge R, Dragon Racing UI (Hidden)
		[2480] = { id=2480, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 04 Challenge, Dragon Racing UI (Hidden)
		[2481] = { id=2481, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 04 Challenge R, Dragon Racing UI (Hidden)
		[2482] = { id=2482, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 05 Challenge, Dragon Racing UI (Hidden)
		[2483] = { id=2483, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 05 Challenge R, Dragon Racing UI (Hidden)
		[2484] = { id=2484, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 06 Challenge, Dragon Racing UI (Hidden)
		[2485] = { id=2485, category=251, hide=true }, -- Dragon Racing - Personal Best Record - F Reach 06 Challenge R, Dragon Racing UI (Hidden)
		[2486] = { id=2486, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 01 Challenge, Dragon Racing UI (Hidden)
		[2487] = { id=2487, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 01 Challenge R, Dragon Racing UI (Hidden)
		[2488] = { id=2488, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 02 Challenge, Dragon Racing UI (Hidden)
		[2489] = { id=2489, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 02 Challenge R, Dragon Racing UI (Hidden)
		[2490] = { id=2490, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 03 Challenge, Dragon Racing UI (Hidden)
		[2491] = { id=2491, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 03 Challenge R, Dragon Racing UI (Hidden)
		[2492] = { id=2492, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 04 Challenge, Dragon Racing UI (Hidden)
		[2493] = { id=2493, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 04 Challenge R, Dragon Racing UI (Hidden)
		[2494] = { id=2494, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 05 Challenge, Dragon Racing UI (Hidden)
		[2495] = { id=2495, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 05 Challenge R, Dragon Racing UI (Hidden)
		[2496] = { id=2496, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 06 Challenge, Dragon Racing UI (Hidden)
		[2497] = { id=2497, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Z Cavern 06 Challenge R, Dragon Racing UI (Hidden)
		[2498] = { id=2498, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 01 Challenge, Dragon Racing UI (Hidden)
		[2499] = { id=2499, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 01 Challenge R, Dragon Racing UI (Hidden)
		[2500] = { id=2500, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 02 Challenge, Dragon Racing UI (Hidden)
		[2501] = { id=2501, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 02 Challenge R, Dragon Racing UI (Hidden)
		[2502] = { id=2502, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 03 Challenge, Dragon Racing UI (Hidden)
		[2503] = { id=2503, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 03 Challenge R, Dragon Racing UI (Hidden)
		[2504] = { id=2504, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 04 Challenge, Dragon Racing UI (Hidden)
		[2505] = { id=2505, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 04 Challenge R, Dragon Racing UI (Hidden)
		[2506] = { id=2506, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 05 Challenge, Dragon Racing UI (Hidden)
		[2507] = { id=2507, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 05 Challenge R, Dragon Racing UI (Hidden)
		[2508] = { id=2508, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 06 Challenge, Dragon Racing UI (Hidden)
		[2509] = { id=2509, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 06 Challenge R, Dragon Racing UI (Hidden)
		[2510] = { id=2510, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 07 Challenge, Dragon Racing UI (Hidden)
		[2511] = { id=2511, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 07 Challenge R, Dragon Racing UI (Hidden)
		[2512] = { id=2512, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 08 Challenge, Dragon Racing UI (Hidden)
		[2513] = { id=2513, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 08 Challenge R, Dragon Racing UI (Hidden)
		[2514] = { id=2514, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 09 Challenge, Dragon Racing UI (Hidden)
		[2515] = { id=2515, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 09 Challenge R, Dragon Racing UI (Hidden)
		[2516] = { id=2516, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 10 Challenge, Dragon Racing UI (Hidden)
		[2517] = { id=2517, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 10 Challenge R, Dragon Racing UI (Hidden)
		[2518] = { id=2518, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 11 Challenge, Dragon Racing UI (Hidden)
		[2519] = { id=2519, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 11 Challenge R, Dragon Racing UI (Hidden)
		[2520] = { id=2520, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 12 Challenge, Dragon Racing UI (Hidden)
		[2521] = { id=2521, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 12 Challenge R, Dragon Racing UI (Hidden)
		[2522] = { id=2522, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 13 Challenge, Dragon Racing UI (Hidden)
		[2523] = { id=2523, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 13 Challenge R, Dragon Racing UI (Hidden)
		[2524] = { id=2524, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 14 Challenge, Dragon Racing UI (Hidden)
		[2525] = { id=2525, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 14 Challenge R, Dragon Racing UI (Hidden)
		[2526] = { id=2526, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 15 Challenge, Dragon Racing UI (Hidden)
		[2527] = { id=2527, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 15 Challenge R, Dragon Racing UI (Hidden)
		[2528] = { id=2528, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 16 Challenge, Dragon Racing UI (Hidden)
		[2529] = { id=2529, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Kalimdor 16 Challenge R, Dragon Racing UI (Hidden)
		[2531] = { id=2531, category=250 }, -- zzOLD Delving Gems, Dragonflight
		[2533] = { id=2533, category=142 }, -- Renascent Shadowflame, Hidden
		[2536] = { id=2536, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 01, Dragon Racing UI (Hidden)
		[2537] = { id=2537, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 02, Dragon Racing UI (Hidden)
		[2538] = { id=2538, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 03, Dragon Racing UI (Hidden)
		[2539] = { id=2539, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 04, Dragon Racing UI (Hidden)
		[2540] = { id=2540, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 05, Dragon Racing UI (Hidden)
		[2541] = { id=2541, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 06, Dragon Racing UI (Hidden)
		[2542] = { id=2542, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 07, Dragon Racing UI (Hidden)
		[2543] = { id=2543, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 08, Dragon Racing UI (Hidden)
		[2544] = { id=2544, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 09, Dragon Racing UI (Hidden)
		[2545] = { id=2545, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 10, Dragon Racing UI (Hidden)
		[2546] = { id=2546, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 11, Dragon Racing UI (Hidden)
		[2547] = { id=2547, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 12, Dragon Racing UI (Hidden)
		[2548] = { id=2548, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 13, Dragon Racing UI (Hidden)
		[2549] = { id=2549, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 14, Dragon Racing UI (Hidden)
		[2550] = { id=2550, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 15, Dragon Racing UI (Hidden)
		[2551] = { id=2551, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 16, Dragon Racing UI (Hidden)
		[2552] = { id=2552, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 01 Advanced, Dragon Racing UI (Hidden)
		[2553] = { id=2553, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 02 Advanced, Dragon Racing UI (Hidden)
		[2554] = { id=2554, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 03 Advanced, Dragon Racing UI (Hidden)
		[2555] = { id=2555, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 04 Advanced, Dragon Racing UI (Hidden)
		[2556] = { id=2556, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 05 Advanced, Dragon Racing UI (Hidden)
		[2557] = { id=2557, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 06 Advanced, Dragon Racing UI (Hidden)
		[2558] = { id=2558, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 07 Advanced, Dragon Racing UI (Hidden)
		[2559] = { id=2559, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 08 Advanced, Dragon Racing UI (Hidden)
		[2560] = { id=2560, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 09 Advanced, Dragon Racing UI (Hidden)
		[2561] = { id=2561, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 10 Advanced, Dragon Racing UI (Hidden)
		[2562] = { id=2562, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 11 Advanced, Dragon Racing UI (Hidden)
		[2563] = { id=2563, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 12 Advanced, Dragon Racing UI (Hidden)
		[2564] = { id=2564, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 13 Advanced, Dragon Racing UI (Hidden)
		[2565] = { id=2565, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 14 Advanced, Dragon Racing UI (Hidden)
		[2566] = { id=2566, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 15 Advanced, Dragon Racing UI (Hidden)
		[2567] = { id=2567, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 16 Advanced, Dragon Racing UI (Hidden)
		[2568] = { id=2568, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 01 Reverse, Dragon Racing UI (Hidden)
		[2569] = { id=2569, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 02 Reverse, Dragon Racing UI (Hidden)
		[2570] = { id=2570, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 03 Reverse, Dragon Racing UI (Hidden)
		[2571] = { id=2571, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 04 Reverse, Dragon Racing UI (Hidden)
		[2572] = { id=2572, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 05 Reverse, Dragon Racing UI (Hidden)
		[2573] = { id=2573, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 06 Reverse, Dragon Racing UI (Hidden)
		[2574] = { id=2574, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 07 Reverse, Dragon Racing UI (Hidden)
		[2575] = { id=2575, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 08 Reverse, Dragon Racing UI (Hidden)
		[2576] = { id=2576, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 09 Reverse, Dragon Racing UI (Hidden)
		[2577] = { id=2577, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 10 Reverse, Dragon Racing UI (Hidden)
		[2578] = { id=2578, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 11 Reverse, Dragon Racing UI (Hidden)
		[2579] = { id=2579, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 12 Reverse, Dragon Racing UI (Hidden)
		[2580] = { id=2580, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 13 Reverse, Dragon Racing UI (Hidden)
		[2581] = { id=2581, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 14 Reverse, Dragon Racing UI (Hidden)
		[2582] = { id=2582, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 15 Reverse, Dragon Racing UI (Hidden)
		[2583] = { id=2583, category=251, hide=true }, -- Dragon Racing - Personal Best Record - E Kingdoms 16 Reverse, Dragon Racing UI (Hidden)
		[2588] = { id=2588, category=1 }, -- Riders of Azeroth Badge, Miscellaneous
		[2590] = { id=2590, category=250 }, -- Lost Transcripts, Dragonflight
		[2591] = { id=2591, category=250 }, -- 11.0 Delves - Score Inside, Dragonflight
		[2592] = { id=2592, category=250 }, -- 11.0 Delves - Reputation Score, Dragonflight
		[2594] = { id=2594, category=250 }, -- Paracausal Flakes, Dragonflight
		[2595] = { id=2595, category=251, hide=true }, -- Dragon Racing - Medal Widget - Normal [DNT], Dragon Racing UI (Hidden)
		[2596] = { id=2596, category=251, hide=true }, -- Dragon Racing - Medal Widget - Advanced [DNT], Dragon Racing UI (Hidden)
		[2597] = { id=2597, category=251, hide=true }, -- Dragon Racing - Medal Widget - Reverse [DNT], Dragon Racing UI (Hidden)
		[2598] = { id=2598, category=251, hide=true }, -- Dragon Racing - Medal Widget - Temp [DNT], Dragon Racing UI (Hidden)
		[2599] = { id=2599, category=251, hide=true }, -- Dragon Racing - Medal Widget - Temp2 [DNT], Dragon Racing UI (Hidden)
		[2600] = { id=2600, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 01, Dragon Racing UI (Hidden)
		[2601] = { id=2601, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 02, Dragon Racing UI (Hidden)
		[2602] = { id=2602, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 03, Dragon Racing UI (Hidden)
		[2603] = { id=2603, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 04, Dragon Racing UI (Hidden)
		[2604] = { id=2604, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 05, Dragon Racing UI (Hidden)
		[2605] = { id=2605, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 06, Dragon Racing UI (Hidden)
		[2606] = { id=2606, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 07, Dragon Racing UI (Hidden)
		[2607] = { id=2607, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 08, Dragon Racing UI (Hidden)
		[2608] = { id=2608, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 09, Dragon Racing UI (Hidden)
		[2609] = { id=2609, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 10, Dragon Racing UI (Hidden)
		[2610] = { id=2610, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 11, Dragon Racing UI (Hidden)
		[2611] = { id=2611, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 12, Dragon Racing UI (Hidden)
		[2612] = { id=2612, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 13, Dragon Racing UI (Hidden)
		[2613] = { id=2613, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 14, Dragon Racing UI (Hidden)
		[2614] = { id=2614, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 15, Dragon Racing UI (Hidden)
		[2615] = { id=2615, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 01 Advanced, Dragon Racing UI (Hidden)
		[2616] = { id=2616, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 02 Advanced, Dragon Racing UI (Hidden)
		[2617] = { id=2617, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 03 Advanced, Dragon Racing UI (Hidden)
		[2618] = { id=2618, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 04 Advanced, Dragon Racing UI (Hidden)
		[2619] = { id=2619, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 05 Advanced, Dragon Racing UI (Hidden)
		[2620] = { id=2620, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 06 Advanced, Dragon Racing UI (Hidden)
		[2621] = { id=2621, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 07 Advanced, Dragon Racing UI (Hidden)
		[2622] = { id=2622, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 08 Advanced, Dragon Racing UI (Hidden)
		[2623] = { id=2623, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 09 Advanced, Dragon Racing UI (Hidden)
		[2624] = { id=2624, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 10 Advanced, Dragon Racing UI (Hidden)
		[2625] = { id=2625, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 11 Advanced, Dragon Racing UI (Hidden)
		[2626] = { id=2626, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 12 Advanced, Dragon Racing UI (Hidden)
		[2627] = { id=2627, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 13 Advanced, Dragon Racing UI (Hidden)
		[2628] = { id=2628, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 14 Advanced, Dragon Racing UI (Hidden)
		[2629] = { id=2629, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 15 Advanced, Dragon Racing UI (Hidden)
		[2630] = { id=2630, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 01 Reverse, Dragon Racing UI (Hidden)
		[2631] = { id=2631, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 02 Reverse, Dragon Racing UI (Hidden)
		[2632] = { id=2632, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 03 Reverse, Dragon Racing UI (Hidden)
		[2633] = { id=2633, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 04 Reverse, Dragon Racing UI (Hidden)
		[2634] = { id=2634, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 05 Reverse, Dragon Racing UI (Hidden)
		[2635] = { id=2635, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 06 Reverse, Dragon Racing UI (Hidden)
		[2636] = { id=2636, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 07 Reverse, Dragon Racing UI (Hidden)
		[2637] = { id=2637, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 08 Reverse, Dragon Racing UI (Hidden)
		[2638] = { id=2638, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 09 Reverse, Dragon Racing UI (Hidden)
		[2639] = { id=2639, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 10 Reverse, Dragon Racing UI (Hidden)
		[2640] = { id=2640, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 11 Reverse, Dragon Racing UI (Hidden)
		[2641] = { id=2641, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 12 Reverse, Dragon Racing UI (Hidden)
		[2642] = { id=2642, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 13 Reverse, Dragon Racing UI (Hidden)
		[2643] = { id=2643, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 14 Reverse, Dragon Racing UI (Hidden)
		[2644] = { id=2644, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 15 Reverse, Dragon Racing UI (Hidden)
		[2645] = { id=2645, category=142 }, -- Soridormi's Recognition, Hidden
		[2649] = { id=2649, category=142 }, -- [DNT] The Currency Formerly Named Dream Ephemera, Hidden
		[2650] = { id=2650, category=250 }, -- Emerald Dewdrop, Dragonflight
		[2651] = { id=2651, category=250 }, -- Seedbloom, Dragonflight
		[2652] = { id=2652, category=142 }, -- Dream Wardens, Hidden
		[2653] = { id=2653, category=142 }, -- Renown - Dream Wardens, Hidden
		[2654] = { id=2654, category=251, hide=true }, -- Dragon Racing - Kalimdor Cup Preferred Mount, Dragon Racing UI (Hidden)
		[2655] = { id=2655, category=142 }, -- Revives, Hidden
		[2657] = { id=2657, category=250 }, -- Mysterious Fragment, Dragonflight
		[2658] = { id=2658, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 16, Dragon Racing UI (Hidden)
		[2659] = { id=2659, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 17, Dragon Racing UI (Hidden)
		[2660] = { id=2660, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 18, Dragon Racing UI (Hidden)
		[2661] = { id=2661, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 19, Dragon Racing UI (Hidden)
		[2662] = { id=2662, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 20, Dragon Racing UI (Hidden)
		[2663] = { id=2663, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 21, Dragon Racing UI (Hidden)
		[2664] = { id=2664, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 16 Advanced, Dragon Racing UI (Hidden)
		[2665] = { id=2665, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 17 Advanced, Dragon Racing UI (Hidden)
		[2666] = { id=2666, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 18 Advanced, Dragon Racing UI (Hidden)
		[2667] = { id=2667, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 19 Advanced, Dragon Racing UI (Hidden)
		[2668] = { id=2668, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 20 Advanced, Dragon Racing UI (Hidden)
		[2669] = { id=2669, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 21 Advanced, Dragon Racing UI (Hidden)
		[2670] = { id=2670, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 16 Reverse, Dragon Racing UI (Hidden)
		[2671] = { id=2671, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 17 Reverse, Dragon Racing UI (Hidden)
		[2672] = { id=2672, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 18 Reverse, Dragon Racing UI (Hidden)
		[2673] = { id=2673, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 19 Reverse, Dragon Racing UI (Hidden)
		[2674] = { id=2674, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 20 Reverse, Dragon Racing UI (Hidden)
		[2675] = { id=2675, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Outland 21 Reverse, Dragon Racing UI (Hidden)
		[2676] = { id=2676, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 01, Dragon Racing UI (Hidden)
		[2677] = { id=2677, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 02, Dragon Racing UI (Hidden)
		[2678] = { id=2678, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 03, Dragon Racing UI (Hidden)
		[2679] = { id=2679, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 04, Dragon Racing UI (Hidden)
		[2680] = { id=2680, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 05, Dragon Racing UI (Hidden)
		[2681] = { id=2681, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 06, Dragon Racing UI (Hidden)
		[2682] = { id=2682, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 01 Advanced, Dragon Racing UI (Hidden)
		[2683] = { id=2683, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 02 Advanced, Dragon Racing UI (Hidden)
		[2684] = { id=2684, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 03 Advanced, Dragon Racing UI (Hidden)
		[2685] = { id=2685, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 04 Advanced, Dragon Racing UI (Hidden)
		[2686] = { id=2686, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 05 Advanced, Dragon Racing UI (Hidden)
		[2687] = { id=2687, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 06 Advanced, Dragon Racing UI (Hidden)
		[2688] = { id=2688, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 01 Reverse, Dragon Racing UI (Hidden)
		[2689] = { id=2689, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 02 Reverse, Dragon Racing UI (Hidden)
		[2690] = { id=2690, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 03 Reverse, Dragon Racing UI (Hidden)
		[2691] = { id=2691, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 04 Reverse, Dragon Racing UI (Hidden)
		[2692] = { id=2692, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 05 Reverse, Dragon Racing UI (Hidden)
		[2693] = { id=2693, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Emerald Dream 06 Reverse, Dragon Racing UI (Hidden)
		[2694] = { id=2694, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 01 Challenge, Dragon Racing UI (Hidden)
		[2695] = { id=2695, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 01 Challenge R, Dragon Racing UI (Hidden)
		[2696] = { id=2696, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 02 Challenge, Dragon Racing UI (Hidden)
		[2697] = { id=2697, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 02 Challenge R, Dragon Racing UI (Hidden)
		[2698] = { id=2698, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 03 Challenge, Dragon Racing UI (Hidden)
		[2699] = { id=2699, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 03 Challenge R, Dragon Racing UI (Hidden)
		[2700] = { id=2700, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 04 Challenge, Dragon Racing UI (Hidden)
		[2701] = { id=2701, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 04 Challenge R, Dragon Racing UI (Hidden)
		[2702] = { id=2702, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 05 Challenge, Dragon Racing UI (Hidden)
		[2703] = { id=2703, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 05 Challenge R, Dragon Racing UI (Hidden)
		[2704] = { id=2704, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 06 Challenge, Dragon Racing UI (Hidden)
		[2705] = { id=2705, category=251, hide=true }, -- Dragon Racing - Personal Best Record - ED 06 Challenge R, Dragon Racing UI (Hidden)
		[2706] = { id=2706, category=142 }, -- Whelpling's Dreaming Crest, Hidden
		[2707] = { id=2707, category=142 }, -- Drake's Dreaming Crest, Hidden
		[2708] = { id=2708, category=142 }, -- Wyrm's Dreaming Crest, Hidden
		[2709] = { id=2709, category=142 }, -- Aspect's Dreaming Crest, Hidden
		[2710] = { id=2710, category=142 }, -- Study of Shadowflame, Hidden
		[2715] = { id=2715, category=142 }, -- Whelpling's Dreaming Crests, Hidden
		[2716] = { id=2716, category=142 }, -- Drake's Dreaming Crests, Hidden
		[2717] = { id=2717, category=142 }, -- Wyrm's Dreaming Crests, Hidden
		[2718] = { id=2718, category=142 }, -- Aspect's Dreaming Crests, Hidden
		[2720] = { id=2720, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 01, Dragon Racing UI (Hidden)
		[2721] = { id=2721, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 02, Dragon Racing UI (Hidden)
		[2722] = { id=2722, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 03, Dragon Racing UI (Hidden)
		[2723] = { id=2723, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 04, Dragon Racing UI (Hidden)
		[2724] = { id=2724, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 05, Dragon Racing UI (Hidden)
		[2725] = { id=2725, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 06, Dragon Racing UI (Hidden)
		[2726] = { id=2726, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 07, Dragon Racing UI (Hidden)
		[2727] = { id=2727, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 08, Dragon Racing UI (Hidden)
		[2728] = { id=2728, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 09, Dragon Racing UI (Hidden)
		[2729] = { id=2729, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 10, Dragon Racing UI (Hidden)
		[2730] = { id=2730, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 11, Dragon Racing UI (Hidden)
		[2731] = { id=2731, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 12, Dragon Racing UI (Hidden)
		[2732] = { id=2732, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 13, Dragon Racing UI (Hidden)
		[2733] = { id=2733, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 14, Dragon Racing UI (Hidden)
		[2734] = { id=2734, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 15, Dragon Racing UI (Hidden)
		[2735] = { id=2735, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 16, Dragon Racing UI (Hidden)
		[2736] = { id=2736, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 17, Dragon Racing UI (Hidden)
		[2737] = { id=2737, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 18, Dragon Racing UI (Hidden)
		[2738] = { id=2738, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 01 Advanced, Dragon Racing UI (Hidden)
		[2739] = { id=2739, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 02 Advanced, Dragon Racing UI (Hidden)
		[2740] = { id=2740, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 03 Advanced, Dragon Racing UI (Hidden)
		[2741] = { id=2741, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 04 Advanced, Dragon Racing UI (Hidden)
		[2742] = { id=2742, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 05 Advanced, Dragon Racing UI (Hidden)
		[2743] = { id=2743, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 06 Advanced, Dragon Racing UI (Hidden)
		[2744] = { id=2744, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 07 Advanced, Dragon Racing UI (Hidden)
		[2745] = { id=2745, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 08 Advanced, Dragon Racing UI (Hidden)
		[2746] = { id=2746, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 09 Advanced, Dragon Racing UI (Hidden)
		[2747] = { id=2747, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 10 Advanced, Dragon Racing UI (Hidden)
		[2748] = { id=2748, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 11 Advanced, Dragon Racing UI (Hidden)
		[2749] = { id=2749, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 12 Advanced, Dragon Racing UI (Hidden)
		[2750] = { id=2750, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 13 Advanced, Dragon Racing UI (Hidden)
		[2751] = { id=2751, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 14 Advanced, Dragon Racing UI (Hidden)
		[2752] = { id=2752, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 15 Advanced, Dragon Racing UI (Hidden)
		[2753] = { id=2753, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 16 Advanced, Dragon Racing UI (Hidden)
		[2754] = { id=2754, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 17 Advanced, Dragon Racing UI (Hidden)
		[2755] = { id=2755, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 18 Advanced, Dragon Racing UI (Hidden)
		[2756] = { id=2756, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 01 Reverse, Dragon Racing UI (Hidden)
		[2757] = { id=2757, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 02 Reverse, Dragon Racing UI (Hidden)
		[2758] = { id=2758, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 03 Reverse, Dragon Racing UI (Hidden)
		[2759] = { id=2759, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 04 Reverse, Dragon Racing UI (Hidden)
		[2760] = { id=2760, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 05 Reverse, Dragon Racing UI (Hidden)
		[2761] = { id=2761, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 06 Reverse, Dragon Racing UI (Hidden)
		[2762] = { id=2762, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 07 Reverse, Dragon Racing UI (Hidden)
		[2763] = { id=2763, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 08 Reverse, Dragon Racing UI (Hidden)
		[2764] = { id=2764, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 09 Reverse, Dragon Racing UI (Hidden)
		[2765] = { id=2765, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 10 Reverse, Dragon Racing UI (Hidden)
		[2766] = { id=2766, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 11 Reverse, Dragon Racing UI (Hidden)
		[2767] = { id=2767, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 12 Reverse, Dragon Racing UI (Hidden)
		[2768] = { id=2768, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 13 Reverse, Dragon Racing UI (Hidden)
		[2769] = { id=2769, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 14 Reverse, Dragon Racing UI (Hidden)
		[2770] = { id=2770, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 15 Reverse, Dragon Racing UI (Hidden)
		[2771] = { id=2771, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 16 Reverse, Dragon Racing UI (Hidden)
		[2772] = { id=2772, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 17 Reverse, Dragon Racing UI (Hidden)
		[2773] = { id=2773, category=251, hide=true }, -- Dragon Racing - Personal Best Record - Northrend 18 Reverse, Dragon Racing UI (Hidden)
		[2774] = { id=2774, category=142, hide=true }, -- 10.2 Professions - Personal Tracker - S3 Spark Drops (Hidden), Hidden
		[2777] = { id=2777, category=250 }, -- Dream Infusion, Dragonflight
		[2778] = { id=2778, category=1 }, -- Bronze, Miscellaneous
		[2780] = { id=2780, category=142 }, -- Echoed Ephemera Tracker [DNT], Hidden
		[2784] = { id=2784, category=142, hide=true }, -- 10.2 Legendary - Progressive Advance - Tracker, Hidden
		[2785] = { id=2785, category=142 }, -- Khaz Algar Alchemy Knowledge, Hidden
		[2786] = { id=2786, category=142 }, -- Khaz Algar Blacksmithing Knowledge, Hidden
		[2787] = { id=2787, category=142 }, -- Khaz Algar Enchanting Knowledge, Hidden
		[2788] = { id=2788, category=142 }, -- Khaz Algar Engineering Knowledge, Hidden
		[2789] = { id=2789, category=142 }, -- Khaz Algar Herbalism Knowledge, Hidden
		[2790] = { id=2790, category=142 }, -- Khaz Algar Inscription Knowledge, Hidden
		[2791] = { id=2791, category=142 }, -- Khaz Algar Jewelcrafting Knowledge, Hidden
		[2792] = { id=2792, category=142 }, -- Khaz Algar Leatherworking Knowledge, Hidden
		[2793] = { id=2793, category=142 }, -- Khaz Algar Mining Knowledge, Hidden
		[2794] = { id=2794, category=142 }, -- Khaz Algar Skinning Knowledge, Hidden
		[2795] = { id=2795, category=142 }, -- Khaz Algar Tailoring Knowledge, Hidden
		[2796] = { id=2796, category=142 }, -- Renascent Dream, Hidden
		[2797] = { id=2797, category=2 }, -- Trophy of Strife, Player vs. Player
		[2799] = { id=2799, category=142 }, -- [DNT] Beetle Ranch Invisible Currency, Hidden
		[2800] = { id=2800, category=142, hide=true }, -- 10.2.6 Professions - Personal Tracker - S4 Spark Drops (Hidden), Hidden
		[2803] = { id=2803, category=281 }, -- Undercoin, Delves
		[2805] = { id=2805, category=142 }, -- Whelpling's Awakened Crest, Hidden
		[2806] = { id=2806, category=250 }, -- Whelpling's Awakened Crest, Dragonflight
		[2807] = { id=2807, category=250 }, -- Drake's Awakened Crest, Dragonflight
		[2808] = { id=2808, category=142 }, -- Drake's Awakened Crest, Hidden
		[2809] = { id=2809, category=250 }, -- Wyrm's Awakened Crest, Dragonflight
		[2810] = { id=2810, category=142 }, -- Wyrm's Awakened Crest, Hidden
		[2811] = { id=2811, category=142 }, -- Aspect's Awakened Crest, Hidden
		[2812] = { id=2812, category=250 }, -- Aspect's Awakened Crest, Dragonflight
		[2813] = { id=2813, category=142 }, -- Harmonized Silk, Hidden
		[2814] = { id=2814, category=142 }, -- Renown-Keg Leg's Crew, Hidden
		[2815] = { id=2815, category=260 }, -- Resonance Crystals, War Within
		[2819] = { id=2819, category=142 }, -- Azerothian Archives, Hidden
		[2822] = { id=2822, category=144 }, -- [DNT] Corgi Cache, Virtual
		[2839] = { id=2839, category=260, hide=true }, -- [DNT] Awakening Currency, War Within
		[2853] = { id=2853, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Primary, Hidden
		[2854] = { id=2854, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Stamina, Hidden
		[2855] = { id=2855, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Critical Strike, Hidden
		[2856] = { id=2856, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Haste, Hidden
		[2857] = { id=2857, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Leech, Hidden
		[2858] = { id=2858, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Mastery, Hidden
		[2859] = { id=2859, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Speed, Hidden
		[2860] = { id=2860, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Versatility, Hidden
		[2861] = { id=2861, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Aberration, Hidden
		[2862] = { id=2862, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Beast, Hidden
		[2863] = { id=2863, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Demon, Hidden
		[2864] = { id=2864, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Dragonkin, Hidden
		[2865] = { id=2865, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Elemental, Hidden
		[2866] = { id=2866, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Giant, Hidden
		[2867] = { id=2867, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Humanoid, Hidden
		[2868] = { id=2868, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Mechanical, Hidden
		[2869] = { id=2869, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Head - Undead, Hidden
		[2870] = { id=2870, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Waist - Physical, Hidden
		[2871] = { id=2871, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Waist - Arcane, Hidden
		[2872] = { id=2872, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Waist - Fire, Hidden
		[2873] = { id=2873, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Waist - Frost, Hidden
		[2874] = { id=2874, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Waist - Holy, Hidden
		[2875] = { id=2875, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Waist - Shadow, Hidden
		[2876] = { id=2876, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Waist - Nature, Hidden
		[2878] = { id=2878, category=142, hide=true }, -- 10.2 Professions - Personal Tracker - Legendary - Restored Leaf, Hidden
		[2897] = { id=2897, category=142 }, -- Council of Dornogal, Hidden
		[2898] = { id=2898, category=142 }, -- Renown - The Assembly of the Deeps, Hidden
		[2899] = { id=2899, category=142 }, -- Hallowfall Arathi, Hidden
		[2900] = { id=2900, category=142 }, -- Renown - Council of Dornogal, Hidden
		[2901] = { id=2901, category=142 }, -- Renown - Hallowfall Arathi, Hidden
		[2902] = { id=2902, category=142 }, -- The Assembly of the Deeps, Hidden
		[2903] = { id=2903, category=142 }, -- The Severed Threads, Hidden
		[2904] = { id=2904, category=142 }, -- Renown - The Severed Threads, Hidden
		[2906] = { id=2906, category=142 }, -- Plunder, Hidden
		[2907] = { id=2907, category=142, hide=true }, -- Pirate Booty Visual, Hidden
		[2908] = { id=2908, category=142 }, -- Dominance Offensive, Hidden
		[2909] = { id=2909, category=142 }, -- Operation: Shieldwall, Hidden
		[2910] = { id=2910, category=142 }, -- The Klaxxi, Hidden
		[2911] = { id=2911, category=142 }, -- Order of the Cloud Serpent, Hidden
		[2912] = { id=2912, category=142 }, -- Renascent Awakening, Hidden
		[2913] = { id=2913, category=142 }, -- Shado-Pan, Hidden
		[2914] = { id=2914, category=142 }, -- Weathered Harbinger Crest, Hidden
		[2915] = { id=2915, category=142 }, -- Carved Harbinger Crest, Hidden
		[2916] = { id=2916, category=142 }, -- Runed Harbinger Crest, Hidden
		[2917] = { id=2917, category=142 }, -- Gilded Harbinger Crest, Hidden
		[2918] = { id=2918, category=142 }, -- Weathered Harbinger Crest, Hidden
		[2919] = { id=2919, category=142 }, -- Carved Harbinger Crest, Hidden
		[2920] = { id=2920, category=142 }, -- Runed Harbinger Crest, Hidden
		[2921] = { id=2921, category=142 }, -- Gilded Harbinger Crest, Hidden
		[2922] = { id=2922, category=142 }, -- Plunder, Hidden
		[2923] = { id=2923, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R1 Easy, Dragon Racing UI (Hidden)
		[2924] = { id=2924, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R2 Easy, Dragon Racing UI (Hidden)
		[2925] = { id=2925, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R3 Easy, Dragon Racing UI (Hidden)
		[2926] = { id=2926, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R4 Easy, Dragon Racing UI (Hidden)
		[2927] = { id=2927, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R5 Easy, Dragon Racing UI (Hidden)
		[2928] = { id=2928, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R6 Easy, Dragon Racing UI (Hidden)
		[2929] = { id=2929, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R1 Advanced, Dragon Racing UI (Hidden)
		[2930] = { id=2930, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R2 Advanced, Dragon Racing UI (Hidden)
		[2931] = { id=2931, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R3 Advanced, Dragon Racing UI (Hidden)
		[2932] = { id=2932, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R4 Advanced, Dragon Racing UI (Hidden)
		[2933] = { id=2933, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R5 Advanced, Dragon Racing UI (Hidden)
		[2934] = { id=2934, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R6 Advanced, Dragon Racing UI (Hidden)
		[2935] = { id=2935, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R1 Reverse, Dragon Racing UI (Hidden)
		[2936] = { id=2936, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R2 Reverse, Dragon Racing UI (Hidden)
		[2937] = { id=2937, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R3 Reverse, Dragon Racing UI (Hidden)
		[2938] = { id=2938, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R4 Reverse, Dragon Racing UI (Hidden)
		[2939] = { id=2939, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R5 Reverse, Dragon Racing UI (Hidden)
		[2940] = { id=2940, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z1 R6 Reverse, Dragon Racing UI (Hidden)
		[2941] = { id=2941, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R1 Easy, Dragon Racing UI (Hidden)
		[2942] = { id=2942, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R2 Easy, Dragon Racing UI (Hidden)
		[2943] = { id=2943, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R3 Easy, Dragon Racing UI (Hidden)
		[2944] = { id=2944, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R4 Easy, Dragon Racing UI (Hidden)
		[2945] = { id=2945, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R5 Easy, Dragon Racing UI (Hidden)
		[2946] = { id=2946, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R6 Easy, Dragon Racing UI (Hidden)
		[2947] = { id=2947, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R1 Advanced, Dragon Racing UI (Hidden)
		[2948] = { id=2948, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R2 Advanced, Dragon Racing UI (Hidden)
		[2949] = { id=2949, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R3 Advanced, Dragon Racing UI (Hidden)
		[2950] = { id=2950, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R4 Advanced, Dragon Racing UI (Hidden)
		[2951] = { id=2951, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R5 Advanced, Dragon Racing UI (Hidden)
		[2952] = { id=2952, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R6 Advanced, Dragon Racing UI (Hidden)
		[2953] = { id=2953, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R1 Reverse, Dragon Racing UI (Hidden)
		[2954] = { id=2954, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R2 Reverse, Dragon Racing UI (Hidden)
		[2955] = { id=2955, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R3 Reverse, Dragon Racing UI (Hidden)
		[2956] = { id=2956, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R4 Reverse, Dragon Racing UI (Hidden)
		[2957] = { id=2957, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R5 Reverse, Dragon Racing UI (Hidden)
		[2958] = { id=2958, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z2 R6 Reverse, Dragon Racing UI (Hidden)
		[2959] = { id=2959, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R1 Easy, Dragon Racing UI (Hidden)
		[2960] = { id=2960, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R2 Easy, Dragon Racing UI (Hidden)
		[2961] = { id=2961, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R3 Easy, Dragon Racing UI (Hidden)
		[2962] = { id=2962, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R4 Easy, Dragon Racing UI (Hidden)
		[2963] = { id=2963, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R5 Easy, Dragon Racing UI (Hidden)
		[2964] = { id=2964, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R6 Easy, Dragon Racing UI (Hidden)
		[2965] = { id=2965, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R1 Advanced, Dragon Racing UI (Hidden)
		[2966] = { id=2966, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R2 Advanced, Dragon Racing UI (Hidden)
		[2967] = { id=2967, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R3 Advanced, Dragon Racing UI (Hidden)
		[2968] = { id=2968, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R4 Advanced, Dragon Racing UI (Hidden)
		[2969] = { id=2969, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R5 Advanced, Dragon Racing UI (Hidden)
		[2970] = { id=2970, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R6 Advanced, Dragon Racing UI (Hidden)
		[2971] = { id=2971, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R1 Reverse, Dragon Racing UI (Hidden)
		[2972] = { id=2972, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R2 Reverse, Dragon Racing UI (Hidden)
		[2973] = { id=2973, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R3 Reverse, Dragon Racing UI (Hidden)
		[2974] = { id=2974, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R4 Reverse, Dragon Racing UI (Hidden)
		[2975] = { id=2975, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R5 Reverse, Dragon Racing UI (Hidden)
		[2976] = { id=2976, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z3 R6 Reverse, Dragon Racing UI (Hidden)
		[2977] = { id=2977, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R1 Easy, Dragon Racing UI (Hidden)
		[2978] = { id=2978, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R2 Easy, Dragon Racing UI (Hidden)
		[2979] = { id=2979, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R3 Easy, Dragon Racing UI (Hidden)
		[2980] = { id=2980, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R4 Easy, Dragon Racing UI (Hidden)
		[2981] = { id=2981, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R5 Easy, Dragon Racing UI (Hidden)
		[2982] = { id=2982, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R6 Easy, Dragon Racing UI (Hidden)
		[2983] = { id=2983, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R1 Advanced, Dragon Racing UI (Hidden)
		[2984] = { id=2984, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R2 Advanced, Dragon Racing UI (Hidden)
		[2985] = { id=2985, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R3 Advanced, Dragon Racing UI (Hidden)
		[2986] = { id=2986, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R4 Advanced, Dragon Racing UI (Hidden)
		[2987] = { id=2987, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R5 Advanced, Dragon Racing UI (Hidden)
		[2988] = { id=2988, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R6 Advanced, Dragon Racing UI (Hidden)
		[2989] = { id=2989, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R1 Reverse, Dragon Racing UI (Hidden)
		[2990] = { id=2990, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R2 Reverse, Dragon Racing UI (Hidden)
		[2991] = { id=2991, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R3 Reverse, Dragon Racing UI (Hidden)
		[2992] = { id=2992, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R4 Reverse, Dragon Racing UI (Hidden)
		[2993] = { id=2993, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R5 Reverse, Dragon Racing UI (Hidden)
		[2994] = { id=2994, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z5 R6 Reverse, Dragon Racing UI (Hidden)
		[3000] = { id=3000, category=142 }, -- 10.2.7 Timewalking Season - Random Gem Counter, Hidden
		[3001] = { id=3001, category=142 }, -- 10.2.7 Timewalking Season - Artifact - Cloak - Experience Gain, Hidden
		[3002] = { id=3002, category=142 }, -- The Weaver (Notoriety), Hidden
		[3003] = { id=3003, category=142 }, -- The General (Notoriety), Hidden
		[3004] = { id=3004, category=142 }, -- The Vizier (Notoriety), Hidden
		[3005] = { id=3005, category=142 }, -- The General (Notoriety), Hidden
		[3006] = { id=3006, category=142 }, -- The Vizier (Notoriety), Hidden
		[3007] = { id=3007, category=142 }, -- The Weaver (Notoriety), Hidden
		[3008] = { id=3008, category=142 }, -- Valorstones, Hidden
		[3009] = { id=3009, category=142 }, -- Bonus Valorstones, Hidden
		[3010] = { id=3010, category=142, hide=true }, -- 10.2.6 Rewards - Personal Tracker - S4 Dinar Drops (Hidden), Hidden
		[3011] = { id=3011, category=142 }, -- Plunder, Hidden
		[3013] = { id=3013, category=142, hide=true }, -- Jewelcrafting Concentration, Hidden
		[3022] = { id=3022, category=142 }, -- Renown - Season 1 Delves, Hidden
		[3023] = { id=3023, category=142, hide=true }, -- 11.0 Professions - Personal Tracker - S1 Spark Drops (Hidden), Hidden
		[3024] = { id=3024, category=142, hide=true }, -- Cosmetic, Hidden
		[3025] = { id=3025, category=142, hide=true }, -- Cosmetic, Hidden
		[3026] = { id=3026, category=142, hide=true }, -- Cosmetic, Hidden
		[3027] = { id=3027, category=142, hide=true }, -- Cosmetic, Hidden
		[3028] = { id=3028, category=281 }, -- Restored Coffer Key, Delves
		[3040] = { id=3040, category=142, hide=true }, -- Blacksmithing Concentration, Hidden
		[3041] = { id=3041, category=142, hide=true }, -- Tailoring Concentration, Hidden
		[3042] = { id=3042, category=142, hide=true }, -- Leatherworking Concentration, Hidden
		[3043] = { id=3043, category=142, hide=true }, -- Inscription Concentration, Hidden
		[3044] = { id=3044, category=142, hide=true }, -- Engineering Concentration, Hidden
		[3045] = { id=3045, category=142, hide=true }, -- Alchemy Concentration, Hidden
		[3046] = { id=3046, category=142, hide=true }, -- Enchanting Concentration, Hidden
		[3047] = { id=3047, category=142, hide=true }, -- Jewelcrafting Concentration, Hidden
		[3048] = { id=3048, category=142, hide=true }, -- Tailoring Concentration, Hidden
		[3049] = { id=3049, category=142, hide=true }, -- Leatherworking Concentration, Hidden
		[3050] = { id=3050, category=142, hide=true }, -- Blacksmithing Concentration, Hidden
		[3051] = { id=3051, category=142, hide=true }, -- Enchanting Concentration, Hidden
		[3052] = { id=3052, category=142, hide=true }, -- Engineering Concentration, Hidden
		[3053] = { id=3053, category=142, hide=true }, -- Inscription Concentration, Hidden
		[3054] = { id=3054, category=142, hide=true }, -- Alchemy Concentration, Hidden
		[3055] = { id=3055, category=260 }, -- Mereldar Derby Mark, War Within
		[3056] = { id=3056, category=260 }, -- Kej, War Within
		[3057] = { id=3057, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Alchemy Knowledge, Hidden
		[3058] = { id=3058, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Blacksmithing Knowledge, Hidden
		[3059] = { id=3059, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Enchanting Knowledge, Hidden
		[3060] = { id=3060, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Engineering Knowledge, Hidden
		[3061] = { id=3061, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Herbalism Knowledge, Hidden
		[3062] = { id=3062, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Inscription Knowledge, Hidden
		[3063] = { id=3063, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Jewelcrafting Knowledge, Hidden
		[3064] = { id=3064, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Leatherworking Knowledge, Hidden
		[3065] = { id=3065, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Mining Knowledge, Hidden
		[3066] = { id=3066, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Skinning Knowledge, Hidden
		[3067] = { id=3067, category=142, hide=true }, -- 11.0 Professions - Tracker - Weekly Tailoring Knowledge, Hidden
		[3068] = { id=3068, category=142 }, -- Delver's Journey, Hidden
		[3069] = { id=3069, category=142 }, -- 11.0 Professions - Tailoring - Fishing - Khaz Algar - Skill, Hidden
		[3070] = { id=3070, category=142 }, -- 11.0 Professions - Fishing - Algari Weaverthread - Perception, Hidden
		[3071] = { id=3071, category=142 }, -- 11.0 Professions - Fishing - Algari Weaverthread - Skill, Hidden
		[3072] = { id=3072, category=142 }, -- Everburning Ignition Refund, Hidden
		[3073] = { id=3073, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Tailoring Knowledge, Hidden
		[3074] = { id=3074, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Skinning Knowledge, Hidden
		[3075] = { id=3075, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Mining Knowledge, Hidden
		[3076] = { id=3076, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Leatherworking Know., Hidden
		[3077] = { id=3077, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Jewelcrafting Knowledge, Hidden
		[3078] = { id=3078, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Inscription Knowledge, Hidden
		[3079] = { id=3079, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Herbalism Knowledge, Hidden
		[3080] = { id=3080, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Engineering Knowledge, Hidden
		[3081] = { id=3081, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Enchanting Knowledge, Hidden
		[3082] = { id=3082, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Blacksmithing Knowledge, Hidden
		[3083] = { id=3083, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Alchemy Knowledge, Hidden
		[3084] = { id=3084, category=142, hide=true }, -- 11.0 Professions - Tracker - Insc Book - Inscription Knowledge, Hidden
		[3085] = { id=3085, category=142, hide=true }, -- 11.0 Delves - Personal Tracker - S1 Weekly Elise Turn-In(Hidden), Hidden
		[3086] = { id=3086, category=142, hide=true }, -- DPS, Hidden
		[3087] = { id=3087, category=142, hide=true }, -- Tank, Hidden
		[3088] = { id=3088, category=142, hide=true }, -- Healer, Hidden
		[3089] = { id=3089, category=260 }, -- Residual Memories, War Within
		[3090] = { id=3090, category=260 }, -- Flame-Blessed Iron, War Within
		[3093] = { id=3093, category=260 }, -- Nerub-ar Finery, War Within
		[3094] = { id=3094, category=142, hide=true }, -- 11.0 Raid - Nerubian - Account Quest Complete Tracker (Hidden), Hidden
		[3099] = { id=3099, category=142, hide=true }, -- 11.0 Raid - Nerubian - Nerubar Finery Tracking Currency (Hidden), Hidden
		[3100] = { id=3100, category=1 }, -- Bronze Celebration Token, Miscellaneous
		[3102] = { id=3102, category=142 }, -- Bronze Celebration Token, Hidden
		[3103] = { id=3103, category=142, hide=true }, -- 11.0 Delves - System - Seasonal Affix - Events Active, Hidden
		[3104] = { id=3104, category=142, hide=true }, -- 11.0 Delves - System - Seasonal Affix - Events Maximum, Hidden
		[3107] = { id=3107, category=142 }, -- Weathered Undermine Crest, Hidden
		[3108] = { id=3108, category=142 }, -- Carved Undermine Crest, Hidden
		[3109] = { id=3109, category=142 }, -- Runed Undermine Crest, Hidden
		[3110] = { id=3110, category=142 }, -- Gilded Undermine Crest, Hidden
		[3111] = { id=3111, category=142 }, -- Weathered Undermine Crest, Hidden
		[3112] = { id=3112, category=142 }, -- Carved Undermine Crest, Hidden
		[3113] = { id=3113, category=142 }, -- Runed Undermine Crest, Hidden
		[3114] = { id=3114, category=142 }, -- Gilded Undermine Crest, Hidden
		[3115] = { id=3115, category=142 }, -- [DNT] Worldsoul Memory Score, Hidden
		[3116] = { id=3116, category=142 }, -- Essence of Kaja'mite, Hidden
		[3118] = { id=3118, category=142 }, -- The Cartels of Undermine, Hidden
		[3119] = { id=3119, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R1 Easy, Dragon Racing UI (Hidden)
		[3120] = { id=3120, category=142 }, -- The Cartels of Undermine, Hidden
		[3121] = { id=3121, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R1 Reverse, Dragon Racing UI (Hidden)
		[3122] = { id=3122, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R2 Easy, Dragon Racing UI (Hidden)
		[3123] = { id=3123, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R2 Reverse, Dragon Racing UI (Hidden)
		[3124] = { id=3124, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R3 Easy, Dragon Racing UI (Hidden)
		[3125] = { id=3125, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R3 Reverse, Dragon Racing UI (Hidden)
		[3126] = { id=3126, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R4 Easy, Dragon Racing UI (Hidden)
		[3127] = { id=3127, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R4 Reverse, Dragon Racing UI (Hidden)
		[3128] = { id=3128, category=142 }, -- Renown - The K'aresh Trust, Hidden
		[3129] = { id=3129, category=142 }, -- The K'aresh Trust, Hidden
		[3130] = { id=3130, category=142 }, -- Renown - Season 2 Delves, Hidden
		[3131] = { id=3131, category=142 }, -- Delver's Journey, Hidden
		[3132] = { id=3132, category=142, hide=true }, -- 11.1 Professions - Personal Tracker - S2 Spark Drops (Hidden), Hidden
		[3135] = { id=3135, category=142, hide=true }, -- 11.1 Delves - Personal Tracker - S2 Weekly Elise Turn-In(Hidden), Hidden
		[3136] = { id=3136, category=142 }, -- Gallagio Loyalty Rewards Club, Hidden
		[3137] = { id=3137, category=142 }, -- Renown - Gallagio Loyalty Rewards Club, Hidden
		[3139] = { id=3139, category=142, hide=true }, -- Plunder, Hidden
		[3140] = { id=3140, category=142 }, -- 11.1.5 Arathi - Renown Rank, Hidden
		[3141] = { id=3141, category=142 }, -- Starlight Spark Dust, Hidden
		[3142] = { id=3142, category=142 }, -- EVERGREEN Delves - Tracker - EoD Account Rewards - Weekly Cap, Hidden
		[3143] = { id=3143, category=142, hide=true }, -- 11.0 Delves - Bountiful Tracker - Delver's Journey Cap, Hidden
		[3144] = { id=3144, category=142, hide=true }, -- 11.0.5 20th Anniversary - Tracker, Hidden
		[3145] = { id=3145, category=142, hide=true }, -- 11.0.5 20th Anniversary - Tracker, Hidden
		[3146] = { id=3146, category=142, hide=true }, -- 11.0.5 20th Anniversary - Tracker, Hidden
		[3147] = { id=3147, category=142, hide=true }, -- 11.0 Delves - Vendor - Bountiful Key Tracker - Cap, Hidden
		[3149] = { id=3149, category=260 }, -- Displaced Corrupted Mementos, War Within
		[3150] = { id=3150, category=142 }, -- Midnight Alchemy Knowledge, Hidden
		[3151] = { id=3151, category=142 }, -- Midnight Blacksmithing Knowledge, Hidden
		[3152] = { id=3152, category=142 }, -- Midnight Enchanting Knowledge, Hidden
		[3153] = { id=3153, category=142 }, -- Midnight Engineering Knowledge, Hidden
		[3154] = { id=3154, category=142 }, -- Midnight Herbalism Knowledge, Hidden
		[3155] = { id=3155, category=142 }, -- Midnight Inscription Knowledge, Hidden
		[3156] = { id=3156, category=142 }, -- Midnight Jewelcrafting Knowledge, Hidden
		[3157] = { id=3157, category=142 }, -- Midnight Leatherworking Knowledge, Hidden
		[3158] = { id=3158, category=142 }, -- Midnight Mining Knowledge, Hidden
		[3159] = { id=3159, category=142 }, -- Midnight Skinning Knowledge, Hidden
		[3160] = { id=3160, category=142 }, -- Midnight Tailoring Knowledge, Hidden
		[3161] = { id=3161, category=142, hide=true }, -- Alchemy Concentration, Hidden
		[3162] = { id=3162, category=142, hide=true }, -- Blacksmithing Concentration, Hidden
		[3163] = { id=3163, category=142, hide=true }, -- Enchanting Concentration, Hidden
		[3164] = { id=3164, category=142, hide=true }, -- Engineering Concentration, Hidden
		[3165] = { id=3165, category=142, hide=true }, -- Inscription Concentration, Hidden
		[3166] = { id=3166, category=142, hide=true }, -- Jewelcrafting Concentration, Hidden
		[3167] = { id=3167, category=142, hide=true }, -- Leatherworking Concentration, Hidden
		[3168] = { id=3168, category=142, hide=true }, -- Tailoring Concentration, Hidden
		[3169] = { id=3169, category=142 }, -- The Bilgewater Cartel, Hidden
		[3170] = { id=3170, category=142 }, -- The Bilgewater Cartel, Hidden
		[3171] = { id=3171, category=142 }, -- The Blackwater Cartel, Hidden
		[3172] = { id=3172, category=142 }, -- The Blackwater Cartel, Hidden
		[3173] = { id=3173, category=142 }, -- The Steamwheedle Cartel, Hidden
		[3174] = { id=3174, category=142 }, -- The Steamwheedle Cartel, Hidden
		[3175] = { id=3175, category=142 }, -- The Venture Company, Hidden
		[3176] = { id=3176, category=142 }, -- Venture Company, Hidden
		[3177] = { id=3177, category=142 }, -- Darkfuse Solutions, Hidden
		[3178] = { id=3178, category=142 }, -- Darkfuse Solutions, Hidden
		[3180] = { id=3180, category=144 }, -- Weekly Limit Test Currency, Virtual
		[3181] = { id=3181, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R5 Easy, Dragon Racing UI (Hidden)
		[3182] = { id=3182, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R5 Reverse, Dragon Racing UI (Hidden)
		[3183] = { id=3183, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R6 Easy, Dragon Racing UI (Hidden)
		[3184] = { id=3184, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R6 Reverse, Dragon Racing UI (Hidden)
		[3185] = { id=3185, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R7 Easy, Dragon Racing UI (Hidden)
		[3186] = { id=3186, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R7 Reverse, Dragon Racing UI (Hidden)
		[3187] = { id=3187, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R8 Easy, Dragon Racing UI (Hidden)
		[3188] = { id=3188, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 11 Z6 R8 Reverse, Dragon Racing UI (Hidden)
		[3189] = { id=3189, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Alchemy Knowledge, Hidden
		[3190] = { id=3190, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Tailoring Knowledge, Hidden
		[3191] = { id=3191, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Skinning Knowledge, Hidden
		[3192] = { id=3192, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Mining Knowledge, Hidden
		[3193] = { id=3193, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Leatherworking Knowledge, Hidden
		[3194] = { id=3194, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Jewelcrafting Knowledge, Hidden
		[3195] = { id=3195, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Inscription Knowledge, Hidden
		[3196] = { id=3196, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Herbalism Knowledge, Hidden
		[3197] = { id=3197, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Engineering Knowledge, Hidden
		[3198] = { id=3198, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Enchanting Knowledge, Hidden
		[3199] = { id=3199, category=142, hide=true }, -- 12.x Professions - Tracker - Weekly Blacksmithing Knowledge, Hidden
		[3200] = { id=3200, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Tailoring Knowledge, Hidden
		[3201] = { id=3201, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Skinning Knowledge, Hidden
		[3202] = { id=3202, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Mining Knowledge, Hidden
		[3203] = { id=3203, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Leatherworking Know., Hidden
		[3204] = { id=3204, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Jewelcrafting Knowledge, Hidden
		[3205] = { id=3205, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Inscription Knowledge, Hidden
		[3206] = { id=3206, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Inscription Knowledge, Hidden
		[3207] = { id=3207, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Herbalism Knowledge, Hidden
		[3208] = { id=3208, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Engineering Knowledge, Hidden
		[3209] = { id=3209, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Enchanting Knowledge, Hidden
		[3210] = { id=3210, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Blacksmithing Knowledge, Hidden
		[3211] = { id=3211, category=142, hide=true }, -- 12.x Professions - Tracker - Insc Book - Alchemy Knowledge, Hidden
		[3212] = { id=3212, category=142 }, -- Radiant Spark Dust, Hidden
		[3213] = { id=3213, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 112 Hope's R1 Easy, Dragon Racing UI (Hidden)
		[3214] = { id=3214, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 112 Hope's R1 Advanced, Dragon Racing UI (Hidden)
		[3215] = { id=3215, category=251, hide=true }, -- Dragon Racing - Personal Best Record - 112 Hope's R1 Reverse, Dragon Racing UI (Hidden)
		[3216] = { id=3216, category=260 }, -- Bounty's Remnants, War Within
		[3218] = { id=3218, category=260 }, -- Empty Kaja'Cola Can, War Within
		[3220] = { id=3220, category=260 }, -- Vintage Kaja'Cola Can, War Within
		[3221] = { id=3221, category=142 }, -- Goblin Cartels Reputation, Hidden
		[3223] = { id=3223, category=260 }, -- Titan Disc, War Within
		[3224] = { id=3224, category=142, hide=true }, -- [DNT] NAK Test Currency, Hidden
		[3225] = { id=3225, category=142, hide=true }, -- Blacksmithing Specialization Reset, Hidden
		[3226] = { id=3226, category=260 }, -- Market Research, War Within
		[3227] = { id=3227, category=142, hide=true }, -- Alchemy Specialization Reset, Hidden
		[3228] = { id=3228, category=142, hide=true }, -- Enchanting Specialization Reset, Hidden
		[3229] = { id=3229, category=142, hide=true }, -- Engineering Specialization Reset, Hidden
		[3230] = { id=3230, category=142, hide=true }, -- Herbalism Specialization Reset, Hidden
		[3231] = { id=3231, category=142, hide=true }, -- Inscription Specialization Reset, Hidden
		[3232] = { id=3232, category=142, hide=true }, -- Jewelcrafting Specialization Reset, Hidden
		[3233] = { id=3233, category=142, hide=true }, -- Leatherworking Specialization Reset, Hidden
		[3234] = { id=3234, category=142, hide=true }, -- Mining Specialization Reset, Hidden
		[3235] = { id=3235, category=142, hide=true }, -- Skinning Specialization Reset, Hidden
		[3236] = { id=3236, category=142, hide=true }, -- Tailoring Specialization Reset, Hidden
		[3238] = { id=3238, category=142, hide=true }, -- Alchemy Specialization Reset, Hidden
		[3239] = { id=3239, category=142, hide=true }, -- Enchanting Specialization Reset, Hidden
		[3240] = { id=3240, category=142, hide=true }, -- Engineering Specialization Reset, Hidden
		[3241] = { id=3241, category=142, hide=true }, -- Herbalism Specialization Reset, Hidden
		[3242] = { id=3242, category=142, hide=true }, -- Inscription Specialization Reset, Hidden
		[3243] = { id=3243, category=142, hide=true }, -- Jewelcrafting Specialization Reset, Hidden
		[3244] = { id=3244, category=142, hide=true }, -- Leatherworking Specialization Reset, Hidden
		[3245] = { id=3245, category=142, hide=true }, -- Mining Specialization Reset, Hidden
		[3246] = { id=3246, category=142, hide=true }, -- Skinning Specialization Reset, Hidden
		[3247] = { id=3247, category=142, hide=true }, -- Tailoring Specialization Reset, Hidden
		[3248] = { id=3248, category=142, hide=true }, -- Blacksmithing Specialization Reset, Hidden
		[3250] = { id=3250, category=142 }, -- Faceted Crystalline Fel, Hidden
		[3251] = { id=3251, category=266 }, -- Felforged Bronze, Timerunning
		[3253] = { id=3253, category=142 }, -- EVERGREEN Delves - Tracker - Mislaid Curiosity - Weekly Cap, Hidden
		[3254] = { id=3254, category=142, hide=true }, -- Chase's Test Currency [DNT], Hidden
		[3256] = { id=3256, category=280 }, -- Artisan Alchemist's Moxie, Professions
		[3257] = { id=3257, category=280 }, -- Artisan Blacksmith's Moxie, Professions
		[3258] = { id=3258, category=280 }, -- Artisan Enchanter's Moxie, Professions
		[3259] = { id=3259, category=280 }, -- Artisan Engineer's Moxie, Professions
		[3260] = { id=3260, category=280 }, -- Artisan Herbalist's Moxie, Professions
		[3261] = { id=3261, category=280 }, -- Artisan Scribe's Moxie, Professions
		[3262] = { id=3262, category=280 }, -- Artisan Jewelcrafter's Moxie, Professions
		[3263] = { id=3263, category=280 }, -- Artisan Leatherworker's Moxie, Professions
		[3264] = { id=3264, category=280 }, -- Artisan Miner's Moxie, Professions
		[3265] = { id=3265, category=280 }, -- Artisan Skinner's Moxie, Professions
		[3266] = { id=3266, category=280 }, -- Artisan Tailor's Moxie, Professions
		[3267] = { id=3267, category=142 }, -- Felforged Bronze, Hidden
		[3269] = { id=3269, category=142 }, -- Ethereal Voidsplinter, Hidden
		[3270] = { id=3270, category=142, hide=true }, -- 11.2 Delves - Personal Tracker - S3 Weekly Elise Turn-In(Hidden), Hidden
		[3271] = { id=3271, category=142 }, -- Renown - Season 3 Delves, Hidden
		[3272] = { id=3272, category=142 }, -- Delver's Journey, Hidden
		[3278] = { id=3278, category=142 }, -- Ethereal Strands, Hidden
		[3279] = { id=3279, category=142, hide=true }, -- 11. Raid Renown - Gallagio - Raid Buff Acct Tracker, Hidden
		[3280] = { id=3280, category=142, hide=true }, -- 11. Raid Renown - Gallagio - Speed Buff Acct Tracker, Hidden
		[3282] = { id=3282, category=142 }, -- Gallagio Loyalty Rewards Club, Hidden
		[3283] = { id=3283, category=142 }, -- Flame's Radiance, Hidden
		[3284] = { id=3284, category=142 }, -- Weathered Ethereal Crest, Hidden
		[3285] = { id=3285, category=142 }, -- Weathered Ethereal Crest, Hidden
		[3286] = { id=3286, category=142 }, -- Carved Ethereal Crest, Hidden
		[3287] = { id=3287, category=142 }, -- Carved Ethereal Crest, Hidden
		[3288] = { id=3288, category=142 }, -- Runed Ethereal Crest, Hidden
		[3289] = { id=3289, category=142 }, -- Runed Ethereal Crest, Hidden
		[3290] = { id=3290, category=142 }, -- Gilded Ethereal Crest, Hidden
		[3291] = { id=3291, category=142 }, -- Gilded Ethereal Crest, Hidden
		[3293] = { id=3293, category=266 }, -- Epoch Memento, Timerunning
		[3303] = { id=3303, category=260 }, -- Untethered Coin, War Within
		[3304] = { id=3304, category=142 }, -- Manaforge Vandals, Hidden
		[3305] = { id=3305, category=142 }, -- Renown - Manaforge Vandals, Hidden
		[3306] = { id=3306, category=142 }, -- Manaforge Vandals, Hidden
		[3307] = { id=3307, category=142, hide=true }, -- 11.2 Raid Renown - Manaforge - Raid Buff Acct Tracker, Hidden
		[3308] = { id=3308, category=142, hide=true }, -- 11.2 Raid Renown - Manaforge Speed Buff Acct Tracker, Hidden
		[3309] = { id=3309, category=1 }, -- Hellstone Shard, Miscellaneous
		[3310] = { id=3310, category=281 }, -- Coffer Key Shards, Delves
		[3313] = { id=3313, category=142, hide=true }, -- 11. Raid Renown - Gallagio - Raid Buff Acct Tracker, Hidden
		[3314] = { id=3314, category=142, hide=true }, -- 11. Raid Renown - Gallagio - Speed Buff Acct Tracker, Hidden
		[3315] = { id=3315, category=142 }, -- Renown - Gallagio Loyalty Rewards Club, Hidden
		[3316] = { id=3316, category=264 }, -- Voidlight Marl, Midnight
		[3317] = { id=3317, category=142 }, -- Renown - Season 1 Delves, Hidden
		[3318] = { id=3318, category=142 }, -- Delver's Journey, Hidden
		[3319] = { id=3319, category=284 }, -- Twilight's Blade Insignia, Features
		[3341] = { id=3341, category=142 }, -- Veteran Dawncrest, Hidden
		[3342] = { id=3342, category=142 }, -- Veteran Dawncrest, Hidden
		[3343] = { id=3343, category=142 }, -- Champion Dawncrest, Hidden
		[3344] = { id=3344, category=142 }, -- Champion Dawncrest, Hidden
		[3345] = { id=3345, category=142 }, -- Hero Dawncrest, Hidden
		[3346] = { id=3346, category=142 }, -- Hero Dawncrest, Hidden
		[3347] = { id=3347, category=142 }, -- Myth Dawncrest, Hidden
		[3348] = { id=3348, category=142 }, -- Myth Dawncrest, Hidden
		[3349] = { id=3349, category=264 }, -- [DNT] [PH] Evergreen Initiative Currency, Midnight
		[3351] = { id=3351, category=21, hide=true }, -- Social Meter, Wrath of the Lich King
		[3352] = { id=3352, category=264, hide=true }, -- Party Favor, Midnight
		[3354] = { id=3354, category=142 }, -- The Amani Tribe, Hidden
		[3355] = { id=3355, category=142 }, -- Renown - The Amani Tribe, Hidden
		[3356] = { id=3356, category=281 }, -- Untainted Mana-Crystals, Delves
		[3360] = { id=3360, category=142, hide=true }, -- [DNT] 11.1.5 Midseason - Turbo-Boost Quest Turn-In Tracker, Hidden
		[3363] = { id=3363, category=1 }, -- Community Coupons, Miscellaneous
		[3364] = { id=3364, category=142, hide=true }, -- [DNT] 11.2.5 Midseason - Turbo-Boost Quest Turn-In Tracker, Hidden
		[3365] = { id=3365, category=142 }, -- Silvermoon Court, Hidden
		[3369] = { id=3369, category=142 }, -- Renown - The Hara'ti, Hidden
		[3370] = { id=3370, category=142 }, -- The Hara'ti, Hidden
		[3371] = { id=3371, category=142 }, -- Renown - Silvermoon Court, Hidden
		[3372] = { id=3372, category=142 }, -- Bronze, Hidden
		[3373] = { id=3373, category=283 }, -- Angler Pearls, Zones
		[3375] = { id=3375, category=142 }, -- [DNT] Moth Hunt Tracking Currency, Hidden
		[3376] = { id=3376, category=283 }, -- Shard of Dundun, Zones
		[3377] = { id=3377, category=283 }, -- Unalloyed Abundance, Zones
		[3378] = { id=3378, category=142 }, -- Dawnlight Manaflux, Hidden
		[3379] = { id=3379, category=283 }, -- Brimming Arcana, Zones
		[3383] = { id=3383, category=142 }, -- Adventurer Dawncrest, Hidden
		[3385] = { id=3385, category=142 }, -- Luminous Dust, Hidden
		[3386] = { id=3386, category=142 }, -- Renown - Prey, Hidden
		[3387] = { id=3387, category=142 }, -- Preyseeker's Journey, Hidden
		[3388] = { id=3388, category=142 }, -- Renown - The Singularity, Hidden
		[3389] = { id=3389, category=142 }, -- The Singularity, Hidden
		[3390] = { id=3390, category=142 }, -- Farstriders, Hidden
		[3391] = { id=3391, category=142 }, -- Adventurer Dawncrest, Hidden
		[3392] = { id=3392, category=284 }, -- Remnant of Anguish, Features
		[3393] = { id=3393, category=284 }, -- Illusionary Coin, Features
		[3396] = { id=3396, category=142 }, -- Shades of the Row, Hidden
		[3397] = { id=3397, category=142 }, -- Magisters, Hidden
		[3398] = { id=3398, category=142 }, -- Blood Knights, Hidden
		[3400] = { id=3400, category=283 }, -- Uncontaminated Void Sample, Zones
		[3401] = { id=3401, category=142, hide=true }, -- 12.0 Delves - Personal Tracker - S1 Weekly Turn-In (Hidden), Hidden
		[3405] = { id=3405, category=284 }, -- Field Accolade, Features
		[3409] = { id=3409, category=142, hide=true }, -- [DNT] 12.0 Midseason - Voidforge Unlock - Turn-In Tracker, Hidden
		[3410] = { id=3410, category=142 }, -- Slayer's Duellum, Hidden
		[3418] = { id=3418, category=264 }, -- Nebulous Voidcore, Midnight
		[3419] = { id=3419, category=142, hide=true }, -- [DNT] 12.0.5 Midseason - Voidforge Upgrade - Turn-In Tracker, Hidden
		[3420] = { id=3420, category=142, hide=true }, -- [DNT] Nebulous Voidcore Turn-In Tracker, Hidden
		[3428] = { id=3428, category=142 }, -- Renown - Ritual Sites, Hidden
		[3429] = { id=3429, category=142 }, -- Ritual Site Knowledge, Hidden
		[3431] = { id=3431, category=251, hide=true }, -- Housing - Going Postal - Personal Best Record - Alliance - Rt1, Dragon Racing UI (Hidden)
		[3432] = { id=3432, category=251, hide=true }, -- Housing - Going Postal - Personal Best Record - Alliance - Rt2, Dragon Racing UI (Hidden)
		[3433] = { id=3433, category=251, hide=true }, -- Housing - Going Postal - Personal Best Record - Alliance - Rt3, Dragon Racing UI (Hidden)
		[3434] = { id=3434, category=251, hide=true }, -- Housing - Going Postal - Personal Best Record - Horde - Rt1, Dragon Racing UI (Hidden)
		[3435] = { id=3435, category=251, hide=true }, -- Housing - Going Postal - Personal Best Record - Horde - Rt2, Dragon Racing UI (Hidden)
		[3436] = { id=3436, category=251, hide=true }, -- Housing - Going Postal - Personal Best Record - Horde - Rt3, Dragon Racing UI (Hidden)
		[3437] = { id=3437, category=142 }, -- Adventurer Mistcrest, Hidden
		[3438] = { id=3438, category=142 }, -- Veteran Mistcrest, Hidden
		[3439] = { id=3439, category=142 }, -- Champion Mistcrest, Hidden
		[3440] = { id=3440, category=142 }, -- Hero Mistcrest, Hidden
		[3441] = { id=3441, category=142 }, -- Myth Mistcrest, Hidden
		[3442] = { id=3442, category=282 }, -- Adventurer Mistcrest, Crests
		[3443] = { id=3443, category=282 }, -- Veteran Mistcrest, Crests
		[3444] = { id=3444, category=282 }, -- Champion Mistcrest, Crests
		[3445] = { id=3445, category=282 }, -- Hero Mistcrest, Crests
		[3446] = { id=3446, category=282 }, -- Myth Mistcrest, Crests
		[3448] = { id=3448, category=283 }, -- Corrosive Coin, Zones
		[3449] = { id=3449, category=278, hide=true }, -- Total Score, Sites Score UI (Hidden)
		[3450] = { id=3450, category=278, hide=true }, -- Sites Tier, Sites Score UI (Hidden)
		[3451] = { id=3451, category=278, hide=true }, -- Sites Treasure, Sites Score UI (Hidden)
		[3452] = { id=3452, category=278, hide=true }, -- Total Multiplier, Sites Score UI (Hidden)
		[3453] = { id=3453, category=278, hide=true }, -- Tier Multiplier, Sites Score UI (Hidden)
		[3454] = { id=3454, category=278, hide=true }, -- Challenge - Tendrils, Sites Score UI (Hidden)
		[3455] = { id=3455, category=278, hide=true }, -- Challenge - Manifestations, Sites Score UI (Hidden)
		[3456] = { id=3456, category=278, hide=true }, -- Challenge - Magical Alarm Bells, Sites Score UI (Hidden)
		[3457] = { id=3457, category=278, hide=true }, -- Challenge - Shrines Portals Obelisks, Sites Score UI (Hidden)
		[3458] = { id=3458, category=278, hide=true }, -- Challenge - Tainted Corpses, Sites Score UI (Hidden)
		[3459] = { id=3459, category=278, hide=true }, -- Challenge - Reinforced, Sites Score UI (Hidden)
		[3460] = { id=3460, category=278, hide=true }, -- Challenge - Patrols, Sites Score UI (Hidden)
		[3461] = { id=3461, category=278, hide=true }, -- Challenge - Banners, Sites Score UI (Hidden)
		[3462] = { id=3462, category=278, hide=true }, -- Sites Bosses, Sites Score UI (Hidden)
		[3464] = { id=3464, category=142 }, -- Renown - Season 2 Delves, Hidden
		[3465] = { id=3465, category=277 }, -- Venomblight Manaflux, Season 2
		[3466] = { id=3466, category=278, hide=true }, -- Sites Deaths, Sites Score UI (Hidden)
		[3467] = { id=3467, category=278, hide=true }, -- Sites Deaths Dues, Sites Score UI (Hidden)
		[3471] = { id=3471, category=142 }, -- Renown - Zul'jarra's Forces, Hidden
		[3474] = { id=3474, category=142, hide=true }, -- Bonus Experience, Hidden
		[3477] = { id=3477, category=278, hide=true }, -- Sites Rares, Sites Score UI (Hidden)
		[3479] = { id=3479, category=142 }, -- Spoils, Hidden
		[3480] = { id=3480, category=142 }, -- Deaths, Hidden
		[3481] = { id=3481, category=278, hide=true }, -- Sites Death Percent, Sites Score UI (Hidden)
		[3482] = { id=3482, category=278, hide=true }, -- Sites Subtotal, Sites Score UI (Hidden)
		[3483] = { id=3483, category=142 }, -- Delver's Journey, Hidden
		[3487] = { id=3487, category=142, hide=true }, -- Tailoring Specialization Reset, Hidden
		[3488] = { id=3488, category=142, hide=true }, -- Skinning Specialization Reset, Hidden
		[3489] = { id=3489, category=142, hide=true }, -- Mining Specialization Reset, Hidden
		[3490] = { id=3490, category=142, hide=true }, -- Leatherworking Specialization Reset, Hidden
		[3491] = { id=3491, category=142, hide=true }, -- Jewelcrafting Specialization Reset, Hidden
		[3492] = { id=3492, category=142, hide=true }, -- Inscription Specialization Reset, Hidden
		[3493] = { id=3493, category=142, hide=true }, -- Herbalism Specialization Reset, Hidden
		[3494] = { id=3494, category=142, hide=true }, -- Engineering Specialization Reset, Hidden
		[3495] = { id=3495, category=142, hide=true }, -- Enchanting Specialization Reset, Hidden
		[3496] = { id=3496, category=142, hide=true }, -- Blacksmithing Specialization Reset, Hidden
		[3497] = { id=3497, category=142, hide=true }, -- Alchemy Specialization Reset, Hidden
		[3504] = { id=3504, category=142 }, -- Zul'jarra's Forces, Hidden
		[3505] = { id=3505, category=142 }, -- [DNT] Diver Score, Hidden
		[3506] = { id=3506, category=142 }, -- [DNT] Diver Display Currency, Hidden
		[3508] = { id=3508, category=1 }, -- Salty Pet Charms, Miscellaneous
		[3509] = { id=3509, category=264 }, -- Tidal Spark Dust, Midnight
		[3511] = { id=3511, category=277 }, -- [DNT, Unused] Venomous Voidcore, Season 2
		[3513] = { id=3513, category=142 }, -- Nebulous Voidcore, Hidden
		[3514] = { id=3514, category=142 }, -- Renown - Prey Season 2, Hidden
		[3515] = { id=3515, category=142 }, -- Preyseeker's Journey, Hidden
		[3532] = { id=3532, category=142, hide=true }, -- 12.1 Delves - Personal Tracker - S2 Weekly Turn-In (Hidden), Hidden
		[3536] = { id=3536, category=142 }, -- Renown - Season 2 Labyrinth, Hidden
		[3537] = { id=3537, category=142 }, -- Kindo'jan's Labyrinth Journey, Hidden
		[3540] = { id=3540, category=142 }, -- Captain Tokka, Hidden
		[3543] = { id=3543, category=268 }, -- Test Myth Dawncrest, Season 1
		[3544] = { id=3544, category=142 }, -- Aqir Research Enclave, Hidden
		[3545] = { id=3545, category=142 }, -- Renown - Season 3 Delves, Hidden
		[3546] = { id=3546, category=280 }, -- Coiled Filament, Professions
		[3568] = { id=3568, category=142, hide=true }, -- Contained Corruption, Hidden
		[3569] = { id=3569, category=142, hide=true }, -- Cleansing Multiplier, Hidden
		[3570] = { id=3570, category=142, hide=true }, -- Wave Multiplier, Hidden
		[3574] = { id=3574, category=142 }, -- PMM Currency 1, Hidden
		[3575] = { id=3575, category=142 }, -- PMM Currency 2, Hidden
		[3583] = { id=3583, category=251, hide=true }, -- Housing - Going Postal - Personal Best Record - Alliance - Rt1, Dragon Racing UI (Hidden)
		[3584] = { id=3584, category=251, hide=true }, -- Housing - Going Postal - Personal Best Record - Alliance - Rt1, Dragon Racing UI (Hidden)
		[3592] = { id=3592, category=142, hide=true }, -- 12.1.5 Labyrinth - Personal Tracker - S2 Weekly Turn-In (Hidden), Hidden
		[3606] = { id=3606, category=142 }, -- Soul, Hidden
	}

	private.data = data
end

