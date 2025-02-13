#!/bin/bash
set -e
set -u

DCONF="$1/02-shell"
EXTENSIONS=(
    "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
    "system-monitor@gnome-shell-extensions.gcampax.github.com"
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "dash-to-panel@jderose9.github.com"
    "arcmenu@arcmenu.com"
    "appindicatorsupport@rgcjonas.gmail.com"
    "no-overview@fthx"
    "forge@jmmaranan.com"
    "space-bar@luchrioh"
)
EXTENSIONS="$(printf "'%s'," "${EXTENSIONS[@]}" | sed 's/,$//')"

FAVORITE_APPS=(
    "org.gnome.Nautilus.desktop"
    "Alacritty.desktop"
    "firefox.desktop"
)
FAVORITE_APPS="$(printf "'%s'," "${FAVORITE_APPS[@]}" | sed 's/,$//')"

declare -A PANEL=(
["showAppsButton"]="false,stackedTL"
["activitiesButton"]="false,stackedTL"
["leftBox"]="true,stackedTL"
["taskbar"]="true,stackedTL"
["centerBox"]="true,stackedBR"
["rightBox"]="true,stackedBR"
["dateMenu"]="true,stackedBR"
["systemMenu"]="false,stackedBR"
["desktopButton"]="false,stackedBR"
)
PANEL_ORDER=(
    "showAppsButton" "activitiesButton" "leftBox" "taskbar"
    "centerBox" "rightBox" "dateMenu" "systemMenu" "desktopButton"
)
ITEMS=()
for KEY in "${PANEL_ORDER[@]}"; do

    IFS="," read -r VISIBLE POSITION <<< "${PANEL[$KEY]}"
    ITEMS+=("{\"element\":\"$KEY\",\"visible\":$VISIBLE,\"position\":\"$POSITION\"}")
done
PANEL="{\"0\":[$(IFS=,; echo "${ITEMS[*]}")]}"

cat <<EOF | sudo tee "$DCONF" &>"/dev/null"
[org/gnome/shell]
enabled-extensions=[$EXTENSIONS]
favorite-apps=[$FAVORITE_APPS]
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/app-switcher]
current-workspace-only=true
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/keybindings]
focus-active-notification=@as []
open-new-window-application-1=@as []
open-new-window-application-2=@as []
open-new-window-application-3=@as []
open-new-window-application-4=@as []
open-new-window-application-5=@as []
open-new-window-application-6=@as []
open-new-window-application-7=@as []
open-new-window-application-8=@as []
open-new-window-application-9=@as []
screenshot=['<Control>End']
screenshot-window=@as []
show-screen-recording-ui=['<Shift><Control><Alt>End']
show-screenshot-ui=['<Shift><Control>End']
switch-to-application-1=@as []
switch-to-application-2=@as []
switch-to-application-3=@as []
switch-to-application-4=@as []
switch-to-application-5=@as []
switch-to-application-6=@as []
switch-to-application-7=@as []
switch-to-application-8=@as []
switch-to-application-9=@as []
toggle-application-view=@as []
toggle-message-tray=@as []
toggle-overview=['<Super>twosuperior']
toggle-quick-settings=@as []
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/extensions/dash-to-panel]
appicon-margin=0
appicon-padding=9
dot-color-dominant=true
dot-size=2
group-apps=false
group-apps-label-font-size=12
group-apps-use-launchers=true
hot-keys=true
isolate-monitors=true
isolate-workspaces=true
panel-element-positions='$PANEL'
panel-sizes='{"0":42}'
secondarymenu-contains-showdetails=true
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/extensions/arcmenu]
menu-layout='Whisker'
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/extensions/forge]
focus-border-toggle=false
split-border-toggle=false
window-gap-size=uint32 0

[org/gnome/shell/extensions/forge/keybindings]
con-split-horizontal=@as []
con-split-layout-toggle=@as []
con-split-vertical=@as []
con-stacked-layout-toggle=@as []
con-tabbed-layout-toggle=@as []
con-tabbed-showtab-decoration-toggle=@as []
focus-border-toggle=@as []
prefs-open=@as []
prefs-tiling-toggle=@as []
window-focus-down=['<Super>Down']
window-focus-left=['<Super>Left']
window-focus-right=['<Super>Right']
window-focus-up=['<Super>Up']
window-gap-size-decrease=@as []
window-gap-size-increase=@as []
window-move-down=['<Shift><Super>Down']
window-move-left=['<Shift><Super>Left']
window-move-right=['<Shift><Super>Right']
window-move-up=['<Shift><Super>Up']
window-resize-bottom-decrease=['<Control><Alt><Super>Down']
window-resize-bottom-increase=['<Control><Super>Down']
window-resize-left-decrease=['<Control><Alt><Super>Left']
window-resize-left-increase=['<Control><Super>Left']
window-resize-right-decrease=['<Control><Alt><Super>Right']
window-resize-right-increase=['<Control><Super>Right']
window-resize-top-decrease=['<Control><Alt><Super>Up']
window-resize-top-increase=['<Control><Super>Up']
window-snap-center=@as []
window-snap-one-third-left=@as []
window-snap-one-third-right=@as []
window-snap-two-third-left=@as []
window-snap-two-third-right=@as []
window-swap-down=@as []
window-swap-last-active=@as []
window-swap-left=@as []
window-swap-right=@as []
window-swap-up=@as []
window-toggle-always-float=@as []
window-toggle-float=['<Super>f']
workspace-active-tile-toggle=@as []
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/extensions/space-bar/behavior]
position='right'
position-index=0

[org/gnome/shell/extensions/space-bar/shortcuts]
enable-activate-workspace-shortcuts=false
EOF
