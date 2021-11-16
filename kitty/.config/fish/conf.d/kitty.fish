# Kitty already does reflow, BUT! this causes the cursor to jump a column.
# That is more annoying than the duplicate prompts that fish would draw.
# That's why this is forced to 1 here as otherwise fish would default to 0 with kitty.
set -g fish_handle_reflow 1
