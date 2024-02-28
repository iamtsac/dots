#!/bin/bash

echo "Creating $HOME/pkg/ folder"
mkdir $HOME/pkg/
cd $HOME/pkg/

echo "Installing paru"
sudo pacman -S --needed base-devel


echo "Installing Essentials"
sudo pacman -Sy neovim rustup fish tmux wezterm

echo "Setting up Rust"
rustup default stable
export PATH=$HOME/.cargo/bin:$PATH

echo "Install Rust apps"
cargo install bat starship ripgrep paru
cargo install --git https://github.com/ogham/exa.git

rm -rf $HOME/pkg/
