require('prose').setup({
	width = 100,
	width_step = 4,
	sprint_minutes = 45,
	footer = {
		enabled = true,
		width_mode = "document", -- Options: "full" or "document"
		separator = "  ",
		format = { "file", "document", "session", "sprint" },
		highlights = {
			footer_active = "StatusLine",
			footer_inactive = "StatusLineNC",
		},
	},
	recovery = {
		enabled = true,
		interval_ms = 30000,
	},
	keymaps = {
		save_and_quit = "ZZ", -- Default save & quit
	},
	spell = {
		enabled = true,
		local_spellfile_name = '.prose-spell.utf-8.add',
	},
})


vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		pcall(function() require('cmp').setup.buffer({ enabled = false }) end)
	end,
})

