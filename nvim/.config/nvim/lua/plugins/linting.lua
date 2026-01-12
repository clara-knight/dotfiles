-- Linting configuration
require('lint').linters_by_ft = {
    python = { 'ruff' }
}

vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("Linter", { clear = true }),
    callback = function()
        require("lint").try_lint()
    end,
})
