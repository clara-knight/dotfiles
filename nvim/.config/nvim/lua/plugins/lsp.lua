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

local servers = { 'clangd', 'basedpyright', 'html', 'cssls', 'htmx', 'texlab', 'ruff' }

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

vim.lsp.config('basedpyright', {
    settings = {
        basedpyright = {
            analysis = {
                -- 'standard' matches stock pyright's default noise level.
                -- basedpyright's own default ('recommended') reports many
                -- more diagnostics (e.g. unknown/partial types), which is
                -- noisy for untyped code. Per-project pyproject.toml or
                -- basedpyrightconfig.json still overrides this.
                typeCheckingMode = 'standard',
                -- Hand-picked extras on top of 'standard'. All three are
                -- (near-)zero noise on untyped code but catch real bugs:
                --   reportUnreachable: dead code after return/raise/continue
                --   reportImplicitStringConcatenation: accidental "a" "b" joins
                --   reportIgnoreCommentWithoutRule: stale blanket ignores
                diagnosticSeverityOverrides = {
                    reportUnreachable = 'error',
                    reportImplicitStringConcatenation = 'warning',
                    reportIgnoreCommentWithoutRule = 'warning',
                },
            },
        },
    },
})

require('mason-lspconfig').setup({
    ensure_installed = servers,
    automatic_enable = servers,
})
