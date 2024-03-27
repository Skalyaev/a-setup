#!/bin/bash
# Set a jgmenu from some .list files
PATH='/bin:/sbin:/usr/bin:/usr/sbin'

CATEGORIES=$(cat $(dirname "$0")/categories.list)
CATEGORIES=$(echo "$CATEGORIES" | grep -v '^$' | grep -v '^#')

APPLICATIONS=$(cat $(dirname "$0")/applications.list)
APPLICATIONS=$(echo "$APPLICATIONS" | grep -v '^$' | grep -v '^#')
use_term() {
    local terminal='/usr/bin/alacritty -e'
    local shell='/usr/bin/bash -c'
    local cmd="$1; exec $(echo "$shell" | cut -d' ' -f1)"
    echo "$terminal $shell \"$cmd\""
}

LINKS=$(cat $(dirname "$0")/links.list)
LINKS=$(echo "$LINKS" | grep -v '^$' | grep -v '^#')
open_link() {
    local browser='/usr/bin/firefox-esr -new-tab'
    echo "$browser $1"
}
#
#
#
ENTRIES=()

while read entry; do
    c_entry=$(echo "$entry" | tr ' ' '-')
    if echo "$entry" | grep -q '/'; then
        parent="require[$(dirname "$c_entry")] "
        c_entry=$(basename "$c_entry")
        entry=$(basename "$entry")
    fi
    entry="$parent$entry, ^checkout($c_entry)"
    ENTRIES=("${ENTRIES[@]}" "$entry")
    unset parent
done <<< "$CATEGORIES"

while read entry; do
    if echo "$entry" | grep -q '@@'; then
        parent=$(echo "$entry" | cut -d'@' -f1)
        parent=$(echo "$parent" | sed 's/ $//')
        parent=$(echo "$parent" | tr ' ' '-')
        parent="require[$parent] "
        entry=$(echo "$entry" | cut -d'@' -f3-)
    fi
    if echo "$entry" | grep -q '=='; then
        name=$(echo "$entry" | cut -d'=' -f1)
        name=$(echo "$name" | sed 's/ $//')
        name=$(echo "$name" | sed 's/^ //')

        cmd=$(echo "$entry" | cut -d'=' -f3-)
        cmd=$(echo "$cmd" | sed 's/^ //')
        if echo "$cmd" | grep -q '^term '; then
            cmd=$(echo "$cmd" | cut -d' ' -f2-)
            cmd=$(use_term "$cmd")
        fi

        entry="$parent$name, $cmd"
        ENTRIES=("${ENTRIES[@]}" "$entry")
        unset name cmd
    else
        echo 'Jgmenu setup: applications.list: invalid entry:'
        echo "$entry"
    fi
    unset parent
done <<< "$APPLICATIONS"

while read entry; do
    if echo "$entry" | grep -q '@@'; then
        parent=$(echo "$entry" | cut -d'@' -f1)
        parent=$(echo "$parent" | sed 's/ $//')
        parent=$(echo "$parent" | tr ' ' '-')
        parent="require[$parent] "
        entry=$(echo "$entry" | cut -d'@' -f3-)
    fi
    if echo "$entry" | grep -q '=='; then
        name=$(echo "$entry" | cut -d'=' -f1)
        name=$(echo "$name" | sed 's/ $//')
        name=$(echo "$name" | sed 's/^ //')

        url=$(echo "$entry" | cut -d'=' -f3-)
        url=$(echo "$url" | sed 's/^ //')

        entry="$parent$name, $(open_link "$url")"
        ENTRIES=("${ENTRIES[@]}" "$entry")
        unset name url
    else
        echo 'Jgmenu setup: links.list: invalid entry:'
        echo "$entry"
    fi
    unset parent
done <<< "$LINKS"
#
#
#
OUTPUT="#===========================ROOT"
SUBS=()
x=0
while [ "$x" -lt "${#ENTRIES[@]}" ]; do
    entry="${ENTRIES[$x]}"
    if echo "$entry" | grep -q '^require\['; then
        x=$((x+1))
        sub=$(echo "$entry" | cut -d' ' -f1)
        sub=$(echo "$sub" | cut -d'[' -f2-)
        sub=$(echo "$sub" | cut -d']' -f1)
        for entry in "${SUBS[@]}"; do
            if [ "$entry" = "$sub" ]; then
                continue 2
            fi
        done
        SUBS=("${SUBS[@]}" "$sub")
        continue
    fi
    ENTRIES=("${ENTRIES[@]:0:$x}" "${ENTRIES[@]:$((x+1))}")
    OUTPUT="$OUTPUT\n$entry"
done
OUTPUT="$OUTPUT\n"

x=0
while [ "$x" -lt "${#SUBS[@]}" ]; do
    sub="${SUBS[$x]}"
    subname="SUB - $(echo "$sub" | tr '[:lower:]' '[:upper:]')"
    OUTPUT="$OUTPUT\n#===========================$subname"
    OUTPUT="$OUTPUT\n^tag($(basename "$sub"))"
    y=0
    while [ "$y" -lt "${#ENTRIES[@]}" ]; do
        entry="${ENTRIES[$y]}"
        if echo "$entry" | grep -q "^require\[$sub\] "; then
            ENTRIES=("${ENTRIES[@]:0:$y}" "${ENTRIES[@]:$((y+1))}")
            entry=$(echo "$entry" | cut -d' ' -f2-)
            OUTPUT="$OUTPUT\n$entry"
            continue
        fi
        y=$((y+1))
    done
    OUTPUT="$OUTPUT\n"
    x=$((x+1))
done

echo -e "$OUTPUT"
