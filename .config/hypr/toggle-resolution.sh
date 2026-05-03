#!/bin/bash

STATEFILE="$HOME/.config/hypr/monitor-state"
HYPRCONF="$HOME/.config/hypr/hyprland.conf"
CURRENT=$(hyprctl monitors -j | jq '.[0].width')

if [ "$CURRENT" = "3440" ]; then
    RES="2560x1440@144"
else
    RES="3440x1440@144"
fi

echo "$RES" > "$STATEFILE"
sed -i "s/^monitor=.*/monitor=,${RES},auto,1/" "$HYPRCONF"
hyprctl keyword monitor ,"$RES",auto,1
