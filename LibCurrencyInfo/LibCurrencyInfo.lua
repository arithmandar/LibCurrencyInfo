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
local GetCurrencyInfo
local GetLocale = _G.GetLocale

-- Determine WoW TOC Version
local WoWClassic, WoWRetail, WoWShadowlands
local wowtocversion  = select(4, GetBuildInfo())
if wowtocversion < 19999 then
	WoWClassic = true
elseif wowtocversion > 19999 and wowtocversion < 90000 then 
	WoWRetail = true
else
	WoWShadowlands = true
end

if WoWClassic or WoWRetail then
	GetCurrencyInfo = _G.GetCurrencyInfo
else -- Shadowlands
	GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
end

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub

local MAJOR_VERSION = "LibCurrencyInfo"
local MINOR_VERSION = 90000 + tonumber(("$Rev$"):match("%d+"))

local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

lib.data = private.data

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
	
	if WoWClassic or WoWRetail then
		name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered, rarity = GetCurrencyInfo(currencyID)
	else
		local curr = GetCurrencyInfo(currencyID)
		name = curr.name
		currentAmount = curr.quantity
		texture = curr.iconFileID
		earnedThisWeek = curr.quantityEarnedThisWeek
		weeklyMax = curr.maxWeeklyQuantity
		totalMax = curr.maxQuantity
		isDiscovered = curr.discovered
		rarity = curr.quality
	end
	if not name then return end
	local CurrencyDisplayInfo = C_CurrencyInfo.GetBasicCurrencyInfo(currencyID)
	
	categoryID = lib.data.Currencies[currencyID].category
	categoryName = lib.data.CurrencyCategories[categoryID] and lib.data.CurrencyCategories[categoryID][lang] or nil
	--currencyDesc = lib.data.CurrencyDesc[currencyID] and lib.data.CurrencyDesc[currencyID][lang] or nil
	currencyDesc = CurrencyDisplayInfo and CurrencyDisplayInfo.description or nil
	
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
		str = str.."\n\n"..NORMAL_FONT_COLOR_CODE..format(CURRENCY_TOTAL_CAP, HIGHLIGHT_FONT_COLOR_CODE, count, totalMax)
	else
		str = str.."\n\n"..NORMAL_FONT_COLOR_CODE..format(CURRENCY_TOTAL, HIGHLIGHT_FONT_COLOR_CODE, count)
	end
	
	return str
end

function lib:GetCurrencyCategoryNameByCurrencyID(currencyID, lang)
	if not currencyID or type(currencyID) ~= "number" then return end
	if not lib.data.Currencies[currencyID] then return end
	
	local categoryID = lib.data.Currencies[currencyID].category
	if not categoryID then return end
	if not lib.data.CurrencyCategories[categoryID] then return end
	
	return lib.data.CurrencyCategories[categoryID][lang] or lib.data.CurrencyCategories[categoryID]["enUS"]
	
end

function lib:GetCurrencyCategoryNameByCategoryID(categoryID, lang)
	if not lib.data.CurrencyCategories[categoryID] then return end
	
	return lib.data.CurrencyCategories[categoryID][lang] or lib.data.CurrencyCategories[categoryID]["enUS"]
	
end
