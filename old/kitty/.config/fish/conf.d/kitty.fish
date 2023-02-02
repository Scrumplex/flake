# Kitty already does reflow, BUT! this causes the cursor to jump a column.
# That is more annoying than the duplicate prompts that fish would draw.
# That's why this is forced to 1 here as otherwise fish would default to 0 with kitty.
set -g fish_handle_reflow 1

# Enable shell integration
if set -q KITTY_INSTALLATION_DIR
    set --global KITTY_SHELL_INTEGRATION no-cursor
    source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
    set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
end
