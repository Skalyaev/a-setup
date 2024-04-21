#!/bin/bash
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
GRAY="\033[0;37m"
NC="\033[0m"

USAGE="$GRAY==================USAGE$NC
$YELLOW$(basename "$0") $BLUE<command> $GREEN[options]$NC

$BLUE<install>$NC:
From a resource directory:
    $RED*$NC Install apt packages via .apt files
    $RED*$NC Run install.sh scripts from .script dirs
    $RED*$NC Install local resources via .swap files
$BLUE<restore>$NC:
From a backup directory:
    $RED*$NC Uninstall apt packages via diff file
    $RED*$NC Run remove.sh scripts
    $RED*$NC Uninstall local resources via diff file

$GREEN[options]$NC:
$GREEN-u, --user <user>$NC
    $RED*$NC Install/Backup for the specified user
$GREEN-p, --path <dir>$NC
    $RED*$NC Specify a path to the resource/backup directory
    $RED*$NC Default: $HOME/.local/share/setup
$GREEN-e, --exclude <dir1> [dir2]...$NC
    $RED*$NC When install, exclude the specified directories
$GREEN--no-apt$NC
    $RED*$NC When install, do not read .apt files
$GREEN--no-script$NC
    $RED*$NC When install, do not read .script dirs
$GREEN--no-swap$NC
    $RED*$NC When install, do not read .swap files
$GREEN--no-backup$NC
    $RED*$NC When install, do not create backup
"
if [[ "$#" -lt 1 ]];then
    echo -e "$USAGE"
    exit 1
fi
err() {
    echo -e "[$RED ERR $NC] $1"
    exit 1
}
COMMAND="$1"
shift
[[ "$COMMAND" != "install" && "$COMMAND" != "restore" ]]\
    && err "unknown command: $COMMAND"

while [[ "$#" -gt 0 ]];do
    case "$1" in
    "-u" | "--user")
        [[ "$#" -lt 2 ]] && err "missing argument for $GREEN$1$NC"
        USER="$2"
        HOME="$(getent passwd "$USER" | cut -d: -f6)"
        [[ "$HOME" ]] || err "can not set home for $USER"
        shift 2
        ;;
    "-p" | "--path")
        [[ "$#" -lt 2 ]] && err "missing argument for $GREEN$1$NC"
        [[ -e "$2" ]] || err "path not found: $2"
        ROOT="$(realpath "$2")"
        shift 2
        ;;
    "-e" | "--exclude")
        [[ "$#" -lt 2 || "${2:0:1}" == "-" ]]\
            && err "missing argument for $GREEN$1$NC"
        shift
        while [[ "$#" -gt 0 ]];do
            [[ "${1:0:1}" == "-" ]] && break
            EXCLUDES+=("!" "-path" "*/$1/*")
            shift
        done
        ;;
    "--no-apt") NO_APT=1; shift;;
    "--no-script") NO_SCRIPT=1; shift;;
    "--no-swap") NO_SWAP=1; shift;;
    "--no-backup") NO_BACKUP=1; shift;;
    *) err "unknown option: $1";;
    esac
done
[[ "$ROOT" ]] || ROOT="$HOME/.local/share/setup"

ft_apt() {
    echo -ne "${BLUE}updating$NC apt..."
    if ! apt update -y &>"/dev/null";then
        echo -e "[$RED ERR $NC] Non-zero from apt, try as sudo"
        return 1
    fi
    echo -e "[$GREEN OK $NC]"
    echo -e "$GRAY============READING: .apt$NC"
    while read pkg;do
        if dpkg-query -W -f='${Status}' "$pkg" 2>"/dev/null"\
            | grep -q "install ok installed"
        then
            echo -e "$pkg [$GREEN OK $NC]"
            continue
        fi
        echo -ne "${BLUE}installing$NC $pkg..."
        if ! apt install -y "$pkg" &>"/dev/null";then
            echo -e "[$RED ERR $NC] Non-zero from apt"
            continue
        fi
        [[ "$NO_BACKUP" ]] || DIFF+=("apt:$pkg")
        echo -e "[$GREEN OK $NC]"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".apt"\
        | xargs cat | cut -d: -f1 | sort | uniq)
    return 0
}

ft_swap() {
    echo -e "$GRAY============READING: .swap$NC"
    while read file;do
        local dir="$(dirname "$file")"
        while read -r line;do
            [[ "$line" ]] || continue

            local dst="$(xargs <<< "${line#*@}")"
            dst="${dst/\~/$HOME}"
            local src="$(xargs <<< "${line%@*}")"
            if [[ "${src:0:8}" == "no-link " ]];then
                src="${src:8}"
                local cmd="cp -r "
            else
                local cmd="ln -s "
            fi
            local basesrc="$(basename "$src")"
            src="$(realpath "$dir/$(dirname "$src")")"
            dst="$(realpath "$dst")"

            if [[ "$basesrc" == "*" ]];then
                local targets=($(ls -A "$src"))
            else
                local targets=("$basesrc")
            fi
            for target in "${targets[@]}";do
                local from="$src/$target"
                local to="$dst/$target"
                if [[ -e "$to" ]];then
                    if diff "$from" "$to" 1>"/dev/null";then
                        echo -e "$to [$GREEN OK $NC]"
                        continue
                    elif [[ ! "$NO_BACKUP" ]];then
                        mv "$to" "$BACKUP" || continue
                        DIFF+=("swap:$to")
                        local swapped=1
                    fi
                fi
                echo -ne "${BLUE}setting${NC} $to..."
                eval "$cmd $from $to" || continue
                chown -R "$USER:$USER" "$to"
                if [[ ! "$swapped" ]];then
                    [[ "$NO_BACKUP" ]] || DIFF+=("add:$to")
                else
                    unset swapped
                fi
                echo -e "[$GREEN OK $NC]"
            done
        done<"$file"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".swap")
    return 0
}

ft_script() {
    echo -e "$GRAY============READING: .script$NC"
    while read dir;do
        while read file;do
            echo -ne "${BLUE}Running$NC $file..."
            bash "$file" 1>"/dev/null"
            if [[ "$?" -eq -1 ]];then
                if [[ ! "$NO_BACKUP" ]];then
                    local dir="$(dirname "$file")"
                    mkdir -p "$BACKUP/$dir"
                    [[ -e "$dir/remove.sh" ]]\
                        && cp -r "$dir/remove.sh" "$BACKUP/$dir"
                fi
            elif [[ "$?" -ne 0 ]];then continue; fi
            echo -e "[$GREEN OK $NC]\n"
        done< <(find "$dir" -type f -name "install.sh")
        cd "$ROOT"
    done< <(find . "${EXCLUDES[@]}" -type d -name ".script")
    return 0
}

ft_restore() {
    if [[ -e "diff" ]];then
        echo -e "$GRAY============READING: diff$NC"
        while read line;do
            case "${line%:*}" in
            "apt")
                local pkg="${line#*:}"
                echo -ne "${BLUE}removing$NC $pkg..."
                apt remove -y "$pkg" 1>"/dev/null" || continue
                echo -e "[$GREEN OK $NC]\n"
                ;;
            "swap")
                local target="${line#*:}"
                echo -ne "${BLUE}restoring$NC $target..."
                mv "$(basename "$target")" "$target" || continue
                echo -e "[$GREEN OK $NC]\n"
                ;;
            "add")
                local target="${line#*:}"
                echo -ne "${BLUE}removing$NC $target..."
                if [[ -d "$target" ]];then
                    rm -r "$target" || continue
                else
                    rm "$target" || continue
                fi
                echo -e "[$GREEN OK $NC]\n"
                ;;
            esac
        done<"diff"
    fi
    while read file;do
        echo -ne "${BLUE}Running$NC $file..."
        bash "$file" 1>"/dev/null" || continue
        echo -e "[$GREEN OK $NC]\n"
    done< <(find . -type f -name "remove.sh")
    return 0
}

if [ "$EUID" -eq 0 -a "$USER" != "root" ];then
    is_sudo="(sudo) "
fi
echo -e "$GRAY============Running as $is_sudo$USER$NC"
case "$COMMAND" in
"install")
    ROOT+="/resource"
    [[ -e "$ROOT" ]] || err "resource not found: $ROOT"
    if [[ ! "$NO_BACKUP" ]];then
        BACKUP="$(dirname "$ROOT")/backup/$(date +%s)"
        mkdir -p "$BACKUP" || exit 1
    fi
    cd "$ROOT"
    [[ "$NO_APT" ]] || ft_apt
    [[ "$NO_SCRIPT" ]] || ft_script
    [[ "$NO_SWAP" ]] || ft_swap
    [[ "$NO_BACKUP" ]] && exit 0
    if [[ "${#DIFF[@]}" -eq 0 ]];then
        rm -r "$BACKUP"
        BACKUP="$(dirname "$ROOT")/backup"
        [[ "$(ls -A "$BACKUP")" ]] || rm -r "$BACKUP"
        exit 0
    fi
    for line in "${DIFF[@]}";do
        echo "$line"
    done>"$BACKUP/diff"
    chown -R "$USER:$USER" "$BACKUP"
    ;;
"restore")
    ROOT+="/backup"
    [[ -e "$ROOT" ]] || err "backup not found: $ROOT"
    backup="$(ls -t "$ROOT" | head -n1)"
    if [[ ! "$backup" ]];then
        rm -r "$ROOT"
        err "no more backup: $ROOT"
    fi
    ROOT+="/$backup"
    cd "$ROOT"
    ft_restore
    rm -r "$ROOT"
    ;;
esac
