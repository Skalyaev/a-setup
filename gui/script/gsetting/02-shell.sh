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
appicon-margin=0
appicon-padding=10
dot-color-dominant=true
dot-size=2
group-apps=false
group-apps-label-font-size=12
group-apps-use-launchers=true
isolate-workspaces=true
secondarymenu-contains-showdetails=true
panel-element-positions='{"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}'
EOF

cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/shell/extensions/arcmenu]
menu-layout='Whisker'
menu-border-radius=0
menu-border-width=3
menu-height=800
left-panel-width=240
right-panel-width=480
menu-arrow-rise=(true, 8)
override-menu-theme=true
menu-item-active-bg-color='rgb(66,66,66)'
menu-item-hover-bg-color='rgb(66,66,66)'
menu-item-category-icon-size='Small'
menu-item-icon-size='Large'
quicklinks-item-icon-size='Small'
button-item-icon-size='ExtraSmall'
category-icon-type='Symbolic'
shortcut-icon-type='Symbolic'
apps-show-extra-details=true
show-category-sub-menus=true
multi-monitor=true
active-on-hover=true
extra-categories=[(0, true), (4, true), (1, true), (2, true), (3, false)]
highlight-search-result-terms=true
power-display-style='Menu'
power-options=[(1, true), (0, true), (2, true), (3, true), (4, false), (5, false), (6, false), (7, false)]
search-provider-recent-files=true
searchbar-default-top-location='Bottom'
show-search-result-details=true
vert-separator=true
menu-button-icon='Custom_Icon'
custom-menu-button-icon='playonlinux'
custom-menu-button-icon-size=24.0
distro-icon=6
menu-button-border-radius=(true, 0)
menu-button-border-width=(true, 1)
context-menu-items=[{'id': 'com.mattjakeman.ExtensionManager.desktop'}, {'id': 'ArcMenu_Settings', 'name': 'ArcMenu Settings', 'icon': 'ArcMenu_ArcMenuIcon'}, {'id': 'ArcMenu_PanelExtensionSettings', 'name': 'Panel Extension Settings', 'icon': 'application-x-addon-symbolic'}, {'id': 'ArcMenu_Separator', 'name': 'Separator', 'icon': 'list-remove-symbolic'}, {'id': 'ArcMenu_PowerOptions', 'name': 'Power Options', 'icon': 'system-shutdown-symbolic'}, {'id': 'ArcMenu_ActivitiesOverview', 'name': 'Activities Overview', 'icon': 'view-fullscreen-symbolic'}]
EOF
