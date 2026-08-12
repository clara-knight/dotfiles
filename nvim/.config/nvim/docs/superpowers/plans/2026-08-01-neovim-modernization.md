# Neovim Configuration Modernization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Modernize this configuration for Neovim 0.12.4, repair completion integration, reduce lint frequency, remove Telescope, and make the documentation match the implemented behavior.

**Architecture:** Keep the current `init.lua` plus focused `lua/` modules. Use Neovim's native `vim.lsp.config()` interface with Mason restricted to the six configured servers. Keep `vim-plug`, all existing language features, and `\` as the explicit leader key.

**Tech Stack:** Neovim 0.12.4+, Lua, vim-plug, native Neovim LSP, nvim-lspconfig, Mason, nvim-cmp, LuaSnip, nvim-lint, Conform, VimTeX

## Global Constraints

- Target stable Neovim 0.12.4 or later, not a nightly build.
- Keep `vim-plug`; do not migrate to `vim.pack` or another plugin manager.
- Keep `\` as both the global and local leader.
- Keep the current server list: `clangd`, `pyright`, `html`, `cssls`, `htmx`, and `texlab`.
- Preserve the existing Texlab settings and WSL `pdflatex.exe` detection, except for no-op `nil` fields.
- Do not reorganize unrelated modules or change unrelated mappings.
- Remove Telescope and Plenary. Configure the existing `cmp-cmdline` plugin.
- Update `INSTRUCTIONS.md` only after the configuration changes pass preliminary tests.
- Do not commit unless the user separately authorizes commits.
- Do not commit `.nvimlog`; it is a planning-time sandbox artifact.

---

### Task 1: Update the plugin list and core mappings

**Files:**
- Modify: `init.lua`
- Modify: `lua/plugins/init.lua`
- Modify: `lua/keymaps.lua`

**Interfaces:**
- Produces: explicit `vim.g.mapleader` and `vim.g.maplocalleader` values of `\`
- Produces: `[d` for the previous diagnostic and `]d` for the next diagnostic
- Produces: a declared `cmp_luasnip` completion source dependency
- Removes: Telescope and its Plenary runtime dependency

- [ ] **Step 1: Record the baseline**

Run:

```bash
nvim --version | sed -n '1,5p'
rg -n "mapleader|goto_(next|prev)|telescope|plenary|cmp_luasnip" init.lua lua
git status --short
```

Expected before the edit:

- Neovim must report version 0.12.4 or later. Stop and ask the user to finish the planned Neovim update if it does not.
- No explicit leader assignment exists.
- `vim.diagnostic.goto_next()` and `goto_prev()` exist in `lua/keymaps.lua`.
- Telescope and Plenary are declared.
- `cmp_luasnip` is not declared.

- [ ] **Step 2: Set the leader before module loading**

Add these lines at the start of `init.lua`, before `require('options')`:

```lua
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
```

- [ ] **Step 3: Change the plugin declarations**

In `lua/plugins/init.lua`, delete:

```lua
-- Telescope and dependencies
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
```

Add the LuaSnip adapter directly after the LuaSnip declaration:

```lua
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
```

- [ ] **Step 4: Replace the diagnostic mappings**

Replace the two directional mappings in `lua/keymaps.lua` with:

```lua
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, opts)
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, opts)
```

Keep `<leader>vd` unchanged.

- [ ] **Step 5: Install the new plugin**

Run:

```bash
nvim --headless '+PlugInstall --sync' '+qa'
```

Expected: vim-plug installs `cmp_luasnip` and exits successfully. If the sandbox blocks network access or writes to Neovim's data directory, request the required approval and rerun the same command. Do not run `PlugClean`; undeclared Telescope files do not enter the runtime path.

- [ ] **Step 6: Verify the task**

Run:

```bash
rg -n "mapleader|maplocalleader|diagnostic.jump|cmp_luasnip" init.lua lua
rg -n "telescope|plenary|goto_(next|prev)" init.lua lua
```

Expected:

- The first command shows both explicit leader values, two `diagnostic.jump()` calls, and `cmp_luasnip`.
- The second command returns no matches.

---

### Task 2: Migrate LSP configuration to the native Neovim API

**Files:**
- Modify: `lua/plugins/lsp.lua`

**Interfaces:**
- Consumes: `cmp_nvim_lsp.default_capabilities()`
- Produces: shared LSP configuration through `vim.lsp.config("*", shared_config)`
- Produces: Texlab overrides through `vim.lsp.config("texlab", texlab_config)`
- Produces: installation and automatic activation for exactly six servers through `mason-lspconfig`

- [ ] **Step 1: Confirm the legacy API warning**

Run a baseline startup with logs and transient state outside the repository:

```bash
nvim_test_root=$(mktemp -d)
mkdir -m 700 "$nvim_test_root/runtime"
XDG_STATE_HOME="$nvim_test_root/state" XDG_CACHE_HOME="$nvim_test_root/cache" XDG_RUNTIME_DIR="$nvim_test_root/runtime" NVIM_LOG_FILE="$nvim_test_root/nvim.log" nvim --headless -i NONE '+qa'
```

Expected before the migration: startup output contains either the `require('lspconfig')` deprecation warning or an error that says the removed legacy interface cannot load. Record the exact result; both results establish the baseline failure that this task removes.

- [ ] **Step 2: Replace `lua/plugins/lsp.lua`**

Use this complete configuration:

```lua
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
```

Do not add separate `vim.lsp.enable()` calls. `mason-lspconfig` owns activation for the explicit list.

- [ ] **Step 3: Verify native configuration startup**

Repeat the headless startup command from Step 1 with a new temporary directory.

Expected:

- Exit status is zero.
- No `require('lspconfig')` deprecation warning appears.
- No Lua stack trace appears.

- [ ] **Step 4: Verify configured servers**

Run:

```bash
nvim --headless -i NONE "+lua local expected={'clangd','pyright','html','cssls','htmx','texlab'}; for _, name in ipairs(expected) do assert(vim.lsp.config[name], 'missing LSP config: '..name) end" '+qa'
```

Expected: exit status zero with no assertion failure.

---

### Task 3: Configure completion and update linting and formatting

**Files:**
- Modify: `lua/plugins/cmp.lua`
- Modify: `lua/plugins/linting.lua`
- Modify: `lua/plugins/formatting.lua`

**Interfaces:**
- Produces: buffer-word completion for `/` and `?`
- Produces: path and Ex-command completion for `:`
- Produces: lint triggers on `BufWritePost` and `InsertLeave` only
- Produces: Conform LSP fallback through `lsp_format = "fallback"`

- [ ] **Step 1: Add command-line completion**

Append this configuration to `lua/plugins/cmp.lua` after the existing `cmp.setup()` call:

```lua
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
    },
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
    }, {
        { name = 'cmdline' },
    }),
    matching = {
        disallow_symbol_nonprefix_matching = false,
    },
})
```

- [ ] **Step 2: Reduce lint frequency**

Change the autocmd event list in `lua/plugins/linting.lua` to:

```lua
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
```

Keep the existing augroup and callback unchanged.

- [ ] **Step 3: Update Conform's option name**

Change the `format_on_save` table in `lua/plugins/formatting.lua` to:

```lua
format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
},
```

- [ ] **Step 4: Verify source and autocmd registration**

Run:

```bash
nvim --headless -i NONE "+lua local names={}; for _, source in ipairs(require('cmp').get_config().sources) do names[source.name]=true end; assert(names.nvim_lsp and names.luasnip and names.path and names.buffer)" "+lua local events=vim.api.nvim_get_autocmds({group='Linter'}); local found={}; for _, event in ipairs(events) do found[event.event]=true end; assert(found.BufWritePost and found.InsertLeave and not found.TextChanged)" '+qa'
```

Expected: exit status zero with no assertion failure.

- [ ] **Step 5: Confirm deprecated configuration is absent**

Run:

```bash
rg -n "lsp_fallback|TextChanged|diagnostic.goto_(next|prev)|require\(['\"]lspconfig" init.lua lua
```

Expected: no matches.

---

### Task 4: Run preliminary integration tests

**Files:**
- No repository files change in this task.
- Temporary fixtures belong under `/tmp` only.

**Interfaces:**
- Validates: plugin loading, native LSP activation, completion, Black formatting, and Ruff diagnostics

- [ ] **Step 1: Run a clean headless startup**

Run with temporary state and log paths:

```bash
nvim_test_root=$(mktemp -d)
mkdir -m 700 "$nvim_test_root/runtime"
XDG_STATE_HOME="$nvim_test_root/state" XDG_CACHE_HOME="$nvim_test_root/cache" XDG_RUNTIME_DIR="$nvim_test_root/runtime" NVIM_LOG_FILE="$nvim_test_root/nvim.log" nvim --headless -i NONE '+qa'
```

Expected: exit status zero, no deprecation warning, and no Lua stack trace. Sandbox messages about desktop programs are not configuration failures.

- [ ] **Step 2: Verify Python LSP attachment**

Create an empty fixture and open it with the full configuration:

```bash
python_fixture=$(mktemp --suffix=.py)
nvim --headless -i NONE "$python_fixture" "+lua assert(vim.wait(15000, function() return #vim.lsp.get_clients({bufnr=0, name='pyright'}) > 0 end), 'pyright did not attach')" '+qa'
```

Expected: exit status zero. If Pyright is not installed, run `:Mason`, install it, and repeat the test.

- [ ] **Step 3: Verify Texlab attachment**

Run:

```bash
tex_fixture=$(mktemp --suffix=.tex)
nvim --headless -i NONE "$tex_fixture" "+lua assert(vim.wait(15000, function() return #vim.lsp.get_clients({bufnr=0, name='texlab'}) > 0 end), 'texlab did not attach')" '+qa'
```

Expected: exit status zero. If Texlab is not installed, install it with Mason and repeat the test.

- [ ] **Step 4: Verify Black formatting**

Run:

```bash
format_fixture=$(mktemp --suffix=.py)
nvim --headless -i NONE "$format_fixture" "+call setline(1, 'value=  1')" '+write' "+lua require('conform').format({async=false, timeout_ms=5000})" '+write' '+qa'
sed -n '1,5p' "$format_fixture"
```

Expected output:

```text
value = 1
```

- [ ] **Step 5: Verify Ruff diagnostics**

Run:

```bash
lint_fixture=$(mktemp --suffix=.py)
nvim --headless -i NONE "$lint_fixture" "+call setline(1, 'import os')" '+write' "+lua require('lint').try_lint('ruff'); assert(vim.wait(10000, function() return #vim.diagnostic.get(0) > 0 end), 'ruff produced no diagnostics')" '+qa'
```

Expected: exit status zero because Ruff reports the unused import through Neovim diagnostics.

- [ ] **Step 6: Run health checks**

Run inside Neovim:

```vim
:checkhealth vim.lsp
:checkhealth mason
:checkhealth conform
:checkhealth nvim-treesitter
:checkhealth vimtex
```

Expected: no configuration errors in the changed components. Record missing optional desktop tools separately; do not expand this task to unrelated system setup.

---

### Task 5: Correct the documentation

**Files:**
- Modify: `INSTRUCTIONS.md`

**Interfaces:**
- Produces: a user guide that matches the verified configuration

- [ ] **Step 1: Update requirements and architecture**

Make these statements exact in `INSTRUCTIONS.md`:

- Neovim 0.12.4 or later is the validated baseline.
- `vim-plug` remains the plugin manager.
- LSP configuration uses `vim.lsp.config()` and Mason automatically enables only the six listed servers.
- The global and local leader key is `\`.

- [ ] **Step 2: Update plugin and completion documentation**

- Add `cmp_luasnip` as the LuaSnip source adapter.
- Document buffer completion for `/` and `?`.
- Document path and command completion for `:`.
- Remove Telescope and Plenary from all plugin lists and examples.
- Do not add Telescope mappings because Telescope is no longer configured.

- [ ] **Step 3: Update mappings and automation behavior**

- Change the diagnostics table so `[d` means previous and `]d` means next.
- Keep all documented `<leader>` sequences, and state that they begin with `\`.
- Change linting documentation from “save, text change, and insert leave” to “save and insert leave.”
- Describe Conform's LSP formatting fallback without using the obsolete `lsp_fallback` option name.

- [ ] **Step 4: Correct LaTeX and WSL wording**

State that:

- Texlab selects `pdflatex.exe` on WSL and `pdflatex` on native Linux for its build command.
- VimTeX separately uses `latexmk`.
- Zathura remains the configured PDF viewer.

- [ ] **Step 5: Check documentation consistency**

Run:

```bash
rg -n "0\.8|0\.11|Telescope|plenary|text change|lsp_fallback|\[d|\]d|leader|cmp_luasnip|cmdline|latexmk|pdflatex" INSTRUCTIONS.md
```

Expected:

- No obsolete Neovim minimum, removed plugin, old lint-event, or old Conform wording remains.
- The diagnostic directions, explicit leader, completion modes, and LaTeX tool roles agree with the implementation.

---

### Task 6: Final verification and handoff

**Files:**
- Verify all modified files.
- Do not modify unrelated files.

**Interfaces:**
- Produces: an evidence-based completion report with any desktop-only checks clearly separated

- [ ] **Step 1: Run final static checks**

Run:

```bash
rg -n "lsp_fallback|TextChanged|diagnostic.goto_(next|prev)|require\(['\"]lspconfig|telescope|plenary" init.lua lua INSTRUCTIONS.md
git diff --check
```

Expected: `rg` returns no matches and `git diff --check` reports no whitespace errors.

- [ ] **Step 2: Run final startup and integration checks**

Repeat Task 4 Steps 1 through 5 after the documentation edit.

Expected: all commands pass with the same results.

- [ ] **Step 3: Review the complete diff**

Run:

```bash
git status --short
git diff -- init.lua lua/plugins/init.lua lua/keymaps.lua lua/plugins/lsp.lua lua/plugins/cmp.lua lua/plugins/linting.lua lua/plugins/formatting.lua INSTRUCTIONS.md
```

Expected:

- Only the planned configuration and documentation files are modified.
- `docs/superpowers/plans/2026-08-01-neovim-modernization.md` is the only planned new file.
- `.nvimlog` remains untracked and is not included in any commit. Ask before deleting it.

- [ ] **Step 4: Report remaining manual checks**

Tell the user that the automated checks cover startup, LSP, completion registration, formatting, and linting. Ask the user to check only the desktop integrations that cannot be proved headlessly:

- Zathura opens and performs forward search.
- Live Preview opens the preferred browser.
- Discord displays Cord presence.
