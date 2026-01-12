-- LSP configuration
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
    ensure_installed = { 'clangd', 'pyright', 'html', 'cssls', 'htmx', 'texlab' },
})

-- Configure LSP servers
local servers = { 'clangd', 'pyright', 'html', 'cssls', 'htmx', 'texlab' }
for _, lsp in ipairs(servers) do
    local config = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    
    -- Special configuration for texlab (LaTeX LSP)
    -- Auto-detect WSL2 vs native Linux and use appropriate pdflatex command
    if lsp == 'texlab' then
        local function is_wsl2()
            local handle = io.open('/proc/version', 'r')
            if handle then
                local content = handle:read('*all')
                handle:close()
                return content:lower():match('microsoft') ~= nil
            end
            return false
        end
        
        local pdflatex_cmd = 'pdflatex'
        if is_wsl2() then
            pdflatex_cmd = 'pdflatex.exe'
        end
        
        config.settings = {
            texlab = {
                rootDirectory = nil,
                build = {
                    executable = pdflatex_cmd,
                    args = { '-synctex=1', '-interaction=nonstopmode', '-file-line-error', '%f' },
                    onSave = false,
                },
                auxDirectory = '.',
                forwardSearch = {
                    executable = nil,
                    args = {},
                },
                chktex = {
                    onOpenAndSave = false,
                    onEdit = false,
                },
                diagnosticsDelay = 300,
                latexFormatter = 'latexindent',
                latexindent = {
                    ['local'] = nil,
                    modifyLineBreaks = false,
                },
                bibtexFormatter = 'texlab',
                formatterLineLength = 80,
            },
        }
    end
    
    lspconfig[lsp].setup(config)
end
