# bobthefisher Theme settings
set -g theme_color_scheme "nord"
set -g theme_nerd_fonts "yes"


# Don't truncate $PWD
set -g fish_prompt_pwd_dir_length 0


# Custom $PATH
set -g fish_user_paths "$HOME/bin" "$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin"

# GPG Key for package and repo- signing
set -gx GPGKEY "C10411294912A422"

