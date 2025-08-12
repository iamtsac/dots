#!/bin/bash

UPDATE=false
DEBUG=false

for arg in "$@"
do
    case $arg in
        --update)
            UPDATE=true
            ;;
        *)
            echo "Unknown option: $arg"
            ;;
    esac
done

echo "Creating $HOME/pkg/ folder"
mkdir $HOME/pkg/
cd $HOME/pkg/

if [ "$UPDATE" = false ]; then
    echo "Installing Essentials"
    sudo apt update && sudo apt upgrade -y
    sudo apt install build-essential cmake stow ninja-build gettext unzip curl python3-dev python-is-python3 imagemagick python3-venv python3-pip luarocks -y
    # sudo apt install texlive-full -y
fi

echo "Installing Neovim"
git clone https://github.com/neovim/neovim 
cd neovim 
make CMAKE_BUILD_TYPE=Release 
sudo make install
cd ..

if [ "$UPDATE" = false ]; then
    sudo apt-add-repository ppa:fish-shell/release-3
fi
sudo apt update
sudo apt install -y fish

if [ "$UPDATE" = false ]; then
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
    cargo install bat starship ripgrep cargo-update
    cargo install --git https://github.com/eza-community/eza
    cargo install --git https://github.com/sxyazi/yazi yazi-fm yazi-cli
    cargo install --locked tree-sitter-cli
    # cargo install --locked zellij
    curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
    mkdir -p $HOME/.local/bin/
    cp bin/micromamba $HOME/.local/bin/micromamba
    $HOME/.local/bin/micromamba shell init -s fish -r ~/.mamba

    echo "Install NPM"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install nodejs -y
    echo "prefix=\"$HOME/.npm\"" > $HOME/.npmrc
    echo "Install Prompt"
    curl -s https://ohmyposh.dev/install.sh | bash -s
fi

if [ "$UPDATE" = true ]; then
    cargo install-update -a
fi

cd ..
rm -rf $HOME/pkg/
