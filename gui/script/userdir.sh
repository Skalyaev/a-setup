#!/bin/bash
set -e
set -u

cat <<EOF | tee "$HOME/.config/user-dirs.dirs" &>/dev/null
XDG_DOWNLOAD_DIR="\$HOME/download"
XDG_DOCUMENTS_DIR="\$HOME/document"
XDG_PUBLICSHARE_DIR="\$HOME/document"
XDG_DESKTOP_DIR="\$HOME/document"
XDG_TEMPLATES_DIR="\$HOME/document/template"
XDG_PICTURES_DIR="\$HOME/document/media/image"
XDG_MUSIC_DIR="\$HOME/document/media/music"
XDG_VIDEOS_DIR="\$HOME/document/media/video"
EOF
