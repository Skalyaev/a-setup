#!/bin/bash
set -e
set -u

PREFIX="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
SPATH="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
SPATH="$SPATH:$PREFIX"
declare -A KEYBINDINGS=(

["custom0"]="Settings,<Super>s,gnome-control-center"
["custom1"]="Tweaks,<Super>t,gnome-tweaks"
["custom2"]="Dconf,<Super>d,dconf-editor"
["custom3"]="Extension,<Super>e,extension-manager %U"
)
for KEY in "${!KEYBINDINGS[@]}"; do

    IFS=, read -r NAME BIND CMD <<<"${KEYBINDINGS[$KEY]}"

    gsettings set "$SPATH/$KEY/" "name" "$NAME"
    gsettings set "$SPATH/$KEY/" "command" "$CMD"
    gsettings set "$SPATH/$KEY/" "binding" "$BIND"
done
