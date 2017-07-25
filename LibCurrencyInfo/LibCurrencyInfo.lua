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

Sample of function calls:
////////////////////////////////////////////////////
local lib = LibStub:GetLibrary("LibCurrencyInfo")

local name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered, rarity, categoryID, categoryName, currencyDesc = lib:GetCurrencyByID(currencyID)

local currencyPerCategory = {}
currencyPerCategory = lib:GetCurrencyByCategoryID(categoryID)

]]
-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local pairs, type = _G.pairs, _G.type
-- Libraries
local tonumber, error = _G.tonumber, _G.error
local GetCurrencyInfo, GetLocale = _G.GetCurrencyInfo, _G.GetLocale
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local LibStub = _G.LibStub

local MAJOR_VERSION = "LibCurrencyInfo"
local MINOR_VERSION = 90000 + tonumber(("$Rev: 2$"):match("%d+"))

local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

local LANGS = {
	["enUS"] = true,
	["deDE"] = true,
	["esES"] = true,
	["esMX"] = true,
	["frFR"] = true,
	["itIT"] = true,
	["koKR"] = true,
	["ptBR"] = true,
	["ruRU"] = true,
	["zhCN"] = true,
	["zhTW"] = true,
}

local data = {}
lib.data = data

data.CurrencyByCategory = {
	[1] = { -- Miscellaneous
--		1, -- Currency Token Test Token 4
--		2, -- Currency Token Test Token 2
--		4, -- Currency Token Test Token 5
--		42, -- Badge of Justice
		81, -- Epicurean's Award
		402, -- Ironpaw Token
		515, -- Darkmoon Prize Ticket
		1379, -- Trial of Style Token
	},
	[2] = { -- Player vs. Player
--		103, -- Arena Points
--		104, -- Honor Points DEPRECATED
--		121, -- Alterac Valley Mark of Honor
--		122, -- Arathi Basin Mark of Honor
--		123, -- Eye of the Storm Mark of Honor
--		124, -- Strand of the Ancients Mark of Honor
--		125, -- Warsong Gulch Mark of Honor
--		126, -- Wintergrasp Mark of Honor
--		161, -- Stone Keeper's Shard
--		181, -- Honor Points DEPRECATED2
--		201, -- Venture Coin
--		321, -- Isle of Conquest Mark of Honor
		391, -- Tol Barad Commendation
	},
	[21] = { -- Wrath of the Lich King
		61, -- Dalaran Jewelcrafter's Token
		241, -- Champion's Seal
	},
	[22] = { -- Dungeon and Raid
--		101, -- Emblem of Heroism
--		102, -- Emblem of Valor
--		221, -- Emblem of Conquest
--		301, -- Emblem of Triumph
--		341, -- Emblem of Frost
		1166, -- Timewarped Badge
		1191, -- Valor
	},
--	[41] = { -- Test
--		22, -- Birmingham Test Item 3
--	},
	[81] = { -- Cataclysm
		361, -- Illustrious Jewelcrafter's Token
		416, -- Mark of the World Tree
		614, -- Mote of Darkness
		615, -- Essence of Corrupted Deathwing
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
		821, -- Draenor Clans Archaeology Fragment
		828, -- Ogre Archaeology Fragment
		829, -- Arakkoa Archaeology Fragment
--		830, -- n/a
		1172, -- Highborne Archaeology Fragment
		1173, -- Highmountain Tauren Archaeology Fragment
		1174, -- Demonic Archaeology Fragment
	},
--	[89] = { -- Meta
--		483, -- Conquest Arena Meta
--		484, -- Conquest Rated BG Meta
--		692, -- Conquest Random BG Meta
--	},
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
		1299, -- Brawler's Gold
		1314, -- Lingering Soul Fragment
		1342, -- Legionfall War Supplies
		1355, -- Felessence
		1356, -- Echoes of Battle
		1357, -- Echoes of Domination
		1416, -- Coins of Air
		1501, -- Writhing Essence
		1506, -- Argus Waystone
		1508, -- Unsullied Argunite
	},
	[142] = { -- Hidden
--		395, -- Justice Points
--		396, -- Valor Points
		1171, -- Artifact Knowledge
		1324, -- Horde Qiraji Commendation
		1325, -- Alliance Qiraji Commendation
--		1347, -- Legionfall Building - Personal Tracker - Mage Tower (Hidden)
--		1349, -- Legionfall Building - Personal Tracker - Command Tower (Hidden)
--		1350, -- Legionfall Building - Personal Tracker - Nether Tower (Hidden)
	},
}

data.CurrencyCategories = {
	[1] = { enUS="Miscellaneous",deDE="Verschiedenes",esES="Miscelánea",esMX="Miscelánea",frFR="Divers",itIT="Varie",koKR="기타",ptBR="Diversos",ruRU="Разное",zhCN="其它",zhTW="雜項" },
	[2] = { enUS="Player vs. Player",deDE="Spieler gegen Spieler",esES="Jugador contra Jugador",esMX="Jugador contra Jugador",frFR="JcJ",itIT="Personaggio vs Personaggio",koKR="플레이어 대 플레이어",ptBR="Jogador x Jogador",ruRU="PvP",zhCN="PvP",zhTW="玩家對玩家" },
	[4] = { enUS="Classic",deDE="Classic",esES="Clásico",esMX="Clásico",frFR="Classique",itIT="Classico",koKR="오리지널",ptBR="Clássico",ruRU="World of Warcraft",zhCN="经典旧世",zhTW="艾澤拉斯", hide=true, },
	[21] = { enUS="Wrath of the Lich King",deDE="Wrath of the Lich King",esES="Wrath of the Lich King",esMX="Wrath of the Lich King",frFR="Wrath of the Lich King",itIT="Wrath of the Lich King",koKR="리치 왕의 분노",ptBR="Wrath of the Lich King",ruRU="Wrath of the Lich King",zhCN="巫妖王之怒",zhTW="巫妖王之怒" },
	[22] = { enUS="Dungeon and Raid",deDE="Dungeon und Schlachtzug",esES="Mazmorra y banda",esMX="Calabozo y banda",frFR="Donjons & Raids",itIT="Spedizioni e Incursioni",koKR="던전 및 공격대",ptBR="Masmorras e Raides",ruRU="Подземелья и рейды",zhCN="地下城与团队",zhTW="地城與團隊" },
	[23] = { enUS="Burning Crusade",deDE="Burning Crusade",esES="Burning Crusade",esMX="Burning Crusade",frFR="Burning Crusade",itIT="Burning Crusade",koKR="불타는 성전",ptBR="Burning Crusade",ruRU="Burning Crusade",zhCN="燃烧的远征",zhTW="燃燒的遠征", hide=true, },
	[81] = { enUS="Cataclysm",deDE="Cataclysm",esES="Cataclysm",esMX="Cataclysm",frFR="Cataclysm",itIT="Cataclysm",koKR="대격변",ptBR="Cataclysm",ruRU="Cataclysm",zhCN="大地的裂变",zhTW="浩劫與重生" },
	[82] = { enUS="Archaeology",deDE="Archäologie",esES="Arqueología",esMX="Arqueología",frFR="Archéologie",itIT="Archeologia",koKR="고고학",ptBR="Arqueologia",ruRU="Археология",zhCN="考古学",zhTW="考古學" },
	[133] = { enUS="Mists of Pandaria",deDE="Mists of Pandaria",esES="Mists of Pandaria",esMX="Mists of Pandaria",frFR="Mists of Pandaria",itIT="Mists of Pandaria",koKR="판다리아의 안개",ptBR="Mists of Pandaria",ruRU="Mists of Pandaria",zhCN="熊猫人之谜",zhTW="潘達利亞之謎" },
	[137] = { enUS="Warlords of Draenor",deDE="Warlords of Draenor",esES="Warlords of Draenor",esMX="Warlords of Draenor",frFR="Warlords of Draenor",itIT="Warlords of Draenor",koKR="드레노어의 전쟁군주",ptBR="Warlords of Draenor",ruRU="Warlords of Draenor",zhCN="德拉诺之王",zhTW="德拉諾之霸" },
	[141] = { enUS="Legion",deDE="Legion",esES="Legion",esMX="Legion",frFR="Legion",itIT="Legion",koKR="군단",ptBR="Legion",ruRU="Legion",zhCN="军团再临",zhTW="軍團" },
	[142] = { enUS="Hidden",deDE="Versteckt",esES="Oculto",esMX="Oculto",frFR="Caché",itIT="Nascosto",koKR="숨김",ptBR="Escondido",ruRU="Невидимые чары",zhCN="隐藏",zhTW="隱藏" },
}

data.Currencies = {
		[1] = { id=1, category=1, hide=true }, -- Currency Token Test Token 4, Miscellaneous
		[2] = { id=2, category=1, hide=true }, -- Currency Token Test Token 2, Miscellaneous
		[4] = { id=4, category=1, hide=true }, -- Currency Token Test Token 5, Miscellaneous
		[22] = { id=22, category=41, hide=true }, -- Birmingham Test Item 3, Test
		[42] = { id=42, category=1, hide=true }, -- Badge of Justice, Miscellaneous
		[61] = { id=61, category=21 }, -- Dalaran Jewelcrafter's Token, Wrath of the Lich King
		[81] = { id=81, category=1 }, -- Epicurean's Award, Miscellaneous
		[101] = { id=101, category=22, hide=true }, -- Emblem of Heroism, Dungeon and Raid
		[102] = { id=102, category=22, hide=true }, -- Emblem of Valor, Dungeon and Raid
		[103] = { id=103, category=2, hide=true }, -- Arena Points, Player vs. Player
		[104] = { id=104, category=2, hide=true }, -- Honor Points DEPRECATED, Player vs. Player
		[121] = { id=121, category=2, hide=true }, -- Alterac Valley Mark of Honor, Player vs. Player
		[122] = { id=122, category=2, hide=true }, -- Arathi Basin Mark of Honor, Player vs. Player
		[123] = { id=123, category=2, hide=true }, -- Eye of the Storm Mark of Honor, Player vs. Player
		[124] = { id=124, category=2, hide=true }, -- Strand of the Ancients Mark of Honor, Player vs. Player
		[125] = { id=125, category=2, hide=true }, -- Warsong Gulch Mark of Honor, Player vs. Player
		[126] = { id=126, category=2, hide=true }, -- Wintergrasp Mark of Honor, Player vs. Player
		[161] = { id=161, category=2, hide=true }, -- Stone Keeper's Shard, Player vs. Player
		[181] = { id=181, category=2, hide=true }, -- Honor Points DEPRECATED2, Player vs. Player
		[201] = { id=201, category=2, hide=true }, -- Venture Coin, Player vs. Player
		[221] = { id=221, category=22, hide=true }, -- Emblem of Conquest, Dungeon and Raid
		[241] = { id=241, category=21 }, -- Champion's Seal, Wrath of the Lich King
		[301] = { id=301, category=22, hide=true }, -- Emblem of Triumph, Dungeon and Raid
		[321] = { id=321, category=2, hide=true }, -- Isle of Conquest Mark of Honor, Player vs. Player
		[341] = { id=341, category=22, hide=true }, -- Emblem of Frost, Dungeon and Raid
		[361] = { id=361, category=81 }, -- Illustrious Jewelcrafter's Token, Cataclysm
		[384] = { id=384, category=82 }, -- Dwarf Archaeology Fragment, Archaeology
		[385] = { id=385, category=82 }, -- Troll Archaeology Fragment, Archaeology
		[391] = { id=391, category=2 }, -- Tol Barad Commendation, Player vs. Player
		[393] = { id=393, category=82 }, -- Fossil Archaeology Fragment, Archaeology
		[394] = { id=394, category=82 }, -- Night Elf Archaeology Fragment, Archaeology
		[395] = { id=395, category=142, hide=true }, -- Justice Points, Hidden
		[396] = { id=396, category=142, hide=true }, -- Valor Points, Hidden
		[397] = { id=397, category=82 }, -- Orc Archaeology Fragment, Archaeology
		[398] = { id=398, category=82 }, -- Draenei Archaeology Fragment, Archaeology
		[399] = { id=399, category=82 }, -- Vrykul Archaeology Fragment, Archaeology
		[400] = { id=400, category=82 }, -- Nerubian Archaeology Fragment, Archaeology
		[401] = { id=401, category=82 }, -- Tol'vir Archaeology Fragment, Archaeology
		[402] = { id=402, category=1 }, -- Ironpaw Token, Miscellaneous
		[416] = { id=416, category=81 }, -- Mark of the World Tree, Cataclysm
		[483] = { id=483, category=89, hide=true }, -- Conquest Arena Meta, Meta
		[484] = { id=484, category=89, hide=true }, -- Conquest Rated BG Meta, Meta
		[515] = { id=515, category=1 }, -- Darkmoon Prize Ticket, Miscellaneous
		[614] = { id=614, category=81 }, -- Mote of Darkness, Cataclysm
		[615] = { id=615, category=81 }, -- Essence of Corrupted Deathwing, Cataclysm
		[676] = { id=676, category=82 }, -- Pandaren Archaeology Fragment, Archaeology
		[677] = { id=677, category=82 }, -- Mogu Archaeology Fragment, Archaeology
		[692] = { id=692, category=89, hide=true }, -- Conquest Random BG Meta, Meta
		[697] = { id=697, category=133 }, -- Elder Charm of Good Fortune, Mists of Pandaria
		[698] = { id=698, category=133 }, -- Zen Jewelcrafter's Token, Mists of Pandaria
		[738] = { id=738, category=133 }, -- Lesser Charm of Good Fortune, Mists of Pandaria
		[752] = { id=752, category=133 }, -- Mogu Rune of Fate, Mists of Pandaria
		[754] = { id=754, category=82 }, -- Mantid Archaeology Fragment, Archaeology
		[776] = { id=776, category=133 }, -- Warforged Seal, Mists of Pandaria
		[777] = { id=777, category=133 }, -- Timeless Coin, Mists of Pandaria
		[789] = { id=789, category=133 }, -- Bloody Coin, Mists of Pandaria
		[810] = { id=810, category=133 }, -- Black Iron Fragment, Mists of Pandaria
		[821] = { id=821, category=82 }, -- Draenor Clans Archaeology Fragment, Archaeology
		[823] = { id=823, category=137 }, -- Apexis Crystal, Warlords of Draenor
		[824] = { id=824, category=137 }, -- Garrison Resources, Warlords of Draenor
		[828] = { id=828, category=82 }, -- Ogre Archaeology Fragment, Archaeology
		[829] = { id=829, category=82 }, -- Arakkoa Archaeology Fragment, Archaeology
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
		[1172] = { id=1172, category=82 }, -- Highborne Archaeology Fragment, Archaeology
		[1173] = { id=1173, category=82 }, -- Highmountain Tauren Archaeology Fragment, Archaeology
		[1174] = { id=1174, category=82 }, -- Demonic Archaeology Fragment, Archaeology
		[1191] = { id=1191, category=22 }, -- Valor, Dungeon and Raid
		[1220] = { id=1220, category=141 }, -- Order Resources, Legion
		[1226] = { id=1226, category=141 }, -- Nethershard, Legion
		[1268] = { id=1268, category=141 }, -- Timeworn Artifact, Legion
		[1273] = { id=1273, category=141 }, -- Seal of Broken Fate, Legion
		[1275] = { id=1275, category=141 }, -- Curious Coin, Legion
		[1299] = { id=1299, category=141 }, -- Brawler's Gold, Legion
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
		[1416] = { id=1416, category=141 }, -- Coins of Air, Legion
		[1501] = { id=1501, category=141 }, -- Writhing Essence, Legion
		[1506] = { id=1506, category=141 }, -- Argus Waystone, Legion
		[1508] = { id=1508, category=141 }, -- Unsullied Argunite, Legion
}

data.CurrencyDesc = {
	[1] = { hide=true, enUS="Text that describes this item can be found here.", deDE="Text, der den Gegenstand beschreibt, wird hier angezeigt.", esES="Aquí puede encontrarse el texto que describe a este objeto.", esMX="Aquí puede encontrarse el texto que describe a este objeto.", frFR="Un texte qui décrit l'objet figure ici.", itIT="Text that describes this item can be found here.", koKR="아이템 설명", ptBR="O texto que descreve este item pode ser visto aqui.", ruRU="Здесь находится описание предмета.", zhCN="Text that describes this item can be found here.", zhTW="本物品之敘述在此" },
	[61] = { enUS="Tiffany Cartier's shop in Dalaran will gladly accept these tokens for unique jewelcrafting recipes.", deDE="Tiffany Cartiers Geschäft in Dalaran wird diese Symbole im Tausch gegen einzigartige Juweliersrezepte dankend annehmen.", esES="La tienda de Tiffany Cartier en Dalaran cambiará gustosamente estos talismanes por recetas de joyería.", esMX="La tienda de Tiffany Cartier en Dalaran cambiará gustosamente estos talismanes por recetas de joyería.", frFR="La boutique de Tiffany Kartier, à Dalaran, accepte avec joie ces marques contre des dessins de joaillerie uniques.", itIT="Il negozio di Tiffany Cartier a Dalaran accetterà volentieri questi emblemi in cambio di esclusivi modelli da orefice.", koKR="달라란에 있는 티파니 까르티엘의 가게에서 보석세공 디자인으로 교환하는 데 사용합니다.", ptBR="A loja Sojoia Kara em Dalaran aceita de bom grado essas fichas por instruções de joalheria raras.", ruRU="В магазине Тиффани Картье, что в Даларане, вам с радостью обменяют эти знаки на уникальные ювелирные эскизы.", zhCN="达拉然的蒂凡妮·卡蒂亚会欣然接受这些代币，并用稀有的珠宝加工图鉴来交换。", zhTW="蒂芬妮·卡地亞位於達拉然的商店相當願意用獨特的珠寶設計圖來交換這些徽章。" },
	[81] = { enUS="Visit special cooking vendors in Dalaran and the capital cities to to purchase unusual cooking recipes, spices, and even a fine hat!", deDE="Besucht besondere Kochhändler in Dalaran und den Hauptstädten, um ungewöhnliche Kochrezepte, Gewürze und sogar eine großartige Mütze zu kaufen!", esES="Visita a los vendedores de cocina especiales de Dalaran y de las capitales para comprar recetas de cocina poco frecuentes, especias, ¡e incluso un bonito gorro!", esMX="Visita a los vendedores de cocina especiales de Dalaran y de las capitales para comprar recetas de cocina poco frecuentes, especias, ¡e incluso un bonito gorro!", frFR="Rendez visite aux marchands de fournitures de cuisine à Dalaran et dans les autres capitales pour acheter des recettes de cuisine spéciales, des épices, et même une superbe toque !", itIT="Scambiali con i migliori cuochi di Dalaran e delle capitali per acquistare ricette speciali, spezie e persino un bel cappello da cuoco!", koKR="달라란과 대도시의 특별한 요리 상인에게서 이색 조리법, 양념, 심지어 멋진 모자도 살 수 있습니다!", ptBR="Visite comerciantes de culinária em Dalaran e outras capitais para comprar receitas especiais de culinária, condimentos e até mesmo um belo chapéu!", ruRU="Посетите торговцев кулинарными товарами в Даларане и других столицах, чтобы приобрести особые кулинарные рецепты, специи и даже головной убор!", zhCN="造访达拉然与各个主城的烹饪供应商，购买罕见的烹饪配方、香料以及大厨的帽子！", zhTW="拜訪達拉然與主城中的特殊烹飪供應商來購買特殊烹飪食譜及香料，甚至是一頂不錯的帽子!" },
	[104] = { hide=true, enUS="If you can read this, you've found a bug. REPORT IT!", deDE="Wenn Ihr das hier lesen könnt, habt Ihr einen Bug gefunden. MELDET IHN!", esES="Si puedes leer esto, has encontrado un error. ¡Informa!", esMX="Si puedes leer esto, has encontrado un error. ¡Informa!", frFR="Si vous lisez ceci, c'est un bug. SIGNALEZ-LE !", itIT="If you can read this, you've found a bug. REPORT IT!", koKR="이게 보인다면, 버그입니다. 보고하세요!", ptBR="If you can read this, you've found a bug. REPORT IT!", ruRU="Если вы видите это сообщение, это значит, что вы обнаружили ошибку. Сообщите о ней!", zhCN="能读到这行字就说明你遇到了一个bug，赶紧的报bug。", zhTW="如果你讀到這個，就是發現了BUG!回報它!" },
	[181] = { hide=true, enUS="If you can read this, you've found a bug. REPORT IT!", deDE="Wenn Ihr das hier lesen könnt, habt Ihr einen Bug gefunden. MELDET IHN!", esES="Si puedes leer esto, has encontrado un error. ¡Informa!", esMX="Si puedes leer esto, has encontrado un error. ¡Informa!", frFR="Si vous lisez ceci, c'est un bug. SIGNALEZ-LE !", itIT="If you can read this, you've found a bug. REPORT IT!", koKR="이게 보인다면, 버그입니다. 보고하세요!", ptBR="If you can read this, you've found a bug. REPORT IT!", ruRU="Если вы видите это сообщение, это значит, что вы обнаружили ошибку. Сообщите о ней!", zhCN="能读到这行字就说明你遇到了一个bug，赶紧的报bug。", zhTW="如果你讀到這個，就是發現了BUG!回報它!" },
	[241] = { enUS="Awarded for valiant acts in the Crusader's Coliseum.", deDE="Werden für Heldentaten im Kolosseum der Kreuzfahrer verliehen.", esES="Otorgado por las hazañas en el Coliseo de los Cruzados.", esMX="Otorgado por las hazañas en el Coliseo de los Cruzados.", frFR="Obtenu en récompense d’actes de bravoure au colisée des Croisés.", itIT="Assegnato dal Torneo d'Argento per gesta valorose.", koKR="십자군 원형경기장에서 보여준 용맹한 행위에 대한 보상입니다.", ptBR="Concedido por atos de bravura no Coliseu dos Cruzados.", ruRU="За храбрость, проявленную на турнирах Колизея Авангарда.", zhCN="表彰你在十字军演武场中展示的武勇。", zhTW="為表彰你在十字軍大競技場的驍士行為。" },
	[361] = { enUS="Awarded for demonstrating great skill in jewelcrafting, these tokens can be used to purchase unique jewelcrafting plans and the fabulous Chimera's Eye.", deDE="Werden für das Beweisen großer Juwelierskunst vergeben. Diese Symbole können genutzt werden, um einzigartige Juwelierskunstpläne und die sagenhaften Schimärenaugen zu erhalten.", esES="Otorgado por demostrar gran habilidad en joyería, estos talismanes se pueden usar para comprar diseños de joyería únicos y el fabuloso ojo de quimera.", esMX="Otorgado por demostrar gran habilidad en joyería, estos talismanes se pueden usar para comprar diseños de joyería únicos y el fabuloso ojo de quimera.", frFR="Accordées aux joailliers qui montrent un certain talent, ces récompenses peuvent être utilisées pour acheter des dessins de joaillerie uniques et le fabuleux œil de la chimère.", itIT="Concessi a chi dimostra grande perizia nell'arte orafa, questi emblemi vengono impiegati per acquistare esclusivi modelli da oreficeria e il favoloso Occhio di Chimera.", koKR="보석세공에 뛰어난 실력을 보여준 자에게 수여하는 징표입니다. 이 징표는 진귀한 보석세공 디자인과 근사한 키메라 눈을 구매하는 데 사용할 수 있습니다.", ptBR="Concedidas a quem demonstra grande habilidade em joalheria, essas fichas podem ser usadas para comprar instruções de joalheria raras e olhos-da-quimera fabulosos.", ruRU="Награда за проявленное мастерство в ювелирном деле. За эти жетоны можно приобрести уникальные эскизы и непревзойденный глаз химеры.", zhCN="授予技艺最精湛的珠宝名匠，这些奖章可以用来兑换稀有的珠宝加工图鉴和奇美拉之眼。", zhTW="為表彰你在珠寶設計領域的卓越技巧，可以用這些徽章來換取獨特的珠寶設計圖和品質極佳的奇美拉之瞳。" },
	[391] = { enUS="Awarded for brave deeds performed on Tol Barad.", deDE="Werden für mutige Taten auf Tol Barad verliehen.", esES="Otorgado por las valientes hazañas llevadas a cabo en Tol Barad.", esMX="Otorgado por las valientes hazañas llevadas a cabo en Tol Barad.", frFR="Obtenue en récompense d’actes de bravoure à Tol Barad.", itIT="Assegnato per gesta coraggiose compiute a Tol Barad.", koKR="톨 바라드에서 보여준 용감한 행동에 대한 보상입니다.", ptBR="Concedida por atos de bravura em Tol Barad.", ruRU="За отвагу, проявленную на Тол Бараде.", zhCN="奖励你在托尔巴拉德的英勇战绩。", zhTW="為表彰你在托巴拉德的英勇行徑。" },
	[395] = { hide=true, enUS="Used to purchase less-powerful armor and weapons.", deDE="Können für den Erwerb von weniger mächtigen Waffen und Rüstungen verwendet werden.", esES="Se utilizan para comprar armas y armaduras menos poderosas.", esMX="Se utilizan para comprar armas y armaduras menos poderosas.", frFR="Utilisés pour acheter des armures et armes moyennement puissantes.", itIT="Utilizzati per acquistare le armi e le armature meno potenti.", koKR="몬스터 처치에 효과적인 방어구와 무기를 구매하는 데 사용합니다.", ptBR="Usados para adquirir armas e armaduras menos poderosas.", ruRU="За эти очки можно покупать не очень мощное оружие и доспехи.", zhCN="可用来购买较为强大的护甲和武器。", zhTW="用來購買次強的護甲與武器。" },
	[396] = { hide=true, enUS="Used to purchase powerful PvE armor and weapons.", deDE="Können für den Erwerb von mächtigen PvE-Waffen und PvE-Rüstungen verwendet werden.", esES="Se utilizan para comprar armas y armaduras de JcE poderosas.", esMX="Se utilizan para comprar armas y armaduras de JcE poderosas.", frFR="Utilisés pour acheter des armures et armes de JcE puissantes.", itIT="Utilizzati per acquistare le armi e le armature PvA più potenti.", koKR="몬스터 처치에 매우 효과적인 방어구와 무기를 구매하는 데 사용합니다.", ptBR="Usados para adquirir poderosas armas e armaduras de JxA.", ruRU="За эти очки можно покупать мощное оружие и доспехи для PvE-сражений.", zhCN="可用来购买非常强大的PVE护甲和武器。", zhTW="用來購買較強的PvE護甲與武器。" },
	[402] = { enUS="Represents your credit with the Ironpaw family of cooks. Can be redeemed for Cooking ingredients and other things at the Stockmaster in Halfhill Market.", deDE="Symbolisiert Euer Guthaben bei der Kochfamilie Eisentatz. Kann beim Vorratsmeister auf dem Halbhügelmarkt eingetauscht werden.", esES="Representa tu crédito con la familia de cocineros Zarpa Férrea. Se puede canjear por ingredientes de cocina y otras cosas con el maestro de despensa en El Mercado del Alcor.", esMX="Representa tu crédito con la familia de cocineros Zarpa Férrea. Se puede canjear por ingredientes de cocina y otras cosas con el maestro de despensa en El Mercado del Alcor.", frFR="Représente votre mérite auprès de la communauté de la famille de cuisiniers, les Patte de Fer. Peut être utilisé pour acheter des ingrédients de cuisine et autres auprès du maître des provisions sur le marché de Micolline.", itIT="È un pegno di credito per i cuochi degli Zampa Forte. Può essere riscattato per acquistare ingredienti e altro materiale presso il magazziniere del Mercato di Mezzocolle.", koKR="당신이 아이언포우 요리 가문과 쌓은 신뢰를 증명합니다. 언덕골 시장의 재고 관리인에게서 요리 재료나 기타 물품으로 교환할 수 있습니다.", ptBR="Representa seu crédito com a família de cozinheiros Pata de Ferro. Pode ser trocado por ingredientes de Culinária e outras coisas no Estoque do Mercado de Meia Colina.", ruRU="Знак признания со стороны поварской династии Железной Лапы. Жетон можно обменять на кулинарные товары у талантливого кулинара на рынке Полугорья.", zhCN="代表你受到了烹饪世家——铁掌家族的嘉许。可在半山市集的库房管理员处兑换烹饪配料和其它物品。", zhTW="鐵爪家族的徽章是你最棒的烹飪獎勵，可在半丘市集裡與庫存大師兌換烹飪材料和其他的東西。" },
	[416] = { enUS="Granted by the Guardians of Hyjal. Can be used to purchase reinforcements for the Invasion of the Firelands.", deDE="Von den Wächtern des Hyjal verliehen. Kann verwendet werden, um Verstärkung für die Invasion der Feuerlande zu erwerben.", esES="Concedida por los Guardianes de Hyjal. Se puede usar para comprar refuerzos para la invasión de las Tierras de Fuego.", esMX="Concedida por los Guardianes de Hyjal. Se puede usar para comprar refuerzos para la invasión de las Tierras de Fuego.", frFR="Obtenue auprès des gardiens d'Hyjal. Peut être utilisée pour acheter des renforts pour l'invasion des terres de Feu.", itIT="Conferita dai Guardiani di Hyjal, questa valuta è impiegata per acquistare rinforzi in vista dell'Invasione delle Terre del Fuoco.", koKR="하이잘의 수호자로부터 받습니다. 불의 땅 침공에 필요한 추가 병력을 고용하는 데 사용합니다.", ptBR="Concedida pelos Guardiões de Hyjal. Pode ser usada para comprar reforços para a Invasão das Terras do Fogo.", ruRU="Выдается Стражами Хиджала. Может использоваться для приобретения подкреплений во время Вторжения в Огненные Просторы.", zhCN="由海加尔守护者授予。可以用来购买进攻火焰之地的补给。", zhTW="由海加爾守護者所授予。用來購買進軍火源之界所需之補給品。" },
	[515] = { enUS="Awarded for winning games or doing favors at the Darkmoon Faire.", deDE="Werden auf dem Dunkelmond-Jahrmarkt für das Gewinnen von Spielen oder erwiesene Gefallen gewährt.", esES="Otorgado por ganar juegos o hacer favores en la Feria de la Luna Negra.", esMX="Otorgado por ganar juegos o hacer favores en la Feria de la Luna Negra.", frFR="Obtenu en récompense de jeux ou de services rendus à la foire de Sombrelune.", itIT="Ottenuto vincendo alle attrazioni o portando a termine missioni per la Fiera di Lunacupa.", koKR="다크문 축제의 게임에 도전해 성공하거나 임무를 완수했을 때 받을 수 있는 보상입니다.", ptBR="Concedidos a quem ganhar jogos ou realizar favores na Feira de Negraluna", ruRU="Выдается за победы в состязаниях ярмарки Новолуния или за помощь ее устроителям.", zhCN="在暗月马戏团的游戏中获胜或完成工作人员交付的任务后获得。", zhTW="為表彰你在暗月馬戲團贏得遊戲或幫助他人的行為。" },
	[614] = { enUS="Extracted from the forces of Deathwing, this dark energy can be used to power amazing magics.", deDE="Von Todesschwinges Dienern extrahiert. Diese dunkle Energie kann genutzt werden, um erstaunliche Magien zu wirken.", esES="Extraída de las fuerzas de Alamuerte, esta energía oscura se puede usar para potenciar una magia increíble.", esMX="Extraída de las fuerzas de Alamuerte, esta energía oscura se puede usar para potenciar una magia increíble.", frFR="Extraite des troupes d’Aile de mort, cette énergie sombre peut être utilisée pour générer de puissantes magies.", itIT="Estratto dagli alleati di Alamorte, questa oscura energia può essere usata per alimentare incredibili magie.", koKR="데스윙의 부하들에게서 추출된 이 암흑 에너지는 놀라운 마법의 힘을 강화할 수 있습니다.", ptBR="Extraída das forças do Asa da Morte, essa energia negra pode ser usada para potencializar magias prodigiosas.", ruRU="Эта темная энергия может дать силу удивительным заклинаниям.", zhCN="由死亡之翼的灭世之力凝聚而成，其中蕴含的黑暗能量可以强化威力骇人的魔法。", zhTW="從死亡之翼的能量中萃取而出，這種黑暗的能量可用來作為強大且神奇魔法的能量來源。" },
	[615] = { enUS="Extracted from Deathwing himself, this dark energy powers the most fearsome of incantations.", deDE="Von Todesschwinge selbst extrahiert. Diese dunkle Energie ist die Kraftquelle für furchteinflößende Beschwörungen.", esES="Extraída del propio Alamuerte, esta energía oscura potencia los encantamientos más temibles.", esMX="Extraída del propio Alamuerte, esta energía oscura potencia los encantamientos más temibles.", frFR="Extraite d’Aile de mort lui-même, cette énergie sombre alimente les plus effrayantes des incantations.", itIT="Estratta direttamente dal corpo di Alamorte, questa oscura energia può alimentare gli incanti più devastanti.", koKR="데스윙에게서 추출된 이 암흑 에너지는 가장 무시무시한 주문의 힘을 강화합니다.", ptBR="Extraída do próprio Asa da Morte, essa energia negra potencializa os mais assombrosos encantamentos.", ruRU="Эта темная энергия, вырванная у Смертокрыла, питает самые ужасные заклинания.", zhCN="从死亡之翼的身躯中抽离而出的黑暗能量，用以催动最为恐怖的咒术。", zhTW="從死亡之翼本身中萃取而出，這種黑暗的能量是用來作為最可怕咒語的能量來源。" },
	[697] = { enUS="Possession of the Elder Charm of Good Fortune allows its lucky owner to risk a coin to receive a bonus reward from Mogu'shan Vaults, Heart of Fear, Terrace of Endless Spring, Sha of Anger, or Salyis' Warband.", deDE="Das ehrwürdige Amulett des Glücks kann für die Chance eingesetzt werden, zusätzliche Beute aus dem Mogu'shangewölbe, dem Herzen der Angst, der Terrasse des Endlosen Frühlings, vom Sha des Zorns oder von Salyis' Kriegsmeute zu erhalten.", esES="Poseer un talismán ancestral de buena fortuna permite al afortunado propietario apostar una moneda para obtener una recompensa extra en las Cámaras Mogu'shan, el Corazón del Miedo, la Veranda de la Primavera Eterna, del Sha de la Ira o la banda guerrera de Salyis.", esMX="Poseer un talismán ancestral de buena fortuna permite al afortunado propietario apostar una moneda para obtener una recompensa extra en las Cámaras Mogu'shan, el Corazón del Miedo, la Veranda de la Primavera Eterna, del Sha de la Ira o la banda guerrera de Salyis.", frFR="Posséder une breloque ancienne de bonne fortune permet à son chanceux propriétaire d’utiliser une pièce pour obtenir un butin supplémentaire aux caveaux Mogu’shan, au Cœur de la peur, à la terrasse Printanière, sur le sha de la colère ou la troupe de guerre de Salyis.", itIT="Il fortunato possessore di un Talismano Superiore Portafortuna può giocarlo per tentare di vincere una ricompensa bonus nelle Segrete Mogu'shan, nel Cuore della Paura, nella Terrazza dell'Eterna Primavera, dallo Sha della Rabbia o dalla Brigata di Salyis.", koKR="이 부적을 사용하여 모구샨 금고, 공포의 심장, 영원한 봄의 정원, 분노의 샤, 살리스의 전투부대 공격대 우두머리로부터 추가 보상을 획득할 기회를 얻을 수 있습니다.", ptBR="Possuir o Antigo Amuleto de Boa Sorte permite que o proprietário sortudo arrisque uma moeda para receber uma recompensa-bônus em Galerias Mogu'shan, Coração do Medo, Terraço da Primavera Eterna, Sha da Raiva ou Bando Guerreiro de Salyis.", ruRU="Счастливые обладатели большого амулета удачи могут испытать судьбу и получить шанс на дополнительную добычу за победу над рейдовыми боссами Подземелий Могу'шан, Сердца Страха, Террасы Вечной Весны, а также Ша Злости и отрядом Сальиса.", zhCN="长者好运符的拥有者在战胜魔古山宝库、恐惧之心、永春台中的首领，以及怒之煞或萨莱斯的兵团后有机会使用一枚硬币来赢取额外的奖励。", zhTW="持有長者的好運符咒便有機會用一枚硬幣從魔古山寶庫、恐懼之心、豐泉台、憤怒之煞或沙利斯的劫掠兵團獲得額外獎勵。" },
	[698] = { enUS="Awarded for demonstrating great skill in jewelcrafting, these tokens can be used to purchase unique jewelcrafting plans and the beautiful Serpent's Eye.", deDE="Wird für das Beweisen großer Juwelierskunst vergeben. Diese Marken können genutzt werden, um einzigartige Juwelierskunstpläne und die wunderschönen Schlangenaugen zu erhalten.", esES="Otorgado por demostrar gran habilidad en joyería, estas marcas se pueden usar para comprar diseños de joyería únicos y el fabuloso ojo de sierpe.", esMX="Otorgado por demostrar gran habilidad en joyería, estas marcas se pueden usar para comprar diseños de joyería únicos y el fabuloso ojo de sierpe.", frFR="Accordées aux joailliers qui montrent un certain talent, ces récompenses peuvent être utilisées pour acheter des dessins de joaillerie uniques et le magnifique œil de serpent.", itIT="Concessi a chi dimostra grande perizia nell'arte orafa, questi emblemi vengono impiegati per acquistare esclusivi modelli da oreficeria e il meraviglioso Occhio della Serpe.", koKR="보석세공에 뛰어난 실력을 보여준 자에게 수여하는 징표입니다. 이 징표는 진귀한 보석세공 디자인과 근사한 운룡의 눈을 구매하는 데 사용할 수 있습니다.", ptBR="Concedidas a quem demonstra grande habilidade em joalheria, essas fichas podem ser usadas para comprar instruções de joalheria raras e olhos-de-serpente fabulosos.", ruRU="Награда за проявленное мастерство в ювелирном деле. За эти жетоны можно приобрести уникальные эскизы и непревзойденный змеиный глаз.", zhCN="授予技艺最精湛的珠宝名匠，这些奖章可以用来兑换稀有的珠宝加工图鉴和美丽的蛟眼石。", zhTW="為表彰你在珠寶設計領域的卓越技巧，可以用這些徽章來換取獨特的珠寶設計圖和品質極佳的蛟龍之瞳。" },
	[738] = { enUS="Possession of the Lesser Charms of Good Fortune will result in great happiness and the eventual conversion into Warforged Seals, which allow players to risk a coin to receive a bonus reward from raid encounters.", deDE="Das geringe Amulett des Glücks gewährt große Freude und kann letztendlich in Kriegsembleme umgewandelt werden, die für eine Chance eingesetzt werden können, zusätzliche Beute von Schlachtzugsbossen zu erhalten.", esES="Poseer un talismán inferior de buena fortuna proporciona una gran felicidad y al final se acaba convirtiendo en un sello forjado por la guerra que permite a los jugadores apostar una moneda a cambio de una recompensa extra en los encuentros de bandas.", esMX="Poseer un talismán inferior de buena fortuna proporciona una gran felicidad y al final se acaba convirtiendo en un sello forjado por la guerra que permite a los jugadores apostar una moneda a cambio de una recompensa extra en los encuentros de bandas.", frFR="Posséder des breloques de bonne fortune inférieures apportera une grande joie à son propriétaire et la possibilité de les convertir en sceaux de guerre, qui permettent aux personnages-joueurs d’utiliser une pièce pour obtenir un butin supplémentaire lors des rencontres de raid.", itIT="Il fortunato e felice possessore dei Talismani Inferiori Portafortuna potrà convertirli in Sigilli di Guerra, che possono essere giocati per tentare di vincere una ricompensa bonus nelle incursioni.", koKR="행운의 하급 부적을 지니고 있으면 큰 복이 찾아오며, 후에 전쟁벼림 인장으로 교환할 수 있습니다. 전쟁벼림 인장을 사용하면 공격대 우두머리 전투에서 추가 보상을 획득할 기회를 얻을 수 있습니다.", ptBR="Possuir o Amuleto Menor de Boa Sorte resulta em grande felicidade e na conversão do item em Selos Forjados para a Guerra, que permite que os jogadores arrisquem uma moeda para receber uma recompensa extra por encontros em raide.", ruRU="Обладателей малых амулетов удачи ждет огромное счастье. Кроме того, со временем они смогут обменять амулеты на закаленные в бою печати, которые дают шанс на дополнительную добычу за победу над рейдовыми боссами.", zhCN="携带次级好运护符能带来好运，并能最终兑换战火徽记，使玩家在赢得团队副本战斗后有机会使用一枚硬币来赢取额外的奖励。", zhTW="持有次級好運符咒的人能獲得莫大的幸福，這些符咒最終會轉變成戰鑄徽印，讓持有人能在團隊戰鬥裡獲得額外獎勵。" },
	[752] = { enUS="Possession of the Mogu Rune of Fate allows its lucky owner to risk a rune to receive a bonus reward from the Throne of Thunder, Nalak or Oondasta.", deDE="Der Besitz von Schicksalsrunen der Mogu gestattet es dem glücklichen Eigentümer, eine Rune für eine Chance einzusetzen, zusätzliche Beute im Thron des Donners, von Nalak oder von Oondasta zu erhalten.", esES="Poseer una runa del destino mogu permite al afortunado propietario obtener una recompensa extra del Solio del Trueno, de Nalak o de Oondasta.", esMX="Poseer una runa del destino mogu permite al afortunado propietario obtener una recompensa extra del Solio del Trueno, de Nalak o de Oondasta.", frFR="Posséder une rune du destin mogu permet à son chanceux propriétaire de l’utiliser pour obtenir un butin supplémentaire au Trône du tonnerre, sur Nalak ou sur Oondasta.", itIT="Il fortunato possessore di una Runa Mogu del Fato può giocarla per tentare di vincere una ricompensa bonus nel Regno del Tuono, da Nalak o da Undasta.", koKR="이 룬을 사용하면 천둥의 왕좌 우두머리, 나락크, 운다스타로부터 추가 보상을 획득할 기회를 얻을 수 있습니다.", ptBR="Possuir a Runa Mogu do Destino permite que o proprietário sortudo arrisque uma moeda para receber uma recompensa-bônus de Trono do Trovão, Nalak ou Oondasta.", ruRU="Счастливые обладатели руны судьбы могу могут испытать судьбу и получить шанс на дополнительную добычу за победу над рейдовыми боссами Престола Грома, Налаком или Ундастой.", zhCN="魔古命运符文的拥有者也许能在战胜雷电王座中的首领后，以及在战胜纳拉克或乌达斯塔后获得额外的战利品奖励。", zhTW="持有魔古的命運符文便有機會用一枚符文從雷霆王座、納拉卡或烏達斯塔獲得額外獎勵。" },
	[776] = { enUS="Possession of the Warforged Seal allows its lucky owner to risk a seal to receive a bonus reward from the Siege of Orgrimmar, the Celestial Trials, and Ordos.", deDE="Der Besitz von Kriegsemblemen gestattet es dem glücklichen Eigentümer, ein Emblem für eine Chance einzusetzen, zusätzliche Beute in der Schlacht um Orgrimmar, den Prüfungen der Erhabenen und von Ordos zu erhalten.", esES="Poseer un sello forjado por la guerra permite al afortunado propietario jugarse un sello para obtener una recompensa extra del Asedio de Orgrimmar, las pruebas de los Celestiales u Ordos.", esMX="Poseer un sello forjado por la guerra permite al afortunado propietario jugarse un sello para obtener una recompensa extra del Asedio de Orgrimmar, las pruebas de los Celestiales u Ordos.", frFR="Posséder un sceau de guerre permet à son chanceux propriétaire de l’utiliser pour obtenir un butin supplémentaire au Siège d’Orgrimmar, aux épreuves des Astres vénérables et sur Ordos.", itIT="Il fortunato possessore di un Sigillo di Guerra può giocarlo per tentare di vincere una ricompensa bonus nell'Assedio di Orgrimmar, alle Prove dei Celestiali e da Ordos.", koKR="이 인장을 사용하여 오그리마 공성전, 천신의 시합, 오르도스와의 전투에서 추가 보상을 획득할 기회를 얻을 수 있습니다.", ptBR="Possuir o Selo Forjado para a Guerra permite que o proprietário sortudo arrisque um selo para receber uma recompensa bônus pelo Cerco a Orgrimmar, pelas Provações Celestiais e por Ordos.", ruRU="Счастливые обладатели закаленной в бою печати могу могут испытать судьбу и получить шанс на дополнительную добычу во время Осады Оргриммара, боев с Небожителями или сражения с Ордосом.", zhCN="拥有战火徽记的幸运儿有机会在决战奥格瑞玛、天神试炼和斡耳朵圣殿中用一枚徽记换取一份额外奖励。", zhTW="持有戰鑄徽印便有機會用一枚徽印從圍攻奧格瑪、天尊試煉和歐朵斯的戰鬥獲得額外獎勵。" },
	[777] = { enUS="You feel the shadowy fingers of previous and future owners of this coin playing across your hand, as if time itself blurs. Spend upon the Timeless Isle to earn powerful and fluid rewards.", deDE="Ihr spürt, wie die schemenhaften Hände vergangener und zukünftiger Eigentümer dieser Münze über Eure Hand fahren, als wären die Grenzen der Zeit aufgehoben. Gebt diese Währung auf der Zeitlosen Insel für mächtige und flüssige Belohnungen aus.", esES="Sientes los fantasmales dedos de antiguos y futuros dueños de esta moneda jugando en tu mano, como si el propio tiempo se desdibujara. Puedes gastar estas monedas en la Isla Intemporal para obtener poderosas y variadas recompensas.", esMX="Sientes los fantasmales dedos de antiguos y futuros dueños de esta moneda jugando en tu mano, como si el propio tiempo se desdibujara. Puedes gastar estas monedas en la Isla Intemporal para obtener poderosas y variadas recompensas.", frFR="Vous sentez les doigts des propriétaires passés et à venir de cette pièce, comme si le temps lui-même devenait flottant. Dépensez-la sur l’île du Temps figé pour obtenir des récompenses changeantes et puissantes.", itIT="Tenendola in mano si percepiscono le energie oscure dei passati e futuri possessori di questa moneta, come se il tempo stesso si offuscasse. È possibile spenderla sull'Isola Senza Tempo per comprare potenti e mutevoli ricompense.", koKR="과거에 이 주화를 소유했던 주인의 흐릿한 손길이 당신 손을 어루만지는 느낌과 함께, 마치 시간 그 자체가 희미해지는 것만 같은 기분이 듭니다. 영원의 섬에서 강력하고 우아한 보상을 구입하는 데 사용합니다.", ptBR="Você sente os dedos sombrios de antigos e futuros donos da moeda mexer na sua mão, como se o próprio tempo fosse um borrão. Gaste-a na Ilha Perene para receber recompensas fluidas e poderosas.", ruRU="Вы чувствуете прикосновения призрачных пальцев предыдущих владельцев монеты, как будто ткань времени рвется. Вы можете использовать эту монету на Вневременном острове для получения ценных наград.", zhCN="你在恍惚中感觉到这枚铸币过去与未来的拥有者的手指拂过你的掌心，仿佛时间的界限被模糊了。你可以用它在永恒岛上换取强大且多样性的奖励。", zhTW="彷彿時光重疊般，你感覺到有陰影般的指尖撫過你的手掌，那是這枚硬幣過往與將來的持有者的朦朧印象。在永恆之島上，可以用這些硬幣獲得強大而多樣的獎勵。" },
	[789] = { enUS="Pulled from the steaming corpses of foes vanquished in the mists of the Timeless Isle.", deDE="Erbeutet von den noch warmen Leichen besiegter Gegner in den Nebeln der Zeitlosen Insel.", esES="Obtenida de los cadáveres humeantes de enemigos derrotados en las brumas de la Isla Intemporal.", esMX="Obtenida de los cadáveres humeantes de enemigos derrotados en las brumas de la Isla Intemporal.", frFR="Récupérée sur le corps des ennemis vaincus dans les brumes de l’île du Temps figé.", itIT="Recuperata dai corpi fumanti dei nemici sconfitti tra le nebbie dell'Isola Senza Tempo.", koKR="영원의 섬의 안개 속에서 쓰러진 적의 따뜻한 유해에서 꺼낸 동전입니다.", ptBR="Arrancada dos corpos fumegantes de inimigos vencidos em meio às névoas da Ilha Perene.", ruRU="Эту монету можно найти на еще теплых телах врагов, встретивших смерть в туманах Вневременного острова.", zhCN="从死于永恒岛周围迷雾中的敌人身上摸来的铸币。", zhTW="在永恆之島的迷霧中，從你擊敗的敵人還熱氣騰騰的屍體上扯下來的。" },
	[810] = { enUS="Scavenged from the shattered armor and weapons of Iron Horde invaders.", deDE="Von den zerschmetterten Rüstungen und Waffen der Eisernen Horde erbeutet.", esES="Recuperado de la armadura y de las armas destrozadas de invasores de la Horda de Hierro.", esMX="Recogidas de las armaduras y las armas destrozadas de los invasores de la Horda de Hierro.", frFR="Récupérés sur les armes et armures brisées des envahisseurs de la Horde de Fer.", itIT="Ricavato dalle armature e dalle armi distrutte degli invasori dell'Orda di Ferro.", koKR="강철 호드 침략자들의 부서진 방어구와 무기에서 주워 모은 것입니다.", ptBR="Coletado das armaduras e armas partidas dos invasores da Horda de Ferro.", ruRU="Утилизированное из поврежденного оружия и доспехов захватчиков Железной Орды.", zhCN="从钢铁部落入侵者碎裂的护甲和武器中翻检出的金属碎片。", zhTW="從鋼鐵部落的入侵者身上取得的護甲及武器碎塊。" },
	[823] = { enUS="The enduring legacy of a lost civilization, Apexis crystals contain untold reserves of magical power.", deDE="Apexiskristalle, das fortdauernde Vermächtnis einer verlorenen Zivilisation, enthalten ungeahnte magische Kraft.", esES="Los cristales apexis, el eterno legado de una civilización perdida, contienen una incalculable reserva de poder mágico.", esMX="El perdurable legado de una civilización perdida, los cristales de ápices contienen reservas incalculables de poder mágico.", frFR="Héritage tenace d’une civilisation perdue, les cristaux apogides contiennent des réserves insoupçonnables de puissance magique.", itIT="I Cristalli Apexis, eredità duratura di una civiltà perduta, contengono incalcolabili riserve di potere magico.", koKR="사라진 문명의 잔존하는 유산인 에펙시스 수정에는, 언어를 통해서는 제대로 표현할 수 없는 마법의 힘이 담겨 있습니다.", ptBR="Os cristais Apexis, o legado duradouro de uma civilização perdida, contêm reservas incalculáveis de poder mágico.", ruRU="Апекситовые кристаллы, оставшиеся от давно угасшей древней цивилизации, заключают в себе практически неисчерпаемые резервы магической энергии.", zhCN="作为一个失落文明的古老遗产，埃匹希斯水晶蕴藏着难以想象的强大魔力。", zhTW="頂尖水晶是失落古文明遺留下來的遺產，裡面儲存了難以言喻的魔法能量。" },
	[824] = { enUS="Earn resources to build-up and expand your garrison.", deDE="Verdient Ressourcen, um Eure Garnison aufzubauen und zu erweitern.", esES="Obtén recursos para mejorar y expandir tu ciudadela.", esMX="Gana recursos para reforzar y expandir tu fortaleza.", frFR="Obtenez des ressources pour construire et faire prospérer votre fief.", itIT="Ottieni risorse per costruire ed espandere la tua Guarnigione.", koKR="주둔지의 건물을 건설하고 확장하는 데 사용되는 자원입니다.", ptBR="Obtenha recursos para construir e expandir sua guarnição.", ruRU="Добывайте ресурсы, чтобы отстраивать и расширять ваш гарнизон.", zhCN="赚取资源以建造和扩大你的要塞。", zhTW="建造和擴展你要塞的資源。" },
	[910] = { enUS="Allows you to obtain new Alchemy recipes from the Alchemist's Lab.", deDE="Ermöglicht es Euch, neue Alchemierezepte aus dem Alchemielabor zu erhalten.", esES="Te permite obtener nuevas recetas de alquimia del laboratorio de alquimia.", esMX="Permite obtener nuevas recetas de alquimia del Laboratorio del alquimista.", frFR="Vous permet d’obtenir de nouvelles recettes d’alchimie au laboratoire d’alchimie.", itIT="Ti permette di ottenere nuove ricette di Alchimia presso il Laboratorio Alchemico.", koKR="연금술사의 연구실에서 새로운 연금술 조제법을 알아낼 수 있습니다.", ptBR="Permite que você obtenha novas receitas de Alquimia do Laboratório do Alquimista.", ruRU="Открывает доступ к новым рецептам для алхимиков в алхимической лаборатории.", zhCN="让你可通过炼金实验室获得新的炼金配方。", zhTW="讓你從鍊金實驗室取得新的鍊金術配方。" },
	[944] = { enUS="A tiny fragment of an Ashran lost artifact, treasured by the Highmaul Ogres.", deDE="Ein winziges Fragment eines verschollenen Artefakts von Ashran, das die Hochfelsoger sehr schätzen.", esES="Un fragmento minúsculo de un artefacto perdido de Ashran, muy preciado por los ogros de Ogrópolis.", esMX="Un pequeño fragmento de un artefacto perdido de Ashran, atesorado por los ogros Gran Magullador.", frFR="Un minuscule fragment d’une relique perdue d’A’shran, conservé précieusement par les ogres de Cognefort.", itIT="Un piccolo frammento di un Manufatto di Ashran perduto, particolarmente prezioso per gli Ogre Altomaglio.", koKR="아주 작은, 아쉬란의 잃어버린 유물 조각입니다. 높은망치 오우거들이 아끼는 물품입니다.", ptBR="Pequeno fragmento de artefato Ashran perdido. Cobiçado pelos Ogros do Malho Imponente.", ruRU="Крохотный фрагмент утраченного ашранского артефакта, высоко ценимый ограми клана Верховного Молота.", zhCN="一块阿什兰失落神器的小碎片，被悬槌食人魔视为珍宝。", zhTW="天槌巨魔把這些艾斯蘭失落文物的小碎片當成寶貝。" },
	[980] = { enUS="Perhaps they're more valuable than they appear on the surface.", deDE="Vielleicht sind sie wertvoller, als sie auf den ersten Blick erscheinen.", esES="Quizás sean más valiosas de lo que aparentan.", esMX="Quizás sean más valiosos de lo que parecen a simple vista.", frFR="Ils ont peut-être plus de valeur qu’ils ne le paraissent.", itIT="Probabilmente valgono più di quanto sembri.", koKR="겉보기보다 훨씬 가치 있는 물건인지도 모르겠습니다.", ptBR="Talvez sejam mais valiosas do que aparentam na superfície.", ruRU="Возможно, они ценнее, чем кажутся на первый взгляд.", zhCN="或许它们比表面上看起来的要珍贵得多。", zhTW="雖然看起來髒髒的，不過說不定相當有價值。" },
	[994] = { enUS="Twists fate to provide an opportunity for additional treasure in Highmaul or Blackrock Foundry raids.", deDE="Verändert Euer Schicksal und gibt Euch die Möglichkeit, beim Schlachtzug in der Schwarzfelsgießerei oder in Hochfels zusätzliche Schätze zu erhalten.", esES="Altera el destino para ofrecer una oportunidad adicional de obtener botín en Ogrópolis o en la Fundición Roca Negra.", esMX="Retuerce el destino para proporcionar una oportunidad de ganar un tesoro más en las bandas Gran Magullador o Fundición de Roca Negra.", frFR="Modifie le destin pour donner l’occasion de trouver un trésor supplémentaire dans les raids de Cognefort ou la fonderie des Rochenoires.", itIT="Manipola il destino per avere l'opportunità di trovare tesori aggiuntivi ad Altomaglio o nella Fonderia dei Roccianera.", koKR="운명을 뒤틀어 높은망치 또는 검은바위 용광로 공격대에서 추가 보물을 얻을 기회를 줍니다.", ptBR="Distorce o destino para conceder uma oportunidade de conseguir tesouros adicionais nos raides do Malho Imponente ou da Fundição da Rocha Negra.", ruRU="Позволяет вмешиваться в естественный ход событий и предоставляет возможность получения дополнительных сокровищ в рейдах в землях клана Верховного Молота и Литейной Черной горы.", zhCN="扭曲命运，可给你一次在悬槌堡或黑石铸造厂团队副本获得额外宝物的机会。", zhTW="在天槌或黑石鑄造場團隊副本中，可用來扭轉命運，有機會獲得額外的寶藏。" },
	[999] = { enUS="Allows you to obtain Tailoring recipes from the Tailoring Emporium.", deDE="Ermöglicht es Euch, Schneidereirezepte aus der Maßschneiderei zu erhalten.", esES="Te permite obtener recetas de sastrería del emporio de sastrería.", esMX="Te permite obtener nuevas recetas de sastrería del emporio de sastrería.", frFR="Vous permet d’obtenir des patrons de couture à l’atelier de couture.", itIT="Ti permette di ottenere nuovi modelli di Sartoria presso l'Atelier di Sartoria.", koKR="재봉술 잡화점에서 새로운 재봉술 도안을 알아낼 수 있습니다.", ptBR="Permite que você obtenha novas receitas de Alfaiataria no Ateliê de Costura.", ruRU="Открывает доступ к новым рецептам для портных в швейной лавке.", zhCN="可让你从裁缝店获得新的裁缝配方。", zhTW="讓你從裁縫百貨取得裁縫圖樣。" },
	[1008] = { enUS="Allows you to obtain new Jewelcrafting recipes.", deDE="Ermöglicht es Euch, neue Juwelierskunstrezepte zu erhalten.", esES="Te permite obtener nuevas recetas de joyería.", esMX="Te permite obtener nuevas recetas de joyería.", frFR="Permet d'obtenir de nouveaux dessins de joaillerie.", itIT="Ti permette di ottenere nuovi modelli di Oreficeria.", koKR="새로운 보석세공 디자인을 획득할 수 있습니다.", ptBR="Possibilita a obtenção de novas receitas de Joalheria.", ruRU="Открывает доступ к новым рецептам для ювелиров.", zhCN="可让你获得新的珠宝加工配方。", zhTW="讓你取得新的珠寶學設計圖。" },
	[1017] = { enUS="Allows you to obtain Leatherworking recipes from the Tannery.", deDE="Ermöglicht es Euch, Lederverarbeitungsrezepte aus der Gerberei zu erhalten.", esES="Te permite obtener recetas de peletería.", esMX="Te permite obtener nuevas recetas de peletería.", frFR="Vous permet d’obtenir des patrons de travail du cuir à la tannerie.", itIT="Ti permette di ottenere nuovi modelli di Conciatura presso la Conceria.", koKR="가죽상점에서 새로운 가죽세공 도안을 획득할 수 있습니다.", ptBR="Permite que você obtenha receitas de Couraria no Curtume.", ruRU="Открывает доступ к новым рецептам для кожевников в дубильне.", zhCN="可让你从制革厂获得新的制皮配方。", zhTW="讓你從製皮廠取得製皮圖樣。" },
	[1020] = { enUS="Allows you to obtain new Blacksmithing recipes.", deDE="Ermöglicht es Euch, neue Schmiedekunstrezepte zu erhalten.", esES="Te permite obtener nuevas recetas de herrería.", esMX="Te permite obtener nuevas recetas de herrería.", frFR="Permet d'obtenir de nouveaux plans de forge.", itIT="Ti permette di ottenere nuovi progetti di Forgiatura.", koKR="새로운 대장기술 도면을 획득할 수 있습니다.", ptBR="Permite que você obtenha novas receitas de Ferraria.", ruRU="Открывает доступ к новым рецептам для кузнецов.", zhCN="可让你获得新的锻造配方。", zhTW="讓你取得新的鍛造設計圖。" },
	[1101] = { enUS="Found primarily in Tanaan Jungle, Oil is used to fuel naval missions.", deDE="Öl ist primär im Tanaandschungel zu finden und wird als Treibstoff bei Marinemissionen verwendet.", esES="El petróleo se encuentra principalmente en la Selva de Tanaan, y se utiliza como combustible en misiones navales.", esMX="El petróleo, que se encuentra principalmente en la Jungla Tanaan, se usa para las misiones navales.", frFR="Trouvé principalement dans la jungle de Tanaan, ce carburant est utilisé pour alimenter les navires lors des missions navales.", itIT="Trovato principalmente nella Giungla di Tanaan, il Petrolio serve ad alimentare le navi per le missioni navali.", koKR="주로 타나안 밀림에서 발견되는 석유는 해상 임무에 연료로 사용됩니다.", ptBR="Encontrado principalmente na Selva de Tanaan, o Óleo é usado em missões navais.", ruRU="Нефть встречается главным образом в Танаанских джунглях и используется в заданиях для флота.", zhCN="主要产于塔纳安丛林的原油，可以作为海军行动的燃油。", zhTW="油料是執行海上任務的必要資源，主要可從塔南森林尋獲。" },
	[1129] = { enUS="Twists fate to provide an opportunity for additional treasure in Hellfire Citadel or Draenor Mythic Dungeons.", deDE="Wendungen des Schicksals gewähren eine Chance, zusätzliche Beute in der Höllenfeuerzitadelle oder mythischen Dungeons in Draenor zu machen.", esES="Altera el destino para ofrecer una oportunidad adicional de obtener botín en la Ciudadela del Fuego Infernal o en mazmorras míticas de Draenor.", esMX="Retuerce el destino para dar la oportunidad de obtener más tesoros en la Ciudadela del Fuego Infernal o en Calabozos míticos de Draenor.", frFR="Modifie le destin pour donner l’occasion de trouver un trésor supplémentaire dans la citadelle des Flammes infernales ou dans les donjons mythiques de Draenor.", itIT="Manipola il destino per avere l'opportunità di trovare tesori aggiuntivi nella Cittadella del Fuoco Infernale o nelle spedizioni di Draenor in modalità Mitica.", koKR="운명을 뒤틀어 지옥불 성채 또는 드레노어 신화 난이도 던전에서 추가 보물을 얻을 기회를 줍니다.", ptBR="Distorce o destino para conceder uma oportunidade de encontrar tesouros adicionais na Cidadela Fogo do Inferno ou nas Masmorras Míticas de Draenor.", ruRU="Позволяет вмешиваться в естественный ход событий и предоставляет возможность получения дополнительных сокровищ в рейдах в Цитадели Адского Пламени или эпохальных подземельях Дренора.", zhCN="扭转命运，可给你一次在地狱火堡垒或德拉诺史诗地下城获得额外宝物的机会。", zhTW="在地獄火堡壘或德拉諾傳奇難度的地城中，可用來扭轉命運，有機會獲得額外的寶藏。" },
	[1149] = { enUS="A rough, hand-minted coin. It bears a symbol similar to that of the Kirin Tor, with one key difference: the eye is closed.", deDE="Eine grobe, von Hand geprägte Münze. Das abgebildete Symbol ähnelt dem der Kirin Tor, weist aber einen wichtigen Unterschied auf: Das Auge ist geschlossen.", esES="Una irregular moneda acuñada a mano. Tiene un símbolo parecido al del Kirin Tor, con una diferencia crucial: el ojo está cerrado.", esMX="Una moneda tosca, hecha a mano. Lleva un símbolo similar al de los Kirin Tor, con una diferencia específica: el ojo está cerrado.", frFR="Une pièce grossière, frappée à la main. Elle est ornée d’un symbole qui rappelle celui du Kirin Tor, à un détail près : l’œil est fermé.", itIT="Una moneta grezza coniata a mano. Reca un simbolo simile a quello del Kirin Tor, con una differenza fondamentale: l'occhio è chiuso.", koKR="손으로 주조해 만든 거친 동전입니다. 키린 토의 것과 비슷한 상징이 담겨 있지만, 한 가지가 다릅니다. 이 동전의 것은 눈을 감고 있습니다.", ptBR="Uma moeda rústica, gravada a mão. Traz um símbolo similar ao do Kirin Tor, com uma diferença fundamental: o olho está fechado.", ruRU="Примитивная, вручную отчеканенная монета. На ней изображен символ, похожий на знак Кирин-Тора, но с одним отличием: глаз закрыт.", zhCN="一枚粗糙的手工硬币，上面有一个类似肯瑞托的徽记，但有一个最大的不同点：那个眼睛是闭着的。", zhTW="手工打造的粗糙硬幣。上面的圖案和祈倫托的符號很像，但關鍵的差異在於：它的眼睛是閉起來的。" },
	[1154] = { enUS="Prized by pickpockets and marks alike. Can be spent in the Underbelly below Dalaran.", deDE="Von Taschendieben und ihren Opfern gleichermaßen geschätzt. Können in der Schattenseite unter Dalaran ausgegeben werden.", esES="Muy apreciadas por los carteristas y gente de similar calaña. Se pueden gastar en Los Bajos Fondos, debajo de Dalaran.", esMX="Preciadas tanto por ladrones como por blancos. Se pueden gastar en los Bajos Fondos de Dalaran.", frFR="Prisées des voleurs à la tire comme de leurs cibles. Peuvent être dépensées dans les Entrailles de Dalaran.", itIT="Di grande valore per i borseggiatori e... i polli. Può essere speso nei Sotterranei di Dalaran.", koKR="소매치기와 상인들이 모두 귀하게 여기는 화폐입니다. 달라란 지하에 있는 마법의 뒤안길에서 사용할 수 있습니다.", ptBR="Apreciada igualmente por batedores de carteira e pelas vítimas deles. Pode ser gasta nos Esgotos sob Dalaran.", ruRU="Ценятся карманниками и прочими им подобными. Можно потратить в Клоаке под Далараном.", zhCN="在扒手以及类似阶层中广受欢迎。可以在达拉然的下水道中使用。", zhTW="扒手小偷和刺客之間流通的硬幣。可在達拉然底下的城底區使用。" },
	[1155] = { enUS="Concentrated magic from the ancient leylines beneath Suramar.", deDE="Konzentrierte Magie aus den uralten Leylinien, die unter Suramar liegen.", esES="Magia concentrada de las antiguas líneas Ley bajo Suramar.", esMX="Magia concentrada desde las antiguas líneas ley que se encuentran debajo de Suramar.", frFR="Puissance magique concentrée provenant des lignes telluriques anciennes qui courent sous Suramar.", itIT="Il potere magico concentrato delle antiche linee di faglia sotto Suramar.", koKR="수라마르 아래를 지나는 고대 지맥의 마법을 응축한 것입니다.", ptBR="Magia concentrada dos antigos meridianos abaixo de Suramar.", ruRU="Концентрированная магическая энергия древних силовых линий, пролегающих под Сурамаром.", zhCN="来自苏拉玛地下古代魔网的浓缩魔力。", zhTW="從蘇拉瑪爾地下的古老地脈聚集而來的魔法能量。" },
	[1166] = { enUS="Earned in Timewalking dungeons. Exchanged for goods from Timewalking Vendors in capitol cities.", deDE="Werden in Zeitwanderungsdungeons verdient. Können bei Zeitwanderungshändlern in den Hauptstädten gegen Waren eingetauscht werden.", esES="Se consigue en mazmorras de Paseo en el tiempo. Se intercambia por bienes en los vendedores de Paseo en el tiempo de las capitales.", esMX="Se obtiene en calabozos de cronoviaje. Se intercambia por bienes con los vendedores de cronoviajes en las capitales.", frFR="Obtenu dans les donjons des Marcheurs du temps. Peut être échangé auprès des vendeurs des Marcheurs du temps dans les capitales.", itIT="Guadagnato nelle spedizioni in modalità Viaggio nel Tempo. Spendibile dai Mercanti dei Viaggi nel Tempo nelle capitali.", koKR="시간여행 던전에서 획득할 수 있습니다. 시간 여행 상인들에게서 물건을 구입하는 데 사용됩니다.", ptBR="Obtido em masmorras de Caminhada Temporal. Trocado por mercadorias de Comerciantes de Caminhada Temporal nas capitais.", ruRU="Получено в подземелье в режиме путешествия во времени. Можно предложить продавцам товаров для путешественников во времени в столицах.", zhCN="在时空漫游地下城中获得，可以在主城的时空漫游商人处换取货物。", zhTW="在時光漫遊地城獲得。用來在主城向時光漫遊商人購買商品。" },
	[1171] = { enUS="Increases the rate at which you earn Artifact Power.", deDE="Erhöht die Zuwachsrate Eurer Artefaktmacht.", esES="Aumenta la velocidad a la que ganas poder de artefacto.", esMX="Aumenta el ritmo con el que ganas poder de artefacto.", frFR="Augmente les gains de puissance prodigieuse.", itIT="Aumenta la frequenza con cui ottieni Potere Artefatto.", koKR="유물력 획득량이 증가합니다.", ptBR="Aumenta a taxa de recebimento de Poder do Artefato.", ruRU="Увеличивают скорость прироста силы артефакта.", zhCN="提高你获得神器能量的速度。", zhTW="提高你獲得神兵之力的速率。" },
	[1191] = { enUS="A currency used to increase the power of items from Hellfire Citadel, Tanaan Jungle, Draenor Dungeons, and powerful crafted items.", deDE="Eine Währung, mit der Gegenstände verbessert werden können. Erlaubt das Verbessern von mächtigen hergestellten Gegenständen und Gegenständen aus der Höllenfeuerzitadelle, dem Tanaandschungel und Draenordungeons.", esES="Una moneda empleada para aumentar el poder de potentes objetos creados y de objetos de la Ciudadela del Fuego Infernal, la Selva de Tanaan y las mazmorras de Draenor.", esMX="Una moneda que se usa para aumentar el poder de los objetos de la Ciudadela del Fuego Infernal, la Jungla Tanaan, los calabozos de Draenor, y los objetos artesanales poderosos.", frFR="Une monnaie utilisée pour augmenter la puissance des objets de la citadelle des Flammes infernales, de la jungle de Tanaan, des donjons de Draenor, et de puissants objets d’artisanat.", itIT="Una valuta utilizzata per potenziare gli oggetti della Cittadella del Fuoco Infernale, della Giungla di Tanaan, delle spedizioni di Draenor e degli equipaggiamenti artigianali più potenti.", koKR="지옥불 성채, 타나안 밀림, 드레노어 던전에서 획득한 아이템과, 강력한 제작 아이템의 힘을 증가시키는 데 사용되는 화폐입니다.", ptBR="Uma moeda usada para aumentar o poder de itens da Cidadela Fogo do Inferno, da Selva de Tanaan, de Masmorras de Draenor e de poderosos itens criados.", ruRU="Валюта, которая используется для усиления предметов, полученных в Цитадели Адского Пламени, Танаанских джунглях и подземельях Дренора, а также для улучшения могущественных созданных предметов.", zhCN="用于强化来自地狱火堡垒、塔纳安丛林、德拉诺地下城以及强大的制造物品能力的货币。", zhTW="用來強化從地獄火堡壘、塔南森林、德拉諾地城獲得的物品，以及強力手工物品的通貨。" },
	[1220] = { enUS="Used to recruit troops, run missions, and research upgrades for your order hall.", deDE="Kann dazu verwendet werden, Trupps zu rekrutieren, Missionen zu starten und Verbesserungen Eurer Ordenshalle zu erforschen.", esES="Se usan para reclutar tropas, realizar misiones e investigar mejoras para la sede de tu clase.", esMX="Se usa para reclutar tropas, ejecutar misiones e investigar mejoras para tu Sala de orden.", frFR="Utilisées pour recruter des troupes, effectuer des missions et rechercher des améliorations pour votre domaine de classe.", itIT="Usate per reclutare truppe, avviare missioni e ricercare potenziamenti per la tua Enclave di Classe.", koKR="병력을 소집하고, 임무를 수행하고, 연맹 전당에서 연구를 하는 데 사용됩니다.", ptBR="Usados para recrutar tropas, realizar missões e pesquisar aprimoramentos no seu Salão da Ordem.", ruRU="Используются для вербовки отрядов, выполнения заданий и исследования улучшений оплота класса.", zhCN="用来招募部队，执行任务和研究职业大厅的升级选项。", zhTW="可以用來招募部隊、執行任務和升級職業大廳。" },
	[1226] = { enUS="A fragment of crystallized nether brought to Azeroth by the Legion.", deDE="Ein kristallisiertes Netherfragment, das mit dem Einfall der Legion nach Azeroth gekommen ist.", esES="Un fragmento de vacío cristalizado que la Legión ha llevado a Azeroth.", esMX="Un fragmento de vacío cristalizado que la Legión llevó a Azeroth.", frFR="Un fragment de Néant cristallisé apporté sur Azeroth par la Légion.", itIT="Un frammento cristallizzato di Fatuo, portato su Azeroth dalla Legione.", koKR="군단이 아제로스로 가져 온 결정화된 황천 조각입니다.", ptBR="Um fragmento de éter cristalizado trazido para Azeroth pela Legião.", ruRU="Фрагмент кристаллизованной Пустоты, принесенный на Азерот Легионом.", zhCN="虚空的结晶碎片，由燃烧军团带到艾泽拉斯。", zhTW="虛空能量晶化而成的碎片，由燃燒軍團帶來到艾澤拉斯。" },
	[1268] = { enUS="A mysterious naga artifact from the depths of the Great Sea. King Mrgl-Mrgl is looking for these at Timeworn Strand.", deDE="Ein mysteriöses Nagaartefakt aus den Tiefen des Großen Meeres. König Mrgl-Mrgl sucht am Verwitterten Strand nach diesen Objekten.", esES="Un misterioso artefacto naga de las profundidades del Mare Magnum. El rey Mrgl-Mrgl los busca en Ensenada Marchita.", esMX="Un artefacto naga misterioso de las profundidades del Mare Magnum. El rey Mrgl-Mrgl los está buscando en la Ensenada Marchita.", frFR="Mystérieux artéfact naga issu des profondeurs de la Grande mer. Le roi Mrgl-Mrgl écume le rivage Érodé à la recherche de tels objets.", itIT="Un misterioso manufatto dei Naga proveniente dalle profondità del Grande Mare. Il Re Mrgl-Mrgl lo sta cercando presso la Riva Logora.", koKR="대해 깊은 곳에서 발견된 신비한 나가 유물입니다. 시간에 바랜 해안에서 멀록왕 아옳아옳이 이 유물을 찾고 있습니다.", ptBR="Um misterioso artefato naga das profundezas do Grande Oceano. O rei Mrgl-Mrgl está procurando por estes artefatos na Barra dos Tempos Idos.", ruRU="Загадочный артефакт наг из глубин Великого моря. Такие разыскивает король Мргл-Мргл на Древнем берегу.", zhCN="一件来自无尽之海深处的神秘纳迦神器。国王姆嘎姆嘎正在上古海滩寻找这种东西。", zhTW="從無盡之海深處尋得的神秘納迦文物。莫戈莫戈大王正在時朽海灘尋找這類物品。" },
	[1273] = { enUS="Twists fate to provide an opportunity for additional treasure from Legion raid and Mythic dungeon bosses.", deDE="Wendungen des Schicksals gewähren eine Chance, zusätzliche Beute von Bossen in Schlachtzügen und mythischen Dungeons von Legion zu erhalten.", esES="Altera el destino para ofrecer una oportunidad adicional de obtener botín de jefes de bandas y mazmorras míticas de Legion.", esMX="Tuerce el destino para dar la oportunidad de obtener más tesoros de los jefes de banda de Legion y calabozos míticos.", frFR="Modifie le destin pour donner l’occasion de trouver un trésor supplémentaire sur les boss de raid et de donjon mythiques de Legion.", itIT="Manipola il destino per avere l'opportunità di trovare tesori aggiuntivi nelle spedizioni in modalità Mitica e nelle incursioni di Legion.", koKR="운명을 뒤틀어 군단 공격대와 신화 던전 우두머리에게서 추가 보물을 얻을 기회를 줍니다.", ptBR="Distorce o destino para conceder uma oportunidade de obter tesouros adicionais de chefes de masmorras Míticas e raides de Legion.", ruRU="Позволяет вмешиваться в естественный ход событий и предоставляет возможность получения дополнительных сокровищ в рейдах дополнения Legion и при убийстве боссов подземелий в эпохальном режиме.", zhCN="扭转命运，可给你一次在《军团再临》团队副本和史诗地下城的首领处获得额外宝物的机会。", zhTW="從軍團團隊和傳奇難度地城首領取得，可用來扭轉命運，有機會獲得額外的寶藏。" },
	[1275] = { enUS="This unusual coin is warm to the touch and vibrates gently in your hand. Used to procure items from Xur'ios in Dalaran.", deDE="Diese ungewöhnliche Münze fühlt sich warm an und vibriert sanft in Eurer Hand. Sie kann verwendet werden, um Gegenstände von Xur'ios in Dalaran zu erwerben.", esES="Esta inusual moneda está caliente al tacto y vibra con suavidad en tu mano. Se usa para conseguir objetos de Xur'ios en Dalaran.", esMX="Esa moneda inusual es cálida al tacto y vibra suavemente en tu mano. Se usa para obtener objetos de Xur'ios en Dalaran.", frFR="Cette monnaie étrange est chaude au toucher et vibre légèrement sous les doigts. Elle est utile pour faire affaire avec Xur’ios à Dalaran.", itIT="Questa strana moneta è calda al tocco e vibra leggermente. Viene usata per acquistare oggetti da Xur'ios a Dalaran.", koKR="낯선 동전에 손을 대니 어딘가 따뜻한 기운이 느껴지며 부드럽게 떨립니다. 예전에 달라란의 줄로스에게서 물품을 구입할 때 사용되었습니다.", ptBR="Essa moeda incomum é quente e vibra um pouco em suas mãos. Usada para obter itens com Xur'ios, em Dalaran.", ruRU="Эта необычная монета – теплая на ощупь и слегка вибрирует в вашей руке. Такие принимает торговец Ксур'иос в Даларане.", zhCN="这种特别的货币摸上去热乎乎的，并在你手中轻轻震动着。可以用来向达拉然的苏伊奥斯购买物品。", zhTW="這枚奇特的硬幣觸手生溫，還會在你的掌中微微顫動。可用來和達拉然的瑟里歐斯換取物品。" },
	[1299] = { enUS="Awarded to victors of the Brawler's Guild. Use it to purchase Rumble Cards and other world-altering items at the Brawler's Gold Exchange vendor.", deDE="Verliehen an Sieger der Kampfgilde. Kann bei einem Händler in der Goldbörse der Kampfgilde gegen Prügeleikarten und andere weltverändernde Gegenstände eingetauscht werden.", esES="Otorgado a los vencedores de la Hermandad de camorristas. Usa esto para adquirir cartas de reyerta y otros objetos para alterar el mundo en el vendedor de intercambio por oro de los camorristas.", esMX="Otorgado a los ganadores del Gremio de luchadores. Úsalo para comprar cartas de reyerta y otros objetos para alterar el mundo en el vendedor de intercambio de oro de los luchadores.", frFR="Obtenu par les vainqueurs des Bastonneurs. Utilisez-le pour acheter des cartes de bastonnade et autres objets de modification du monde auprès des changeurs d’or des Bastonneurs.", itIT="Guadagnato vincendo gli scontri al Circolo dei Combattenti. Utilizzabile per comprare le Carte Rissa e altri oggetti utili presso la Mercante d'Oro dei Combattenti.", koKR="싸움꾼 조합의 승리자들에게 수여됩니다. 싸움꾼의 골드 상인에게서 난장 카드와 기타 혁신적인 아이템을 구입하는 데 사용합니다.", ptBR="Dado aos vencedores da Guilda dos Brigões. Use-o para comprar Cartões de Briga e outros itens que alteram o mundo no Câmbio de Ouro dos Brigões.", ruRU="Награда победителям арены бойцовской гильдии. Используйте этот предмет для приобретения карточек разборок и других влияющих на окружение предметов у торговца предметами за бойцовское золото.", zhCN="搏击俱乐部的获胜者得到的奖励。可以用它在拳手金币兑换商处购买乱斗卡牌和其他能够改变世界的物品。", zhTW="鬥陣俱樂部勝利者的獎勵。可用來向鬥陣金幣交易商人購買格鬥卡以及其他物品。" },
	[1314] = { enUS="Soul fragment once belonging to a powerful enemy.", deDE="Ein Seelenfragment, das einst einem mächtigen Gegner gehört hat.", esES="Trozo de alma que pertenecía a un enemigo poderoso.", esMX="Fragmento de alma que perteneció a un enemigo poderoso.", frFR="Fragment d’âme ayant autrefois appartenu à un ennemi puissant.", itIT="Frammento d'anima un tempo appartenente a un potente nemico.", koKR="한때 강력한 적에게 담겨 있었던 영혼의 파편입니다.", ptBR="Um fragmento de alma que pertencia a um inimigo poderoso.", ruRU="Фрагмент души, некогда принадлежавший могучему противнику.", zhCN="曾属于某个强大敌人的灵魂残片。", zhTW="這枚靈魂碎片曾屬於一名強大的敵人。" },
	[1324] = { 
		enUS="Completing this quest will grant the Horde credit in the Call of the Scarab event. The faction which earns the most credit today may hang their banners by the Scarab Gong for the rest of the year.", 
		deDE="Der Abschluss dieser Quest gewährt der Horde Punkte für das Gedenkereignis von Ahn'Qiraj. Das Banner der Fraktion, die heute die meisten Punkte verdient, wird für den Rest des Jahres den Skarabäusgong zieren.", 
		esES="Completar esta misión otorgará crédito a la Horda en el evento Llamada del Escarabajo. La facción que obtenga mayor reconocimiento a lo largo del día podrá colgar su estandarte en el gong del Escarabajo hasta que acabe el año.", 
		esMX="Al completar esta misión, la Horda recibirá crédito en el evento de La llamada del Escarabajo. La facción que obtenga más crédito el día de hoy podrá colgar sus estandartes en el gong del Escarabajo por el resto del año.", 
		frFR="Terminer cette quête confère à la Horde des crédits pour l’évènement de l’Appel du Scarabée. Les couleurs de la faction ayant gagné le plus de crédits aujourd’hui seront affichées auprès du gong du Scarabée pour le reste de l’année.", 
		itIT="Completare questa missione fornisce un Encomio Qiraji dell'Orda per l'evento Richiamo dello Scarabeo. La fazione che guadagnerà più encomi oggi potrà esporre i propri vessilli sul Gong dello Scarabeo fino alla fine dell'anno.", 
		koKR="이 퀘스트를 완료하면 호드에 스카라베의 부름 이벤트 점수를 수여합니다. 오늘 더 많은 점수를 획득한 진영은 올해의 남은 기간 동안 스카라베 징 옆에 해당 진영의 깃발을 걸 수 있습니다.", 
		ptBR="Cumprir essa missão dará crédito à Horda no evento Chamado do Escaravelho. A facção que ganhar mais crédito hoje poderá estender seus estandartes perto do Gongo do Escaravelho pelo resto do ano.", 
		ruRU="Завершение этого задания пойдет в зачет Орде в рамках события \"Зов скарабея\". Фракция, которая покажет сегодня лучший результат, сможет вывесить свои знамена у гонга Скарабея до конца года.", 
		zhCN="完成此任务可增加部落在甲虫的召唤活动中的积分。活动中积分最高的阵营可以将自己的旗帜挂在甲虫之锣旁，直到年末。", 
		zhTW="完成此任務可為部落爭取甲蟲的呼喚的積分。今天獲得最多積分的陣營可以在今年接下來的日子裡，於甲蟲之鑼旁高掛陣營旗幟。" 
	},
	[1325] = { 
		enUS="Completing this quest will grant the Alliance credit in the Call of the Scarab event. The faction which earns the most credit today may hang their banners by the Scarab Gong for the rest of the year.", 
		deDE="Der Abschluss dieser Quest gewährt der Allianz Punkte für das Gedenkereignis von Ahn'Qiraj. Das Banner der Fraktion, die heute die meisten Punkte verdient, wird für den Rest des Jahres den Skarabäusgong zieren.", 
		esES="Completar esta misión otorgará crédito a la Alianza en el evento Llamada del Escarabajo. La facción que obtenga mayor reconocimiento a lo largo del día podrá colgar su estandarte en el gong del Escarabajo hasta que acabe el año.", 
		esMX="Al completar esta misión, la Alianza recibirá crédito en el evento de La llamada del Escarabajo. La facción que obtenga más crédito el día de hoy podrá colgar sus estandartes en el gong del Escarabajo por el resto del año.", 
		frFR="Terminer cette quête confère à l’Alliance des crédits pour l’évènement de l’Appel du Scarabée. Les couleurs de la faction ayant gagné le plus de crédits aujourd’hui seront affichées auprès du gong du Scarabée pour le reste de l’année.", 
		itIT="Completare questa missione fornisce un Encomio Qiraji dell'Alleanza per l'evento Richiamo dello Scarabeo. La fazione che guadagnerà più encomi oggi potrà esporre i propri vessilli sul Gong dello Scarabeo fino alla fine dell'anno.", 
		koKR="이 퀘스트를 완료하면 얼라이언스에 스카라베의 부름 이벤트 점수를 수여합니다. 오늘 더 많은 점수를 획득한 진영은 올해의 남은 기간 동안 스카라베 징 옆에 해당 진영의 깃발을 걸 수 있습니다.", 
		ptBR="Cumprir essa missão dará crédito à Aliança no evento Chamado do Escaravelho. A facção que ganhar mais crédito hoje poderá estender seus estandartes perto do Gongo do Escaravelho pelo resto do ano.", 
		ruRU="Завершение этого задания пойдет в зачет Альянсу в рамках события \"Зов скарабея\". Фракция, которая покажет сегодня лучший результат, сможет вывесить свои знамена у гонга Скарабея до конца года.", 
		zhCN="完成此任务可增加联盟在甲虫的召唤活动中的积分。活动中积分最高的阵营可以将自己的旗帜挂在甲虫之锣旁，直到年末。", 
		zhTW="今天獲得最多獎勵的陣營可以在今年接下來的日子裡，於甲蟲之鑼旁高掛陣營旗幟。完成此任務可為聯盟爭取甲蟲的呼喚事件的積分。" 
	},
	[1342] = { enUS="Used to further the construction of valuable structures on the Broken Shore.", deDE="Werden zum Bau von wichtigen Gebäuden an der Verheerten Küste verwendet.", esES="Se utilizan para avanzar en la construcción de valiosas estructuras en la Costa Abrupta.", esMX="Se usan para avanzar en la construcción de estructuras valiosas en la Costa Quebrada.", frFR="Utilisées pour la construction de bâtiments importants au rivage Brisé.", itIT="Utilizzati per proseguire la costruzione di importanti edifici alla Riva Dispersa.", koKR="부서진 해변에서 중요 건축물을 건설하는 데 사용됩니다.", ptBR="Adianta a construção de estruturas importantes na Costa Partida.", ruRU="Используются для ускорения строительства важных сооружений на Расколотом берегу.", zhCN="用于强化破碎海滩上的珍贵建筑。", zhTW="可以用來在破碎海岸建造重要的建築物。" },
	[1355] = { enUS="Concentrated demonic essence which can be captured and used to create armor of great power.", deDE="Konzentrierte dämonische Essenz, die gesammelt werden kann, um mächtige Rüstung herzustellen.", esES="Esencia demoníaca concentrada que se puede atrapar y utilizar para crear armaduras de gran poder.", esMX="Esencia demoníaca concentrada que se puede capturar y usar para crear una armadura de gran poder.", frFR="Essence démoniaque concentrée qui peut être collectée et utilisée pour créer une armure d’une grande puissance.", itIT="Essenza demoniaca concentrata che può essere raccolta e utilizzata per creare armature molto potenti.", koKR="응축된 악마의 정수입니다. 막대한 힘을 지닌 방어구를 제작하는 데 사용됩니다.", ptBR="Essência demoníaca concentrada, que pode ser armazenada e usada na fabricação de armaduras poderosas.", ruRU="Концентрированная демоническая сущность, которая может быть изолирована и использована для изготовления мощных доспехов.", zhCN="浓缩的恶魔精华，可收集并用于制造强大的护甲。", zhTW="濃縮惡魔精華，可以用來製造強大的護甲。" },
	[1356] = { enUS="Used to purchase powerful PvP armor. At the end of the season, this currency converts to gold.", deDE="Können für den Erwerb von mächtigen PvP-Rüstungen verwendet werden. Am Ende der Saison wird diese Währung in Gold umgewandelt.", esES="Se utilizan para comprar armaduras de JcJ poderosas. Al final de la temporada, esta moneda se convierte en oro.", esMX="Used to purchase powerful PvP armor. At the end of the season, this currency converts to gold.", frFR="Utilisés pour acheter des armures de JcJ puissantes. Convertis en pièce d’or à la fin de la saison.", itIT="Utilizzati per acquistare le armature PvP più potenti. Alla fine della stagione, questa valuta si tramuta in oro.", koKR="강력한 플레이어 간 전투 방어구를 구매하는 데 사용합니다. 시즌 종료 시 골드로 변환됩니다.", ptBR="Usados para adquirir poderosas armaduras de JxJ. No fim da temporada, esta moeda é convertida em ouro.", ruRU="Можно потратить на мощные доспехи для PvP-сражений. В конце сезона конвертируются в золото.", zhCN="用于购买强大的PvP护甲。赛季结束时，此货币会转换为金币。", zhTW="用來購買強大的PvP護甲。賽季結束時，這種通貨會轉換成金幣。" },
	[1357] = { enUS="Used to purchase elite PvP armor. At the end of the season, this currency converts to gold.", deDE="Können für den Erwerb von Elite-PvP-Rüstungen verwendet werden. Am Ende der Saison wird diese Währung in Gold umgewandelt.", esES="Se utilizan para comprar armaduras de JcJ de élite. Al final de la temporada, esta moneda se convierte en oro.", esMX="Used to purchase elite PvP armor. At the end of the season, this currency converts to gold.", frFR="Utilisés pour acheter des armures de JcJ d’élite. Convertis en pièce d’or à la fin de la saison.", itIT="Utilizzati per acquistare le armature PvP Élite. Alla fine della stagione, questa valuta si tramuta in oro.", koKR="정예 플레이어 간 전투 방어구를 구매하는 데 사용합니다. 시즌 종료 시 골드로 변환됩니다.", ptBR="Usados para adquirir armaduras de elite de JxJ. No fim da temporada, esta moeda é convertida em ouro.", ruRU="Можно потратить на элитные доспехи для PvP-сражений. В конце сезона конвертируются в золото.", zhCN="用于购买精锐PvP护甲。赛季结束时，此货币会转换为金币。", zhTW="用來購買精英PvP護甲。賽季結束時，這種通貨會轉換成金幣。" },
	[1379] = { enUS="Earned by participating in the Trial of Style. Can be exchanged for transmoggable gear in Dalaran.", deDE="Werden durch Teilnahme am großen Stylecheck verdient. Können in Dalaran gegen transmogrifizierbare Ausrüstung eingetauscht werden.", esES="Se obtiene por participar en el torneo de la Prueba de Estilo. Se puede intercambiar por equipo transfigurable en Dalaran.", esMX="Se otorga como recompensa por participar en el Desafío de estilos. Puedes intercambiarla por equipo para transfigurar en Dalaran.", frFR="Remportée en participant à l’épreuve du style. Peut être échangée contre de l’équipement transmogrifié à Dalaran.", itIT="Guadagnato per aver partecipato alla Prova dello Stile. Può essere scambiato con equipaggiamenti per la trasmogrificazione a Dalaran.", koKR="멋의 대제전에 참여하면 얻을 수 있습니다. 달라란에서 형상변환용 장비를 구입하는 데 사용됩니다.", ptBR="Obtido por participar da Provação do Estilo. Pode ser trocada por equipamentos transmogrificáveis em Dalaran.", ruRU="Дается в качестве награды за участие в шоу \"Наденьте это немедленно!\". Можно обменять на предметы для трансмогрификации в Даларане.", zhCN="通过参与时尚试炼获得。可以在达拉然兑换可幻化的装备。", zhTW="參加時尚大考驗獲得的獎品。可用來在達拉然換取可塑形的裝備。" },
	[1416] = { enUS="Evaporate into mist after a while.", deDE="Löst sich nach einer Weile in Nebel auf.", esES="Se evaporan pasado un rato.", esMX="Se evaporan y se vuelven niebla después de un tiempo.", frFR="S’évapore dans la brume au bout d’un certain temps.", itIT="Evaporano nell'aria dopo poco.", koKR="시간이 지나면 증발합니다.", ptBR="Evapora na forma de bruma após alguns instantes.", ruRU="Через некоторое время растворяются в воздухе.", zhCN="旋即蒸发，化为迷雾。", zhTW="過一陣子會化為霧氣消散。" },
	[1501] = { enUS="Used to upgrade Legion Legendary items to item level 970.", deDE="Wird verwendet, um legendäre Gegenstände von Legion auf Gegenstandsstufe 970 aufzuwerten.", esES="Se usa para mejorar los objetos legendarios de Legion a nivel de objeto 970.", esMX="Usado para mejorar objetos legendarios a nivel 970.", frFR="Utilisée pour améliorer les objets légendaires de Legion jusqu’au niveau d’objet 970.", itIT="Usata per potenziare gli oggetti leggendari di Legion al livello 970.", koKR="군단 전설 아이템의 아이템 레벨을 970으로 강화하는 데 사용합니다.", ptBR="Usado para aprimorar itens lendários de Legion até o nível de item 970.", ruRU="Используется для улучшения легендарных предметов Legion до 970-го уровня.", zhCN="用于将《军团再临》传说物品的物品等级提升至970。", zhTW="將軍團傳說級裝備的物品等級提高至970所需的物品。" },
	[1506] = { enUS="Used by the minions of Sargeras to force open portals from Argus to other Legion-controlled worlds.", deDE="Wird von Sargeras' Dienern benutzt, um auf Argus Portale in andere von der Legion kontrollierte Welten aufzureißen.", esES="Usada por los esbirros de Sargeras para forzar la apertura de portales desde Argus hasta otros mundos controlados por la Legión.", esMX="Los esbirros de Sargeras la usan para abrir portales desde Argus a otros mundos controlados por la Legión.", frFR="Utilisées par les serviteurs de Sargeras pour ouvrir des portails entre Argus et les autres mondes contrôlés par la Légion.", itIT="Used by the minions of Sargeras to force open portals from Argus to other Legion-controlled worlds.", koKR="살게라스의 부하들이 아르거스에서 군단이 점령 중인 다른 행성으로 차원문을 열 때 사용합니다.", ptBR="Usada pelos lacaios de Sargeras para abrir portais de Argus para outros mundos controlados pela Legião.", ruRU="С помощью этого предмета слуги Саргераса открывают порталы из Аргуса в другие миры, захваченные Легионом.", zhCN="萨格拉斯的仆从用它来强行打开从阿古斯前往其他被军团控制的世界的传送门。", zhTW="由薩格拉斯的手下用來從阿古斯強制開啟傳送門前往其他由燃燒軍團控制的世界。" },
	[1508] = { enUS="Sought by the Army of the Light to fuel their war against the Burning Legion.", deDE="Begehrt bei der Armee des Lichts, um ihren Krieg gegen die Brennende Legion voranzutreiben.", esES="Sought by the Army of the Light to fuel their war against the Burning Legion.", esMX="Sought by the Army of the Light to fuel their war against the Burning Legion.", frFR="Recherchée par l’armée de la Lumière pour alimenter sa guerre contre la Légion ardente.", itIT="Sought by the Army of the Light to fuel their war against the Burning Legion.", koKR="Sought by the Army of the Light to fuel their war against the Burning Legion.", ptBR="Sought by the Army of the Light to fuel their war against the Burning Legion.", ruRU="Sought by the Army of the Light to fuel their war against the Burning Legion.", zhCN="圣光军团急需这种物资来支援他们与燃烧军团的战争。", zhTW="Sought by the Army of the Light to fuel their war against the Burning Legion." },
}

local function CheckLang(lang)
	if not lang then return end
	if (LANGS[lang]) then return true end
end

--[[ /////////////////////////////////////////
-- lib:GetCurrencyByID(currencyID, lang)
-- Returns:
    name 
        String - the name of the currency, localized to the language
    amount 
        Number - Current amount of the currency at index
    texture 
        Number - The textureID of the currency's icon. 
    earnedThisWeek 
        Number - The amount of the currency earned this week
    weeklyMax 
        Number - Maximum amount of currency possible to be earned this week
    totalMax 
        Number - Total maximum currency possible to stockpile
    isDiscovered 
        Boolean - Whether the character has ever got some of this currency
    rarity 
        Integer - Rarity indicator for this currency 
    categoryID
        Number  - The currency's corresponding categoryID
    categoryName
        String  - The currency's corresponding category name
    currencyDesc
        String  - The currency's description
-- /////////////////////////////////////////]]
function lib:GetCurrencyByID(currencyID, lang)
	if not currencyID or type(currencyID) ~= "number" then return end

	local name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered, rarity, categoryID, categoryName, currencyDesc

	if (lang) then
		if ( not CheckLang(lang) ) then
			error(format("The specified language \"%s\" is invalid or not available", lang))
			return nil
		end
	else
		lang = GetLocale()
	end

	name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered, rarity = GetCurrencyInfo(currencyID)
	if not name then return end
	
	categoryID = lib.data.Currencies[currencyID].category
	categoryName = lib.data.CurrencyCategories[categoryID] and lib.data.CurrencyCategories[categoryID][lang] or nil
	currencyDesc = lib.data.CurrencyDesc[currencyID] and lib.data.CurrencyDesc[currencyID][lang] or nil
	
	return name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered, rarity, categoryID, categoryName, currencyDesc
end

function lib:GetCurrencyByCategoryID(categoryID)
	if not categoryID or type(categoryID) ~= "number" then return end
	
	if lib.data.CurrencyByCategory[categoryID] then return lib.data.CurrencyByCategory[categoryID] end
end

function lib:GetCurrencyTokenStrings(currencyID, lang)
	if not currencyID or type(currencyID) ~= "number" then return end

	local name, count, _, _, _, totalMax, _, _, _, _, currencyDesc = lib:GetCurrencyByID(currencyID, lang)
	if not name then return end
	if not count then count = 0 end

	local str = HIGHLIGHT_FONT_COLOR_CODE..name
	if currencyDesc then str = str.."\n"..NORMAL_FONT_COLOR_CODE..currencyDesc end
	if (totalMax and totalMax > 0) then
		str = str.."\n\n"..format(CURRENCY_TOTAL_CAP, HIGHLIGHT_FONT_COLOR_CODE, count, totalMax)
	else
		str = str.."\n\n"..format(CURRENCY_TOTAL, HIGHLIGHT_FONT_COLOR_CODE, count)
	end
	
	return str
end