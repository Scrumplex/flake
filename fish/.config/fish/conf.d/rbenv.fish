# Load rbenv automatically by appending
# the following to ~/.config/fish/config.fish:



status --is-interactive; and command -q rbenv; and source (rbenv init -|psub)
