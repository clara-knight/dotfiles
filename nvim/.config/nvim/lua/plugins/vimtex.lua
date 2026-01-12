-- VimTeX configuration for LaTeX editing
-- Auto-detect WSL2 vs native Linux and use appropriate pdflatex command
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

vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'generic'
vim.g.vimtex_compiler_generic = {
    command = pdflatex_cmd,
    args = {
        '-synctex=1',
        '-interaction=nonstopmode',
        '-file-line-error',
        '%f',
    },
    callback = 1,
    continuous = 0,  -- Set to 0 since pdflatex doesn't support continuous mode like latexmk
}

-- Enable quickfix window for errors
vim.g.vimtex_quickfix_mode = 0

-- Enable syntax concealment
vim.g.vimtex_syntax_conceal = {
    accents = 1,
    ligatures = 1,
    cites = 1,
    fancy = 1,
    spacing = 0,
    greek = 1,
    math_bounds = 1,
    math_delimiters = 1,
    math_fracs = 1,
    math_super_sub = 1,
    math_symbols = 1,
    sections = 0,
}

-- Enable folding
vim.g.vimtex_fold_enabled = 1
vim.g.vimtex_fold_manual = 1
vim.g.vimtex_fold_types = {
    cmd_addplot = {
        cmds = {
            'addplot',
            'addplot3',
            'addplot+',
            'addplot3+',
        },
    },
    cmd_multi = {
        cmds = {
            '%(re)?new%(command|environment)',
            'presetkeys',
            'hypersetup',
            'tikzset',
            'pgfplotstableread',
            'lstset',
            'mintedsetup',
        },
    },
    cmd_options = {
        cmds = {
            '\\documentclass',
            '\\usepackage',
            '\\PassOptionsToPackage',
        },
    },
    cmd_preamble = {
        cmds = {
            '\\usepackage',
            '\\RequirePackage',
        },
    },
    cmd_single = {
        cmds = {
            '\\%(',
            '\\%(sub)?section',
            '\\begin',
            '\\end',
            '\\label',
            '\\%(item|bibitem)',
        },
    },
    comments = {
        enabled = 0,
    },
    env_options = vim.empty_dict(),
    env_verbatim = {
        enabled = 0,
    },
    markers = vim.empty_dict(),
    parts = {
        cmds = {
            '\\part',
            '\\chapter',
        },
    },
    preamble = {
        enabled = 0,
    },
}

-- Key mappings for vimtex
vim.keymap.set('n', '<leader>ll', '<cmd>VimtexCompile<cr>', { desc = 'Compile LaTeX' })
vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<cr>', { desc = 'View PDF' })
vim.keymap.set('n', '<leader>ls', '<cmd>VimtexStop<cr>', { desc = 'Stop compilation' })
vim.keymap.set('n', '<leader>lc', '<cmd>VimtexClean<cr>', { desc = 'Clean auxiliary files' })
vim.keymap.set('n', '<leader>le', '<cmd>VimtexErrors<cr>', { desc = 'Show errors' })
vim.keymap.set('n', '<leader>lo', '<cmd>VimtexCompileOutput<cr>', { desc = 'Show output' })
vim.keymap.set('n', '<leader>lg', '<cmd>VimtexStatus<cr>', { desc = 'Show status' })
vim.keymap.set('n', '<leader>lk', '<cmd>VimtexStopAll<cr>', { desc = 'Stop all' })
vim.keymap.set('n', '<leader>lK', '<cmd>VimtexStopAll<cr>', { desc = 'Stop all' })
vim.keymap.set('n', '<leader>lx', '<cmd>VimtexReload<cr>', { desc = 'Reload vimtex' })
vim.keymap.set('n', '<leader>lX', '<cmd>VimtexReloadState<cr>', { desc = 'Reload state' })
