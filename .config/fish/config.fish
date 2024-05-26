function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

# Exports
switch (uname)
    case Linux
        set PATH /usr/local/bin $PATH
        set CPPFLAGS -I/usr/include/ $CPPFLAGS
        set CPPFLAGS -I/usr/local/include $CPPFLAGS
        set CPPFLAGS -I/opt/include/ $CPPFLAGS
        set LDFLAGS -L/usr/lib/ $LDFLAGS
        set LDFLAGS -L/usr/local/lib/ $LDFLAGS
        set LDFLAGS -L/opt/lib/ $LDFLAGS
        set LD_LIBRARY_PATH /usr/lib/ $LD_LIBRARY_PATH
        set LD_LIBRARY_PATH /usr/local/lib/ $LD_LIBRARY_PATH
        set LD_LIBRARY_PATH /opt/lib/ $LD_LIBRARY_PATH
        set PATH /opt/cuda/bin $PATH
        set LD_LIBRARY_PATH /opt/cuda/lib64 $LD_LIBRARY_PATH
        set CUDA_HOME /opt/cuda
    case Darwin
        set PATH /opt/homebrew/bin $PATH
        set CPPFLAGS -I/opt/homebrew/include $CPPFLAGS
        set LDFLAGS -L/opt/homebrew/lib $LDFLAGS
end
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.local/bin $PATH
export PATH
export PYTHONPATH
export LDFLAGS
export CPPFLAGS
export LD_LIBRARY_PATH
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Settings
set -U fish_greeting
set -g COLORTERM truecolor
set -g fish_term24bit 1
set EDITOR nvim
set VISUAL nvim

# Aliases
alias fzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias ls="eza --icons -l"

# Funcs

function gdiff
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end

source $HOME/.config/fish/conf.d/local_conf.fish

starship init fish | source
