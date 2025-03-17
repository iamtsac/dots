function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

# if not set -q MONITOR_KITTY_CONFIG
#     set -U MONITOR_KITTY_CONFIG 1
#     while inotifywait -e close_write $HOME/.config/kitty/configure.lua
#         lua $HOME/.config/kitty/configure.lua
#     end > /dev/null 2>&1 &; disown
# end

# Exports
switch (uname)
    case Linux
        set CPPFLAGS -I/usr/include/ $CPPFLAGS
        set LDFLAGS -L/usr/lib/ $LDFLAGS
        set LD_LIBRARY_PATH /usr/lib/ $LD_LIBRARY_PATH

        set PATH /usr/local/bin $PATH
        set CPPFLAGS -I/usr/local/include $CPPFLAGS
        set LDFLAGS -L/usr/local/lib/ $LDFLAGS
        set LD_LIBRARY_PATH /usr/local/lib/ $LD_LIBRARY_PATH

        set CPPFLAGS -I/opt/include/ $CPPFLAGS
        set LDFLAGS -L/opt/lib/ $LDFLAGS
        set LD_LIBRARY_PATH /opt/lib/ $LD_LIBRARY_PATH

        set PATH /opt/cuda/bin $PATH
        set LD_LIBRARY_PATH /opt/cuda/lib64 $LD_LIBRARY_PATH
        set CUDA_HOME /opt/cuda
        export CUDA_HOME
    case Darwin
        set PATH /opt/homebrew/bin $PATH
        set CPPFLAGS -I/opt/homebrew/include $CPPFLAGS
        set LDFLAGS -L/opt/homebrew/lib $LDFLAGS
end
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.npm/bin $PATH
set PATH $HOME/.pixi/bin $PATH
set PATH $HOME/.local/bin $PATH
set PATH /opt/bin/ $PATH
set PATH $HOME/.conda/bin $PATH
export PATH
export PYTHONPATH
export LDFLAGS
export CPPFLAGS
export LD_LIBRARY_PATH
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Settings
set -U fish_greeting
set -g COLORTERM truecolor
set -g fish_term24bit 1
export EDITOR=nvim
export VISUAL=nvim

# Aliases
alias fzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias ls="eza --icons -l --group-directories-first"

# Funcs

function gdiff
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end

if test -e $HOME/.config/fish/conf.d/local_conf.fish
    source $HOME/.config/fish/conf.d/local_conf.fish
end

if not test -n $SSH_CLIENT
    lua $HOME/.config/kitty/configure.lua
end
starship init fish | source
