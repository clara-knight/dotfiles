-- General keymaps
local opts = { noremap = true, silent = true }

-- Save with space-w
vim.keymap.set('n', '<space>w', '<cmd>write<cr>', { desc = 'Save' })

-- Explorer with F2
vim.keymap.set('n', '<F2>', '<cmd>Lexplore<cr>', { desc = 'Explorer' })

-- Diagnostics
vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, opts)
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, opts)
