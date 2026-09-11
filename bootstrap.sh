#!/usr/bin/env bash
set -euo pipefail

# Ensure ~/.local/bin is in PATH for user-installed binaries & scripts
export PATH="$HOME/.local/bin:$PATH"

# ==============================================================================
# Clara's Debian Post-Install Bootstrap Script
# Modular, idempotent setup for shell, development toolchains, Neovim, and Suckless.
# ==============================================================================

# Colors & Logging
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_done() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_err()  { echo -e "${RED}[ERROR]${NC} $1"; }

AUTO_YES=false

ask_step() {
    local prompt="$1"
    local func="$2"
    if [[ "$AUTO_YES" == "true" ]]; then
        $func
    else
        echo ""
        read -rp "$(echo -e "${YELLOW}?${NC} $prompt [y/N]: ")" choice
        case "$choice" in
            [yY][eE][sS]|[yY]) $func ;;
            *) log_info "Skipping: $prompt" ;;
        esac
    fi
}

# 1. Base APT Packages & Build Toolchain
step_base_packages() {
    log_info "Installing base packages, build toolchain, and utilities..."
    sudo apt update
    sudo apt install -y \
        build-essential cmake ninja-build gettext curl wget git pkg-config unzip \
        libtool make automake autoconf bison flex zsh tmux xstow rsync ripgrep fd-find \
        ca-certificates fontconfig xclip libx11-dev libxinerama-dev libxft-dev xorg xinit
    log_done "Base packages installed."
}

# 2. GitHub CLI (gh)
step_github_cli() {
    if command -v gh >/dev/null 2>&1; then
        log_info "GitHub CLI already installed ($(gh --version | head -n1))."
        return
    fi
    log_info "Setting up official GitHub CLI repository..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    local out
    out=$(mktemp)
    wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
    cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    rm -f "$out"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install -y gh
    log_done "GitHub CLI installed."
}

# 3. Build jq From Source
step_build_jq() {
    if command -v jq >/dev/null 2>&1; then
        log_info "jq is already installed ($(jq --version))."
        return
    fi
    log_info "Cloning and compiling jq from source..."
    local build_dir
    build_dir=$(mktemp -d /tmp/jq-build-XXXXXX)
    git clone https://github.com/jqlang/jq.git "$build_dir"
    (
        cd "$build_dir"
        git submodule update --init
        autoreconf -i
        ./configure --with-oniguruma=builtin
        make -j"$(nproc)"
        sudo make install
    )
    rm -rf "$build_dir"
    log_done "jq successfully compiled and installed."
}

# 4. Build Neovim From Source
step_build_neovim() {
    if command -v nvim >/dev/null 2>&1; then
        log_info "Neovim is already installed ($(nvim --version | head -n1))."
        return
    fi
    log_info "Cloning and compiling Neovim (stable)..."
    local build_dir
    build_dir=$(mktemp -d /tmp/neovim-build-XXXXXX)
    git clone https://github.com/neovim/neovim.git "$build_dir"
    (
        cd "$build_dir"
        git checkout stable
        make clean || true
        make CMAKE_BUILD_TYPE=Release -j"$(nproc)"
        sudo make install
    )
    rm -rf "$build_dir"
    log_done "Neovim successfully compiled and installed."
}

# 5. Stow Core Dotfiles
step_dotfiles() {
    log_info "Stowing core dotfiles (zshrc, tmux, nvim)..."
    local dotfiles_dir="${DOTFILES:-$HOME/dotfiles}"
    if [ ! -d "$dotfiles_dir" ]; then
        log_warn "Dotfiles directory not found at $dotfiles_dir."
        return
    fi
    (
        cd "$dotfiles_dir"
        xstow zshrc tmux nvim
    )
    log_done "Core dotfiles stowed."
}

# 6. Oh-My-Zsh & Theme
step_shell() {
    log_info "Setting up Oh-My-Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        rm -rf "$HOME/.oh-my-zsh/custom"
    fi
    local dotfiles_dir="${DOTFILES:-$HOME/dotfiles}"
    if [ -d "$dotfiles_dir/oh-my-zsh" ]; then
        (
            cd "$dotfiles_dir"
            xstow oh-my-zsh
        )
    fi
    if [ "$SHELL" != "$(which zsh)" ]; then
        log_info "Setting default login shell to zsh..."
        chsh -s "$(which zsh)" "$USER" || true
    fi
    log_done "Shell configured with Oh-My-Zsh & custom theme."
}

# 7. Neovim Plugins, Vim-Plug & Node.js
step_neovim_plugins() {
    log_info "Setting up vim-plug and Node.js for Neovim..."
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    sudo apt install -y nodejs npm
    log_info "Running Neovim PlugInstall..."
    nvim --headless +PlugInstall +qa || true
    log_done "Neovim plugins and runtime ready."
}

# 8. Python & pywal via uv
step_python() {
    log_info "Setting up uv and pywal..."
    if ! command -v uv >/dev/null 2>&1; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
    fi
    uv tool install pywal
    log_done "Python tooling & pywal configured."
}

# 9. Suckless Desktop Suite (dwm, slstatus, st, dmenu)
step_suckless() {
    log_info "Stowing and compiling Suckless suite..."
    local dotfiles_dir="${DOTFILES:-$HOME/dotfiles}"
    (
        cd "$dotfiles_dir"
        xstow dwm slstatus st dmenu
    )
    if command -v suckless-recompile >/dev/null 2>&1; then
        suckless-recompile
    elif [ -x "$dotfiles_dir/dwm/.local/bin/suckless-recompile" ]; then
        "$dotfiles_dir/dwm/.local/bin/suckless-recompile"
    fi
    log_done "Suckless suite built and installed."
}

# 10. PipeWire Audio Stack
step_audio() {
    log_info "Installing and activating PipeWire audio stack..."
    sudo apt install -y pipewire pipewire-pulse pipewire-alsa wireplumber alsa-utils
    systemctl --user enable --now wireplumber pipewire pipewire-pulse || true
    log_done "Audio stack installed and enabled."
}

# 11. Nerd Fonts
step_fonts() {
    log_info "Installing Roboto Mono & Symbols Nerd Fonts..."
    mkdir -p "$HOME/.local/share/fonts"
    local font_zip="/tmp/RobotoMono.zip"
    wget -nv -O "$font_zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip"
    unzip -qo "$font_zip" -d "$HOME/.local/share/fonts/"
    rm -f "$font_zip"
    fc-cache -fv "$HOME/.local/share/fonts" >/dev/null
    log_done "Nerd Fonts installed and font cache updated."
}

# 12. Build Girara & Zathura From Source (with Build Dependency Cleanup)
step_build_zathura() {
    if command -v zathura >/dev/null 2>&1; then
        log_info "Zathura is already installed ($(zathura --version | head -n1))."
        return
    fi

    local runtime_deps=(
        libgtk-4-1 libglib2.0-0 libjson-glib-1.0-0 libmagic1
        libsqlite3-0 libxxhash0 libpoppler-glib8
    )
    local build_deps=(
        meson doxygen
        libgtk-4-dev libglib2.0-dev libjson-glib-dev libmagic-dev
        libsqlite3-dev libxxhash-dev libpoppler-glib-dev
    )

    log_info "Installing build dependencies for Girara & Zathura..."
    sudo apt update
    sudo apt install -y "${runtime_deps[@]}" "${build_deps[@]}" || sudo apt install -y "${build_deps[@]}"

    export PKG_CONFIG_PATH="/usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

    local work_dir
    work_dir=$(mktemp -d /tmp/zathura-build-XXXXXX)

    log_info "Building Girara from source..."
    git clone https://github.com/pwmt/girara.git "$work_dir/girara"
    (
        cd "$work_dir/girara"
        meson setup build
        ninja -C build
        sudo ninja -C build install
        sudo ldconfig
    )

    log_info "Building Zathura from source..."
    git clone https://github.com/pwmt/zathura.git "$work_dir/zathura"
    (
        cd "$work_dir/zathura"
        meson setup build
        ninja -C build
        sudo ninja -C build install
        sudo ldconfig
    )

    log_info "Building Zathura Poppler PDF Plugin from source..."
    git clone https://github.com/pwmt/zathura-pdf-poppler.git "$work_dir/zathura-pdf-poppler"
    (
        cd "$work_dir/zathura-pdf-poppler"
        meson setup build
        ninja -C build
        sudo ninja -C build install
        sudo ldconfig
    )

    rm -rf "$work_dir"

    log_info "Cleaning up temporary build dependencies and headers..."
    sudo apt remove -y "${build_deps[@]}"
    sudo apt clean

    log_done "Girara, Zathura, and Poppler PDF plugin installed (build bloat removed)."
}

# 13. NVIDIA Drivers (Optional / Hardware-specific)
step_nvidia() {
    log_info "Installing NVIDIA proprietary drivers & kernel headers..."
    sudo apt install -y linux-headers-amd64 nvidia-driver firmware-misc-nonfree
    log_done "NVIDIA drivers installed (reboot recommended)."
}

# ==============================================================================
# Main Runner
# ==============================================================================
main() {
    if [[ "${1:-}" == "--all" || "${1:-}" == "-y" ]]; then
        AUTO_YES=true
    fi

    echo "=================================================="
    echo "       Debian Post-Install Bootstrap Suite        "
    echo "=================================================="

    ask_step "1. Install base build packages & tools"            step_base_packages
    ask_step "2. Install GitHub CLI (gh)"                         step_github_cli
    ask_step "3. Compile jq from source"                         step_build_jq
    ask_step "4. Compile Neovim from source"                     step_build_neovim
    ask_step "5. Stow core dotfiles (zshrc, tmux, nvim)"          step_dotfiles
    ask_step "6. Setup Oh-My-Zsh & theme"                        step_shell
    ask_step "7. Setup Vim-Plug, Node & nvim plugins"            step_neovim_plugins
    ask_step "8. Install uv & pywal"                             step_python
    ask_step "9. Stow & build Suckless suite (dwm/st)"           step_suckless
    ask_step "10. Setup PipeWire audio stack"                    step_audio
    ask_step "11. Download & install Nerd Fonts"                 step_fonts
    ask_step "12. Compile Girara & Zathura from source (VimTeX)" step_build_zathura
    ask_step "13. Install NVIDIA GPU drivers (if needed)"        step_nvidia

    echo ""
    echo "=================================================="
    log_done "All requested bootstrap steps finished!"
    echo "=================================================="
}

main "$@"
