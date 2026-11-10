-- Rex config, migrated from tmux and iTerm2.

-- tmux (~/.config/tmux/tmux.conf), prefix ctrl+b
rex.bind("ctrl+b>c", "client.tab.new")                -- tmux.conf:6
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" }) -- pass the prefix through

-- cmd+arrows (and shift+cmd+arrows) are left unbound: OmniWM uses them on macOS for
-- window focus/move (common/modules/programs/omniwm). Use ctrl+a / ctrl+e for line start/end.

-- iTerm2 profile "Default" Keyboard Map
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

-- Tab switching inside the CURRENT session (same host).
-- The app can't "session.select" a session that lives on a remote host (cloudtop), and
-- client.tab.goto counts tabs across every host in the sidebar. So we find the current tab's
-- position in this session and step there with client.tab.next/previous: a session's tabs are
-- contiguous in the sidebar, so the steps never leave the session.
local function session_tabs(ctx)
  local view, err = rex.session.view{}
  if err ~= nil then error(err, 0) end
  local windows = view.windows or {}
  local cur
  for i, w in ipairs(windows) do
    for _, layer in ipairs(w.layers or {}) do
      for _, b in ipairs(layer.blocks or {}) do
        if b.block_id == ctx.block_id then cur = i end
      end
    end
  end
  if cur == nil then -- fallback: the server's active window
    for i, w in ipairs(windows) do
      if w.window_id == view.active_window_id then cur = i end
    end
  end
  return #windows, cur or 1
end

local function step_tabs(delta)
  local action = delta > 0 and "client.tab.next" or "client.tab.previous"
  for _ = 1, math.abs(delta) do rex.client.queue(action, {}) end
end

-- ctrl+b <number>: go to tab N of the current session (1-9, 0 = tab 10).
rex.action{
  name  = "goto_session_tab",
  title = "Go to Tab in Current Session",
  args  = { index = "integer" },
  run   = function(ctx, args)
    local n, cur = session_tabs(ctx)
    if args.index > n then return end -- no such tab: do nothing
    step_tabs(args.index - cur)
  end,
}
for i = 1, 9 do
  rex.bind("ctrl+b>" .. i, "goto_session_tab", { index = i })
end
rex.bind("ctrl+b>0", "goto_session_tab", { index = 10 })

-- ctrl+b n / p: next / previous tab, wrapping around inside the current session.
rex.action{
  name  = "cycle_session_tab",
  title = "Next/Previous Tab in Current Session",
  args  = { step = "integer" },
  run   = function(ctx, args)
    local n, cur = session_tabs(ctx)
    if n < 2 then return end
    local nxt = ((cur - 1 + args.step) % n) + 1
    step_tabs(nxt - cur)
  end,
}
rex.bind("ctrl+b>n", "cycle_session_tab", { step = 1 })
rex.bind("ctrl+b>p", "cycle_session_tab", { step = -1 })

-- ctrl+b x x: close the current tab immediately, without the app's "is still running" confirmation.
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
rex.bind("ctrl+b>shift+x", "client.tab.close") -- X: close with the app's confirmation

-- Panes, Emacs C-x style: ctrl+b x <key> (ctrl may stay held on the x: ctrl+b ctrl+x <key>).
--   2 split below   3 split right   0 close pane   1 close other panes   o next pane   x close tab
rex.action{
  name  = "close_pane_now",
  title = "Close Pane Without Confirmation",
  run   = function(ctx)
    local _, err = rex.call("block.close", { session_id = ctx.session_id, block_id = ctx.block_id })
    if err ~= nil then error(err, 0) end
  end,
}
local pane_keys = {
  ["2"] = { "pane.split", { direction = "down" } },
  ["3"] = { "pane.split", { direction = "right" } },
  ["0"] = { "close_pane_now" },
  ["1"] = { "pane.close_others" },
  ["o"] = { "pane.focus_next" },
  ["x"] = { "close_tab_now" },
}
for key, b in pairs(pane_keys) do
  rex.bind("ctrl+b>x>" .. key, b[1], b[2])
  rex.bind("ctrl+b>ctrl+x>" .. key, b[1], b[2])
end

-- cmd+1..9: go to pane N of the current tab, numbered like Emacs winum (Spacemacs M-1..9,
-- cmd = Meta): top-left first, in layout order. When the focused pane runs Emacs, or the tab
-- has fewer panes than N, the key goes to the program as alt+N instead (so winum inside a
-- terminal Emacs keeps working).
local function tab_panes(ctx)
  local view = rex.session.view{}
  for _, w in ipairs((view and view.windows) or {}) do
    for _, layer in ipairs(w.layers or {}) do
      if layer.kind == "tiled" then
        local ids, found = {}, false
        local function walk(n)
          if not n then return end
          if n.block_id then
            ids[#ids + 1] = n.block_id
            if n.block_id == ctx.block_id then found = true end
          elseif n.split then
            walk(n.split.before); walk(n.split.after)
          end
        end
        walk(layer.layout)
        if found then return ids end
      end
    end
  end
  return {}
end

rex.action{
  name  = "goto_pane",
  title = "Go to Pane N in Current Tab",
  args  = { index = "integer" },
  run   = function(ctx, args)
    local proc = rex.block.call("com.superlogical.terminal", "process",
      { session_id = ctx.session_id, block_id = ctx.block_id })
    local fg = (proc and proc.foreground and proc.foreground.name) or ""
    local panes = tab_panes(ctx)
    if fg:match("emacs") or args.index > #panes then
      rex.client.queue("pane.send_key", { key = "alt+" .. args.index })
      return
    end
    local _, err = rex.session.focus_block{ block_id = panes[args.index] }
    if err ~= nil then error(err, 0) end
  end,
}
for i = 1, 9 do
  rex.bind("cmd+" .. i, "goto_pane", { index = i }) -- after the cmd->alt loop above, so this wins
end

-- ctrl+b m: command palette
rex.bind("ctrl+b>m", "client.palette.toggle")

-- ctrl+b s <key>: sidebar / session group (ctrl+b s alone is only a prefix)
rex.bind("ctrl+b>s>t", "client.sidebar.toggle")   -- t: toggle sidebar
rex.bind("ctrl+b>s>f", "session.switch")          -- f: change session (picker)
rex.bind("ctrl+b>s>c", "session.new")             -- c: new session on the current host
rex.bind("ctrl+b>s>r", "session.rename")          -- r: rename current session
rex.bind("ctrl+b>s>shift+r", "session.refresh")   -- R: refresh sessions

-- ctrl+b [: copy mode, like tmux. Rex has no keyboard copy mode, so this opens the pane's
-- screen and scrollback read-only in Emacs, in a full-window floating pane on the same host
-- (works for remote hosts too). Emacs keys select text: C-SPC mark, C-n/C-p/M-v/C-v/C-s move,
-- M-w copies to the clipboard (OSC 52, which Rex hands to the client) and exits, q quits.
local copy_mode_el = [==[
(progn
  (setq inhibit-startup-screen t make-backup-files nil auto-save-default nil)
  (menu-bar-mode -1)
  (setq-default truncate-lines t)
  (defun rex-copy-mode-copy (beg end)
    (interactive "r")
    (let ((s (buffer-substring-no-properties beg end)))
      (send-string-to-terminal
       (format "%c]52;c;%s%c" 27 (base64-encode-string (encode-coding-string s 'utf-8) t) 7))
      (kill-emacs 0)))
  (global-set-key (kbd "M-w") #'rex-copy-mode-copy)
  (global-set-key (kbd "q") (lambda () (interactive) (kill-emacs 0)))
  (read-only-mode 1)
  (setq-default mode-line-format " COPY MODE  C-SPC mark  M-w copy+exit  C-s search  q quit")
  (add-hook 'emacs-startup-hook
            (lambda ()
              (goto-char (point-max))
              (skip-chars-backward " \t\n")
              (beginning-of-line)
              (ignore-errors (recenter -1)))))
]==]

-- $1 = block to capture, $2 = the Emacs setup above. Runs on the block's own host, where
-- `rex` talks to that host's server.
local copy_mode_sh = [[
f=$(mktemp "${TMPDIR:-/tmp}/rex-copy.XXXXXX") || exit 1
trap 'rm -f "$f"' EXIT HUP INT TERM
rex block capture -b "$1" --unwrap > "$f" && emacs -nw -Q "$f" --eval "$2"
]]

rex.action{
  name  = "copy_mode",
  title = "Copy Mode (Emacs)",
  run   = function(ctx)
    local req = {
      session_id = ctx.session_id,
      bounds = { 0, 0, 1, 1 },
      focus = true,
      layout = { block = {
        flavor = "com.superlogical.terminal.shell",
        label = "copy mode",
        options = { command = { "sh", "-c", copy_mode_sh, "rex-copy", ctx.block_id, copy_mode_el } },
      } },
    }
    local _, err = rex.session.new_layer(req)
    if err ~= nil and ctx.server then -- remote tab: call that host's server directly
      _, err = rex.server(ctx.server).session.new_layer(req)
    end
    if err ~= nil then error(err, 0) end
  end,
}
rex.bind("ctrl+b>[", "copy_mode")

-- Host-specific overrides from ~/.config/rex/local.lua (not managed by
-- home-manager, so it can be edited freely per machine).
-- KEEP THIS AT THE END OF THE FILE: later bindings win, so loading local.lua
-- last gives it the highest priority and lets it override anything above.
-- home-manager creates an empty file on switch if it is missing (see
-- default.nix), so this require never fails.
require("local")
