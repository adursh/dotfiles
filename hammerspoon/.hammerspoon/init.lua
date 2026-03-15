hs.window.animationDuration = 0

local function focusWindowUnderMouse()
  local pos = hs.mouse.absolutePosition()
  local wins = hs.window.allWindows()
  for _, win in ipairs(wins) do
    if win ~= nil
      and win:isVisible()
      and not win:isMinimized()
      and win:application() ~= nil then
      local f = win:frame()
      if pos.x >= f.x and pos.x <= (f.x + f.w)
        and pos.y >= f.y and pos.y <= (f.y + f.h) then
        if win ~= hs.window.focusedWindow() then
          win:focus()
        end
        return
      end
    end
  end
end

focusTimer = hs.timer.new(0.05, focusWindowUnderMouse)
focusTimer:start()

clickWatcher = hs.eventtap.new(
  { hs.eventtap.event.types.leftMouseDown },
  function()
    focusTimer:stop()
    hs.timer.doAfter(0.3, function()
      focusTimer:start()
    end)
  end
)
clickWatcher:start()
