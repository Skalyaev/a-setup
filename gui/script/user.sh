#!/bin/bash
set -e
set -u

cat <<EOF | sudo tee "/etc/xdg/user-dirs.defaults" &>/dev/null
DOWNLOAD=download
DOCUMENTS=document
PUBLICSHARE=document
DESKTOP=document
TEMPLATES=document/template
MUSIC=document/media/music
PICTURES=document/media/image
VIDEOS=document/media/video
EOF

DST="/var/lib/AccountsService"
sudo cp "$HOME/document/media/image/redteam.png" "$DST/icons/$USER"
cat <<EOF | sudo tee "$DST/users/$USER" &>/dev/null
[User]
Languages=fr_FR.UTF-8;
Session=
Icon=/var/lib/AccountsService/icons/skalya
SystemAccount=false
EOF

cat <<EOF | tee "$HOME/.config/gtk-3.0/bookmarks" &>/dev/null
file://$HOME/download download
file://$HOME/document/github github
file://$HOME/.config .config
file://$HOME/.local .local
file:///etc etc
file:///usr usr
file:///var var
EOF
