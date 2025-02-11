#!/bin/bash
set -e
set -u

DCONF="$1/00-settings-daemon"

cat <<EOF | sudo tee "$DCONF" &>"/dev/null"
[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true
night-light-schedule-automatic=false
night-light-temperature=uint32 4200
night-light-schedule-from=0.0
night-light-schedule-to=24.0
EOF
