# bobthefisher Theme settings
set -g theme_color_scheme "nord"
set -g theme_nerd_fonts "yes"
set -g theme_title_display_process "yes"

# Custom $PATH
fish_add_path -g "/usr/lib/ccache/bin"
fish_add_path -g "$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin"
fish_add_path -g "$HOME/bin"

# for real, why is this the default?
set -gx ANSIBLE_NOCOWS 1

