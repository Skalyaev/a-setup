#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
    cat <<EOF
Usage:
    $0 [options] name type value
Options:
    -d "exemple": To add an app description
    -i "exemple": To define an app icon
    -c "exemple1;exemple2": To define app categories
    -t: To make it pop up a terminal
Exemples:
    $0 "exemple" "Application" "/bin/exemple"
    $0 "exemple" "Link" "http://exemple.com"
    $0 "exemple" "Directory" "/exemple"
EOF
}
if [ $# -lt 3 ]; then
    usage
    exit 1
fi

comment=""
icon=""
categories=""
term="false"
name=""
type=""
value=""

args=("$@")
x=0
while [ $x -lt $# ]; do
    case "${args[$x]}" in
        -d)
            ((x++))
            if [ $x -eq $# ]; then
                usage
                exit 1
            fi
            comment="${args[$x]}"
            ;;
        -i)
            ((x++))
            if [ $x -eq $# ]; then
                usage
                exit 1
            fi
            icon="${args[$x]}"
            ;;
        -c)
            ((x++))
            if [ $x -eq $# ]; then
                usage
                exit 1
            fi
            categories="${args[$x]}"
            ;;
        -t)
            term="true"
            ;;
        *)
            name="${args[$x]}"
            ((x++))
            if [ $x -eq $# ]; then
                usage
                exit 1
            fi
            type="${args[$x]}"
            if [ $type != "Application" ] && [ $type != "Link" ] && [ $type != "Directory" ]; then
                usage
                exit 1
            fi
            ((x++))
            if [ $x -eq $# ]; then
                usage
                exit 1
            fi
            value="${args[$x]}"
            ;;
    esac
    ((x++))
done

filename=$(echo "$name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
file="$HOME/.local/share/applications/$filename.desktop"
touch "$file"

echo "[Desktop Entry]" >> "$file"
echo "Name=$name" >> "$file"
if [ ! -z "$comment" ]; then
    echo "Comment=$comment" >> "$file"
fi
echo "Type=$type" >> "$file"
case "$type" in
    "Application")
        echo "Exec=terminator -e \"$value; exec bash\"" >> "$file"
        ;;
    "Link")
        echo "URL=$value" >> "$file"
        ;;
    "Directory")
        echo "Path=$value" >> "$file"
        ;;
esac
echo "Terminal=$term" >> "$file"
if [ ! -z "$icon" ]; then
    echo "Icon=$icon" >> "$file"
fi
if [ ! -z "$categories" ]; then
    echo "Categories=$categories" >> "$file"
fi
