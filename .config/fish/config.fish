if status is-interactive
  starship init fish | source
  set -gx EDITOR nvim 
  set -g fish_greeting
  alias !!="$history[1]"
    # Commands to run in interactive sessions can go here
end
