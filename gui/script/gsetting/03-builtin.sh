#!/bin/bash
set -e
set -u

DCONF="$1/03-builtin"

cat <<EOF | sudo tee "$DCONF" &>"/dev/null"
[org/gnome/mutter]
edge-tiling=false
auto-maximize=false

[org/gnome/mutter/keybindings]
toggle-tiled-left=@as []
toggle-tiled-right=@as []

[org/gnome/mutter/wayland/keybindings]
restore-shortcuts=@as []
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/nautilus/preferences]
default-folder-viewer='list-view'
default-sort-order='type'
show-delete-permanently=true
show-create-link=true
show-hidden-files=true

[org/gnome/nautilus/list-view]
default-zoom-level='small'
default-visible-columns=['name', 'size', 'type', 'date_modified']
use-tree-view=true
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gtk/gtk4/Settings/FileChooser]
show-hidden=true
EOF
