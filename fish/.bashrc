#
# ~/.bashrc
#

# avoid starting fish if the dumb user wants a bash session inside a fish session
if [ "$(ps -p $PPID -o comm=)" != "fish" ]; then
    exec fish
fi

