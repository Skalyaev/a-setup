#!/bin/bash
set -e
set -u

DCONF="$1/00-settings-daemon"

PREFIX="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
KEYBINDINGS=("custom0" "custom1" "custom2" "custom3")
KEYBINDINGS="$(printf "'$PREFIX/%s/', " "${KEYBINDINGS[@]}" | sed 's/, $//')"

cat <<EOF | sudo tee "$DCONF" &>"/dev/null"
[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true
night-light-schedule-automatic=false
night-light-schedule-from=0.0
night-light-schedule-to=24.0
night-light-temperature=uint32 4200
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/settings-daemon/plugins/power]
power-button-action='interactive'
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/settings-daemon/plugins/media-keys]
custom-keybindings=[$KEYBINDINGS]
help=@as []
increase-text-size=@as []
logout=@as []
magnifier=@as []
magnifier-zoom-in=@as []
magnifier-zoom-out=@as []
screenreader=@as []

[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0]
name='Settings'
binding='<Super>s'
command='gnome-control-center'

[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1]
name='Tweaks'
binding='<Super>t'
command='gnome-tweaks'

[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2]
name='Dconf'
binding='<Super>d'
command='dconf-editor'

[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3]
name='Extension'
binding='<Super>e'
command='extension-manager %U'
EOF
