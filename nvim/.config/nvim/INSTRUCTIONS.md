# Neovim Configuration Instructions

This document provides a comprehensive guide to understanding, using, and modifying this Neovim configuration.

## Table of Contents

- [Overview](#overview)
- [File Structure](#file-structure)
- [Installation & Setup](#installation--setup)
- [Keybindings & Shortcuts](#keybindings--shortcuts)
- [Plugins & Configuration](#plugins--configuration)
- [Modifying the Configuration](#modifying-the-configuration)

---

## Overview

This is a modular Neovim configuration designed for:
- **Language Support**: C/C++ (clangd), Python (pyright), HTML/CSS (html/cssls/htmx), LaTeX (texlab)
- **Development Tools**: LSP, completion, linting, formatting, syntax highlighting
- **Special Features**: LaTeX editing with VimTeX, HTML/CSS live preview, Discord rich presence

The configuration uses **vim-plug** as the plugin manager and is organized into separate modules for easy maintenance.

The validated baseline is **Neovim 0.12.4 or later**. Both the global and local leader keys are `\`.

---

## File Structure

```
nvim/
├── init.lua                 # Main entry point - loads all modules
└── lua/
    ├── options.lua          # Basic vim options (indentation, search, etc.)
    ├── keymaps.lua          # General keybindings
    ├── colorscheme.lua      # Colorscheme configuration
    └── plugins/
        ├── init.lua         # Plugin definitions (vim-plug)
        ├── lsp.lua          # LSP server configuration
        ├── cmp.lua          # Completion (nvim-cmp) setup
        ├── linting.lua      # Linting configuration
        ├── formatting.lua   # Formatting configuration
        ├── treesitter.lua   # Treesitter syntax highlighting
        ├── vimtex.lua       # VimTeX (LaTeX) configuration
        ├── latex-snippets.lua  # LaTeX snippets for LuaSnip
        ├── livepreview.lua  # HTML/CSS live preview
        └── cord.lua         # Discord rich presence
```

### Module Loading Order

The `init.lua` file loads modules in this order:
1. `options.lua` - Basic settings
2. `keymaps.lua` - Keybindings
3. `plugins/init.lua` - Plugin definitions (must load first)
4. `colorscheme.lua` - Colorscheme (after plugins)
5. Plugin configurations (after plugins are installed)

---

## Installation & Setup

### Prerequisites

1. **Neovim** (v0.12.4 or later)
2. **vim-plug** plugin manager
   ```bash
   sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   ```

### Installation Steps

1. **Copy configuration files** to `~/.config/nvim/` (or symlink them)

2. **Create symlink** for the lua directory if using dotfiles:
   ```bash
   cd ~/.config/nvim
   ln -sf /path/to/dotfiles/nvim/.config/nvim/lua lua
   ```

3. **Open Neovim** and install plugins:
   ```vim
   :PlugInstall
   ```

4. **Install LSP servers** (Mason manages these automatically):
   ```vim
   :Mason
   ```
   Mason automatically installs and enables only the configured servers: clangd, pyright, html, cssls, htmx, and texlab.

### Setting Up After Pulling from Repository (xstow)

If you're using **xstow** to manage your dotfiles (configuration lives in `~/.dotfiles/nvim/...`), follow these steps after pulling the latest changes:

1. **Run xstow to create/update symlinks**:
   ```bash
   cd ~/.dotfiles
   xstow nvim
   ```
   This will create symlinks from `~/.dotfiles/nvim/.config/nvim/` to `~/.config/nvim/`

2. **Verify symlinks are created**:
   ```bash
   ls -la ~/.config/nvim
   ```
   You should see symlinks pointing to your dotfiles directory.

3. **Ensure vim-plug is installed** (if not already):
   ```bash
   sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   ```

4. **Open Neovim and install/update plugins**:
   ```vim
   :PlugInstall
   ```
   Or to update existing plugins:
   ```vim
   :PlugUpdate
   ```

5. **Install/update LSP servers via Mason**:
   ```vim
   :Mason
   ```
   The configured LSP servers (clangd, pyright, html, cssls, htmx, texlab) are ensured and automatically enabled by Mason.

6. **Verify configuration loads**:
   ```vim
   :checkhealth
   ```
   Check for any issues with LSP, Mason, or LuaSnip.

**Note**: After pulling updates, you typically only need to run `xstow nvim` and `:PlugUpdate` in Neovim. LSP servers will auto-update via Mason when you open files.

### Platform Detection (WSL2 vs Native Linux)

Texlab **automatically detects** whether it is running on WSL2 or native Linux for its build command:
- **WSL2**: Uses `pdflatex.exe` (Windows executable)
- **Native Linux**: Uses `pdflatex` (Linux executable)

VimTeX separately uses `latexmk` as its compiler. Zathura remains the configured PDF viewer (change `vimtex_view_method` in `vimtex.lua` if needed).

---

## Keybindings & Shortcuts

### General Keybindings

| Key | Action | Description |
|-----|-------|-------------|
| `<Space>w` | Save file | Quick save |
| `<F2>` | Toggle explorer | Open/close file explorer (Lexplore) |

### Diagnostics (LSP)

The global and local leader key is `\`, so every `<leader>` sequence below begins with `\`.

| Key | Action | Description |
|-----|-------|-------------|
| `<leader>vd` | Open float | Show diagnostic in floating window |
| `[d` | Previous diagnostic | Jump to previous diagnostic |
| `]d` | Next diagnostic | Jump to next diagnostic |

### LSP (Language Server Protocol)

These keybindings work when an LSP server is active:

| Key | Action | Description |
|-----|-------|-------------|
| `gd` | Go to definition | Jump to symbol definition |
| `K` | Hover | Show documentation for symbol under cursor |
| `<leader>vws` | Workspace symbol | Search workspace symbols |
| `<leader>vca` | Code action | Show available code actions |
| `<leader>vrr` | References | Find all references to symbol |
| `<leader>vrn` | Rename | Rename symbol |
| `<C-h>` | Signature help | Show function signature (insert mode) |

### Completion (nvim-cmp)

| Key | Action | Description |
|-----|-------|-------------|
| `<C-Space>` | Trigger completion | Open completion menu |
| `<Tab>` | Next item / Expand snippet | Select next item or expand LuaSnip snippet |
| `<S-Tab>` | Previous item / Jump back | Select previous item or jump back in snippet |
| `<C-n>` | Next item | Select next completion item |
| `<C-p>` | Previous item | Select previous completion item |
| `<CR>` | Confirm | Accept selected completion |
| `<C-e>` | Abort | Close completion menu |
| `/` or `?` | Buffer completion | Complete words from the current buffer while searching |
| `:` | Path and command completion | Complete filesystem paths and Ex commands |

The `cmp_luasnip` adapter provides the LuaSnip completion source used by nvim-cmp.

### VimTeX (LaTeX Editing)

| Key | Action | Description |
|-----|-------|-------------|
| `<leader>ll` | Compile | Compile LaTeX document |
| `<leader>lv` | View PDF | Open PDF viewer |
| `<leader>ls` | Stop compilation | Stop current compilation |
| `<leader>lc` | Clean | Remove auxiliary files (.aux, .log, etc.) |
| `<leader>le` | Show errors | Display compilation errors |
| `<leader>lo` | Show output | Display compilation output |
| `<leader>lg` | Status | Show VimTeX status |
| `<leader>lk` / `<leader>lK` | Stop all | Stop all VimTeX processes |
| `<leader>lx` | Reload | Reload VimTeX |
| `<leader>lX` | Reload state | Reload VimTeX state |

### LaTeX Snippets

LaTeX snippets are available via LuaSnip. Type the trigger and press `<Tab>` to expand:
- Math: `frac`, `sum`, `int`, `alpha`, `beta`, etc.
- Text: `emph`, `textbf`, `textit`, `texttt`
- Environments: `begin`, `equation`, `align`, `figure`, `table`
- References: `ref`, `cite`, `label`
- Document structure: `section`, `subsection`
- And many more...

---

## Plugins & Configuration

### Core Plugins

#### vim-plug
- **Purpose**: Plugin manager
- **Location**: `lua/plugins/init.lua`
- **Usage**: `:PlugInstall`, `:PlugUpdate`, `:PlugClean`

### Language Support

#### Mason & LSP
- **Plugins**: `mason.nvim`, `mason-lspconfig.nvim`, `nvim-lspconfig`
- **Location**: `lua/plugins/lsp.lua`
- **Configuration**: Uses Neovim's native `vim.lsp.config()` API. Mason automatically enables only the six configured servers.
- **Configured LSP Servers**:
  - `clangd` - C/C++
  - `pyright` - Python
  - `html` - HTML
  - `cssls` - CSS
  - `htmx` - HTMX
  - `texlab` - LaTeX
- **Installation**: Use `:Mason` command or servers auto-install via Mason
- **Configuration**: Edit `lua/plugins/lsp.lua` to add or modify the server list and native LSP settings

#### nvim-cmp (Completion)
- **Plugins**: `nvim-cmp`, `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-cmdline`, and `cmp_luasnip` with `LuaSnip`
- **Location**: `lua/plugins/cmp.lua`
- **Sources**: LSP, LuaSnip, buffer, and path in insert mode; buffer completion for `/` and `?`; path and Ex-command completion for `:`
- **Configuration**: Edit `lua/plugins/cmp.lua` to modify completion sources or keybindings

#### Treesitter
- **Plugin**: `nvim-treesitter`
- **Location**: `lua/plugins/treesitter.lua`
- **Features**: Syntax highlighting
- **Update**: Run `:TSUpdate` after installation

### Linting & Formatting

#### nvim-lint
- **Plugin**: `nvim-lint`
- **Location**: `lua/plugins/linting.lua`
- **Configured Linters**:
  - Python: `ruff`
- **Auto-linting**: Triggers on save and insert leave
- **Configuration**: Add more linters in `lua/plugins/linting.lua`

#### conform.nvim
- **Plugin**: `conform.nvim`
- **Location**: `lua/plugins/formatting.lua`
- **Configured Formatters**:
  - Python: `black`
- **Format on Save**: Enabled (500ms timeout)
- **LSP formatting fallback**: Enabled; Conform uses the LSP formatter when no configured formatter is available
- **Configuration**: Edit `lua/plugins/formatting.lua`

### LaTeX Support

#### VimTeX
- **Plugin**: `vimtex`
- **Location**: `lua/plugins/vimtex.lua`
- **Texlab build command**: Auto-detects platform:
  - **WSL2**: `pdflatex.exe`
  - **Native Linux**: `pdflatex`
- **VimTeX compiler**: `latexmk` (configured separately from Texlab)
- **Viewer**: Zathura (change `vimtex_view_method` to modify)
- **Features**:
  - Syntax concealment (Greek letters, math symbols, etc.)
  - Folding enabled
  - SyncTeX support
  - Platform auto-detection (WSL2 vs native Linux)
- **Configuration**: 
  - Change compiler manually: Edit `vim.g.vimtex_compiler_generic.command` (not needed - auto-detects)
  - Change viewer: Edit `vim.g.vimtex_view_method`
  - Modify folding: Edit `vim.g.vimtex_fold_types`

#### LaTeX Snippets
- **Plugin**: Uses `LuaSnip`
- **Location**: `lua/plugins/latex-snippets.lua`
- **Usage**: Type trigger word + `<Tab>` to expand
- **Adding Snippets**: Edit `lua/plugins/latex-snippets.lua`

### Other Plugins

#### Live Preview
- **Plugin**: `live-preview.nvim`
- **Location**: `lua/plugins/livepreview.lua`
- **Purpose**: Live preview HTML/CSS
- **Port**: 5500 (configurable)
- **Usage**: `:LivePreviewStart`

#### Emmet
- **Plugin**: `emmet-vim`
- **Purpose**: HTML/CSS abbreviations
- **Usage**: Type abbreviation + `<C-y>,` (or check plugin docs)

#### Discord Rich Presence
- **Plugin**: `cord.nvim`
- **Location**: `lua/plugins/cord.lua`
- **Purpose**: Show Neovim status in Discord
- **Configuration**: Edit `lua/plugins/cord.lua`

#### Colorscheme
- **Plugin**: `wal.vim`
- **Location**: `lua/colorscheme.lua`
- **Change**: Edit `lua/colorscheme.lua` to use a different colorscheme

---

## Modifying the Configuration

### Adding a New Plugin

1. **Add plugin definition** in `lua/plugins/init.lua`:
   ```lua
   Plug 'author/plugin-name'
   ```

2. **Create configuration file** (optional) in `lua/plugins/`:
   ```lua
   -- lua/plugins/myplugin.lua
   require('myplugin').setup({
       option = 'value',
   })
   ```

3. **Load configuration** in `init.lua`:
   ```lua
   require('plugins.myplugin')
   ```

4. **Install plugin**:
   ```vim
   :PlugInstall
   ```

### Adding an LSP Server

1. **Add the server name** to the `servers` list in `lua/plugins/lsp.lua`:
   ```lua
   local servers = { 'clangd', 'new-lsp-server', ... }
   ```

2. **Add custom configuration** (optional) with native LSP configuration:
   ```lua
   vim.lsp.config('new-lsp-server', {
       settings = {
           -- custom settings
       },
   })
   ```

Mason uses the `servers` list for installation and automatic activation.

### Changing Keybindings

1. **General keybindings**: Edit `lua/keymaps.lua`
2. **LSP keybindings**: Edit `lua/plugins/lsp.lua` (in `on_attach` function)
3. **Completion keybindings**: Edit `lua/plugins/cmp.lua` (in `mapping` section)
4. **Plugin-specific keybindings**: Edit the corresponding plugin config file

### Changing Options

Edit `lua/options.lua` to modify:
- Search behavior (`ignorecase`, `smartcase`, `hlsearch`)
- Text wrapping (`wrap`, `breakindent`)
- Indentation (`tabstop`, `shiftwidth`)
- Timeout (`timeoutlen`)
- Colors (`termguicolors`)

### Adding a Linter

1. **Install the linter** (ensure it's in PATH)

2. **Add to `lua/plugins/linting.lua`**:
   ```lua
   require('lint').linters_by_ft = {
       python = { 'ruff' },
       javascript = { 'eslint' },  -- new
   }
   ```

### Adding a Formatter

1. **Install the formatter** (ensure it's in PATH)

2. **Add to `lua/plugins/formatting.lua`**:
   ```lua
   formatters_by_ft = {
       python = { "black" },
       javascript = { "prettier" },  -- new
   }
   ```

### Changing LaTeX Compiler

Texlab automatically selects `pdflatex.exe` on WSL2 and `pdflatex` on native Linux. To change Texlab's build command, edit `lua/plugins/lsp.lua`. VimTeX separately uses `latexmk`; to change its compiler method, edit `lua/plugins/vimtex.lua`:

```lua
vim.g.vimtex_compiler_method = 'latexmk'
```

Manual changes to the Texlab command are usually not needed.

### Changing PDF Viewer

Edit `lua/plugins/vimtex.lua`:
```lua
vim.g.vimtex_view_method = 'your-viewer'  -- e.g., 'sumatra', 'mupdf'
```

### Disabling a Plugin

1. **Comment out** the plugin in `lua/plugins/init.lua`
2. **Comment out** the require in `init.lua`
3. **Run**: `:PlugClean` to remove unused plugins

### Troubleshooting

- **Config not loading**: Check that symlinks are set up correctly
- **Plugins not installing**: Run `:PlugInstall` and check for errors
- **LSP not working**: Ensure LSP server is installed (use `:Mason`)
- **LaTeX not compiling**: 
  - Verify `pdflatex` (or `pdflatex.exe` on WSL2) is in PATH for Texlab builds
  - Verify `latexmk` is in PATH for VimTeX compilation
  - Check that the platform is detected correctly (WSL2 vs native Linux)
  - Configuration auto-detects the Texlab platform-specific build command, but verify the correct command is available
- **Snippets not working**: Ensure LuaSnip is loaded (check `:checkhealth luasnip`)

---

## Tips

1. **Use `:checkhealth`** to diagnose issues:
   - `:checkhealth lsp`
   - `:checkhealth mason`
   - `:checkhealth luasnip`

2. **Reload config** without restarting:
   ```vim
   :source ~/.config/nvim/init.lua
   ```

3. **Plugin commands**:
   - `:PlugInstall` - Install plugins
   - `:PlugUpdate` - Update plugins
   - `:PlugClean` - Remove unused plugins
   - `:Mason` - Manage LSP servers

4. **LSP commands**:
   - `:LspInfo` - Show LSP server status
   - `:LspRestart` - Restart LSP server

---

## License & Credits

This configuration uses various plugins maintained by their respective authors. Refer to each plugin's repository for licensing information.

---

*Last updated: Configuration verified and tested on WSL2 and native Linux with Neovim 0.12.4+*
