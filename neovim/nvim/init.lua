-- Neovim Configuration
-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Cannot install lazy.nvim: " .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Keep undo history after closing and reopening a file.
vim.opt.undofile = true

-- Basic Settings
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " "

vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.mouse = 'a'           -- Enable mouse
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.ignorecase = true     -- Case insensitive search
vim.opt.smartcase = true      -- Unless search has uppercase
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 4        -- Indent width
vim.opt.tabstop = 4           -- Tab width
vim.opt.termguicolors = true  -- True color support
vim.opt.cursorline = true     -- Highlight current line
vim.opt.signcolumn = 'yes'    -- Always show sign column
vim.opt.updatetime = 250      -- Faster completion
vim.opt.timeoutlen = 300      -- Faster key sequence completion

-- Folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false        -- Start with folds open
vim.opt.foldlevel = 99            -- High level = most folds open by default
vim.opt.foldlevelstart = 99       -- Open all folds when opening a file

-- Setup plugins with lazy.nvim
require("lazy").setup({
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- LSP server installer
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration for nvim
      { 'folke/neodev.nvim', opts = {} },
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },

  -- Treesitter for parser installation
  {
    'nvim-treesitter/nvim-treesitter',
    commit = '568ede7e79172a0fe7c9d631454a97ad968deaf2', -- Tested with Neovim 0.11.
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.1',  -- Keep the tested Neovim 0.11-compatible release.
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Color scheme
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard", -- can be "hard", "soft" or empty string
      })
      vim.cmd.colorscheme 'gruvbox'
      vim.o.background = 'dark'
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  -- Git integration
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',

  -- LazyGit integration
  {
    'kdheepak/lazygit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Autopairs
  'windwp/nvim-autopairs',

  -- Comment toggling
  'numToStr/Comment.nvim',

  -- Which-key: shows keybindings as you type
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      win = {
        height = { min = 4, max = 25 },  -- Increased from default
        width = { min = 20, max = 50 },
      },
    },
  },

  -- Trouble: beautiful diagnostics and references list
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  -- Flash: jump to any location on screen quickly
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- Surround: add/change/delete surrounding quotes, brackets, etc.
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },

  -- Conform: better code formatting
  {
    'stevearc/conform.nvim',
    opts = {},
  },
}, {
  rocks = { enabled = false }, -- No configured plugins require LuaRocks.
})

-- LSP Configuration
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'clangd', 'lua_ls' }, -- Add language servers you need
  automatic_enable = false, -- Servers are configured and enabled below.
})

-- LSP keybindings (set when LSP attaches to buffer)
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr }

  -- Navigation (using traditional vim keybindings)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)

  -- Information
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

  -- Actions
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.keymap.set('n', '<leader>f', function() require('conform').format({ async = true, lsp_fallback = true }) end, opts)

  -- Diagnostics
  vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)

  -- Clangd specific: switch between header and source
  if client.name == 'clangd' then
    vim.keymap.set('n', '<leader>h', function()
      local bufnr = vim.api.nvim_get_current_buf()
      local params = vim.lsp.util.make_text_document_params(bufnr)
      vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, result)
        if err then
          vim.notify('Error switching header/source: ' .. tostring(err), vim.log.levels.ERROR)
          return
        end
        if not result then
          vim.notify('Corresponding file not found', vim.log.levels.WARN)
          return
        end
        vim.cmd.edit(vim.fn.fnameescape(vim.uri_to_fname(result)))
      end)
    end, opts)
  end
end

-- Setup language servers using new vim.lsp.config API (Neovim 0.11+)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- C/C++ (clangd)
vim.lsp.config.clangd = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
  capabilities = capabilities,
}
vim.lsp.enable('clangd')

-- Lua
vim.lsp.config.lua_ls = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}
vim.lsp.enable('lua_ls')

-- Setup on_attach for all LSP servers
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      on_attach(client, bufnr)
    end
  end,
})

-- Autocompletion setup with IntelliSense-like experience
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = function(entry, vim_item)
      -- Add source name
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip', priority = 750 },
    { name = 'buffer', priority = 500 },
    { name = 'path', priority = 250 },
  }),
  experimental = {
    ghost_text = true, -- Show inline completion suggestions
  },
})

-- Treesitter: Neovim 0.11 has built-in treesitter support
-- Parsers can be installed with :TSInstall <language>
-- Example: :TSInstall c cpp lua vim vimdoc query
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    -- Fall back to regular syntax highlighting when no parser is installed.
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Telescope setup with better path display
require('telescope').setup({
  defaults = {
    path_display = { "smart" },  -- Smart truncation: shows end of path with context
    dynamic_preview_title = true,  -- Shows full filename in preview title
    layout_config = {
      horizontal = {
        width = 0.9,      -- Use 90% of screen width
        height = 0.9,     -- Use 90% of screen height
        preview_width = 0.6,  -- Give more space to preview
      },
    },
    mappings = {
      i = {
        ["<C-h>"] = "which_key",  -- Press Ctrl+h in Telescope to see all keybindings
        ["<C-p>"] = function(prompt_bufnr)  -- Press Ctrl+p to peek at full path
          local action_state = require('telescope.actions.state')
          local entry = action_state.get_selected_entry()
          if entry then
            local path = entry.path or entry.filename or entry.value
            vim.notify(path, vim.log.levels.INFO, { title = "Full Path" })
          end
        end,
      },
      n = {
        ["<C-p>"] = function(prompt_bufnr)  -- Also works in normal mode
          local action_state = require('telescope.actions.state')
          local entry = action_state.get_selected_entry()
          if entry then
            local path = entry.path or entry.filename or entry.value
            vim.notify(path, vim.log.levels.INFO, { title = "Full Path" })
          end
        end,
      },
    },
  },
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",  -- Ctrl+d to delete buffer in picker
        },
      },
    },
    diagnostics = {
      layout_config = {
        horizontal = {
          width = 0.95,
          preview_width = 0.65,  -- More space for full diagnostic message
        },
      },
      line_width = 'full',  -- Don't truncate lines in results
    },
  },
})

-- Telescope keybindings
local telescope = require('telescope.builtin')
local live_grep_state = {
  glob_pattern = nil,
  ignore_case = false,
}

local function live_grep_with_state()
  telescope.live_grep({
    glob_pattern = live_grep_state.glob_pattern,
    additional_args = function()
      if live_grep_state.ignore_case then
        return { '--ignore-case' }
      end
      return {}
    end,
  })
end

local function set_live_grep_glob()
  vim.ui.input({
    prompt = 'Live grep file glob (example: *.lua, *.{ts,tsx}; empty = all): ',
    default = live_grep_state.glob_pattern or '',
  }, function(input)
    if input == nil then
      return
    end

    local trimmed = vim.trim(input)
    live_grep_state.glob_pattern = trimmed ~= '' and trimmed or nil
    vim.notify(
      'Live grep file filter: ' .. (live_grep_state.glob_pattern or 'all files'),
      vim.log.levels.INFO
    )
  end)
end

local function toggle_live_grep_case()
  live_grep_state.ignore_case = not live_grep_state.ignore_case
  local mode = live_grep_state.ignore_case and 'ignore-case (-i)' or 'smart-case (default)'
  vim.notify('Live grep case mode: ' .. mode, vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', live_grep_with_state, { desc = 'Live grep (with filters)' })
vim.keymap.set('n', '<leader>ft', set_live_grep_glob, { desc = 'Set live grep file glob' })
vim.keymap.set('n', '<leader>fc', toggle_live_grep_case, { desc = 'Toggle live grep case mode' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fs', telescope.lsp_document_symbols, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>fw', telescope.lsp_workspace_symbols, { desc = 'Workspace symbols' })
vim.keymap.set('n', '<leader>fd', telescope.diagnostics, { desc = 'Diagnostics' })

-- File explorer
require('nvim-tree').setup()
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })

-- Status line
require('lualine').setup({
  options = {
    theme = 'gruvbox',
    icons_enabled = true,
  }
})

-- Git signs with line highlighting
require('gitsigns').setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },
  linehl = false,  -- Disabled by default, toggle with keybinding
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Navigation
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, buffer=bufnr, desc='Next git hunk'})

    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, buffer=bufnr, desc='Previous git hunk'})

    -- Actions
    vim.keymap.set('n', '<leader>gp', gs.preview_hunk, {buffer=bufnr, desc='Preview hunk'})
    vim.keymap.set('n', '<leader>gb', function() gs.blame_line{full=true} end, {buffer=bufnr, desc='Blame line'})
    vim.keymap.set('n', '<leader>gd', function()
      gs.toggle_deleted()
      gs.toggle_linehl()
    end, {buffer=bufnr, desc='Toggle deleted lines & highlights'})

    -- Toggle between comparing to HEAD vs main branch (auto-detected or 'develop')
    local comparing_to_main = false
    vim.keymap.set('n', '<leader>gm', function()
      if comparing_to_main then
        gs.change_base('HEAD', true)
        comparing_to_main = false
        vim.notify('Comparing to HEAD', vim.log.levels.INFO)
      else
        local directory = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
        local result = vim.system({ 'git', '-C', directory, 'symbolic-ref',
          '--short', 'refs/remotes/origin/HEAD' }, { text = true }):wait()
        local base = result.code == 0 and vim.trim(result.stdout) or nil
        if not base or base == '' then
          vim.notify('No origin default branch. Run git remote set-head origin -a.', vim.log.levels.WARN)
          return
        end

        gs.change_base(base, true)
        comparing_to_main = true
        vim.notify('Comparing to ' .. base, vim.log.levels.INFO)
      end
    end, {buffer=bufnr, desc='Toggle compare HEAD vs main branch'})
  end,
})

-- Customize gitsigns highlight colors for line backgrounds
vim.api.nvim_set_hl(0, 'GitSignsAddLn', { bg = '#1a3a1a' })  -- Dark green background
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { bg = '#3a3a1a' })  -- Dark yellow/olive background
vim.api.nvim_set_hl(0, 'GitSignsDeleteVirtLn', { fg = '#ff6b6b', bg = '#3a1a1a' })  -- Red text on dark red background

-- Autopairs
require('nvim-autopairs').setup()

-- Comment
require('Comment').setup()

-- Trouble: better diagnostics and references
require('trouble').setup()

-- Conform: better code formatting
require('conform').setup({
  formatters_by_ft = {
    cpp = { 'clang-format' },
    c = { 'clang-format' },
    lua = { 'stylua' },
    python = { 'isort', 'black' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

-- General keybindings
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- LazyGit
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit' })

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bl', ':buffers<CR>', { desc = 'List buffers' })

-- Trouble keybindings
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions / references / ... (Trouble)' })
vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
