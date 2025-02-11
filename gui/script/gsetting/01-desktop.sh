#!/bin/bash
set -e
set -u

DCONF="$1/01-desktop"

FONT_DISPLAY="Red Hat Display 11"
FONT_TEXT="Red Hat Text 11"
FONT_MONO="Red Hat Mono 11"

BACKGROUND="$HOME/document/media/image/background.jpeg"

cat <<EOF | sudo tee "$DCONF" &>"/dev/null"
[org/gnome/desktop/interface]
color-scheme='prefer-dark'
accent-color='slate'
font-name='$FONT_DISPLAY'
document-font-name='$FONT_TEXT'
monospace-font-name='$FONT_MONO'
enable-hot-corners=false

[org/gnome/desktop/background]
picture-uri='file://$BACKGROUND'
picture-uri-dark='file://$BACKGROUND'
primary-color='#000000'
secondary-color='#000000'

[org/gnome/desktop/screensaver]
picture-uri='file://$BACKGROUND'
primary-color='#000000'
secondary-color='#000000'

[org/gnome/desktop/wm/preferences]
button-layout='appmenu:minimize,maximize,close'
action-double-click-titlebar='minimize'
action-middle-click-titlebar='lower'
EOF
