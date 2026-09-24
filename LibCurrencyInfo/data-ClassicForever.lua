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

-- Beta-only fallback:
-- Replace these bounds with values verified from the actual Forever client.
local isForeverBeta = projectID == PROJECT_MAINLINE and interfaceVersion >= 10000 and interfaceVersion < 20000
local isClassicForever = isForeverBeta


if (isClassicForever) then
	local data = {}

	data.CurrencyCategories = {
		[1] = { enUS="Miscellaneous",deDE="Verschiedenes",esES="Misceláneo",esMX="Miscelánea",frFR="Divers",itIT="Miscellaneous",koKR="기타",ptBR="Diversos",ruRU="Разное",zhCN="其它",zhTW="雜項", },
		[2] = { enUS="Player vs. Player",deDE="Spieler gegen Spieler",esES="Jugador contra Jugador",esMX="Jugador contra Jugador",frFR="JcJ",itIT="Player vs. Player",koKR="플레이어 대 플레이어",ptBR="Jogador x Jogador",ruRU="PvP",zhCN="PvP",zhTW="玩家對玩家", },
		[3] = { enUS="Unused",deDE="Unused",esES="Unused",esMX="Unused",frFR="Unused",itIT="Non usato",koKR="Unused",ptBR="Unused",ruRU="Unused",zhCN="Unused",zhTW="Unused", hide=true, },
		[22] = { enUS="Dungeon and Raid",deDE="Dungeon und Schlachtzug",esES="Mazmorra y banda",esMX="Calabozo y banda",frFR="Raid",itIT="Dungeon and Raid",koKR="던전 및 공격대",ptBR="Masmorras e Raides",ruRU="Подземелья и рейды",zhCN="地下城与团队",zhTW="地城與團隊", },
		[142] = { enUS="Hidden",deDE="Hidden",esES="Hidden",esMX="Hidden",frFR="Hidden",itIT="Hidden",koKR="Hidden",ptBR="Hidden",ruRU="Hidden",zhCN="Hidden",zhTW="Hidden", hide=true, },
		[273] = { enUS="Professions & Tradeskills",deDE="Berufe und Berufsfertigkeiten",esES="Profesiones y habilidades comerciales",esMX="Profesiones y habilidades comerciales",frFR="Métiers et artisanat",itIT="Professions & Tradeskills",koKR="전문 기술 및 보조 기술",ptBR="Profissões e Perícias",ruRU="Профессии и ремесла",zhCN="专业与商业技能",zhTW="專業技能與交易技能", },
	}

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
	private.data = data

end

