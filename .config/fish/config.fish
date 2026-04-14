# ~ / .config/fish/config.fish

# Environment Variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx COLORTERM truecolor
set -gx fish_term24bit 1
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Path and Library Management
# fish_add_path automatically handles deduplication and existence checks
fish_add_path $HOME/.cargo/bin \
              $HOME/.npm/bin \
              $HOME/.pixi/bin \
              $HOME/.local/bin \
              $HOME/.conda/bin \
              /opt/bin

switch (uname)
    case Linux
        fish_add_path /usr/local/bin /opt/cuda/bin
        set -gx CPPFLAGS -I/usr/local/include -I/opt/include $CPPFLAGS
        set -gx LDFLAGS -L/usr/local/lib -L/opt/lib $LDFLAGS
        set -gx LD_LIBRARY_PATH /usr/local/lib /opt/lib /opt/cuda/lib64 $LD_LIBRARY_PATH
        set -gx CUDA_HOME /opt/cuda
    case Darwin
        fish_add_path /opt/homebrew/bin
        set -gx CPPFLAGS -I/opt/homebrew/include $CPPFLAGS
        set -gx LDFLAGS -L/opt/homebrew/lib $LDFLAGS
end

# Interactive Settings
if status is-interactive
    # Key Bindings
    # fish_vi_key_bindings sets the global mode; use a function for custom keys
    set -g fish_key_bindings fish_vi_key_bindings

    function fish_user_key_bindings
        bind -M insert \cp up-or-search
        bind -M insert \cn down-or-search
    end

    # Plugin Initialization
    skim_key_bindings
    oh-my-posh init fish --config "$HOME/.config/oh-my-posh.omp.toml" | source

    # Greeting
    set -g fish_greeting ""

    # Aliases
    alias bat="bat --theme='base16'"
    alias ls="eza --icons -l --group-directories-first"

    # Skim Settings
    set -gx SKIM_DEFAULT_OPTIONS "--height 40% --layout=reverse"
    set -gx SKIM_CTRL_T_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx SKIM_CTRL_T_OPTS "--preview 'bat --color=always --line-range :500 {}'"

    bind -M insert \ce forward-char
    bind -M insert \cx edit_command_buffer
    bind -M default \cx edit_command_buffer
end

function fish_mode_prompt
    # Leave empty to remove [n], [i], [v] indicators
end

function skrg
    sk --ansi -i -c 'rg --color=always --line-number {q}'

end

function gdiff
    git diff --name-only --relative --diff-filter=d | xargs -r bat --diff --theme='base16'
end
complete -c gdiff -w 'git diff'

for file in $HOME/.config/fish/conf.d/{local_conf,theme}.fish
    if test -f $file
        source $file
    end
end

oh-my-posh init fish --config "$HOME/.config/oh-my-posh.omp.toml" | source
