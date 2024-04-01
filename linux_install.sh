#!/bin/bash

echo "Creating $HOME/pkg/ folder"
mkdir $HOME/pkg/
cd $HOME/pkg/

echo "Installing paru"
sudo pacman -S --needed base-devel


echo "Installing Essentials"
sudo pacman -Sy neovim rustup fish wezterm

echo "Installing Tmux"
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure --enable-sixel && make
sudo make install
cd ..

echo "Installing Ranger"
git clone https://github.com/ranger/ranger
cd ranger
sudo python setup.py install --optimize=1 --record=install_log.txt --prefix=/usr/
cd ..

echo "Setting up Rust"
rustup default stable
export PATH=$HOME/.cargo/bin:$PATH

echo "Install Rust apps"
cargo install bat starship ripgrep paru
cargo install --git https://github.com/ogham/exa.git

rm -rf $HOME/pkg/
