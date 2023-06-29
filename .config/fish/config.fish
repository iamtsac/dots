function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

# Exports
switch (uname)
    case Linux
        set PATH /usr/local/bin $PATH
        set CPPFLAGS -I/usr/include/:-I/usr/local/include $CPPFLAGS
        set CPPFLAGS -I/opt/NOSALRO/include/:-I/opt/include/ $CPPFLAGS
        set LDFLAGS -L/usr/lib/:-L/usr/local/lib/:-L/opt/lib/ $LDFLAGS
        set LD_LIBRARY_PATH /usr/lib/:/usr/local/lib/:/opt/lib/ $LD_LIBRARY_PATH
    case Darwin
        set PATH /opt/homebrew/bin $PATH
        set CPPFLAGS -I/opt/homebrew/include $CPPFLAGS
        set LDFLAGS -L/opt/homebrew/lib $LDFLAGS
end
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.local/bin $PATH
export PATH
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
export NNN_TMPFILE=~/.config/nnn/.lastd
export NNN_SSHFS='sshfs -o reconnect,idmap=user,cache_timeout=3600'

# Aliases
alias fzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias ls="exa --icons -l"

# Funcs

function gdiff
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/tsak/.conda/bin/conda
    eval /home/tsak/.conda/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

starship init fish | source

