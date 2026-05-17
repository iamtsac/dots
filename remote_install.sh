#!/bin/bash

# Exit on error (except during uninstall where we want to keep going if a file is already missing)
set -e

# -----------------------------------------------------------------------------
# Configuration & Paths
# -----------------------------------------------------------------------------
SRC_DIR="$HOME/.local/src"
BIN_DIR="$HOME/.local/bin"

# Detect System Architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64)
        TMUX_ARCH="x86_64|amd64"
        TS_ARCH="x64"
        ;;
    aarch64|arm64)
        TMUX_ARCH="aarch64|arm64"
        TS_ARCH="arm64"
        ;;
    *)
        echo "Error: Unsupported architecture ($ARCH)"
        exit 1
        ;;
esac

# Helper function to clone or pull a git repo incrementally
sync_repo() {
    local url=$1
    local dir=$2
    if [ -d "$dir" ]; then
        echo "Updating Git repository: $(basename "$dir")..."
        cd "$dir"
        git stash --quiet || true
        git pull || {
            echo "Pull failed. Resetting and cloning fresh..."
            cd .. && rm -rf "$dir"
            git clone --depth 1 "$url" "$dir" && cd "$dir"
        }
    else
        echo "Cloning Git repository: $(basename "$dir")..."
        git clone --depth 1 "$url" "$dir"
        cd "$dir"
    fi
}

# -----------------------------------------------------------------------------
# Installation / Update Actions
# -----------------------------------------------------------------------------

manage_rust() {
    if ! command -v cargo &> /dev/null; then
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        echo "Updating Rust toolchain..."
        rustup update
    fi
}

manage_zvm_zig() {
    if ! command -v zvm &> /dev/null; then
        echo "Installing ZVM..."
        curl https://www.zvm.app/install.sh | bash
        export PATH="$HOME/.zvm/bin:$HOME/.zvm/self:$PATH"
    else
        echo "Updating ZVM..."
        zvm upgrade
    fi
    echo "Ensuring Zig 0.15.2 is configured..."
    zvm install 0.15.2
    zvm use 0.15.2
}

manage_zmx() {
    sync_repo "https://github.com/neurosnap/zmx.git" "$SRC_DIR/zmx"
    echo "Building ZMX Multiplexer..."
    zig build -Doptimize=ReleaseSafe --prefix "$HOME/.local"
}

manage_pixi() {
    if ! command -v pixi &> /dev/null; then
        echo "Installing Pixi..."
        curl -fsSL https://pixi.sh/install.sh | bash
        export PATH="$HOME/.pixi/bin:$PATH"
    else
        echo "Updating Pixi..."
        pixi self-update
    fi
}

manage_fish() {
    sync_repo "https://github.com/fish-shell/fish-shell.git" "$SRC_DIR/fish-shell"
    echo "Building/Updating Fish Shell from source..."
    cmake . -DCMAKE_INSTALL_PREFIX="$HOME/.local/"
    make && make install
}

manage_neovim() {
    sync_repo "https://github.com/neovim/neovim.git" "$SRC_DIR/neovim"
    echo "Building/Updating Neovim from source..."
    make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$HOME/.local"
    make install
}

manage_cargo_tools() {
    echo "Managing Cargo ecosystem tools..."
    cargo install --force yazi-build

    if ! command -v cargo-install-update &> /dev/null; then
        echo "Installing cargo-update manager with vendored OpenSSL..."
        cargo install cargo-update --features vendored-openssl
    fi

    declare -A tools=(
        [rg]=ripgrep [bat]=bat [eza]=eza [fd]=fd-find [zoxide]=zoxide [sk]=skim [tuckr]=tuckr
    )
    for bin in "${!tools[@]}"; do
        if ! command -v "$bin" &> /dev/null; then
            echo "Installing missing tool: ${tools[$bin]}..."
            cargo install "${tools[$bin]}"
        fi
    done

    echo "Bumping out-of-date Cargo packages safely..."
    cargo install-update ripgrep bat eza fd-find zoxide skim tuckr
    cargo install cargo-update --features vendored-openssl
}

manage_treesitter() {
    echo "Checking GitHub for the latest Tree-sitter release..."
    LATEST_TAG=$(curl -s https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [ -z "$LATEST_TAG" ]; then echo "Warning: Skipping Tree-sitter update."; return; fi
    CLEAN_VER=$(echo "$LATEST_TAG" | sed -E 's/^v//')

    if ! command -v tree-sitter &> /dev/null || [[ "$(tree-sitter --version 2>/dev/null)" != *"$CLEAN_VER"* ]]; then
        echo "Installing/Updating to prebuilt static Tree-sitter ($LATEST_TAG)..."
        cd "$SRC_DIR"
        curl -sLO "https://github.com/tree-sitter/tree-sitter/releases/download/${LATEST_TAG}/tree-sitter-linux-${TS_ARCH}.gz"
        gunzip -f "tree-sitter-linux-${TS_ARCH}.gz"
        mv "tree-sitter-linux-${TS_ARCH}" "$BIN_DIR/tree-sitter"
        chmod +x "$BIN_DIR/tree-sitter"
    fi
}

manage_oh_my_posh() {
    if ! command -v oh-my-posh &> /dev/null; then
        curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$BIN_DIR"
    else
        oh-my-posh upgrade
    fi
}

manage_ghostty() {
    cd "$SRC_DIR"
    curl -sLO https://raw.githubusercontent.com/ghostty-org/ghostty/main/terminfo/ghostty.terminfo
    tic -x -o "$HOME/.terminfo" ghostty.terminfo
    rm -f ghostty.terminfo
}

manage_tmux() {
    echo "Checking GitHub for the latest Tmux release..."
    DOWNLOAD_URL=$(curl -s https://api.github.com/repos/tmux/tmux-builds/releases/latest | grep '"browser_download_url":' | grep 'linux' | grep -E "$TMUX_ARCH" | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')
    if [ -z "$DOWNLOAD_URL" ]; then echo "Warning: Skipping Tmux update."; return; fi
    FILENAME=$(basename "$DOWNLOAD_URL")
    CLEAN_VER=$(echo "$FILENAME" | sed -E 's/tmux-([^_-]+)-.*/\1/')

    if ! command -v tmux &> /dev/null || [[ "$(tmux -V 2>/dev/null)" != *"$CLEAN_VER"* ]]; then
        echo "Installing/Updating to static Tmux version $CLEAN_VER..."
        cd "$SRC_DIR"
        curl -sLO "$DOWNLOAD_URL"
        tar -xzf "$FILENAME"
        mv tmux "$BIN_DIR/tmux"
        rm -f "$FILENAME"
    fi
}

configure_env() {
    if ! grep -q "# --- Custom Environment ---" "$HOME/.bashrc"; then
        cat << 'EOF' >> "$HOME/.bashrc"

# --- Custom Environment ---
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.zvm/bin:$HOME/.zvm/self:$HOME/.pixi/bin:$PATH"

# Auto-start Fish for interactive sessions
if [[ $- == *i* ]] && command -v fish >/dev/null 2>&1; then
    exec fish
fi
EOF
    fi
}

# -----------------------------------------------------------------------------
# Uninstall Actions
# -----------------------------------------------------------------------------
execute_uninstall() {
    echo "!!! WARNING: This will completely erase all tools, plugins, and caches managed by this script !!!"
    read -p "Are you absolutely sure you want to proceed? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstall aborted."
        exit 0
    fi

    # Allow errors to pass during uninstall so missing folders don't halt progress
    set +e

    # 1. Clear Yazi system /tmp cache using the CLI before deleting files
    if command -v yazi &> /dev/null; then
        echo "Asking Yazi to purge temporary system caches..."
        yazi --clear-cache
    fi

    echo "Removing source code and temporary build workspaces..."
    rm -rf "$SRC_DIR"

    echo "Removing isolated package managers (Rust, Pixi, ZVM)..."
    rm -rf "$HOME/.cargo" "$HOME/.rustup"
    rm -rf "$HOME/.pixi"
    rm -rf "$HOME/.zvm"

    echo "Removing specific local binaries..."
    cd "$BIN_DIR" && rm -f fish nvim tmux tree-sitter oh-my-posh zmx rg bat eza fd zoxide sk tuckr yazi yazi-cli yazi-build cargo-install-update

    echo "Removing Ghostty terminfo mappings..."
    rm -f "$HOME/.terminfo/g/ghostty"

    echo "--- DEEP CLEAN: Purging Application Plugins, States, & Caches ---"

    # 2. CONFIGS PRESERVED: Left commented out because they are linked by tuckr
    echo "Preserving configuration files in ~/.config/..."
    # rm -rf "$HOME/.config/nvim"
    # rm -rf "$HOME/.config/fish"
    # rm -rf "$HOME/.config/yazi"

    # 3. Clean up Neovim state and local plugin downloads
    echo "Clearing Neovim leftovers..."
    rm -rf "$HOME/.local/share/nvim"
    rm -rf "$HOME/.local/state/nvim"
    rm -rf "$HOME/.local/lib/nvim"
    rm -rf "$HOME/.cache/nvim"

    # 4. Clean up Fish Shell data history
    echo "Clearing Fish Shell leftovers..."
    rm -rf "$HOME/.local/share/fish"

    # 5. Clean up Yazi data folders
    echo "Clearing Yazi leftovers..."
    rm -rf "$HOME/.local/share/yazi"
    rm -rf "$HOME/.cache/yazi"

    # 6. Clean up remaining background utility tracking
    echo "Clearing remaining terminal utility leftovers..."
    rm -rf "$HOME/.local/share/zoxide"
    rm -rf "$HOME/.cache/pixi"
    rm -rf "$HOME/.cache/zig"

    echo "Cleaning up .bashrc shell paths..."
    if [ -f "$HOME/.bashrc" ]; then
        sed -i '/# --- Custom Environment ---/,/fi/d' "$HOME/.bashrc"
    fi

    echo "--- Uninstall Complete ---"
    echo "Your machine is clean. Configuration files were preserved for tuckr."
    echo "Please run 'source ~/.bashrc' or restart your terminal to finish."
}

# -----------------------------------------------------------------------------
# Runtime Controller
# -----------------------------------------------------------------------------
MODE=${1:-install}

case "$MODE" in
    install|update)
        mkdir -p "$SRC_DIR" "$BIN_DIR" "$HOME/.terminfo"
        echo "--- Initializing No-Root Environment Setup [Mode: ${MODE^^}] ---"
        manage_rust
        manage_zvm_zig
        manage_zmx
        manage_pixi
        manage_fish
        manage_neovim
        manage_cargo_tools
        manage_treesitter
        manage_oh_my_posh
        manage_ghostty
        manage_tmux
        configure_env
        echo "--- Setup/Update Action Complete! ---"
        ;;
    uninstall)
        execute_uninstall
        ;;
    *)
        echo "Error: Invalid argument."
        echo "Usage: $0 [install|update|uninstall]"
        exit 1
        ;;
esac
