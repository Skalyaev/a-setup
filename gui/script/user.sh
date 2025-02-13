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
    "$HOME/document/media/video"

cat <<EOF | sudo tee "$HOME/.config/user-dirs.dirs" &>/dev/null
XDG_DOWNLOAD_DIR="\$HOME/download"
XDG_DOCUMENTS_DIR="\$HOME/document"
XDG_PUBLICSHARE_DIR="\$HOME/document"
XDG_DESKTOP_DIR="\$HOME/document"
XDG_TEMPLATES_DIR="\$HOME/document/template"
XDG_PICTURES_DIR="\$HOME/document/media/image"
XDG_MUSIC_DIR="\$HOME/document/media/music"
XDG_VIDEOS_DIR="\$HOME/document/media/video"
EOF
