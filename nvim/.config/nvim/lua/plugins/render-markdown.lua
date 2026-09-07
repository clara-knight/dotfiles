-- Render Markdown configuration
require('render-markdown').setup({
    heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        signs = { '󰫎 ' },
    },
    code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_pad = 0,
        disable_background = { 'diff' },
    },
    dash = {
        enabled = true,
        icon = '─',
        width = 'full',
    },
    bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
    },
    checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰱒 ' },
        custom = {
            todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
        },
    },
    quote = {
        enabled = true,
        icon = '▋',
    },
    anti_conceal = {
        enabled = true,
        ignore = {
            head_border = true,
            table_border = true,
        },
    },
    pipe_table = {
        enabled = true,
        preset = 'round',
        style = 'full',
        cell = 'padded',
        alignment_indicator = '━',
        border_virtual = true,
    },
    callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
    },
    link = {
        enabled = true,
        image = '󰥶 ',
        email = '󰀓 ',
        hyperlink = '󰌹 ',
        highlight = 'RenderMarkdownLink',
    },
    sign = {
        enabled = true,
    },
    latex = {
        enabled = false,
    },
    win_options = {
        conceallevel = {
            default = vim.o.conceallevel,
            rendered = 2,
        },
        concealcursor = {
            default = vim.o.concealcursor,
            rendered = '',
        },
        wrap = {
            default = vim.o.wrap,
            rendered = false,
        },
    },
})

-- Keymap to toggle markdown rendering
vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle markdown rendering' })
