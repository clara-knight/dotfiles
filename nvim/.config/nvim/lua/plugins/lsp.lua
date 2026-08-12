-- LSP configuration
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(_, bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

local servers = { 'clangd', 'pyright', 'html', 'cssls', 'htmx', 'texlab' }

local function is_wsl2()
    local handle = io.open('/proc/version', 'r')
    if not handle then
        return false
    end

    local content = handle:read('*all')
    handle:close()
    return content:lower():match('microsoft') ~= nil
end

local pdflatex_cmd = is_wsl2() and 'pdflatex.exe' or 'pdflatex'

require('mason').setup()

vim.lsp.config('*', {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config('texlab', {
    settings = {
        texlab = {
            build = {
                executable = pdflatex_cmd,
                args = { '-synctex=1', '-interaction=nonstopmode', '-file-line-error', '%f' },
                onSave = false,
            },
            auxDirectory = '.',
            chktex = {
                onOpenAndSave = false,
                onEdit = false,
            },
            diagnosticsDelay = 300,
            latexFormatter = 'latexindent',
            latexindent = {
                modifyLineBreaks = false,
            },
            bibtexFormatter = 'texlab',
            formatterLineLength = 80,
        },
    },
})

require('mason-lspconfig').setup({
    ensure_installed = servers,
    automatic_enable = servers,
})
