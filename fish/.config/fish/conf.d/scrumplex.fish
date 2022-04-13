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
set -gx FZF_DEFAULT_OPTS "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
