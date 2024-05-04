#!/bin/bash
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
GRAY="\033[0;37m"
NC="\033[0m"

USAGE="$GRAY===================USAGE$NC
$YELLOW$(basename "$0") $BLUE<menu> $GREEN[options]$NC

From the $BLUE<menu>$NC directory,
set a jgmenu csv file from some .list files:
    $RED*$NC categories.list
    $RED*$NC applications.list
    $RED*$NC links.list

$GREEN[options]$NC:
-p, --path <path>
    $RED*$NC Path to $BLUE<menu>$NC
    $RED*$NC Default: ~/.local/share/jgmenu/sets
-o, --output <path>
    $RED*$NC Path to jgmnu csv file
    $RED*$NC Default: ~/.config/jgmenu/menu.csv
"
if [[ "$#" -lt 1 ]];then
    echo -e "$USAGE"
    exit 1
fi

DIR="$HOME/.config/jgmenu/set/$1"
CSV="$HOME/.config/jgmenu/menu.csv"
TERM="/usr/bin/alacritty -e"
BROWSER="/usr/bin/firefox-esr -new-tab"

shift
err() {
    echo -e "[$RED ERR $NC] $1"
    exit 1
}
while [[ "$#" -gt 0 ]];do
    case "$1" in
    "-p" | "--path")
        [[ "$#" -lt 2 ]] && err "Missing argument:$GREEN $1$NC"
        DIR="$2/$(basename "$DIR")"
        shift 2
        ;;
    "-o" | "--output")
        [[ "$#" -lt 2 ]] && err "Missing argument:$GREEN $1$NC"
        CSV="$2"
        shift 2
        ;;
    *) err "Unknown option:$GREEN $1$NC"
    esac
done

#====================READING CATEGORIES
while read line;do
    [[ "$line" ]] || continue
    [[ "${line:0:1}" == "#" ]] && continue
    clean_line="$(tr " " "-" <<< "$line")"

    if grep -q "/" <<< "$line";then
        parent="require[$(dirname "$clean_line")]"
        clean_line="$(basename "$clean_line")"
        line="$(basename "$line")"
    fi
    ENTRIES+=("$parent$line, ^checkout($clean_line)")
    unset parent

done< <([[ -e "$DIR/categories.list" ]]\
    && cat "$DIR/categories.list")

#====================READING APPLICATIONS
while read line;do
    [[ "$line" ]] || continue
    [[ "${line:0:1}" == "#" ]] && continue

    if ! grep -q "==" <<< "$line";then
        echo -e "[$RED ERR $NC] applications.list: $line"
        continue
    fi
    if grep -q "@@" <<< "$line";then
        parent="require[$(xargs <<< "${line%@@*}" | tr " " "-")]"
        line="${line#*@@}"
    fi
    name="$(xargs <<< "${line%==*}")"
    cmd="$(xargs <<< "${line#*==}")"

    if [[ "${cmd:0:4}" == "term" ]];then
        cmd="${cmd:5}; exec /usr/bin/bash"
        cmd="$TERM /usr/bin/bash -c \"$cmd\""
    fi
    ENTRIES+=("$parent$name, $cmd")
    unset parent

done< <([[ -e "$DIR/applications.list" ]]\
    && cat "$DIR/applications.list")

#====================READING LINKS
while read line;do
    [[ "$line" ]] || continue
    [[ "${line:0:1}" == "#" ]] && continue

    if ! grep -q "==" <<< "$line";then
        echo -e "[$RED ERR $NC] links.list: $line"
        continue
    fi
    if grep -q "@@" <<< "$line";then
        parent="require[$(xargs <<< "${line%@@*}" | tr " " "-")]"
        line="${line#*@@}"
    fi
    name="$(xargs <<< "${line%==*}")"
    url="\"$(xargs <<< "${line#*==}")\""

    ENTRIES+=("$parent$name, $BROWSER $url")
    unset parent

done< <([[ -e "$DIR/links.list" ]]\
    && cat "$DIR/links.list")

#====================WRITING CSV
OUTPUT="#===========================ROOT"
x=0
while [[ "$x" -lt "${#ENTRIES[@]}" ]];do
    line="${ENTRIES[x]}"
    if [[ "${line:0:8}" == "require[" ]];then
        ((++x))
        sub="$(sed "s=^require\[\(.*\)\].*=\1=" <<< "$line")"
        for line in "${SUBS[@]}";do
            [[ "$line" == "$sub" ]] && continue 2
        done
        SUBS+=("$sub")
        continue
    fi
    ENTRIES=("${ENTRIES[@]:0:x}" "${ENTRIES[@]:((x+1))}")
    OUTPUT+="\n$line"
done
OUTPUT+="\n"
x=0
while [[ "$x" -lt "${#SUBS[@]}" ]];do
    sub="${SUBS[((x++))]}"
    OUTPUT+="\n#===========================SUB - $(\
        tr "[:lower:]" "[:upper:]" <<< "$sub")\n^tag($(\
        basename "$sub"))"
    y=-1
    while [[ "$y" -lt "${#ENTRIES[@]}" ]];do
        ((++y))
        line="${ENTRIES[y]}"
        if grep -q "^require\[$sub\]" <<< "$line";then
            ENTRIES=("${ENTRIES[@]:0:y}" "${ENTRIES[@]:((y+1))}")
            OUTPUT+="\n$(cut -d"]" -f2- <<< "$line")"
            ((--y))
            continue
        fi
    done
    OUTPUT+="\n"
done
echo -e "$OUTPUT" > "$CSV"