## Overview

**LibCurrencyInfo** is a library for World of Warcraft addon authors.

It combines live currency information from the WoW client with curated currency-category data maintained by the library. It provides currency categories, localized category names, category membership lookups, and formatted currency tooltip text.

This is an embedded library. It does not provide a standalone user interface or gameplay feature by itself.

## Features

LibCurrencyInfo provides:

*   Live currency information by currency ID
*   Currency categories maintained by the library
*   Localized category names for supported WoW locales
*   Currency IDs grouped by category
*   Currency tooltip text suitable for use in `GameTooltip`
*   A table-returning API for new code
*   A legacy positional-return API for compatibility with existing addons

Live currency information can include the current quantity, icon file ID, weekly progress, weekly cap, total cap, discovery state, and quality. Available fields depend on the running WoW client and the specific currency.

## Supported Locales

Localized category names are available for:

*   `enUS`
*   `deDE`
*   `esES`
*   `esMX`
*   `frFR`
*   `itIT`
*   `koKR`
*   `ptBR`
*   `ruRU`
*   `zhCN`
*   `zhTW`

When no locale is specified, the library uses the player’s current game-client locale. If a category translation is unavailable for the requested locale, the library falls back to English (`enUS`).

## Getting Started

```
local LibCurrencyInfo = LibStub("LibCurrencyInfo")

local currency = LibCurrencyInfo:GetCurrencyInfo(2032)

if currency then
    print(currency.name)
    print(currency.quantity)
    print(currency.categoryName)
end
```

For new code, use `lib:GetCurrencyInfo(currencyID[, locale])`. It returns one table with named fields and is easier to extend safely.

## API

### `lib:GetCurrencyInfo(currencyID[, locale])`

Returns a table containing live currency information together with LibCurrencyInfo category metadata.

#### Arguments

| Argument   |Type             |Description                                                                                 |
| ---------- |---------------- |------------------------------------------------------------------------------------------- |
| <code>currencyID</code> |number           |Currency ID to look up.                                                                     |
| <code>locale</code> |string, optional |Locale used for the returned category name. Defaults to the player’s current client locale. |

#### Returns

Returns `nil` if the currency is not available through the current client API. Otherwise, returns:

| Field                  |Type           |Description                                                                                  |
| ---------------------- |-------------- |-------------------------------------------------------------------------------------------- |
| <code>name</code>      |string         |Localized currency name returned by the WoW client.                                          |
| <code>quantity</code>  |number         |Current amount held by the character.                                                        |
| <code>iconFileID</code> |number         |File ID for the currency icon.                                                               |
| <code>quantityEarnedThisWeek</code> |number or <code>nil</code> |Amount earned during the current week, when applicable.                                      |
| <code>maxWeeklyQuantity</code> |number or <code>nil</code> |Weekly maximum amount, when applicable.                                                      |
| <code>maxQuantity</code> |number or <code>nil</code> |Maximum amount the character can hold, when applicable.                                      |
| <code>discovered</code> |boolean or <code>nil</code> |Whether the currency has been discovered by the character.                                   |
| <code>quality</code>   |number or <code>nil</code> |Currency quality supplied by the WoW client.                                                 |
| <code>categoryID</code> |number or <code>nil</code> |Category ID assigned by LibCurrencyInfo.                                                     |
| <code>categoryName</code> |string         |Localized category name, an English fallback, or an empty string if no category is assigned. |
| <code>description</code> |string         |Currency description returned by the WoW client, or an empty string if unavailable.          |

Example:

```
local currency = LibCurrencyInfo:GetCurrencyInfo(2032, "zhTW")

if currency then
    print(currency.name)
    print(currency.categoryID)
    print(currency.categoryName)
end
```

### `lib:GetCurrencyByID(currencyID[, locale])`

Legacy compatibility API.

It returns the same information as `GetCurrencyInfo()`, but as positional return values:

```
local name, quantity, iconFileID,
    quantityEarnedThisWeek, maxWeeklyQuantity, maxQuantity,
    discovered, quality,
    categoryID, categoryName, description =
    LibCurrencyInfo:GetCurrencyByID(currencyID)
```

New code should generally use `GetCurrencyInfo()` instead.

### `lib:GetCurrencyByCategoryID(categoryID)`

Returns the library-owned array of currency IDs assigned to a category.

```
local currencyIDs =
    LibCurrencyInfo:GetCurrencyByCategoryID(categoryID)
```

Returns `nil` when the category is unknown.

The returned table belongs to LibCurrencyInfo and should be treated as **read-only**.

Example:

```
local currencyIDs = LibCurrencyInfo:GetCurrencyByCategoryID(1)

if currencyIDs then
    for _, currencyID in ipairs(currencyIDs) do
        print(currencyID)
    end
end
```

### `lib:GetCurrencyCategoryNameByCurrencyID(currencyID[, locale])`

Returns the localized category name assigned to a currency, or `nil` if the currency does not have a known library category.

```
local categoryName =
    LibCurrencyInfo:GetCurrencyCategoryNameByCurrencyID(2032)
```

### `lib:GetCurrencyCategoryNameByCategoryID(categoryID[, locale])`

Returns the localized category name for a category, or `nil` if the category is unknown.

```
local categoryName =
    LibCurrencyInfo:GetCurrencyCategoryNameByCategoryID(1, "deDE")
```

### `lib:GetCurrencyTokenStrings(currencyID[, locale])`

Returns formatted text suitable for a `GameTooltip`.

The result includes the localized currency name, description when available, current quantity, and total cap when applicable.

```
local text = LibCurrencyInfo:GetCurrencyTokenStrings(2032)

if text then
    GameTooltip:AddLine(text)
end
```

## Data Tables

The curated data is available through `LibCurrencyInfo.data` for advanced use.

Addon authors should generally prefer the public API. The underlying data layout may change as new currencies are added or Blizzard reorganizes currency categories.

### `lib.data.CurrencyByCategory`

Maps a category ID to an array of currency IDs:

```
local currencyIDs = LibCurrencyInfo.data.CurrencyByCategory[2]
```

Example:

```
 = {[2]
    81,   -- Epicurean's Award
    402,  -- Ironpaw Token
    515,  -- Darkmoon Prize Ticket
    1379, -- Trial of Style Token
}
```

### `lib.data.CurrencyCategories`

Maps a category ID to localized category names:

```
local category = LibCurrencyInfo.data.CurrencyCategories[2]
local zhTWName = category.zhTW
```

Example:

```
 = {[2]
    enUS = "Miscellaneous",
    deDE = "Verschiedenes",
    esES = "Miscelánea",
    esMX = "Miscelánea",
    frFR = "Divers",
    itIT = "Varie",
    koKR = "기타",
    ptBR = "Diversos",
    ruRU = "Разное",
    zhCN = "其它",
    zhTW = "雜項",
}
```

### `lib.data.Currencies`

Maps a currency ID to library metadata:

```
local currencyData = LibCurrencyInfo.data.Currencies[3]
```

Each entry can contain:

| Field    |Type              |Description                                                     |
| -------- |----------------- |--------------------------------------------------------------- |
| <code>id</code> |number            |Currency ID.                                                    |
| <code>category</code> |number            |Category ID assigned by LibCurrencyInfo.                        |
| <code>hide</code> |boolean, optional |Marks an inactive, internal, test, or normally hidden currency. |

Example:

```
 = {[3]
    id = 81,
    category = 1,
}
```

## Compatibility Notes

*   Live data is character-specific and comes from `C_CurrencyInfo` at runtime.
*   Category membership and category names come from LibCurrencyInfo’s curated data.
*   A currency can be available in the WoW client before it has been added to LibCurrencyInfo’s category data.
*   In that case, live fields can still be returned, while `categoryID` is `nil` and `categoryName` is an empty string.
*   The library returns `nil` when the current client does not provide the required currency API or when the requested currency cannot be resolved.

## Reporting Issues

Please report missing currencies, incorrect category assignments, incorrect localized category names, or client-compatibility problems through the project’s issue tracker or CurseForge comments.

Include:

*   Currency ID
*   In-game currency name
*   WoW client version and game branch
*   Expected category, if applicable
*   Affected game locale for localization reports
*   Screenshot or API output when available