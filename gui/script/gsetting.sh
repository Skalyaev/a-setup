#!/bin/bash
set -e
set -u

DCONF="/etc/dconf/db/local.d"
mkdir -p "$DCONF"

sudo cat <<EOF >"$DCONF/00-settings-daemon"
[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true
night-light-schedule-automatic=false
night-light-temperature=4200
night-light-schedule-from=0.0
night-light-schedule-to=24.0
EOF

BACKGROUND="$HOME/document/media/image/background.jpeg"

FONT_REGULAR="Terminess Nerd Font Medium 12"
FONT_MONO="Terminess Nerd Font Mono Medium 12"

sudo cat <<EOF >"$DCONF/01-desktop"
[org/gnome/desktop/input-sources]
sources=[('xkb', 'fr')]
mru-sources=[('xkb', 'fr')]

[org/gnome/desktop/interface]
color-scheme='prefer-dark'
accent-color='slate'
font-name='$FONT_REGULAR'
monospace-font-name='$FONT_MONO'

[org/gnome/desktop/background]
picture-uri='file://$BACKGROUND'
picture-uri-dark='file://$BACKGROUND'
primary-color='#000000'
secondary-color='#000000'

[org/gnome/desktop/screensaver]
picture-uri='file://$BACKGROUND'
primary-color='#000000'
secondary-color='#000000'
EOF

sudo dconf update
