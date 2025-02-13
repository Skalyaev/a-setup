#!/bin/bash
set -e
set -u

DCONF="/etc/dconf/db/local.d"
sudo mkdir -p "$DCONF"

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/00-settings-daemon.sh "$DCONF"
"$DIR"/01-desktop.sh "$DCONF"
"$DIR"/02-shell.sh "$DCONF"
"$DIR"/03-builtin.sh "$DCONF"

PROFILE="/etc/dconf/profile"
sudo mkdir -p "$PROFILE"

cat <<EOF | sudo tee "$PROFILE/user" &>/dev/null
user-db:user
system-db:local
EOF
sudo dconf update

STATE="$HOME/.local/state/gsettings"
mkdir -p "$(dirname "$STATE")"
gsettings list-recursively >"$STATE"
