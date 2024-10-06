#!/bin/bash

echo "Creating $HOME/pkg/ folder"
mkdir $HOME/pkg/
cd $HOME/pkg/

echo "Installing paru"
sudo pacman -Sy --needed base-devel cmake unzip ninja curl --noconfirm

echo "Installing Essentials"
sudo pacman -Sy fish wezterm --noconfirm

# echo "Setting up Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$HOME/.cargo/bin:$PATH

echo "Install Rust apps"
cargo install bat starship ripgrep
cargo install --git https://github.com/eza-community/eza
cargo install --git https://github.com/Morganamilo/paru
cargo install --git https://github.com/sxyazi/yazi yazi-fm yazi-cli

echo "Install neovim"
paru -Sy neovim-git --noconfirm
rm -rf $HOME/pkg/
