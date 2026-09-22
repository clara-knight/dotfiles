-- Linting configuration
-- NOTE: Python is covered by the ruff language server (see lsp.lua),
-- which provides diagnostics plus code actions. Add CLI-only linters
-- for other filetypes here.
require('lint').linters_by_ft = {
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("Linter", { clear = true }),
    callback = function()
        require("lint").try_lint()
    end,
})
