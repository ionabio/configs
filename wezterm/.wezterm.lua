local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Shells (explicit)
local pwsh = { 'pwsh.exe', '-NoLogo' }
local git_bash = { 'C:\\Program Files\\Git\\bin\\bash.exe', '--login', '-i' }
local git_bash_env = { CHERE_INVOKING = '1', MSYSTEM = 'MINGW64' }

-- Editor (explicit)
local micro_exe = 'nvim'

local function url_decode(s)
    if not s then
        return nil
    end

    s = s:gsub('+', ' ')
    s = s:gsub('%%(%x%x)', function(hex)
        return string.char(tonumber(hex, 16))
    end)
    return s
end

local function parse_query(q)
    local params = {}
    if not q or q == '' then
        return params
    end

    for key, value in q:gmatch('([^&=?]+)=([^&]*)') do
        params[key] = url_decode(value)
    end

    return params
end

-- Helper function to open a file path in neovim (reuses existing pane or creates split)
local function open_in_nvim(window, pane, file_path, line, col)
    if not file_path or file_path == '' then
        return
    end

    -- If line/col not provided, try to parse from file_path
    if not line then
        local path_only, line_str, col_str = file_path:match('^(.+):(%d+):?(%d*)$')
        if path_only then
            file_path = path_only
            line = tonumber(line_str)
            col = tonumber(col_str)
        end
    end

    local args = { micro_exe }
    if line and line > 0 then
        table.insert(args, '+' .. tostring(line))
        if col and col > 0 then
            table.insert(args, '+normal! ' .. tostring(col - 1) .. '|')
        end
    end
    table.insert(args, file_path)

    -- Try to find an existing neovim pane
    local tab = window:active_tab()
    local nvim_pane = nil

    if tab then
        for _, p in ipairs(tab:panes()) do
            local process_name = p:get_foreground_process_name()
            if process_name and process_name:find('nvim') then
                nvim_pane = p
                break
            end
        end
    end

    if nvim_pane then
        -- Send command to existing neovim pane
        nvim_pane:activate()
        local nvim_cmd = ':edit '
        if line and line > 0 then
            nvim_cmd = nvim_cmd .. '+' .. tostring(line) .. ' '
            if col and col > 0 then
                nvim_cmd = nvim_cmd .. '+normal!\\ ' .. tostring(col - 1) .. '\\| '
            end
        end
        nvim_cmd = nvim_cmd .. file_path .. '\r'
        nvim_pane:send_text(nvim_cmd)
    else
        -- Create new vertical split
        window:perform_action(wezterm.action.SplitHorizontal { args = args }, pane)
    end
end

-- Open micro:// links inside wezterm; prevent the default OS handler
wezterm.on('open-uri', function(window, pane, uri)
    if type(uri) ~= 'string' then
        return
    end

    if not uri:match('^micro://') then
        return
    end

    local target, query = uri:match('^micro://([^?]*)%??(.*)$')
    if target ~= 'open' then
        return
    end

    local params = parse_query(query)
    local path = params.path
    if not path or path == '' then
        return
    end

    local line = tonumber(params.line)
    local col = tonumber(params.col)

    open_in_nvim(window, pane, path, line, col)
    return false
end)

config.default_prog = pwsh

-- Reserve bare Alt for GlazeWM. Keep WezTerm management on Ctrl+Shift.
local wezterm_mods = 'CTRL|SHIFT'
local wezterm_num_mods = 'CTRL'
config.disable_default_key_bindings = true

-- Appearance
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 12
config.line_height = 1.2
config.scrollback_lines = 50000
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }

-- Launcher menu
config.launch_menu = {
    { label = 'PowerShell', args = pwsh },
    { label = 'Git Bash',   args = git_bash },
}

config.keys = {
    -- Open selection as file path in neovim
    {
        key = 'o',
        mods = wezterm_mods,
        action = wezterm.action_callback(function(window, pane)
            local success, selection = pcall(function()
                return window:get_selection_text_for_pane(pane)
            end)

            if success and selection and selection ~= '' then
                selection = selection:match('^%s*(.-)%s*$')
                open_in_nvim(window, pane, selection)
            end
        end),
    },

    -- Panes: explicit shells
    { key = 'r',          mods = wezterm_mods, action = wezterm.action.SplitHorizontal { args = pwsh } },
    { key = 'd',          mods = wezterm_mods, action = wezterm.action.SplitVertical { args = pwsh } },
    { key = 'b',          mods = wezterm_mods, action = wezterm.action.SplitHorizontal { args = git_bash, set_environment_variables = git_bash_env } },
    { key = 'n',          mods = wezterm_mods, action = wezterm.action.SplitVertical { args = git_bash, set_environment_variables = git_bash_env } },

    -- New tabs
    { key = '1',          mods = wezterm_num_mods, action = wezterm.action.SpawnCommandInNewTab { args = pwsh } },
    { key = '2',          mods = wezterm_num_mods, action = wezterm.action.SpawnCommandInNewTab { args = git_bash, set_environment_variables = git_bash_env } },
    { key = '3',          mods = wezterm_num_mods, action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    { key = 't',          mods = wezterm_mods, action = wezterm.action.SpawnTab 'CurrentPaneDomain' },

    -- Navigate panes
    { key = 'h',          mods = wezterm_mods, action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'l',          mods = wezterm_mods, action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'k',          mods = wezterm_mods, action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'j',          mods = wezterm_mods, action = wezterm.action.ActivatePaneDirection 'Down' },

    -- Resize panes
    { key = 'LeftArrow',  mods = wezterm_mods, action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
    { key = 'RightArrow', mods = wezterm_mods, action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
    { key = 'UpArrow',    mods = wezterm_mods, action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
    { key = 'DownArrow',  mods = wezterm_mods, action = wezterm.action.AdjustPaneSize { 'Down', 5 } },

    -- Close pane
    { key = 'w',          mods = wezterm_mods, action = wezterm.action.CloseCurrentPane { confirm = true } },

    -- Swap pane with UI selection
    { key = 's',          mods = wezterm_mods, action = wezterm.action.PaneSelect { mode = 'SwapWithActive' } },

    -- Search in scrollback
    { key = 'f',          mods = 'CTRL|SHIFT', action = wezterm.action.Search { CaseInSensitiveString = '' } },

    -- Clipboard
    { key = 'c',          mods = wezterm_mods, action = wezterm.action.CopyTo 'Clipboard' },
    { key = 'v',          mods = wezterm_mods, action = wezterm.action.PasteFrom 'Clipboard' },

    -- Copy mode
    { key = 'm',          mods = wezterm_mods, action = wezterm.action.ActivateCopyMode },

    -- Quick scroll
    { key = 'PageUp',     mods = 'SHIFT',      action = wezterm.action.ScrollByPage(-1) },
    { key = 'PageDown',   mods = 'SHIFT',      action = wezterm.action.ScrollByPage(1) },
    { key = 'Home',       mods = 'SHIFT',      action = wezterm.action.ScrollToTop },
    { key = 'End',        mods = 'SHIFT',      action = wezterm.action.ScrollToBottom },

    -- Command palette
    { key = 'p',          mods = wezterm_mods, action = wezterm.action.ActivateCommandPalette },
}

-- Mouse bindings
config.mouse_bindings = {
    -- Ctrl+MiddleClick: Open selection as file in neovim
    {
        event = { Up = { streak = 1, button = 'Middle' } },
        mods = 'CTRL',
        action = wezterm.action_callback(function(window, pane)
            local success, selection = pcall(function()
                return window:get_selection_text_for_pane(pane)
            end)

            if success and selection and selection ~= '' then
                selection = selection:match('^%s*(.-)%s*$')
                open_in_nvim(window, pane, selection)
            end
        end),
    },
}

-- Link rules (no lookbehind)
local rules = {
    -- Repo-root relative paths with line numbers
    {
        regex = [[(^|[\s\(\[\{<"'`])((?:src|include|Resource|cmake|shared)/[^\s:]+):(\d+)]],
        format = 'micro://open?path=C:/Development/Aim/aim_gitlab/aimsport-vision/$2&line=$3',
    },

    -- Repo-root relative paths without line numbers
    {
        regex = [[(^|[\s\(\[\{<"'`])((?:src|include|Resource|cmake|shared)/[^\s]+)]],
        format = 'micro://open?path=C:/Development/Aim/aim_gitlab/aimsport-vision/$2',
    },

    -- Absolute Windows paths with line numbers
    {
        regex = [[(^|[\s\(\[\{<"'`])([A-Za-z]:/[^\s:]+):(\d+)]],
        format = 'micro://open?path=$2&line=$3',
    },

    -- Absolute Windows paths without line numbers
    {
        regex = [[(^|[\s\(\[\{<"'`])([A-Za-z]:/[^\s]+)]],
        format = 'micro://open?path=$2',
    },
}

-- Append defaults after our custom rules
for _, r in ipairs(wezterm.default_hyperlink_rules()) do
    table.insert(rules, r)
end

config.hyperlink_rules = rules

return config
