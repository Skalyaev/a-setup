#!/bin/bash
set -e
set -u

DCONF="$1/01-desktop"

FONT_DISPLAY="Red Hat Display 11"
FONT_TEXT="Red Hat Text 11"
FONT_MONO="Red Hat Mono 11"

ICONS="candy-icons"
BACKGROUND="$HOME/document/media/image/background.jpeg"

cat <<EOF | sudo tee "$DCONF" &>"/dev/null"
[org/gnome/desktop/interface]
accent-color='slate'
color-scheme='prefer-dark'
document-font-name='$FONT_TEXT'
enable-hot-corners=false
font-name='$FONT_DISPLAY'
monospace-font-name='$FONT_MONO'
icon-theme='$ICONS'
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/desktop/session]
idle-delay=uint32 900
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/desktop/peripherals/keyboard]
numlock-state=true
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/desktop/background]
picture-uri='file://$BACKGROUND'
picture-uri-dark='file://$BACKGROUND'
primary-color='#000000'
secondary-color='#000000'
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/desktop/screensaver]
picture-uri='file://$BACKGROUND'
primary-color='#000000'
secondary-color='#000000'
EOF
cat <<EOF | sudo tee -a "$DCONF" &>"/dev/null"

[org/gnome/desktop/wm/preferences]
action-double-click-titlebar='minimize'
action-middle-click-titlebar='lower'
button-layout='appmenu:minimize,maximize,close'

[org/gnome/desktop/wm/keybindings]
activate-window-menu=@as []
begin-move=@as []
begin-resize=@as []
close=['<Control>q']
cycle-group=@as []
cycle-group-backward=@as []
cycle-panels=@as []
cycle-panels-backward=@as []
cycle-windows=@as []
cycle-windows-backward=@as []
maximize=['<Shift><Alt><Super>Up']
minimize=['<Shift><Alt><Super>Down']
move-to-monitor-down=@as []
move-to-monitor-left=@as []
move-to-monitor-right=@as []
move-to-monitor-up=@as []
move-to-workspace-1=@as []
move-to-workspace-last=@as []
move-to-workspace-left=['<Shift><Alt><Super>Left']
move-to-workspace-right=['<Shift><Alt><Super>Right']
panel-run-dialog=@as []
switch-applications=@as []
switch-applications-backward=@as []
switch-group=@as []
switch-group-backward=@as []
switch-input-source=@as []
switch-input-source-backward=@as []
switch-panels=@as []
switch-panels-backward=@as []
switch-to-workspace-1=@as []
switch-to-workspace-last=@as []
switch-to-workspace-left=['<Alt><Super>Left']
switch-to-workspace-right=['<Alt><Super>Right']
switch-windows=['<Alt>Tab']
switch-windows-backward=['<Shift><Alt>Tab']
toggle-fullscreen=['<Super>Page_Up']
toggle-maximized=@as []
unmaximize=@as []
EOF
