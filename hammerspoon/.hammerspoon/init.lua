hs.execute("export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH")

-- Dropdown terminal using Visor.spoon
hs.loadSpoon("Visor")
-- hs.loadSpoon tells Hammerspoon to load a Spoon from ~/.hammerspoon/Spoons/

spoon.Visor:configureForKitty({
  height = 0.40,   -- 40% of screen height, adjust to your taste
  opacity = 0.95   -- slight transparency, 1.0 = fully opaque
})

spoon.Visor:bindHotKeys {
  toggleTerminal = { {"ctrl"}, "`" }
  -- ctrl+` is a natural dropdown key, won't conflict with your option-based AeroSpace binds
}

-- Show on whichever display your cursor/focus is on
spoon.Visor:showOnDisplayBehavior(spoon.Visor.DisplayOptions.ActiveDisplay)

spoon.Visor:start()
-- start() must be called last — registers the hotkey and starts monitoring
