--[[
Name: LibCurrencyInfo
Maintainers: Arith
Website: https://www.wowace.com/projects/libcurrencyinfo
Dependencies: None
License: MIT

LibCurrencyInfo provides curated World of Warcraft currency category data,
localized category names, and currency-category lookup functions.

It also provides convenience methods that combine the library's category
metadata with live currency information returned by C_CurrencyInfo.

For new code, prefer lib:GetCurrencyInfo(currencyID[, locale]), which
returns a table with named fields. GetCurrencyByID is retained for
compatibility and returns the same information as positional values.
]]

local _G = getfenv(0)

local type = _G.type
local error = _G.error
local format = _G.format
local GetLocale = _G.GetLocale
local LibStub = _G.LibStub

local _, private = ...

local MAJOR_VERSION = "LibCurrencyInfo"
local MINOR_VERSION = 91051

local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then
    return
end

local C_CurrencyInfo = _G.C_CurrencyInfo
local BlizzardGetCurrencyInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo
local BlizzardGetBasicCurrencyInfo = C_CurrencyInfo and C_CurrencyInfo.GetBasicCurrencyInfo

local EMPTY_DATA = {
    Currencies = {},
    CurrencyCategories = {},
    CurrencyByCategory = {},
}

-- The relevant data file must load before this file. The empty fallback keeps
-- the library safe if this file is accidentally loaded without its data file.
lib.data = private and private.data or EMPTY_DATA

local LANGS = {
    enUS = true,
    deDE = true,
    esES = true,
    esMX = true,
    frFR = true,
    itIT = true,
    koKR = true,
    ptBR = true,
    ruRU = true,
    zhCN = true,
    zhTW = true,
}

local function IsSupportedLocale(locale)
    return locale ~= nil and LANGS[locale] == true
end

local function ResolveLocale(locale)
    if locale == nil then
        return GetLocale()
    end

    if not IsSupportedLocale(locale) then
        error(format(
            "The specified locale \"%s\" is invalid or unavailable.",
            tostring(locale)
        ), 3)
    end

    return locale
end

local function GetData()
    return lib.data or EMPTY_DATA
end

local function GetCategoryData(categoryID)
    if not categoryID then
        return nil
    end

    return GetData().CurrencyCategories[categoryID]
end

local function GetLocalizedCategoryName(categoryID, locale)
    local categoryData = GetCategoryData(categoryID)

    if not categoryData then
        return nil
    end

    return categoryData[locale] or categoryData.enUS
end

--[[
lib:GetCurrencyByID(currencyID[, locale])

Returns, in order:
  1. name
  2. quantity
  3. iconFileID
  4. quantityEarnedThisWeek
  5. maxWeeklyQuantity
  6. maxQuantity
  7. discovered
  8. quality
  9. categoryID
 10. categoryName
 11. description
]]
function lib:GetCurrencyByID(currencyID, locale)
    if not currencyID or type(currencyID) ~= "number" then
        return nil
    end

    if type(BlizzardGetCurrencyInfo) ~= "function" then
        return nil
    end

    locale = ResolveLocale(locale)

    local info = BlizzardGetCurrencyInfo(currencyID)
    if not info then
        return nil
    end

    local currInfo = type(BlizzardGetBasicCurrencyInfo) == "function"
        and BlizzardGetBasicCurrencyInfo(currencyID)
        or nil

    local currencyData = GetData().Currencies[currencyID]
    local categoryID = currencyData and currencyData.category or nil
    local categoryName = categoryID
        and lib.data.CurrencyCategories[categoryID]
        and (
            lib.data.CurrencyCategories[categoryID][locale]
            or lib.data.CurrencyCategories[categoryID].enUS
        )
        or ""
    local description = currInfo and currInfo.description or ""

    return
        info.name,
        info.quantity,
        info.iconFileID,
        info.quantityEarnedThisWeek,
        info.maxWeeklyQuantity,
        info.maxQuantity,
        info.discovered,
        info.quality,
        categoryID,
        categoryName,
        description
end

--[[
lib:GetCurrencyInfo(currencyID[, locale])

Returns a table containing the same information as GetCurrencyByID(), with
named fields. Returns nil if the currency is unavailable or unsupported by the
current WoW client.
]]
function lib:GetCurrencyInfo(currencyID, locale)
    local name, quantity, iconFileID,
        quantityEarnedThisWeek, maxWeeklyQuantity, maxQuantity,
        discovered, quality,
        categoryID, categoryName, description =
        self:GetCurrencyByID(currencyID, locale)

    if not name then
        return nil
    end

    return {
        name = name,
        quantity = quantity,
        iconFileID = iconFileID,
        quantityEarnedThisWeek = quantityEarnedThisWeek,
        maxWeeklyQuantity = maxWeeklyQuantity,
        maxQuantity = maxQuantity,
        discovered = discovered,
        quality = quality,
        categoryID = categoryID,
        categoryName = categoryName,
        description = description,
    }
end

--[[
lib:GetCurrencyByCategoryID(categoryID)

Returns the library-owned array of currency IDs for categoryID, or nil when
unknown. Treat the returned table as read-only.
]]
function lib:GetCurrencyByCategoryID(categoryID)
    if not categoryID or type(categoryID) ~= "number" then
        return nil
    end

    return GetData().CurrencyByCategory[categoryID]
end

--[[
lib:GetCurrencyCategoryNameByCurrencyID(currencyID[, locale])

Returns the localized category name assigned by LibCurrencyInfo, or nil if the
currency has no known category.
]]
function lib:GetCurrencyCategoryNameByCurrencyID(currencyID, locale)
    if not currencyID or type(currencyID) ~= "number" then
        return nil
    end

    local currencyData = GetData().Currencies[currencyID]
    if not currencyData or not currencyData.category then
        return nil
    end

    return self:GetCurrencyCategoryNameByCategoryID(currencyData.category, locale)
end

--[[
lib:GetCurrencyCategoryNameByCategoryID(categoryID[, locale])

Returns the localized category name, falling back to enUS when a translation is
not available. Returns nil for an unknown category.
]]
function lib:GetCurrencyCategoryNameByCategoryID(categoryID, locale)
    if not categoryID or type(categoryID) ~= "number" then
        return nil
    end

    locale = ResolveLocale(locale)

    return GetLocalizedCategoryName(categoryID, locale)
end

--[[
lib:GetCurrencyTokenStrings(currencyID[, locale])

Returns formatted text suitable for adding to a GameTooltip. The result includes
the currency name, description when available, current quantity, and total cap
when the client provides one.
]]
function lib:GetCurrencyTokenStrings(currencyID, locale)
    local name, quantity, _, _, _, maxQuantity, _, _, _, _, description =
        self:GetCurrencyByID(currencyID, locale)

    if not name then
        return nil
    end

    quantity = quantity or 0

    local text = HIGHLIGHT_FONT_COLOR_CODE .. name

    if description and description ~= "" then
        text = text .. "\n" .. NORMAL_FONT_COLOR_CODE .. description
    end

    if maxQuantity and maxQuantity > 0 then
        text = text .. "\n\n" .. NORMAL_FONT_COLOR_CODE
            .. format(CURRENCY_TOTAL_CAP, HIGHLIGHT_FONT_COLOR_CODE, quantity, maxQuantity)
    else
        text = text .. "\n\n" .. NORMAL_FONT_COLOR_CODE
            .. format(CURRENCY_TOTAL, HIGHLIGHT_FONT_COLOR_CODE, quantity)
    end

    return text
end

