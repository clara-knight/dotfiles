#!/bin/sh

export PATH="$HOME/.local/bin:$PATH"

# Load dwm colors into the X server (stowed from dwm/.Xresources), then
# restore Pywal colors for terminal/nvim/dmenu sequences
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources" 2>/dev/null
[ -f "$HOME/.Xdefaults" ] && xrdb -merge "$HOME/.Xdefaults" 2>/dev/null
command -v wal >/dev/null 2>&1 && wal -R 2>/dev/null

# Select Window Manager: accepts argument (e.g. startx ~/.xinitrc xmonad) or WM env var
WM="${1:-${WM:-dwm}}"

case "$WM" in
    xmonad)
        exec xmonad
        ;;
    dwm|*)
        slstatus &
        exec dwm
        ;;
esac
