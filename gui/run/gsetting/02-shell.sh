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
    "blur-my-shell@aunetx"
)
EXTENSIONS="$(printf "'%s'," "${EXTENSIONS[@]}" | sed 's/,$//')"

FAVORITE_APPS=(

    "Alacritty.desktop"
    "firefox.desktop"
    "org.gnome.Nautilus.desktop"
)
FAVORITE_APPS="$(printf "'%s'," "${FAVORITE_APPS[@]}" | sed 's/,$//')"

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
panel-element-positions='{"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}'
secondarymenu-contains-showdetails=true
trans-bg-color='#121212'
trans-use-custom-bg=true
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/extensions/arcmenu]
alphabetize-all-programs=false
apps-show-extra-details=true
button-item-icon-size='ExtraSmall'
context-menu-items=[{'id': 'ArcMenu_Settings', 'name': 'ArcMenu Settings', 'icon': 'ArcMenu_ArcMenuIcon'}, {'id': 'ArcMenu_PanelExtensionSettings', 'name': 'Panel Extension Settings', 'icon': 'application-x-addon-symbolic'}, {'id': 'com.mattjakeman.ExtensionManager.desktop'}, {'name': 'Séparateur', 'icon': 'list-remove-symbolic', 'id': 'ArcMenu_Separator'}, {'id': 'gnome-wifi-panel.desktop'}, {'id': 'gnome-bluetooth-panel.desktop'}, {'id': 'org.gnome.Settings.desktop'}, {'id': 'ArcMenu_Separator', 'name': 'Separator', 'icon': 'list-remove-symbolic'}, {'id': 'ArcMenu_PowerOptions', 'name': 'Power Options', 'icon': 'system-shutdown-symbolic'}]
custom-menu-button-icon='playonlinux'
custom-menu-button-icon-size=26.0
disable-recently-installed-apps=true
extra-categories=[(1, true), (4, true), (2, true), (0, false), (3, false)]
highlight-search-result-terms=true
left-panel-width=220
menu-arrow-rise=(true, 0)
menu-border-radius=0
menu-border-width=3
menu-button-border-radius=(true, 0)
menu-button-border-width=(true, 1)
menu-button-icon='Custom_Icon'
menu-height=600
menu-item-active-bg-color='rgb(66,66,66)'
menu-item-category-icon-size='Small'
menu-item-hover-bg-color='rgb(66,66,66)'
menu-item-icon-size='Extralarge'
menu-layout='Whisker'
multi-monitor=true
override-menu-theme=true
pinned-apps=@aa{ss} []
quicklinks-item-icon-size='Small'
right-panel-width=480
search-provider-recent-files=true
searchbar-default-top-location='Bottom'
show-category-sub-menus=true
show-hidden-recent-files=true
show-search-result-details=true
vert-separator=true
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

[org/gnome/shell/extensions/space-bar/appearance]
active-workspace-border-radius=0
active-workspace-padding-h=7
active-workspace-padding-v=14
application-styles='.space-bar {\n  -natural-hpadding: 12px;\n}\n\n.space-bar-workspace-label.active {\n  margin: 0 4px;\n  background-color: rgba(255,255,255,0.3);\n  color: rgba(255,255,255,1);\n  border-color: rgba(0,0,0,0);\n  font-weight: 700;\n  border-radius: 0px;\n  border-width: 0px;\n  padding: 13px 7px;\n}\n\n.space-bar-workspace-label.inactive {\n  margin: 0 4px;\n  background-color: rgba(0,0,0,0);\n  color: rgb(154,153,150);\n  border-color: rgba(0,0,0,0);\n  font-weight: 700;\n  border-radius: 0px;\n  border-width: 0px;\n  padding: 13px 7px;\n}\n\n.space-bar-workspace-label.inactive.empty {\n  margin: 0 4px;\n  background-color: rgba(0,0,0,0);\n  color: rgba(255,255,255,0.5);\n  border-color: rgba(0,0,0,0);\n  font-weight: 700;\n  border-radius: 0px;\n  border-width: 0px;\n  padding: 13px 7px;\n}'
empty-workspace-border-radius=0
empty-workspace-padding-h=7
empty-workspace-padding-v=14
inactive-workspace-border-radius=0
inactive-workspace-padding-h=7
inactive-workspace-padding-v=14
inactive-workspace-text-color='rgb(154,153,150)'
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/extensions/blur-my-shell]
pipelines={'pipeline_default': {'name': <'Default'>, 'effects': <[<{'type': <'native_static_gaussian_blur'>, 'id': <'effect_000000000000'>, 'params': <{'radius': <30>, 'brightness': <0.59999999999999998>, 'unscaled_radius': <10>}>}>]>}, 'pipeline_default_rounded': {'name': <'Default rounded'>, 'effects': <[<{'type': <'native_static_gaussian_blur'>, 'id': <'effect_000000000001'>, 'params': <{'radius': <30>, 'brightness': <0.59999999999999998>, 'unscaled_radius': <10>}>}>, <{'type': <'corner'>, 'id': <'effect_000000000002'>, 'params': <{'radius': <24>}>}>]>}}
EOF
