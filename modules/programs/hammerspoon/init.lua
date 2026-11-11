-- Hammerspoon config, shared by both Macs from home-nix: ~/.hammerspoon/init.lua links here
-- (personal Mac: default.nix in this directory; GMac: home-gmac's [hammerspoon] table).
--
-- tmux-style key sequences: press PREFIX (ctrl+b), then the keys of a sequence.
--   PREFIX o       OmniWM: enter/leave keyboard window mode
--   PREFIX PREFIX  send ctrl+b to the app
--   escape         cancel (an unknown key or a 3 s pause also cancels)
--
-- The hotkey is switched off in Rex and Emacs, so ctrl+b goes straight to them. Rex uses the
-- same PREFIX (modules/programs/rex/init.lua; a per-host Rex local.lua binds PREFIX o there).
-- The OmniWM action calls omniwmctl, so OmniWM needs ipcEnabled = true.
-- Grant Hammerspoon Accessibility access (System Settings > Privacy & Security), which the
-- key capture during a sequence needs.

local PREFIX_MODS, PREFIX_KEY = { "ctrl" }, "b"
local OMNIWMCTL = "/Applications/OmniWM.app/Contents/MacOS/omniwmctl"
local TIMEOUT = 3 -- seconds to wait for the next key
-- Apps that get ctrl+b untouched.
local PASSTHROUGH_APPS = {
  ["com.superlogical.rex"] = true, -- Rex runs its own PREFIX sequences
  ["org.gnu.Emacs"] = true,        -- C-b: backward-char
}

local function omniwm(...)
  local args = { ... }
  local task = hs.task.new(OMNIWMCTL, function(code, _, stderr)
    if code ~= 0 then
      local msg = (stderr or ""):gsub("%s+$", "")
      hs.alert.show("omniwmctl " .. table.concat(args, " ") .. " failed: " .. msg
        .. "\n(is ipcEnabled = true in OmniWM settings?)", 4)
    end
  end, args)
  if not task or not task:start() then
    hs.alert.show("Can't run " .. OMNIWMCTL)
  end
end

-- Sequence tree after PREFIX. A table is a sub-prefix; a function is an action.
local SEQUENCES = {
  o = function() omniwm("command", "toggle-window-mode") end,
}

---------------------------------------------------------------------------------------------

local prefixKey -- the PREFIX hotkey
local tap, timer, alertId
local node, typed = nil, ""

local function hideAlert()
  if alertId then hs.alert.closeSpecific(alertId); alertId = nil end
end

local function stop()
  if tap then tap:stop() end
  if timer then timer:stop() end
  hideAlert()
  node, typed = nil, ""
end

local function hint(n)
  local keys = {}
  for k in pairs(n) do keys[#keys + 1] = k end
  table.sort(keys)
  return table.concat(keys, " ")
end

local function show()
  hideAlert()
  alertId = hs.alert.show("C-b" .. typed .. "  [" .. hint(node) .. "]", "infinite")
end

local function sendPrefixToApp()
  prefixKey:disable()
  hs.eventtap.keyStroke(PREFIX_MODS, PREFIX_KEY, 0)
  prefixKey:enable()
end

local function onKey(e)
  local key = hs.keycodes.map[e:getKeyCode()]
  local flags = e:getFlags()

  if key == "escape" then stop(); return true end
  if typed == "" and key == PREFIX_KEY and flags.ctrl then
    stop(); sendPrefixToApp(); return true
  end

  -- ctrl may still be held from the prefix, so only cmd/alt make a key unknown.
  local nextNode = (not (flags.cmd or flags.alt)) and node[key] or nil
  if type(nextNode) == "function" then
    stop(); nextNode()
  elseif type(nextNode) == "table" then
    node, typed = nextNode, typed .. " " .. key
    timer:start(); show()
  else
    stop() -- unknown key: cancel like tmux, and swallow it
  end
  return true
end

tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, onKey)
timer = hs.timer.delayed.new(TIMEOUT, stop)

prefixKey = hs.hotkey.new(PREFIX_MODS, PREFIX_KEY, function()
  node, typed = SEQUENCES, ""
  tap:start(); timer:start(); show()
end)

-- Keep the hotkey off while a passthrough app is frontmost.
local function updateForApp(app)
  if app and PASSTHROUGH_APPS[app:bundleID()] then
    stop(); prefixKey:disable()
  else
    prefixKey:enable()
  end
end

appWatcher = hs.application.watcher.new(function(_, event, app) -- global: keep from GC
  if event == hs.application.watcher.activated then updateForApp(app) end
end)
appWatcher:start()
updateForApp(hs.application.frontmostApplication())

hs.alert.show("Hammerspoon config loaded")
