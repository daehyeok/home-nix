-- Rex config, migrated from tmux and iTerm2.

-- tmux (~/.config/tmux/tmux.conf), prefix ctrl+b
rex.bind("ctrl+b>c", "client.tab.new")                -- tmux.conf:6
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" }) -- pass the prefix through

-- iTerm2 GlobalKeyMap
rex.bind("shift+cmd+left", "client.tab.move", { direction = "backward" }) -- 0xf702-0x320000, action 33
rex.bind("shift+cmd+right", "client.tab.move", { direction = "forward" }) -- 0xf703-0x320000, action 34

-- iTerm2 profile "Default" Keyboard Map (overrides GlobalKeyMap on the same key)
rex.bind("cmd+left", "pane.send_key", { key = "ctrl+a" })      -- 0xf702-0x300000, action 11 0x1
rex.bind("cmd+right", "pane.send_key", { key = "ctrl+e" })     -- 0xf703-0x300000, action 11 0x5
-- rex.bind("cmd+backspace", "pane.send_key", { key = "ctrl+u" }) -- 0x7f-0x100000, action 11 0x15
rex.bind("delete", "pane.send_key", { key = "ctrl+d" })        -- 0xf728-0x0, action 11 0x4

-- Ghostty (~/.config/ghostty/config.ghostty): cmd acts as Alt/Meta.
-- Every cmd+<key> sends alt+<key> (ESC+<key>) to the program in the pane.
-- NOTE: this overrides Rex/macOS defaults on these keys (cmd+c/v/t/w/k/d/...).
local meta_keys = {}
for c in ("abcdefghijklnopqrstuvwxyz0123456789"):gmatch(".") do -- no "m": cmd+m is Enter below
  table.insert(meta_keys, c)
end
for _, k in ipairs({ ",", ".", "/", ";", "'", "[", "]", "\\", "-", "=", "`" }) do
  table.insert(meta_keys, k)
end
for _, k in ipairs(meta_keys) do
  if k ~= "v" then -- cmd+v keeps the system paste
    rex.bind("cmd+" .. k, "pane.send_key", { key = "alt+" .. k })
  end
  if k:match("%a") then
    rex.bind("shift+cmd+" .. k, "pane.send_key", { key = "shift+alt+" .. k })
  end
end

-- cmd+m acts as Enter (shift+cmd+m stays Meta like the rest)
rex.bind("cmd+m", "pane.send_key", { key = "enter" })
rex.bind("shift+cmd+m", "pane.send_key", { key = "shift+alt+m" })

-- cmd+backspace: Ghostty sends alt+backspace (ESC DEL); replaces the iTerm2 ctrl+u line above
rex.bind("cmd+backspace", "pane.send_key", { key = "alt+backspace" })

-- Ghostty: always send classic control bytes, even when an app enables kitty/CSI-u
rex.bind("ctrl+m", "pane.send_key", { key = "enter" })
rex.bind("ctrl+i", "pane.send_key", { key = "tab" })
rex.bind("ctrl+[", "pane.send_key", { key = "escape" })

-- ctrl+b <number> jumps to a tab in the CURRENT session (1-9, 0 = tab 10).
-- client.tab.goto counts tabs across all sessions in the sidebar, so use the session's own window list.
rex.action{
  name  = "goto_session_tab",
  title = "Go to Tab in Current Session",
  args  = { index = "integer" },
  run   = function(ctx, args)
    local view, err = rex.session.view{}
    if err ~= nil then error(err, 0) end
    local w = (view.windows or {})[args.index]
    if w == nil then return end -- no such tab: do nothing
    -- the app keeps its own tab selection, so ask it to show this session's window N
    rex.client.queue("session.select", { session_id = view.session_id, window_id = w.window_id })
  end,
}
for i = 1, 9 do
  rex.bind("ctrl+b>" .. i, "goto_session_tab", { index = i })
end
rex.bind("ctrl+b>0", "goto_session_tab", { index = 10 })

-- ctrl+b n / p: next / previous tab, wrapping around inside the CURRENT session (same host).
-- client.tab.next/previous walk every tab in the sidebar and jump to other hosts.
rex.action{
  name  = "cycle_session_tab",
  title = "Next/Previous Tab in Current Session",
  args  = { step = "integer" },
  run   = function(ctx, args)
    local view, err = rex.session.view{}
    if err ~= nil then error(err, 0) end
    local windows = view.windows or {}
    local n = #windows
    if n < 2 then return end
    -- find the tab holding the block the key went to (fallback: server's active window)
    local cur
    for i, w in ipairs(windows) do
      for _, layer in ipairs(w.layers or {}) do
        for _, b in ipairs(layer.blocks or {}) do
          if b.block_id == ctx.block_id then cur = i end
        end
      end
      if cur == nil and w.window_id == view.active_window_id then cur = i end
    end
    cur = cur or 1
    local nxt = ((cur - 1 + args.step) % n) + 1
    rex.client.queue("session.select", { session_id = view.session_id, window_id = windows[nxt].window_id })
  end,
}
rex.bind("ctrl+b>n", "cycle_session_tab", { step = 1 })
rex.bind("ctrl+b>p", "cycle_session_tab", { step = -1 })

-- ctrl+b x: close the current tab immediately, without the app's "is still running" confirmation.
-- (client.tab.close asks first; the server API closes the window and its programs directly.)
rex.action{
  name  = "close_tab_now",
  title = "Close Tab Without Confirmation",
  run   = function(ctx)
    local view, err = rex.session.view{}
    if err ~= nil then error(err, 0) end
    for _, w in ipairs(view.windows or {}) do
      for _, layer in ipairs(w.layers or {}) do
        for _, b in ipairs(layer.blocks or {}) do
          if b.block_id == ctx.block_id then
            local _, cerr = rex.session.close_window{ window_id = w.window_id }
            if cerr ~= nil then error(cerr, 0) end
            return
          end
        end
      end
    end
  end,
}
rex.bind("ctrl+b>x", "close_tab_now")
rex.bind("ctrl+b>shift+x", "client.tab.close") -- X: close with the app's confirmation

-- ctrl+b m: command palette
rex.bind("ctrl+b>m", "client.palette.toggle")

-- ctrl+b s <key>: sidebar / session group (ctrl+b s alone is only a prefix)
rex.bind("ctrl+b>s>t", "client.sidebar.toggle")   -- t: toggle sidebar
rex.bind("ctrl+b>s>f", "session.switch")          -- f: change session (picker)
rex.bind("ctrl+b>s>c", "session.new")             -- c: new session on the current host
rex.bind("ctrl+b>s>r", "session.rename")          -- r: rename current session
rex.bind("ctrl+b>s>shift+r", "session.refresh")   -- R: refresh sessions

