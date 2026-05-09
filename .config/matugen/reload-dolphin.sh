#!/bin/bash
#sleep 2
# Find the dolphin dbus service name (handles PID changes)
DOLPHIN_SERVICE=$(qdbus6 | grep -o 'org.kde.dolphin-[0-9]*' | head -1)

if [ -n "$DOLPHIN_SERVICE" ]; then
    # Get current open directories before killing
    CURRENT_URL=$(qdbus6 "$DOLPHIN_SERVICE" /dolphin/Dolphin_1 \
        org.qtproject.Qt.QWidget.windowTitle 2>/dev/null)
    
    # Quit dolphin gracefully via dbus
    qdbus6 "$DOLPHIN_SERVICE" /dolphin/Dolphin_1 \
        org.kde.dolphin.MainWindow.quit
    
    # Wait for it to die
    #sleep 0.5
    
    # Reopen it (it will pick up new colors)
    dolphin &
fi


reload_nvim() {
    echo "$(date): looking for sockets" >> /tmp/matugen-hook.log
    ls /run/user/$(id -u)/nvim.*.sock >> /tmp/matugen-hook.log 2>&1
    for socket in /run/user/$(id -u)/nvim.*.sock; do
        if [ -S "$socket" ]; then
            echo "$(date): reloading $socket" >> /tmp/matugen-hook.log
            timeout 2 nvim --server "$socket" \
                --remote-send '<Esc>:lua reload_matugen()<CR>' \
                >/dev/null 2>&1 || rm "$socket"
        fi
    done
}

# First attempt - matugen may not have written nvim-colors.lua yet
reload_nvim

# Retry after 5s in the background so this script exits immediately,
# avoiding blocking other matugen post_hooks (waybar, hyprland, etc.)
(sleep 0.5 && reload_nvim) &
