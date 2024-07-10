#!/bin/bash

echo "Creating $HOME/pkg/ folder"
mkdir $HOME/pkg/
cd $HOME/pkg/

echo "Installing paru"
sudo pacman -Sy --needed base-devel cmake unzip ninja curl

echo "Installing Essentials"
sudo pacman -Sy cargo fish wezterm

echo "Installing Tmux"
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure --enable-sixel && make
sudo make install
cd ..

echo "Installing Ranger"
pip install -U git+https://github.com/ranger/ranger
ranger --copy-config=all

echo "Setting up Rust"
# rustup default stable
export PATH=$HOME/.cargo/bin:$PATH

echo "Install Rust apps"
cargo install bat starship ripgrep
cargo install --git https://github.com/eza-community/eza
cargo install --git https://github.com/Morganamilo/paru

paru -Sy neovim-git --noconfirm
rm -rf $HOME/pkg/
