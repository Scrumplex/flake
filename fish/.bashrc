#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# avoid starting fish if the dumb user wants a bash session inside a fish session
if [ "$(ps -p $PPID -o comm=)" != "fish" ]; then
    exec fish
fi

