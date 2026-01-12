-- Plugin definitions using vim-plug
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Colors
Plug 'dylanaraps/wal.vim'

-- Live preview for HTML/CSS
Plug 'brianhuster/live-preview.nvim'

-- Telescope and dependencies
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

-- Mason, LSP, and completion
Plug 'mason-org/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'

-- Linting and formatting
Plug 'mfussenegger/nvim-lint'
Plug 'stevearc/conform.nvim'

-- Treesitter
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

-- Emmet
Plug 'mattn/emmet-vim'

-- VimTeX for LaTeX editing
Plug 'lervag/vimtex'

-- Discord rich presence
Plug 'vyfor/cord.nvim'

vim.call('plug#end')
