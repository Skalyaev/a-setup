#!/bin/bash
set -e
set -u

DCONF="$1/02-shell"
EXTENSIONS=(

    "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
    "system-monitor@gnome-shell-extensions.gcampax.github.com"
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "dash-to-panel@jderose9.github.com"
    "appindicatorsupport@rgcjonas.gmail.com"
    "arcmenu@arcmenu.com"
    "no-overview@fthx"
)
EXTENSIONS="$(printf "'%s'," "${EXTENSIONS[@]}" | sed 's/,$//')"

cat <<EOF | sudo tee "$DCONF" &>"/dev/null"
[org/gnome/shell]
enabled-extensions=[$EXTENSIONS]
EOF

cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/extensions/dash-to-panel]
panel-sizes='{"0":42}'
taskbar-locked=true
appicon-margin=0
appicon-padding=9
dot-color-dominant=true
dot-highlight-dominant=true
dot-size=2
group-apps=false
group-apps-label-font-size=13
group-apps-use-launchers=true
isolate-workspaces=true
secondarymenu-contains-showdetails=true
panel-element-positions='{"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"centered"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}'
EOF
