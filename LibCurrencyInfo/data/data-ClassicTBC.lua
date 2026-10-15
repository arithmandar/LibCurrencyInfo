--[[
Name: LibCurrencyInfo
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
local _, private = ...

-- Determine WoW client family
local projectID = WOW_PROJECT_ID

local PROJECT_TBC = WOW_PROJECT_BURNING_CRUSADE_CLASSIC

local isAnniversaryTBC = PROJECT_TBC ~= nil and projectID == PROJECT_TBC

if (isAnniversaryTBC) then
	local data = {}

	data.CurrencyCategories = {
		[247] = { enUS="Player vs. Player",deDE="Spieler gegen Spieler",esES="Jugador contra Jugador",esMX="Jugador contra Jugador",frFR="JcJ",itIT="Personaggio vs Personaggio",koKR="플레이어 간 전투",ptBR="Jogador x Jogador",ruRU="PvP",zhTW="玩家對玩家",zhCN="PvP", },
	}

	data.CurrencyByCategory = {
		[247] = { -- Player vs. Player
			1900, -- Arena Points
			1901, -- Honor Points
		},
	}

	data.Currencies = {
		[1900] = { id=1900, category=247 }, -- Arena Points, Player vs. Player
		[1901] = { id=1901, category=247 }, -- Honor Points, Player vs. Player
	}

	private.data = data
end

