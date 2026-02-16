# TrinketCDs (Fork)

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Commands](#commands) | [Perfomance](#perfomance) | [Options](#options)

> Forked from [Ridepad/TrinketCDs](https://github.com/Ridepad/TrinketCDs) with permission.

- Addon dynamically tracks cooldown of equipped trinkets and enchants.
- Made to remove headache of copying/creating weakauras for every new character/item.
- Works both on 3.3 and 3.4 WotLK versions.
- Full database of WotLK/TBC trinkets.
- Ashen rings, cloak, weapon, hands, boots and belt enchants.
- Doesn't depend on combat log.
- Proc duration, stacks, cooldown.
- Loging and Cooldown on login and after inventory change.
- Has built-in cooldown text (use [OmniCC](https://www.curseforge.com/wow/addons/omni-cc/files/454434) as alternative).
- Caches cooldown even if trinket was unequiped after proc (useful if server has different iCD on equip).

## New Features

### 🔄 Drag & Drop Positioning
Move trinket icons freely by dragging them with the mouse. No more manual X/Y coordinate input!

- Toggle drag mode with `/tcd drag` or the button in options
- All icons become visible with yellow highlight during drag mode
- Positions are saved automatically when you release the icon
- X/Y sliders in options update automatically after dragging
- Drag mode is disabled during combat

![Drag & Drop Demo](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_drag.gif)

### 💾 Profile System
Save and load complete layouts across all your characters.

- Save current icon positions and all settings as a named profile
- Load profiles on any character on the same account
- Manage profiles via dropdown menu in options or chat commands
- Profiles are stored account-wide in SavedVariables

![Profiles Demo](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_profiles.png)

---

## Install

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Commands](#commands) | [Perfomance](#perfomance) | [Options](#options)

- [Download](https://github.com/suprepupre/TrinketCDs/releases/latest).
- Extract `TrinketCDs` folder into `<WoW Folder>/Interface/Addons/` folder.

## Preview

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Commands](#commands) | [Perfomance](#perfomance) | [Options](#options)

### All items preview

![Showcase all](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_all.png)

### Chicken swap preview

Ctrl+Right mouse click to swap to chicken, left mouse click to use. (Ctrl+Right click again to swap back)
> Automatically swaps back to previous trinket after chicken is used, regardless of how chicken was equipped.

![Showcase chicken](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_chicken.gif)

---

## Drag & Drop

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Commands](#commands) | [Perfomance](#perfomance) | [Options](#options)

### How to use:
1. Type `/tcd drag` in chat (or click "Toggle Drag Mode" button in options)
2. All trinket/enchant icons will appear with a **yellow highlight**
3. **Left-click and drag** any icon to move it
4. Type `/tcd drag` again (or `/tcd lock`) to save positions and return to normal mode

### Important notes:
- ⚠️ Cannot enter drag mode during combat
- Positions are saved to your character's settings automatically
- X/Y sliders in the options panel update in real-time after dragging
- You can still use X/Y sliders for fine-tuning after drag positioning

![Drag & Drop Demo](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_drag.gif)

---

## Profiles

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Commands](#commands) | [Perfomance](#perfomance) | [Options](#options)

### What is saved in a profile:
- All icon positions (X/Y)
- Icon sizes
- Zoom, border settings
- Font sizes (CD, stacks, item level)
- Visibility settings (show/hide individual slots)
- Global switches (combat only, hide ready, etc.)

### Using profiles via chat:
1. /tcd save MyLayout - Save current settings as "MyLayout"
2. /tcd load MyLayout - Load "MyLayout" profile
3. /tcd delete MyLayout - Delete "MyLayout" profile
4. /tcd profiles - List all saved profiles

### Using profiles via UI:
1. Open options: `/tcd options`
2. Scroll to **Profiles** section at the bottom
3. Select existing profile from dropdown or type a new name
4. Click **Save**, **Load**, or **Delete**

### Sharing layouts between characters:
1. Set up your layout on Character A
2. `/tcd save healer_layout`
3. Log in to Character B
4. `/tcd load healer_layout`

![Profiles Demo](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_profiles.png)

---

## Commands

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Commands](#commands) | [Perfomance](#perfomance) | [Options](#options)

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

### Left mouse click preview

Default iCD vs 30 sec forced

#### Ctrl-click

Reequips trinket to force it's cooldown.

![Showcase swap with control](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_swap_ctrl.gif)
![Showcase swap with control and 30](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_swap_ctrl30.gif)

#### Shift-click

Swaps trinkets places to force cooldown for both.

![Showcase swap with shift](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_swap_shift.gif)
![Showcase swap with shift and 30](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_swap_shift30.gif)

#### Alt-click

Swaps for trinket with same name, but different ilvl (if exists in bag).

![Showcase swap with alt](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_swap_alt.gif)
![Showcase swap with alt and 30](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_swap_alt30.gif)

---

## Perfomance

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Commands](#commands) | [Perfomance](#perfomance) | [Options](#options)

CPU usage from LoD kill

![Showcase cpu usage](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_cpu_usage.png)

---

## Options

**Fast jump:** [Install](#install) | [Preview](#preview) | [New Features](#new-features) | [Drag & Drop](#drag--drop) | [Profiles](#profiles) | [Commands](#commands) | [Perfomance](#perfomance) | [Options](#options)

Check in game options for settings. Type `/tcd options` to open.

![Showcase options 1](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_options1.png)
![Showcase options 2](https://raw.githubusercontent.com/suprepupre/TrinketCDs/main/showcase/showcase_options2.png)

---

## Credits

- Original addon by [Ridepad](https://github.com/Ridepad/TrinketCDs)
- Fork additions by [Suprematist]: Drag & Drop positioning, Profile system 