# TrinketCDs (Fork)

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Proc Glow](#proc-glow) | [Commands](#commands) | [Performance](#performance) | [Options](#options)

> Forked from [Ridepad/TrinketCDs](https://github.com/Ridepad/TrinketCDs).

- Addon dynamically tracks cooldown of equipped trinkets and enchants.
- Made to remove headache of copying/creating weakauras for every new character/item.
- Works both on 3.3 and 3.4 WotLK versions.
- Full database of WotLK/TBC trinkets.
- Ashen rings, cloak, weapon, hands, boots and belt enchants.
- Doesn't depend on combat log.
- Proc duration, stacks, cooldown.
- Cooldown tracking on login and after inventory change.
- Has built-in cooldown text (use [OmniCC](https://www.curseforge.com/wow/addons/omni-cc/files/454434) as alternative).
- Caches cooldown even if trinket was unequipped after proc (useful if server has different iCD on equip).

---

## New Features

### ✨ Proc Glow
Visual glow effect around icons when a trinket/enchant proc is active.

- Glow appears automatically when a proc buff is detected
- Three glow styles: **Action Button Glow** (default), **Pixel Glow**, and **Proc Glow**
- Action Button Glow — classic WoW marching ants animation
- Pixel Glow — colored pixel dots orbiting the border
- Proc Glow — WeakAuras-style flipbook proc animation (uses UIActionBarFX spritesheet)
- Per-icon glow toggle for each equipment slot
- Bundled [LibCustomGlow-1.0] with 3.3.5a compatibility
- Dedicated **Glow** settings tab in Interface Options
- Show proc icon instead of item icon while active
- Text (cooldown, stacks, ilvl) always renders above glow effects

### 🔄 Drag & Drop Positioning
Move trinket icons freely by dragging them with the mouse.

- Toggle drag mode with `/tcd drag` or the button in options
- All icons become visible with yellow highlight during drag mode
- Positions are saved automatically when you release the icon
- X/Y sliders in options update automatically after dragging
- Drag mode is disabled during combat

### 💾 Profile System
Save and load complete layouts across all your characters.

- Save current icon positions and all settings as a named profile
- Load profiles on any character on the same account
- Manage profiles via dropdown menu in options or chat commands
- Profiles are stored account-wide in SavedVariables

### 🔤 Font Settings
Separate font configuration tab with LibSharedMedia-3.0 support.

- Dedicated **Fonts** subcategory in Interface Options
- Dropdown with all fonts from LibSharedMedia-3.0
- Grouped alphabetically with submenus for large font libraries
- Live font preview that updates instantly when selecting a font

---

## Install

- [Download](https://github.com/suprepupre/TrinketCDs/releases/latest).
- Extract `TrinketCDs` folder into `<WoW Folder>/Interface/Addons/` folder.

### Folder structure

```
Interface/AddOns/TrinketCDs/
├── Libs/
│   ├── LibStub/
│   │   └── LibStub.lua
│   ├── PoolCompat.lua
│   └── LibCustomGlow-1.0/
│       ├── LibCustomGlow-1.0.lua
│       ├── LibCustomGlow-1.0.toc
│       ├── LibCustomGlow-1.0.xml
│       ├── AM_29.blp
│       ├── Artifacts.blp
│       ├── IconAlert.blp
│       ├── IconAlertAnts.blp
│       └── UIActionBarFX.blp
├── Media/
│   ├── BigBorder.blp
│   └── Emblem.ttf
├── TrinketCDs.toc
├── TrinketCDs_Wrath.toc
├── TrinketCDsDB.lua
├── TrinketCDs.lua
└── TrinketCDsOptions.lua
```

---

## Preview

### All items preview

![Showcase all](/showcase/showcase_all.png)

### Chicken swap preview

Ctrl+Right mouse click to swap to chicken, left mouse click to use. (Ctrl+Right click again to swap back)
> Automatically swaps back to previous trinket after chicken is used, regardless of how chicken was equipped.

![Showcase chicken](/showcase/showcase_chicken.gif)

---

## Drag & Drop

### How to use:
1. Type `/tcd drag` in chat (or click "Toggle Drag Mode" button in options)
2. All trinket/enchant icons will appear with a **yellow highlight**
3. **Left-click and drag** any icon to move it
4. Type `/tcd drag` again (or `/tcd lock`) to save positions and return to normal mode

### Notes:
- Cannot enter drag mode during combat
- Positions are saved to your character's settings automatically
- X/Y sliders in the options panel update in real-time after dragging
- You can still use X/Y sliders for fine-tuning after drag positioning

![Drag & Drop Demo](/showcase/showcase_drag.gif)

---

## Profiles

### What is saved in a profile:
- All icon positions (X/Y)
- Icon sizes, zoom, border settings
- Font settings (file, CD size, stacks size, item level size)
- Visibility settings (show/hide individual slots)
- Global switches (combat only, hide ready, proc glow, glow style, etc.)
- Per-icon glow toggle

### Using profiles via chat:
```
/tcd save MyLayout      — Save current settings
/tcd load MyLayout      — Load profile
/tcd delete MyLayout    — Delete profile
/tcd profiles           — List all saved profiles
```

### Using profiles via UI:
1. Open options: `/tcd options`
2. Go to **TrinketCDs → Profiles** subcategory
3. Select existing profile from dropdown or type a new name
4. Click **Save**, **Load**, or **Delete**

### Sharing layouts between characters:
1. Set up your layout on Character A
2. `/tcd save healer_layout`
3. Log in to Character B
4. `/tcd load healer_layout`

![Profiles Demo](/showcase/showcase_profiles.png)

---

## Proc Glow

### How it works:
- When a tracked item proc buff is active, a glow effect appears around the icon.
- Glow disappears automatically when the buff fades.

### Glow styles:

| Style | Description |
|-------|-------------|
| **Action Button** | Classic WoW action bar glow with marching ants animation |
| **Pixel** | Colored pixel dots orbiting the icon border |
| **Proc Glow** | WeakAuras-style animated proc effect using flipbook spritesheet |

### Settings (TrinketCDs → Glow):
- **Enable proc glow** — master toggle for all glow effects
- **Glow style** — dropdown to choose Action Button, Pixel, or Proc Glow
- **Per-icon toggles** — enable/disable glow for each equipment slot

### Defaults:
- Proc glow is **enabled**
- Glow style is **Action Button**
- All icons have glow enabled
- Proc icon replacement is **disabled** (item icon stays visible during procs)

![Showcase Glow](/showcase/showcase_glow1.png)
![Showcase Glow](/showcase/showcase_glow2.png)

---

## Commands

All commands start with `/tcd`:

| Command | Description |
|---------|-------------|
| `/tcd` | Show all available commands |
| `/tcd options` | Open options panel |
| `/tcd drag` | Toggle drag & drop mode |
| `/tcd lock` | Same as drag (toggles) |
| `/tcd unlock` | Same as drag (toggles) |
| `/tcd move` | Same as drag (toggles) |
| `/tcd save <name>` | Save current layout as profile |
| `/tcd load <name>` | Load a saved profile |
| `/tcd delete <name>` | Delete a saved profile |
| `/tcd profiles` | List all saved profiles |
| `/tcd list` | Same as profiles |
| `/tcd cpu` | Show CPU usage stats |

---

## Mouse Controls

| Action | Effect |
|--------|--------|
| **Drag mode: Left-click drag** | Move icon to new position |
| **Ctrl + Left-click** | Reequip trinket to force cooldown |
| **Shift + Left-click** | Swap trinket slots (13↔14) |
| **Alt + Left-click** | Swap to same-name trinket (different ilvl) |
| **Ctrl + Right-click** | Swap to/from chicken trinket |

### Ctrl-click

Reequips trinket to force its cooldown.

![Showcase swap with control](/showcase/showcase_swap_ctrl.gif)
![Showcase swap with control and 30](/showcase/showcase_swap_ctrl30.gif)

### Shift-click

Swaps trinkets places to force cooldown for both.

![Showcase swap with shift](/showcase/showcase_swap_shift.gif)
![Showcase swap with shift and 30](/showcase/showcase_swap_shift30.gif)

### Alt-click

Swaps for trinket with same name, but different ilvl (if exists in bag).

![Showcase swap with alt](/showcase/showcase_swap_alt.gif)
![Showcase swap with alt and 30](/showcase/showcase_swap_alt30.gif)

---

## Performance

CPU usage from LoD kill

![Showcase cpu usage](/showcase/showcase_cpu_usage.png)

---

## Options

Check in game options for settings. Type `/tcd options` to open.

Settings subcategories:
- **TrinketCDs** — main settings, visibility toggles, trinket swap
- **Trinket1 / Trinket2 / Ring / Belt / ...** — per-icon position, size, zoom, border, font sizes
- **Fonts** — font selection via LibSharedMedia-3.0, live preview
- **Glow** — proc glow enable, style selection (Action Button / Pixel / Proc Glow), per-icon toggles
- **Profiles** — drag mode button, save/load/delete profiles

![Showcase options 1](/showcase/showcase_options1.png)
![Showcase options 2](/showcase/showcase_options2.png)

---

## Changelog

### v2.4.2
- Added 3rd glow style: **Proc Glow** (WeakAuras-style flipbook animation)
- Glow style dropdown now correctly shows selected style with checkmark
- Moved font settings to dedicated **Fonts** subcategory with live preview
- Font preview updates instantly on selection
- Fixed Dislodged Foreign Object not showing proc buff (stacked buff fallback)
- Fixed Action Button Glow overlapping cooldown/stacks/ilvl text
- Text overlay now always renders above all glow effects

### v2.4.1
- Added proc glow effect (Action Button Glow and Pixel Glow)
- Bundled LibCustomGlow-1.0 with LibStub and PoolCompat for 3.3.5a
- Added per-icon glow toggle
- Added Glow settings tab in Interface Options
- Added Drag & Drop icon positioning (`/tcd drag`)
- Added profile system (save/load/delete via chat and UI)
- Added per-character auto-save on logout
- Added Profiles settings tab
- Fixed SetColorTexture missing in 3.3.5a
- Fixed version detection via GetBuildInfo()
- Fixed UI overlap for Profiles panel

### v2.3.0 (upstream)
- Original release by Ridepad

---

## Credits

- Original addon by [Ridepad](https://github.com/Ridepad/TrinketCDs)
- Fork by [suprepupre](https://github.com/suprepupre/TrinketCDs): Drag & Drop, Profiles, Proc Glow, Fonts