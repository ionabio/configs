# Personal Configs

Configuration files for Neovim, WezTerm, and GlazeWM.

## Layout

| Tool | Repo path | Live path |
| --- | --- | --- |
| Neovim | `neovim/nvim` | `%LOCALAPPDATA%\nvim` |
| WezTerm | `wezterm/.wezterm.lua` | `%USERPROFILE%\.wezterm.lua` |
| GlazeWM | `glazewm/config.yaml` | `%USERPROFILE%\.glzr\glazewm\config.yaml` |

## Neovim Shortcuts

Leader is `Space`.

### General

| Shortcut | Action |
| --- | --- |
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `<Esc>` | Clear search highlight |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move to left / bottom / top / right window |

In buffers with an attached LSP, `<C-k>` opens signature help instead of moving to the top window.

### LSP

| Shortcut | Action |
| --- | --- |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `go` | Go to type definition |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format buffer |
| `gl` | Open diagnostic float |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>h` | Switch C/C++ header and source with clangd |

### Telescope

| Shortcut | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>fs` | Document symbols |
| `<leader>fw` | Workspace symbols |
| `<C-h>` | Show Telescope key help |
| `<C-p>` | Show the selected entry's full path |
| `<C-d>` | Delete selected buffer in the buffers picker |

### Completion

| Shortcut | Action |
| --- | --- |
| `<C-d>` / `<C-f>` | Scroll completion docs up / down |
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selected completion |
| `<Tab>` / `<S-Tab>` | Next / previous completion item |

### Navigation And Tools

| Shortcut | Action |
| --- | --- |
| `<leader>e` | Toggle file explorer |
| `s` | Flash jump |
| `S` | Flash Treesitter |
| `r` | Remote Flash in operator-pending mode |
| `R` | Treesitter search in operator-pending or visual mode |
| `<C-s>` | Toggle Flash search in command mode |

### Git And Diagnostics

| Shortcut | Action |
| --- | --- |
| `]c` / `[c` | Next / previous git hunk |
| `<leader>gp` | Preview git hunk |
| `<leader>gb` | Show full blame for current line |
| `<leader>gd` | Toggle deleted lines and line highlights |
| `<leader>gm` | Toggle gitsigns comparison between `HEAD` and `develop` |
| `<leader>xx` | Toggle workspace diagnostics in Trouble |
| `<leader>xX` | Toggle current-buffer diagnostics in Trouble |
| `<leader>cs` | Toggle symbols in Trouble |
| `<leader>cl` | Toggle LSP definitions/references in Trouble |
| `<leader>xL` | Toggle location list in Trouble |
| `<leader>xQ` | Toggle quickfix list in Trouble |

### Buffers

| Shortcut | Action |
| --- | --- |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bl` | List buffers |

## WezTerm Shortcuts

Bare `Alt` is reserved for GlazeWM. WezTerm management bindings use `Ctrl+Shift`, except numbered tab shortcuts use `Ctrl`.

| Shortcut | Action |
| --- | --- |
| `Ctrl+Shift+O` | Open selected path in Neovim |
| `Ctrl+Shift+R` | Split horizontally with PowerShell |
| `Ctrl+Shift+D` | Split vertically with PowerShell |
| `Ctrl+Shift+B` | Split horizontally with Git Bash |
| `Ctrl+Shift+N` | Split vertically with Git Bash |
| `Ctrl+1` | Open a new PowerShell tab |
| `Ctrl+2` | Open a new Git Bash tab |
| `Ctrl+3` | Open a new tab in the current pane domain |
| `Ctrl+Shift+T` | Open a new tab in the current pane domain |
| `Ctrl+Shift+H` / `J` / `K` / `L` | Focus pane left / down / up / right |
| `Ctrl+Shift+Left` / `Right` / `Up` / `Down` | Resize pane by 5 cells |
| `Ctrl+Shift+W` | Close current pane with confirmation |
| `Ctrl+Shift+S` | Select a pane to swap with the active pane |
| `Ctrl+Shift+F` | Search scrollback |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / paste |
| `Ctrl+Shift+M` | Activate copy mode |
| `Shift+PageUp` / `Shift+PageDown` | Scroll by page |
| `Shift+Home` / `Shift+End` | Scroll to top / bottom |
| `Ctrl+Shift+P` | Show launcher menu |
| `Ctrl+MiddleClick` | Open selected path in Neovim |

## GlazeWM Shortcuts

### Window Focus And Movement

| Shortcut | Action |
| --- | --- |
| `Alt+H` / `Alt+Left` | Focus left |
| `Alt+L` / `Alt+Right` | Focus right |
| `Alt+K` / `Alt+Up` | Focus up |
| `Alt+J` / `Alt+Down` | Focus down |
| `Alt+Shift+H` / `Alt+Shift+Left` | Move window left |
| `Alt+Shift+L` / `Alt+Shift+Right` | Move window right |
| `Alt+Shift+K` / `Alt+Shift+Up` | Move window up |
| `Alt+Shift+J` / `Alt+Shift+Down` | Move window down |

### Window Sizing And State

| Shortcut | Action |
| --- | --- |
| `Alt+U` | Shrink width by 2 percent |
| `Alt+P` | Grow width by 2 percent |
| `Alt+O` | Grow height by 2 percent |
| `Alt+I` | Shrink height by 2 percent |
| `Alt+R` | Enter resize mode |
| `Alt+V` | Toggle tiling direction |
| `Alt+Shift+/` | Cycle focus between tiling, floating, and fullscreen windows |
| `Alt+Shift+;` | Toggle floating and center the window |
| `Alt+Shift+R` | Rebalance layout |
| `Alt+T` | Toggle tiling |
| `Alt+F` | Toggle fullscreen |
| `Alt+M` | Toggle minimized |
| `Alt+Shift+Q` | Close focused window |

In resize mode, use `H`/`Left`, `L`/`Right`, `K`/`Up`, and `J`/`Down` to resize. Press `Esc` or `Enter` to leave resize mode.

### Workspaces And Monitors

| Shortcut | Action |
| --- | --- |
| `Alt+S` / `Alt+A` | Focus next / previous active workspace |
| `Alt+D` | Focus recent workspace |
| `Alt+1` through `Alt+9` | Focus workspace 1 through 9 |
| `Alt+Shift+1` through `Alt+Shift+9` | Move focused window to workspace 1 through 9 and focus it |
| `Alt+Shift+A` | Move current workspace to the monitor on the left |
| `Alt+Shift+F` | Move current workspace to the monitor on the right |
| `Alt+Shift+D` | Move current workspace to the monitor above |
| `Alt+Shift+S` | Move current workspace to the monitor below |

### WM Commands

| Shortcut | Action |
| --- | --- |
| `Alt+Shift+P` | Toggle GlazeWM pause |
| `Alt+Shift+E` | Exit GlazeWM |
| `Alt+Shift+W` | Redraw all windows |
| `Alt+Enter` | Launch `cmd` |
