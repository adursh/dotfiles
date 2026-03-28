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
