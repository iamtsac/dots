#!/bin/bash

# Exit on error
set -e

echo "--- Initializing No-Root Environment Setup ---"
mkdir -p $HOME/pkg/
mkdir -p $HOME/.local/bin

# Set up paths for the session
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.zvm/bin:$HOME/.zvm/self:$PATH"

cd $HOME/pkg/

# # 1. Install Rust (Foundation)
if ! command -v cargo &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

# # 2. Install ZVM & Zig
echo "Installing ZVM..."
curl https://www.zvm.app/install.sh | bash
export PATH="$HOME/.zvm/bin:$HOME/.zvm/self:$PATH"

# echo "Installing Zig via ZVM..."
zvm install 0.15.2
zvm use 0.15.2

# ZMX (Multiplexer)
git clone https://github.com/neurosnap/zmx.git
cd zmx
zig build -Doptimize=ReleaseSafe --prefix ~/.local
cd ..

# # 3. Install Pixi (Environment Manager)
echo "Installing Pixi..."
curl -fsSL https://pixi.sh/install.sh | bash
export PATH="$HOME/.pixi/bin:$PATH"

# # 4. Build Fish Shell from source
echo "Building Fish Shell..."
git clone --depth 1 https://github.com/fish-shell/fish-shell.git
cd fish-shell
cmake . -DCMAKE_INSTALL_PREFIX=$HOME/.local/
make && make install
cd ..

# # 5. Build Neovim from source
# echo "Building Neovim..."
git clone --depth 1 https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local
make install
cd ..

# 6. Cargo Installs (The Rust Stack)
echo "Installing Rust tools..."

# Yazi (Un-locked to get the latest master updates)
cargo install --force yazi-build

# Skim (fzf replacement)
cargo install skim

# Rest of the essentials
cargo install bat ripgrep eza fd-find tree-sitter-cli

cargo install tuckr

# 7. Oh My Posh (Prompt)
echo "Installing Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin


# echo "Setting Ghostty terminfo.. "
mkdir -p ~/.terminfo
curl -LO https://raw.githubusercontent.com/ghostty-org/ghostty/main/terminfo/ghostty.terminfo
tic -x -o ~/.terminfo ghostty.terminfo


# 8. Cleanup
echo "Cleaning up build files..."
cd $HOME
rm -rf $HOME/pkg/

echo "--- Setup Complete ---"
echo "Add this to your fish config:"
echo 'set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $HOME/.zvm/bin $HOME/.zvm/self $PATH'

echo "Finalizing shell configuration..."

cat << 'EOF' >> "$HOME/.bashrc"

# --- Custom Environment ---
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.zvm/bin:$HOME/.zvm/self:$HOME/.pixi/bin:$PATH"

# Auto-start Fish for interactive sessions
if [[ $- == *i* ]] && command -v fish >/dev/null 2>&1; then
    exec fish
fi
EOF

echo "Setup complete! Log out and back in, or run 'source ~/.bashrc' to begin."
