set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx COLORTERM truecolor
set -gx fish_term24bit 1
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p --theme base16-256'"

fish_add_path $HOME/.cargo/bin \
    $HOME/.npm/bin \
    $HOME/.pixi/bin \
    $HOME/.local/bin \
    $HOME/.conda/bin \
    $HOME/.zvm/bin \
    $ZVM_INSTALL \
    /opt/bin

switch (uname)
    case Linux
        fish_add_path /usr/local/bin /opt/cuda/bin
        set -gx CUDA_HOME /opt/cuda
        set -gx ZVM_INSTALL $HOME/.zvm/self
        set -l cuda_libs /usr/local/lib /opt/lib /opt/cuda/lib64
        for lib in $cuda_libs
            if test -d $lib; and not contains $lib $LD_LIBRARY_PATH
                set -gx LD_LIBRARY_PATH $lib $LD_LIBRARY_PATH
            end
        end

    case Darwin
        fish_add_path /opt/homebrew/bin
        set -gx CPPFLAGS -I/opt/homebrew/include $CPPFLAGS
        set -gx LDFLAGS -L/opt/homebrew/lib $LDFLAGS
end

function force_split_command
    set -l cmd (commandline)
    set -l out ""
    set -l first 1

    for token in (string split ' ' -- $cmd)
        if test $first -eq 1
            set out "$token"
            set first 0
        else if string match -rq '^--|^[a-zA-Z0-9_-]+:' -- $token
            set out "$out \\ \n  $token"
        else
            set out "$out $token"
        end
    end
    commandline -r $out
end

if type -q zmx
    zmx completions fish | source
end

if type -q pixi
    pixi completion --shell fish | source
end

if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings
    set -g fish_greeting ""

    function sk_history_wrapped
        echo ""
        skim-history-widget
        commandline -f repaint
    end

    function sk_file_wrapped
        echo ""
        skim-file-widget
        commandline -f repaint
    end

    function fish_user_key_bindings
        if functions -q skim_key_bindings
            skim_key_bindings
        end

        # Navigation (Insert & Normal)
        bind -M insert \cp up-or-search
        bind -M default \cp up-or-search
        bind -M insert \cn down-or-search
        bind -M default \cn down-or-search

        # Utilities
        bind -M insert \c] force_split_command
        bind -M default \c] force_split_command
        bind -M insert \ce forward-char
        bind -M insert \cx edit_command_buffer
        bind -M default \cx edit_command_buffer

        # Skim Wrapped Overrides (Ctrl-R and Ctrl-T)
        bind \cr sk_history_wrapped
        bind -M insert \cr sk_history_wrapped
        bind \ct sk_file_wrapped
        bind -M insert \ct sk_file_wrapped
    end

    set -gx SKIM_DEFAULT_OPTIONS "--layout reverse --height 40% --color=16 --inline-info --margin 1,0,0,0"
    set -gx SKIM_CTRL_T_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx SKIM_CTRL_T_OPTS "--preview \"bat --color=always --theme='base16-256' --line-range :500 {}\""

    alias bat="bat --theme='base16-256'"
    alias ls="eza --icons -l --group-directories-first"
end

function fish_mode_prompt
    # Empty to hide [n] [i] indicators (Clean look)
end

function skrg
    sk --ansi -i -c 'rg --color=always --line-number {q}'
end

function gdiff
    git diff --name-only --relative --diff-filter=d | xargs -r bat --diff --theme='base16-256'
end
complete -c gdiff -w 'git diff'

for file in $HOME/.config/fish/conf.d/{local_conf,theme}.fish
    if test -f $file
        source $file
    end
end

if type -q direnv
    direnv hook fish | source
end

if type -q direnv
    zoxide init fish | source
end

oh-my-posh init fish --config "$HOME/.config/oh-my-posh.omp.toml" | source
