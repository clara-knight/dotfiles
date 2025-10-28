vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.timeoutlen = 500

-- Save with space-w
vim.keymap.set('n', '<space>w', '<cmd>write<cr>', {desc = 'Save'})
-- Explorer with F2
vim.keymap.set('n', '<F2>', '<cmd>Lexplore<cr>', {desc = 'Explorer'})

-- diagnostics
vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
-- Colors
Plug 'dylanaraps/wal.vim'

-- live-preview for live previewing html/css
Plug 'brianhuster/live-preview.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

-- Mason, CMP, LSP, etc.
Plug 'mason-org/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'L3MON4D3/LuaSnip'

Plug 'mfussenegger/nvim-lint'
Plug 'stevearc/conform.nvim'

Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

Plug'mattn/emmet-vim'

-- Discord rich presence
Plug'vyfor/cord.nvim'

vim.call'plug#end'

-- color scheme
vim.opt.termguicolors = false
vim.cmd("colorscheme wal")


--- livepreview
require('livepreview.config').set()
    require('livepreview.config').set({
	port = 5500,
	browser = 'default',
	dynamic_root = false,
	sync_scroll = true,
	picker = "",
    })

-- LSP configuration. Attach servers to buffers
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
    -- Safe wrapper: only set buffer-local keymaps if buffer is valid
    if not vim.api.nvim_buf_is_valid(bufnr) then return end

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { 'clangd', 'pyright', 'html', 'cssls', 'htmx' },
})

-- Explicitly configure servers to guarantee on_attach runs
local servers = { 'clangd', 'pyright', 'html', 'cssls', 'htmx' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end


-- Completion setup
local cmp = require('cmp')

cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
		{ name = 'buffer' },
	},
	mapping =
		cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-n>'] = cmp.mapping.select_next_item(), -- Select next item
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
			  	cmp.select_next_item()
			elseif require('luasnip').expand_or_jumpable() then
			  	require('luasnip').expand_or_jump()
			else
			  	fallback()
			end
		end, { 'i', 's' }),
		['<C-p>'] = cmp.mapping.select_prev_item(), -- Select previous item
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
			  	cmp.select_prev_item()
			elseif require('luasnip').jumpable(-1) then
			  	require('luasnip').jump(-1)
			else
			  	fallback()
			end
		end, { 'i', 's' }),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
})


require('lint').linters_by_ft = {
	python = {'ruff'}
}

vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged", "InsertLeave"}, {
	group = vim.api.nvim_create_augroup("Linter", { clear = true }),
	callback = function()
		require("lint").try_lint()
	end,
})

-- Formatting setup
require("conform").setup({
	formatters_by_ft = {
		python = { "black" },
	},
	format_on_save = {
		timeout_ms = 500,
	  	lsp_fallback = true,
	},
})

-- Treesitter configuration for syntax awareness
require('nvim-treesitter.configs').setup({
	highlight = { enable = true },
})

--- Discord rich presence
require('cord').setup {
  enabled = true,
  log_level = vim.log.levels.OFF,
  editor = {
    client = 'neovim',
    tooltip = 'The Superior Text Editor',
    icon = nil,
  },
  display = {
    theme = 'default',
    flavor = 'dark',
    view = 'full',
    swap_fields = false,
    swap_icons = false,
  },
  timestamp = {
    enabled = true,
    reset_on_idle = false,
    reset_on_change = false,
    shared = false,
  },
  idle = {
    enabled = true,
    timeout = 300000,
    show_status = true,
    ignore_focus = true,
    unidle_on_focus = true,
    smart_idle = true,
    details = 'Idling',
    state = nil,
    tooltip = '💤',
    icon = nil,
  },
  text = {
    default = nil,
    workspace = '', --function(opts) return 'In ' .. opts.workspace end,
    viewing = function(opts) return 'Viewing ' .. opts.filename end,
    editing = function(opts) return 'Editing ' .. opts.filename end,
    file_browser = function(opts) return 'Browsing files in ' .. opts.name end,
    plugin_manager = function(opts) return 'Managing plugins in ' .. opts.name end,
    lsp = function(opts) return 'Configuring LSP in ' .. opts.name end,
    docs = function(opts) return 'Reading ' .. opts.name end,
    vcs = function(opts) return 'Committing changes in ' .. opts.name end,
    notes = function(opts) return 'Taking notes in ' .. opts.name end,
    debug = function(opts) return 'Debugging in ' .. opts.name end,
    test = function(opts) return 'Testing in ' .. opts.name end,
    diagnostics = function(opts) return 'Fixing problems in ' .. opts.name end,
    games = function(opts) return 'Playing ' .. opts.name end,
    terminal = function(opts) return 'Running commands in ' .. opts.name end,
    dashboard = 'Home',
  }, 
  buttons = nil,
  -- buttons = {
  --   {
  --     label = 'View Repository',
  --     url = function(opts) return opts.repo_url end,
  --   },
  -- },
  assets = nil,
  variables = nil,
  hooks = {
    ready = nil,
    shutdown = nil,
    pre_activity = nil,
    post_activity = nil,
    idle_enter = nil,
    idle_leave = nil,
    workspace_change = nil,
  },
  plugins = nil,
  advanced = {
    plugin = {
      autocmds = true,
      cursor_update = 'on_hold',
      match_in_mappings = true,
    },
    server = {
      update = 'fetch',
      pipe_path = nil,
      executable_path = nil,
      timeout = 300000,
    },
    discord = {
      pipe_paths = nil,
      reconnect = {
        enabled = true,
        interval = 5000,
        initial = true,
      },
    },
    workspace = {
      root_markers = {
        '.git',
        '.hg',
        '.svn',
      },
      limit_to_cwd = false,
    },
  },
}
