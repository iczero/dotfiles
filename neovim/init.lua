-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- options before plugin init
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.o.number = true
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

-- neovide settings
vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_scroll_animation_length = 0
vim.o.guifont = 'Source Code Pro:h12'

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
        lualine_a = {'buffers'},
      },
      extensions = {'toggleterm'},
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { 'akinsho/toggleterm.nvim', config = true },
  {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    build = ':COQdeps',
    config = function()
      vim.g.coq_settings = {
        xdg = true,
        ['display.icons.mode'] = 'none',
      }
      --[[
      require('coq_3p')({
        { src = 'nvimlua', short_name = 'nLUA', conf_only = true },
      })
      ]]
      require('coq').Now('--shut-up')
    end,
    dependencies = { 'ms-jpq/coq.artifacts', 'ms-jpq/coq.thirdparty' },
  },
  { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
  { 'ms-jpq/coq.thirdparty', branch = '3p' },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'c', 'lua', 'vimdoc', 'javascript', 'python', 'rust',
        },
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = {
          -- fix some indent issues (such as with python)
          enable = true,
        },
      })
    end
  },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-sleuth' },
  { 'williamboman/mason.nvim', config = true },
  { 'williamboman/mason-lspconfig.nvim', config = true },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim'
    },
    config = function()
      local lspc = require('lspconfig')
      local coq = require('coq')

      local function lsp_setup(name, opts)
        lspc[name].setup(coq.lsp_ensure_capabilities(opts or {}))
      end
      lsp_setup('rust_analyzer')
      lsp_setup('clangd')
      lsp_setup('pyright')
      lsp_setup('tsserver')
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
})

-- theme configuration
vim.cmd('colorscheme tokyonight')

-- keybinds
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, { noremap = true })
