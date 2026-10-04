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

-- Functions
local _G = getfenv(0)

-- Determine WoW client family
local projectID = WOW_PROJECT_ID
local PROJECT_CLASSIC = WOW_PROJECT_CLASSIC
local isClassicEra = projectID == PROJECT_CLASSIC

if (isClassicEra) then
	local data = {}
	data.CurrencyCategories = {

	}

	data.CurrencyByCategory = {

	}

	data.Currencies = {

	}
	private.data = data
end

