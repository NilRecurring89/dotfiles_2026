#!/bin/bash
# Restore last wallpaper via waypaper
waypaper --restore

# Get the wallpaper path from waypaper's config, expanding ~ to full path
WALLPAPER=$(grep -m1 '^wallpaper' ~/.config/waypaper/config.ini | cut -d'=' -f2 | xargs | sed "s|~|$HOME|")

# Run matugen on it
matugen image "$WALLPAPER" --type scheme-fruit-salad --prefer=darkness

# Signal apps to reload
pkill -USR1 kitty
hyprctl reload
