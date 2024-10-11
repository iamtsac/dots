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
make CMAKE_BUILD_TYPE=Release 
sudo make install
cd ..

sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish

echo "Installing WezTerm"
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm -y

echo "Setting up Rust"
# rustup default stable
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$HOME/.cargo/bin:$PATH

echo "Install Rust apps"
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
