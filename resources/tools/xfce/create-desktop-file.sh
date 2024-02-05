#!/bin/bash
print_usage() {
    cat <<EOF
This script creates a .desktop file in ~/.local/share/applications

usage: $0 <name> <categories> <cmd> <type> [url] [term] [startup_notify]
exemple: $0 "exemple" "Exemple1,Exemple2" "/usr/share/kali-menu/exec-in-shell 'nmap -h'" "app" "" "false"
EOF
}
if [ $# -lt 4 ]; then
    print_usage
    exit 1
fi

name="$1"
categories="$2"
cmd="$3"
type="$4"
if [ "$type" == link ]; then
    if [ $# -lt 5 ]; then
        print_usage
        exit 1
    fi
    url="$5"
    type=Link
elif [ "$type" == app ]; then
    type=Application
else
    print_usage
    exit 1
fi
if [ $# -gt 5 ]; then
    term="$6"
else
    term="true"
fi
if [ $# -gt 6 ]; then
    startup_notify="$7"
else
    startup_notify="false"
fi

lowercase_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
cat <<EOF > "$HOME/.local/share/applications/$lowercase_name.desktop"
[Desktop Entry]
Name=$name
Encoding=UTF-8
Exec=/usr/share/kali-menu/exec-in-shell "$cmd"
Categories=$categories
Type=$type
Terminal=$term
StartupNotify=$startup_notify
EOF
