#!/bin/sh

export PATH="$HOME/.local/bin:$PATH"

# Restore Pywal colors to xrdb before starting WM
wal -R 2>/dev/null

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
