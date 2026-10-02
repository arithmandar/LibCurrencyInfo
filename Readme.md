# LibCurrencyInfo

A World of Warcraft addon library for retrieving currency information and
localized currency-category metadata.

## Overview

**LibCurrencyInfo** is an embedded library for World of Warcraft addon authors.

It combines live currency information from the WoW client with curated
currency-category data maintained by the library. It provides currency
categories, localized category names, category-membership lookups, and formatted
currency tooltip text.

LibCurrencyInfo does not provide a standalone user interface or gameplay
feature by itself.

## Features

LibCurrencyInfo provides:

- Live currency information by currency ID.
- Library-maintained currency categories and category membership.
- Localized category names for supported WoW locales.
- Currency IDs grouped by category.
- Formatted currency tooltip text suitable for use in `GameTooltip`.
- A positional-return API for compatibility with existing addons.

Depending on the running WoW client and the requested currency, live currency
information can include the current quantity, icon file ID, weekly progress,
weekly cap, total cap, discovery state, and quality.

## Supported Locales

Localized category names are available for:

- `enUS`
- `deDE`
- `esES`
- `esMX`
- `frFR`
- `itIT`
- `koKR`
- `ptBR`
- `ruRU`
- `zhCN`
- `zhTW`

When a locale argument is not supplied, APIs that support locale selection use
the player’s current game-client locale.

The category-name lookup APIs fall back to English (`enUS`) if a translation is
not available for the requested locale.

## Installation

LibCurrencyInfo is intended to be embedded in another addon.

1. Add LibCurrencyInfo to your addon’s package metadata or embedded libraries.
2. Load `LibStub` before LibCurrencyInfo.
3. Load LibCurrencyInfo before Lua files that call
   `LibStub("LibCurrencyInfo")`.

Example `.toc` load order:

```toc
Libs\LibStub\LibStub.lua
Libs\LibCurrencyInfo\LibCurrencyInfo.lua
Core.lua
```

If you use a package manager or release packager, declare LibCurrencyInfo as an
external dependency so that it is embedded in your published release archive.

## Getting Started

```lua
local LibCurrencyInfo = LibStub("LibCurrencyInfo")

local name, quantity, iconFileID,
    quantityEarnedThisWeek, maxWeeklyQuantity, maxQuantity,
    discovered, quality,
    categoryID, categoryName, description =
    LibCurrencyInfo:GetCurrencyByID(2032)

if name then
    print(name)
    print(quantity)
    print(categoryName)
end
```

## API

### `lib:GetCurrencyByID(currencyID[, locale])`

Returns live currency information together with LibCurrencyInfo category
metadata.

Returns `nil` if `currencyID` is invalid or unavailable through the current WoW
client API.

#### Arguments

| Argument | Type | Description |
|---|---|---|
| `currencyID` | number | Currency ID to look up |
| `locale` | string, optional | Locale used for the returned category name. Defaults to the player’s current client locale |

#### Returns

The method returns these positional values:

| Position | Name | Type | Description |
|---:|---|---|---|
| 1 | `name` | string | Localized currency name returned by the WoW client |
| 2 | `quantity` | number | Current amount held by the character |
| 3 | `iconFileID` | number or `nil` | Currency icon file ID, when provided by the WoW client |
| 4 | `quantityEarnedThisWeek` | number or `nil` | Amount earned during the current week, when applicable |
| 5 | `maxWeeklyQuantity` | number or `nil` | Weekly maximum amount, when applicable |
| 6 | `maxQuantity` | number or `nil` | Maximum amount the character can hold, when applicable |
| 7 | `discovered` | boolean or `nil` | Whether the character has discovered the currency |
| 8 | `quality` | number or `nil` | Currency quality supplied by the WoW client |
| 9 | `categoryID` | number or `nil` | Category ID assigned by LibCurrencyInfo |
| 10 | `categoryName` | string | Localized library category name, or an empty string if unavailable |
| 11 | `description` | string | Currency description returned by the WoW client, or an empty string if unavailable |

Example:

```lua
local name, quantity, _, _, _, maxQuantity,
    _, _, categoryID, categoryName, description =
    LibCurrencyInfo:GetCurrencyByID(2032, "zhTW")

if name then
    print(name)
    print(quantity)
    print(maxQuantity)
    print(categoryID)
    print(categoryName)
    print(description)
end
```

### `lib:GetCurrencyByCategoryID(categoryID)`

Returns the library-owned array of currency IDs assigned to the specified
category.

Returns `nil` if the category is unknown or `categoryID` is invalid.

```lua
local currencyIDs = LibCurrencyInfo:GetCurrencyByCategoryID(1)

if currencyIDs then
    for _, currencyID in ipairs(currencyIDs) do
        print(currencyID)
    end
end
```

The returned table belongs to LibCurrencyInfo and must be treated as
**read-only**. Do not add, remove, or reorder entries.

### `lib:GetCurrencyCategoryNameByCurrencyID(currencyID[, locale])`

Returns the localized category name assigned to a currency.

Returns `nil` if the currency has no known library category. If a category
translation is not available for the requested locale, the method falls back to
English (`enUS`).

```lua
local categoryName =
    LibCurrencyInfo:GetCurrencyCategoryNameByCurrencyID(2032, "zhTW")
```

### `lib:GetCurrencyCategoryNameByCategoryID(categoryID[, locale])`

Returns the localized name for a library category.

Returns `nil` if the category is unknown. If a translation is not available for
the requested locale, the method falls back to English (`enUS`).

```lua
local categoryName =
    LibCurrencyInfo:GetCurrencyCategoryNameByCategoryID(1, "deDE")
```

### `lib:GetCurrencyTokenStrings(currencyID[, locale])`

Returns one formatted string suitable for adding to a `GameTooltip`.

The string includes the localized currency name, description when available,
current quantity, and total cap when applicable.

Returns `nil` if the currency is invalid or unavailable.

```lua
local text = LibCurrencyInfo:GetCurrencyTokenStrings(2032)

if text then
    GameTooltip:AddLine(text)
end
```

## Data Tables

> **Warning:** `LibCurrencyInfo.data` is available for advanced inspection and
> compatibility use. It is not the primary public API. Its data layout may
> change as currencies are added or Blizzard reorganizes currency categories.
> Addons should prefer the documented API methods whenever possible.

### `lib.data.CurrencyByCategory`

Maps a category ID to an array of currency IDs:

```lua
local currencyIDs = LibCurrencyInfo.data.CurrencyByCategory[2]
```

Example entry:

```lua
 = {[2]
    81,   -- Epicurean's Award
    402,  -- Ironpaw Token
    515,  -- Darkmoon Prize Ticket
    1379, -- Trial of Style Token
},
```

### `lib.data.CurrencyCategories`

Maps a category ID to localized category names:

```lua
local category = LibCurrencyInfo.data.CurrencyCategories[2]
local zhTWName = category.zhTW
```

Example entry:

```lua
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
},
```

### `lib.data.Currencies`

Maps a currency ID to LibCurrencyInfo metadata:

```lua
local currencyData = LibCurrencyInfo.data.Currencies[3]
```

Each entry can contain:

| Field | Type | Description |
|---|---|---|
| `id` | number | Currency ID |
| `category` | number | Category ID assigned by LibCurrencyInfo |
| `hide` | boolean, optional | Marks an inactive, internal, test, or normally hidden currency |

Example entry:

```lua
 = {[3]
    id = 81,
    category = 1,
},
```

## Compatibility Notes

- Live currency data is character-specific and is retrieved from the WoW client
  through `C_CurrencyInfo` at runtime.
- Currency categories and localized category names are maintained by
  LibCurrencyInfo.
- Available live fields depend on the running WoW client and the requested
  currency.
- A currency can exist in the WoW client before it is classified in
  LibCurrencyInfo’s curated category data.
- Category data should therefore be treated as library metadata rather than a
  complete replacement for the WoW client currency API.

## Reporting Issues

Please report missing currencies, incorrect category assignments, incorrect
localized category names, or client-compatibility problems through the
[GitHub issue tracker](../../issues). CurseForge comments are also welcome.

When reporting an issue, include:

- Currency ID.
- In-game currency name.
- WoW client version and game branch.
- Expected category, if applicable.
- Affected game locale for localization reports.
- A screenshot or relevant API output, when available.