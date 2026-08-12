# AGENTS.md

## Overview

This is a [sketchybar](https://github.com/FelixKratz/sketchybar) configuration for macOS menu bar. It consists of bash scripts that configure the status bar, including workspace indicators, front app display, and network speed monitoring.

## Directory Structure

```
sketchybar/
├── sketchybarrc         # Main config file - sourced by sketchybar on startup
├── colors.sh           # Color definitions (Catppuccin Mocha theme)
├── items/              # Menu bar item definitions
│   ├── front_app.sh    # Frontmost application display
│   ├── network.sh      # Network speed indicator
│   └── spaces.sh       # Aerospace workspace indicators (1-10)
└── plugins/            # Item scripts executed by sketchybar events
    ├── front_app.sh    # Updates front app label
    ├── aerospace.sh    # Updates workspace display state
    └── network_speed.sh # Calculates and displays network throughput
```

## Commands

### Reload Configuration
```bash
# Restart sketchybar with fresh config
brew services restart sketchybar

# Or kill and relaunch
killall sketchybar && sketchybar &
```

### Manual Triggering
```bash
# Force update all items
sketchybar --update

# Trigger specific event
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="1"
```

### Workspace Slider Design
- `ws_indicator` is a single sliding thumb anchored after `space.10`; it is **never** `--move`d. Constant `width=16`; per-digit `background.x_offset` targets are measured from digit glyph centers minus an optical nudge: `TARGET=(0 -202 -183 -165 -145 -125 -105 -85 -65 -45 -21)` (home center = 254.5).
- ONE hidden listener item (`ws_listener`, `drawing=off`) subscribes to `aerospace_workspace_change` — never subscribe the same script to every `space.N` (10× concurrent processes = race fuel).
- `plugins/aerospace.sh` emits the ENTIRE slide + squash + highlight in ONE `sketchybar` message, so a newer workspace change atomically replaces any in-flight animation:
  - Slide: `--animate tanh $DUR --set ws_indicator background.x_offset=$T` — starts from the thumb's current (possibly mid-flight) value; NO cache file, NO sleep, NO manual START jump. `DUR = min(3 + DIST, 6)` frames.
  - Squash: a chained keyframe (set `width=16` in the slide block to make it wait) animates the ITEM width `16 → W → 16` (`W` = 12/13/14 for dist ≥6/3-5/2; none for adjacent — `W` must default to 16 so `P = 16 - W = 0` keeps adjacent moves on the no-squash path). The shrink is left-anchored; rightward motion pins the leading edge via `background.x_offset=$((T+P))`, leftward keeps the left edge fixed.
  - Compensation: `front_app`'s `padding_left` animates `12 → 12+P → 12` in a second `--set` block UNDER THE SAME `--animate` as the width keyframes — one animator drives every `--set` that follows it, so the compensation is pixel-synced with the squash. The slide block also re-sets `padding_left=12` (current value) to make the squash's compensation chain after the slide.
  - Highlight: one `--set space.N label.color=...` per digit (all dark) + animated fade on the focused one — full truth per event, last message always wins.
- `--set` accepts ONE item per call — a bare item name in a key/value list errors and the remaining pairs are applied to the CURRENT item (e.g. `--set ws_indicator ... front_app padding_left=12` leaks `padding_left=12` onto `ws_indicator`, shifting its drawn position). Never mix items in one `--set`; use separate `--set` blocks under the same `--animate` instead.
- `background.padding_*` TRANSLATES the whole thumb (both edges move, width unchanged) — it does NOT inset. A real size-squash requires animating the item `width` (left-anchored) with the leading edge pinned via `x_offset`, plus `front_app` padding compensation as above. Item `padding_left` shifts the background draw rightward within the flow slot (calibration assumes the default `1/1`), so never set it on `ws_indicator`.
- Query path for the thumb: `sketchybar --query ws_indicator` → `geometry.background.x_offset`.

### Testing Individual Scripts
```bash
# Run a plugin directly (for debugging)
FOCUSED_WORKSPACE="1" NAME="space.1" bash ~/.config/sketchybar/plugins/aerospace.sh
```

## Code Style Guidelines

### Shebang and Environment
- Always use `#!/bin/bash`
- All scripts must be executable (`chmod +x`)
- Use `set -euo pipefail` at script top for safety

### Variables
- Use `UPPER_SNAKE_CASE` for exported/config variables (e.g., `CONFIG_DIR`, `PLUGIN_DIR`)
- Use `lower_snake_case` for local variables within functions
- Quote all variable expansions: `"$VAR"` not `$VAR`
- Use `${VAR:-default}` for defaults

### Color Format
- Use 8-digit hex with alpha: `0xffRRGGBB`
- All colors defined in `colors.sh` as exports
- Example: `export TEXT=0xffcdd6f4`

### Sketchybar Item Creation Pattern
```bash
sketchybar --add item <name> <position> \
  --set <name> \
    key=value \
    key=value \
    script="$PLUGIN_DIR/<script>.sh" \
  --subscribe <name> <event1> <event2>
```

### Sketchybar Plugin Script Pattern
```bash
#!/bin/bash
# Use $NAME for item name, $INFO for event data
sketchybar --set "$NAME" label="$INFO"
```

### Conditionals and Tests
- Use `[[ ]]` for string tests (bash)
- Use `[ ]` with proper quoting for numeric comparisons
- Always check command exit status: `cmd || { echo "error"; exit 1; }`

### Functions
- Use `function_name()` syntax (no `function` keyword)
- Local variables with `local` keyword
- Return early for error conditions

### Networking Plugins
- Cache state in `/tmp/sketchybar_*` files
- Include cache invalidation logic (60s TTL typical)
- Handle missing commands gracefully with defaults

### Background Tasks
- Prefer `2>/dev/null` over `&>/dev/null` for suppressing stderr alone
- Use `--animate tanh <duration>` for smooth transitions (15ms typical)
- All workspaces pre-created at startup, hidden until needed

## Common sketchybar Properties

| Property | Purpose |
|----------|---------|
| `label` | Text displayed |
| `icon` | Icon glyph |
| `script` | Executed on event |
| `click_script` | Executed on click |
| `background.drawing` | Toggle background |
| `label.font` | Font string format: `Face:Style:Size` |
| `update_freq` | Update interval in seconds |
| `drawing` | Show/hide item |

## Dependencies

- [sketchybar](https://github.com/FelixKratz/sketchybar)
- [aerospace](https://github.com/nikitabobko/AeroSpace)
- `brew services` (Homebrew)
