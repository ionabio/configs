# Neovim Configuration

My personal Neovim setup with LSP, Telescope, and modern plugins.

For the complete Windows terminal setup and backup-aware installer, use
[ionabio/configs](https://github.com/ionabio/configs). This editor-only repository
mirrors its `neovim/nvim` directory. After pulling, run `:Lazy restore` to restore
the tested plugin revisions. Treesitter is pinned for Neovim 0.11 compatibility.

## Installation

1. Install Neovim 0.11+
2. Clone this repo to your config directory:
   - Windows: `C:\Users\USERNAME\AppData\Local\nvim`
   - Linux/Mac: `~/.config/nvim`
3. Open Neovim - plugins will auto-install via lazy.nvim
4. Restart Neovim

## Features

- LSP support (clangd, lua_ls)
- Telescope fuzzy finder
- Treesitter syntax highlighting
- Which-key keybinding help
- Trouble diagnostics viewer
- Flash quick navigation
- Auto-completion with nvim-cmp
- Git integration
- And more!

## Requirements

- Neovim 0.11+
- Git
- Node.js (optional, for some LSP servers)
- C compiler (for treesitter, optional)

## Keyboard Shortcuts

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

### Git, Diagnostics, And Buffers

| Shortcut | Action |
| --- | --- |
| `]c` / `[c` | Next / previous git hunk |
| `<leader>gp` | Preview git hunk |
| `<leader>gb` | Show full blame for current line |
| `<leader>gd` | Toggle deleted lines and line highlights |
| `<leader>gm` | Toggle gitsigns comparison between `HEAD` and the repository's `origin/HEAD` |
| `<leader>xx` | Toggle workspace diagnostics in Trouble |
| `<leader>xX` | Toggle current-buffer diagnostics in Trouble |
| `<leader>cs` | Toggle symbols in Trouble |
| `<leader>cl` | Toggle LSP definitions/references in Trouble |
| `<leader>xL` | Toggle location list in Trouble |
| `<leader>xQ` | Toggle quickfix list in Trouble |
| `<leader>bn` | Next buffer |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bl` | List buffers |
