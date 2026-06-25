-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- options before plugin init
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.o.number = true
vim.o.signcolumn = 'yes:1'
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.autoindent = true
vim.o.backspace = 'indent,eol,start'
vim.o.showcmd = true
vim.o.mouse = 'a'
vim.o.modeline = true
vim.o.updatetime = 500
vim.o.hidden = true
vim.o.cursorline = true

-- neovide settings
vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_scroll_animation_length = 0

if vim.fn.has('macunix') == 1 then
  -- neovide on macos seems to disagree with font sizing
  vim.o.guifont = 'Source Code Pro:h16'
else
  vim.o.guifont = 'Source Code Pro:h12'
end

-- plugin init
require('lazy').setup({
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      style = 'night'
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'tokyonight',
        icons_enabled = false,
        section_separators = { left = '', right = '' },
        component_separators = { left = '\u{00b7}', right = '\u{00b7}' },
      },
      tabline = {
        lualine_a = { 'buffers' },
      },
      extensions = { 'toggleterm', 'nvim-tree' },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              -- single Esc to close
              ['<Esc>'] = actions.close
            },
          },
        },
      })
    end,
  },
  { 'akinsho/toggleterm.nvim', config = true },
  {
    'arborist-ts/arborist.nvim',
    config = true,
    opts = {
      update_cadence = 'weekly',
      install_popular = false,
      concurrency = 1,
    },
  },
  { 'nmac427/guess-indent.nvim', config = true },
  { 'williamboman/mason.nvim', config = true },
  { 'williamboman/mason-lspconfig.nvim', config = true },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim'
    },
    config = function()
      local function lsp_setup(name, opts)
        vim.lsp.enable(name, opts)
      end
      lsp_setup('rust_analyzer')
      lsp_setup('clangd')
      lsp_setup('pyright')
      lsp_setup('ts_ls')
      lsp_setup('lua_ls', {
        on_init = function(client)
          -- TODO: don't load neovim libraries if not in neovim
          local settings = client.config.settings
          settings.Lua = vim.tbl_deep_extend('force', settings.Lua, {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            }
          })
        end,
        settings = {
          Lua = {},
        },
      })
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    opts = {
      filters = { dotfiles = true },
      renderer = {
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = true,
            modified = true,
            diagnostics = false,
            bookmarks = true,
          },
        },
      },
    }
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      -- manually configured below
      map_cr = false,
      map_bs = false,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
      'm00qek/baleia.nvim',
    },
    lazy = true,
    cmd = 'Neogit',
    opts = {},
  },
  { 'https://codeberg.org/andyg/leap.nvim' },
  {
    'windwp/nvim-ts-autotag',
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'saghen/blink.lib' },
    build = function() require('blink.cmp').build():pwait() end,
    opts = {
      keymap = { preset = 'super-tab' },
      -- prefer rust if available
      fuzzy = { implementation = 'prefer_rust' },
    },
  },
})

-- theme configuration
vim.cmd('colorscheme tokyonight')

-- keybinds
local wk = require('which-key')
wk.add({
  mode = 'n',
  { '<Leader>', group = 'Leader' },
  { '<Leader>e', vim.diagnostic.open_float, desc = 'Show current error' },
  { '<Leader>f', group = 'file' },
  { '<Leader>ft', require('nvim-tree.api').tree.toggle, desc = 'Toggle file tree' },
  { '<Leader>s', group = 'select' },
  { '<Leader>sa', 'ggVG', desc = 'Select all' },
  { '<Leader>tt', require('toggleterm').toggle, desc = 'Activate ToggleTerm' },
  { '<Leader>gg', '<cmd>Neogit<cr>', desc = 'Open Neogit UI' },
  { '<C-p>', require('telescope.builtin').buffers, desc = 'Open buffers switcher' },

  -- to be entirely honest i have no idea what this does
  -- { 'S', '<Plug>(leap-from-window)', desc = 'Trigger leap against sibling window?' },
})
wk.add({
  mode = 'nxo',
  { 's', '<Plug>(leap)', desc = 'Trigger leap' },
})
wk.add({
  mode = 't',
  { '<C-Space>', '<C-\\><C-n>', desc = 'Exit terminal mode' },
})

if vim.fn.has('macunix') == 1 then
  wk.add({
    mode = 'v',
    { '<D-c>', '"+y', desc = 'Copy to system clipboard' },
    { '<D-x>', '"+d', desc = 'Cut to system clipboard' },
  })
  wk.add({
    mode = 'i',
    { '<D-v>', '<C-o>"+p', desc = 'Paste from system clipboard' },
  })
else
  wk.add({
    mode = 'v',
    { '<C-S-c>', '"+y', desc = 'Copy to system clipboard' },
    { '<C-S-x>', '"+d', desc = 'Cut to system clipboard' },
  })
  wk.add({
    mode = 'i',
    { '<C-S-v>', '<C-o>"+p', desc = 'Paste from system clipboard' },
  })
end

-- command aliases
vim.keymap.set('ca', 'Git', 'Neogit')
vim.keymap.set('ca', 'git', 'Neogit')

-- autopairs related keybinds
local autopairs = require('nvim-autopairs')
local function insert_handle_cr()
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return autopairs.esc('<C-y>')
    else
      return autopairs.esc('<C-e>') .. autopairs.autopairs_cr()
    end
  else
    return autopairs.autopairs_cr()
  end
end
vim.keymap.set('i', '<CR>', insert_handle_cr, { noremap = true, expr = true, replace_keycodes = false })

local function insert_handle_bs()
  if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return autopairs.esc('<C-e>') .. autopairs.autopairs_bs()
  else
    return autopairs.autopairs_bs()
  end
end
vim.keymap.set('i', '<BS>', insert_handle_bs, { noremap = true, expr = true, replace_keycodes = false })
