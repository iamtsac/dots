#!/bin/bash

echo "Creating $HOME/pkg/ folder"
mkdir $HOME/pkg/
cd $HOME/pkg/

echo "Installing Essentials"
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential cmake stow ninja-build gettext unzip curl python3-dev python-is-python3 imagemagick -y

echo "Installing Neovim"
git clone https://github.com/neovim/neovim 
cd neovim 
make CMAKE_BUILD_TYPE=RelWithDebInfo 
sudo make install
cd ..

echo "Installing paru"
sudo apt install -y cargo fish

echo "Installing WezTerm"
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm -y

echo "Installing Tmux"
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure --enable-sixel && make
sudo make install
cd ..

echo "Setting up Rust"
# rustup default stable
export PATH=$HOME/.cargo/bin:$PATH

echo "Install Rust apps"
cargo install bat starship ripgrep
cargo install --git https://github.com/eza-community/eza
cargo install --git https://github.com/sxyazi/yazi yazi-fm yazi-cli

rm -rf $HOME/pkg/
