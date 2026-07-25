set -g fish_greeting

source ~/.config/fish/hyde_config.fish

if status is-interactive
    starship init fish | source

    # fzf key bindings: Ctrl+T insert file path, Ctrl+R fuzzy history,
    # Alt+C cd into a subdirectory.
    fzf --fish | source

    # zoxide: `z <partial>` jumps to a frecently-used dir, `zi` picks
    # interactively via fzf. Guarded so this file still works on a machine
    # where zoxide isn't installed yet.
    if command -q zoxide
        zoxide init fish | source
    end
end

# Back fzf with fd so it respects .gitignore and skips .git — much faster than
# the default `find` walk in large repos. Guarded like the above.
if command -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
end

# List Directory
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias vc='code'

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

# ssh-agent: the systemd user unit provides the socket but nothing exports it,
# so ssh-add lands on "Could not open a connection to your authentication agent".
if test -S $XDG_RUNTIME_DIR/ssh-agent.socket
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
end
