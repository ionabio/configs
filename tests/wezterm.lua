local wez = {
  config_builder = function() return {} end,
  action_callback = function(fn) return fn end,
  font = function(name) return name end,
  default_hyperlink_rules = function() return {} end,
  action = setmetatable({}, { __index = function(_, key)
    local actions = { IncreaseFontSize=true, DecreaseFontSize=true, ResetFontSize=true }
    if actions[key] then return key end
    return function(value) return {kind=key, value=value} end
  end }),
}
local handlers = {}
wez.on = function(name, fn) handlers[name] = fn end
package.preload.wezterm = function() return wez end
local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
local config = dofile(root .. '/wezterm/.wezterm.lua')
local selection, action
local pane = {}
local window = {
  get_selection_text_for_pane = function() return selection end,
  perform_action = function(_, result, source) assert(source == pane); action = result end,
}
local open
local bindings = {}
for _, binding in ipairs(config.keys) do
  bindings[binding.mods .. ':' .. binding.key] = binding.action
  if binding.key == 'o' then open = binding.action end
end
local count = 0
local function check(path, file, cursor, link)
  selection, action = path, nil
  if link then assert(handlers['open-uri'](window, pane, link) == false)
  else open(window, pane) end
  local args = assert(action).value.args
  assert(args[1] == 'nvim' and args[#args-1] == '--')
  assert(args[#args] == file, vim.inspect(args))
  if cursor then assert(args[2] == '+call cursor(' .. cursor .. ')', vim.inspect(args)) end
  count = count + 1
end
check('"C:/work/main.cpp:12:7"', 'C:/work/main.cpp', '12,7')
check('"C:/work/main.cpp":12:7', 'C:/work/main.cpp', '12,7')
check("'C:/work/a b.cpp:12'", 'C:/work/a b.cpp', '12,1')
check('C:\\work\\main.cpp:12:7', 'C:\\work\\main.cpp', '12,7')
check('src/main.cpp:12', 'src/main.cpp', '12,1')
check('"C:/work/a b.cpp"', 'C:/work/a b.cpp')
check('-test.cpp', '-test.cpp')
check(nil, 'C:/work/a&b#c%20+d.cpp', nil, 'nvim-path:C:/work/a&b#c%20+d.cpp')
check(nil, 'src/main.cpp', '9,4', 'nvim-path:"src/main.cpp:9:4"')
check(nil, 'C:/work/a b.cpp', '3,2', 'nvim://open?path=C%3A%2Fwork%2Fa%20b.cpp&line=3&col=2')
for _, invalid in ipairs({'bad\npath', '   ', '""'}) do
  selection, action = invalid, nil
  open(window, pane)
  assert(action == nil)
  count = count + 1
end
assert(handlers['open-uri'](window, pane, 'https://example.com') == nil)
assert(bindings['CTRL:Tab'].value == 1 and bindings['CTRL|SHIFT:Tab'].value == -1)
assert(bindings['CTRL:='] == 'IncreaseFontSize')
assert(bindings['CTRL:-'] == 'DecreaseFontSize')
assert(bindings['CTRL:0'] == 'ResetFontSize')
print('PASS: ' .. count .. ' file-opening cases and tab/zoom bindings')
