#!/bin/bash

echo "Creating $HOME/pkg/ folder"
mkdir $HOME/pkg/
cd $HOME/pkg/

echo "Installing Neovim"
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
tar -xf nvim-linux64.tar.gz
cp nvim-linux64/bin/nvim $HOME/.local/bin/nvim
cp -r nvim-linux64/lib/nvim $HOME/.local/lib/
cp -r nvim-linux64/share/* $HOME/.local/share/

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

git clone https://github.com/fish-shell/fish-shell.git
cd fish-shell
cmake . -DCMAKE_INSTALL_PREFIX=$HOME/.local/
make
make install
cd ..

echo "Setting up Rust"
# rustup default stable
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$HOME/.cargo/bin:$PATH

echo "Setting up Rust"
# rustup default stable
export PATH=$HOME/.cargo/bin:$PATH

cargo install bat starship ripgrep
cargo install --git https://github.com/eza-community/eza
cargo install --git https://github.com/sxyazi/yazi yazi-fm yazi-cli
cargo install --locked zellij

curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
mkdir -p $HOME/.local/bin/
cp bin/micromamba $HOME/.local/bin/micromamba
$HOME/.local/bin/micromamba shell init -s fish -r ~/.mamba

cd ..
rm -rf $HOME/pkg/
