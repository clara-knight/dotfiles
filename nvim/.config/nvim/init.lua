-- Main Neovim configuration entry point
-- Load configuration modules in order

-- Basic options
require('options')

-- Keymaps
require('keymaps')

-- Load plugins (must be loaded before plugin configurations)
require('plugins')

-- Colorscheme (load after plugins are installed)
require('colorscheme')

-- Plugin configurations (load after plugins are installed)
require('plugins.lsp')
require('plugins.cmp')
require('plugins.linting')
require('plugins.formatting')
require('plugins.treesitter')
require('plugins.livepreview')
require('plugins.vimtex')
require('plugins.latex-snippets')
require('plugins.cord')
