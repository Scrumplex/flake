# bobthefisher Theme settings
set -g theme_color_scheme "catppuccin"
set -g theme_nerd_fonts "yes"
set -g theme_title_display_process "yes"

# Custom $PATH
fish_add_path -g "/usr/lib/ccache/bin"
fish_add_path -g "/usr/bin/site_perl"
fish_add_path -g "/usr/bin/vendor_perl"
fish_add_path -g "/usr/bin/core_perl"

# for real, why is this the default?
set -gx ANSIBLE_NOCOWS 1

