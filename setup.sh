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
from a resource directory:
    $RED*$NC install apt packages via .apt files
    $RED*$NC install pip packages via .pip files
    $RED*$NC install web resources via .web folders
    $RED*$NC install local resources via .local files
$BLUE<restore>$NC:
from a backup directory:
    $RED*$NC perform backup using latest backup directory

$GREEN[options]$NC:
$GREEN-u, --user <user>$NC
    $RED*$NC install/backup for the specified user
$GREEN-p, --path <dir>$NC
    $RED*$NC specify a path to the resource/backup directory
    $RED*$NC default: $HOME/.local/share/setup
$GREEN-e, --exclude <dir1> [dir2]...$NC
    $RED*$NC when install, exclude the specified directories
$GREEN--no-apt$NC
    $RED*$NC when install, do not read .apt files
$GREEN--no-pip$NC
    $RED*$NC when install, do not read .pip files
$GREEN--no-web$NC
    $RED*$NC when install, do not read .web folders
$GREEN--no-local$NC
    $RED*$NC when install, do not read .local files
$GREEN--no-backup$NC
    $RED*$NC when install, do not create backup
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
    "--no-pip") NO_PIP=1; shift;;
    "--no-web") NO_WEB=1; shift;;
    "--no-local") NO_LOCAL=1; shift;;
    "--no-backup") NO_BACKUP=1; shift;;
    *) err "unknown option: $1";;
    esac
done
[[ "$ROOT" ]] || ROOT="$HOME/.local/share/setup"

ft_apt() {
    echo -ne "${BLUE}updating$NC apt..."
    if ! apt update -y &>"/dev/null";then
        echo -e "[$RED ERR $NC] non-zero from apt, try as sudo"
        return 1
    fi
    echo -e "[$GREEN OK $NC]"
    echo -e "$GRAY============READING: .apt$NC"
    while read pkg;do
        [[ "$pkg" ]] || continue

        if dpkg-query -W -f='${Status}' "$pkg" 2>"/dev/null"\
            | grep -q "install ok installed"
        then
            echo -e "$pkg [$GREEN OK $NC]"
            continue
        fi
        echo -ne "${BLUE}installing$NC $pkg..."
        if ! apt install -y "$pkg" &>"/dev/null";then
            echo -e "[$RED ERR $NC] non-zero from apt"
            continue
        fi
        [[ "$NO_BACKUP" ]] || DIFF+=("apt:$pkg")
        echo -e "[$GREEN OK $NC]"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".apt"\
        | xargs cat | sort | uniq)
    return 0
}

ft_pip() {
    if [[ ! -e "$HOME/.local/share/pyenv/bin/activate" ]];then
        echo -e "[$RED ERR $NC] Can not find pyenv"
        return 1
    fi
    source "$HOME/.local/share/pyenv/bin/activate"
    if ! pip show "pip-review" &>"/dev/null";then
        echo -ne "${BLUE}installing$NC pip-review..."
        if ! pip install "pip-review" &>"/dev/null";then
            echo -e "[$RED ERR $NC] non-zero from pip"
            return 1
        fi
        echo -e "[$GREEN OK $NC]"
    fi
    echo -ne "${BLUE}updating$NC pip..."
    if ! pip-review --auto &>"/dev/null";then
        echo -e "[$RED ERR $NC] non-zero from pip"
        return 1
    fi
    echo -e "[$GREEN OK $NC]"
    echo -e "$GRAY============READING: .pip$NC"
    while read pkg;do
        [[ "$pkg" ]] || continue

        if pip show "$pkg" &>"/dev/null";then
            echo -e "$pkg [$GREEN OK $NC]"
            continue
        fi
        echo -ne "${BLUE}installing$NC $pkg..."
        if ! pip install "$pkg" &>"/dev/null";then
            echo -e "[$RED ERR $NC] non-zero from pip"
            continue
        fi
        [[ "$NO_BACKUP" ]] || DIFF+=("pip:$pkg")
        echo -e "[$GREEN OK $NC]"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".pip"\
        | xargs cat | sort | uniq)
}

ft_web() {
    echo -e "$GRAY============READING: .web$NC"
    local ref="$(dirname "$ROOT")/.web"
    [[ ! -e "$ref" ]] && ! mkdir "$ref" && return 1
    while read dir;do
        while read pkg;do
            [[ "$pkg" ]] || continue
            cd "$dir/$pkg" || continue

            if ls "$ref" | grep -q "$pkg";then
                echo -ne "$pkg "
                if [[ ! -e "update.sh" ]];then
                    echo -e "[$GREEN OK $NC]"
                    cd "$ROOT"
                    continue
                fi
                bash "update.sh" && echo -e "[$GREEN OK $NC]"
            else
                if ! mkdir "$ref/$pkg";then
                    cd "$ROOT"
                    continue
                fi
                chown "$USER:$USER" "$ref/$pkg"
                echo -ne "${BLUE}installing$NC $pkg..."
                bash "install.sh" && echo -e "[$GREEN OK $NC]"

                [[ ! "$NO_BACKUP" && -e "remove.sh" ]]\
                    && mkdir "$BACKUP/$pkg"\
                    && cp "remove.sh" "$BACKUP/$pkg"
            fi
            cd "$ROOT"
        done< <(ls "$dir")
    done< <(find . "${EXCLUDES[@]}" -type d -name ".web")
    return 0
}

ft_local() {
    echo -e "$GRAY============READING: .local$NC"
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
                else
                    local todir="$(dirname "$to")"
                    if [[ ! -e "$todir" ]];then
                        mkdir "$todir" || continue
                        chown "$USER:$USER" "$todir"
                        [[ "$NO_BACKUP" ]] || DIFF+=("add:$todir")
                    fi
                fi
                echo -ne "${BLUE}setting${NC} $to..."
                eval "$cmd $from $to" || continue
                if grep -q "$HOME" <<< "$to";then
                    if [[ -L "$to" ]];then
                        chown -h "$USER:$USER" "$to"
                    else
                        chown -R "$USER:$USER" "$to"
                    fi
                fi
                if [[ ! "$swapped" ]];then
                    [[ "$NO_BACKUP" ]] || DIFF+=("add:$to")
                else
                    unset swapped
                fi
                echo -e "[$GREEN OK $NC]"
            done
        done<"$file"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".local")
    return 0
}

ft_restore() {
    while read file;do
        local pkg="$(basename "$(dirname "$file")")"
        rm -r "$BASE/.web/$pkg"

        echo -ne "${BLUE}removing$NC $file..."
        bash "$file" 1>"/dev/null" || continue
        echo -e "[$GREEN OK $NC]"
    done< <(find . -type f -name "remove.sh")

    if [[ -e "diff" ]];then
        echo -e "$GRAY============READING: diff$NC"
        while read line;do
            case "${line%:*}" in
            "apt")
                local pkg="${line#*:}"
                echo -ne "${BLUE}removing$NC $pkg..."
                apt remove -y "$pkg" &>"/dev/null" || continue
                echo -e "[$GREEN OK $NC]"
                ;;
            "pip")
                local pkg="${line#*:}"
                if [[ ! -e "$HOME/.local/share/pyenv/bin/activate" ]]
                then
                    echo -e "[$RED ERR $NC] Can not find pyenv"
                    continue
                fi
                source "$HOME/.local/share/pyenv/bin/activate"
                echo -ne "${BLUE}removing$NC $pkg..."
                pip uninstall -y "$pkg" 1>"/dev/null" || continue
                echo -e "[$GREEN OK $NC]"
                ;;
            "swap")
                local target="${line#*:}"
                echo -ne "${BLUE}restoring$NC $target..."
                mv "$(basename "$target")" "$target" || continue
                echo -e "[$GREEN OK $NC]"
                ;;
            "add")
                local target="${line#*:}"
                echo -ne "${BLUE}removing$NC $target..."
                if [[ -d "$target" ]];then
                    rm -r "$target" || continue
                else
                    rm "$target" || continue
                fi
                echo -e "[$GREEN OK $NC]"
                ;;
            esac
        done<"diff"
    fi
    return 0
}

[[ "$EUID" -eq 0 && "$USER" != "root" ]] && is_sudo="(sudo) "
echo -e "$GRAY============RUNNING AS: $is_sudo$USER$NC"
case "$COMMAND" in
"install")
    ROOT+="/resource"
    [[ -e "$ROOT" ]] || err "resource not found: $ROOT"
    if [[ ! "$NO_BACKUP" ]];then
        BACKUP="$(dirname "$ROOT")/backup"
        [[ ! -e "$BACKUP" ]] && ! mkdir "$BACKUP" && exit 1
        chown "$USER:$USER" "$BACKUP"
        BACKUP+="/$(date +%s)"
        mkdir "$BACKUP" || exit 1
    fi
    cd "$ROOT"
    [[ "$NO_APT" ]] || ft_apt
    [[ "$NO_PIP" ]] || ft_pip
    [[ "$NO_LOCAL" ]] || ft_local
    [[ "$NO_WEB" ]] || ft_web
    [[ "$NO_BACKUP" ]] && exit 0
    if [[ "${#DIFF[@]}" -eq 0 ]];then
        if [[ ! "$(ls -A "$BACKUP")" ]];then
            rm -r "$BACKUP"
            BACKUP="$(dirname "$ROOT")/backup"
            [[ "$(ls -A "$BACKUP")" ]] || rm -r "$BACKUP"
            exit 0
        fi
    fi
    if [[ "${#DIFF[@]}" -ne 0 ]];then
        for line in "${DIFF[@]}";do
            echo "$line"
        done>"$BACKUP/diff"
    fi
    chown -R "$USER:$USER" "$BACKUP"
    ;;
"restore")
    BASE="$ROOT"
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
