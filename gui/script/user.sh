#!/bin/bash
set -e
set -u

cat <<EOF | sudo tee "/etc/xdg/user-dirs.defaults" &>/dev/null
DOWNLOAD=download
DOCUMENTS=document
PUBLICSHARE=document
DESKTOP=document
TEMPLATES=document/template
PICTURES=document/media/image
MUSIC=document/media/music
VIDEOS=document/media/video
EOF

DST="/var/lib/AccountsService"
sudo cp "$HOME/document/media/image/redteam.png" "$DST/icons/$USER"
cat <<EOF | sudo tee "$DST/users/$USER" &>/dev/null
[User]
Languages=fr_FR.UTF-8;
Session=
Icon=/var/lib/AccountsService/icons/$USER
SystemAccount=false
EOF

DST="$HOME/.config/gtk-3.0"
mkdir -p "$DST"
cat <<EOF | tee "$DST/bookmarks" &>/dev/null
file://$HOME/download download
file://$HOME/document/github github
file://$HOME/.config .config
file://$HOME/.local .local
file:///etc etc
file:///usr usr
file:///var var
EOF

mkdir -p "$HOME/document/github" \
    "$HOME/document/template" \
    "$HOME/document/media/image" \
    "$HOME/document/media/music" \
    "$HOME/document/media/video" \
    "$HOME/download"
