#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
    cat <<EOF
Usage: $0 [options] name type value
Options:
    -d "exemple": To add an app description
    -i "exemple": To define an app icon
    -c "exemple1;exemple2": To define app categories
    -t: To make it pop up a terminal
Exemple:
    $0 "exemple" "Application" "/bin/exemple"
    $0 "exemple" "Link" "http://exemple.com"
    $0 "exemple" "Directory" "/exemple"
EOF
}

args=("$@")
for x in "${!args[@]}"; do
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
            ((x++))
            if [ $x -eq $# ]; then
                usage
                exit 1
            fi
            exec="${args[$x]}"
            ;;
    esac
done



#cat <<EOF
#[Desktop Entry]
#Name=$name
#Comment=$comment
#Exec=$exec
#Terminal=$term
#Type=$type
#Icon=$icon
#Categories=$categories
#EOF
