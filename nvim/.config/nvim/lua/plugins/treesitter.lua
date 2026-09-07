-- Treesitter configuration for syntax awareness
local ok, configs = pcall(require, 'nvim-treesitter.configs')
if ok then
    configs.setup({
        highlight = { enable = true },
    })
else
    require('nvim-treesitter').setup()
end
