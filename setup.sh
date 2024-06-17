#!/bin/bash
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
GRAY="\033[0;37m"
NC="\033[0m"
export RED GREEN YELLOW BLUE GRAY NC

# From $HOME
PYENV=".local/share/pyenv/bin/activate"
D_ROOT=".local/share/setup"

USAGE="$GRAY==================USAGE$NC
$YELLOW$(basename "$0") $GREEN[options]$NC

from a resource directory:
    $RED*$NC install & update apt packages via .apt files
    $RED*$NC install & update pip packages via .pip files
    $RED*$NC install & update node packages via .npm files
    $RED*$NC install & update local resources via .local files
    $RED*$NC run scripts from .run folders

$GREEN[options]$NC:
$GREEN-u, --user <user>$NC
    $RED*$NC install for the specified user
$GREEN-p, --path <dir>$NC
    $RED*$NC specify a path to the resource directory
    $RED*$NC default: $HOME/.local/share/setup
$GREEN-e, --exclude <dir1> [dir2]...$NC
    $RED*$NC exclude the specified directories
$GREEN--no-apt$NC
    $RED*$NC do not read .apt files
$GREEN--no-pip$NC
    $RED*$NC do not read .pip files
$GREEN--no-npm$NC
    $RED*$NC do not read .npm files
$GREEN--no-run$NC
    $RED*$NC do not read .run folders
$GREEN--no-local$NC
    $RED*$NC do not read .local files
$GREEN-h, --help$NC
    $RED*$NC print this message
"
err(){
    echo -e "[$RED ERR $NC] $1"
    exit 1
}
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
    "--no-npm") NO_NPM=1; shift;;
    "--no-run") NO_RUN=1; shift;;
    "--no-local") NO_LOCAL=1; shift;;
    "-h" | "--help") echo -e "$USAGE"; exit 0;;
    *) err "unknown option: $1";;
    esac
done
[[ "$ROOT" ]] || ROOT="$HOME/$D_ROOT"
PYENV="$HOME/$PYENV"

ft_apt(){
    echo -ne "\n${BLUE}updating$NC apt..."
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
        echo -e "[$GREEN OK $NC]"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".apt"\
        | xargs cat | sort | uniq)
    return 0
}
ft_npm(){
    echo -e "\n${BLUE}updating$NC npm packages..."
    if ! npm update -g &>"/dev/null";then
        echo -e "[$RED ERR $NC] non-zero from npm, try as sudo"
        return 1
    fi
    echo -e "[$GREEN OK $NC]"
    echo -e "$GRAY============READING: .npm$NC"
    while read pkg;do
        [[ "$pkg" ]] || continue

        if npm list -g "$pkg" &>"/dev/null";then
            echo -e "$pkg [$GREEN OK $NC]"
            continue
        fi
        echo -ne "${BLUE}installing$NC $pkg..."
        if ! npm install -g "$pkg" &>"/dev/null";then
            echo -e "[$RED ERR $NC] non-zero from npm"
            continue
        fi
        echo -e "[$GREEN OK $NC]"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".npm"\
        | xargs cat | sort | uniq)
}
ft_pip(){
    if [[ ! -e "$PYENV" ]];then
        echo -e "[$RED ERR $NC] Can not find pyenv"
        return 1
    fi
    source "$PYENV"
    if ! pip show "pip-review" &>"/dev/null";then
        echo -ne "${BLUE}installing$NC pip-review..."

        if ! pip install "pip-review" &>"/dev/null";then
            echo -e "[$RED ERR $NC] non-zero from pip"
            return 1
        fi
        echo -e "[$GREEN OK $NC]"
    fi
    echo -ne "\n${BLUE}updating$NC pip packages..."
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
        echo -e "[$GREEN OK $NC]"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".pip"\
        | xargs cat | sort | uniq)
}
ft_local(){
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
                    fi
                    rm -rf "$to"
                else
                    local todir="$(dirname "$to")"
                    [[ -e "$todir" ]]\
                        || mkdir -p "$todir" || continue
                fi
                echo -ne "${BLUE}setting${NC} $to..."
                eval "$cmd $from $to" || continue
                echo -e "[$GREEN OK $NC]"
            done
        done<"$file"
    done< <(find . "${EXCLUDES[@]}" -type f -name ".local")
    return 0
}
ft_run(){
    echo -e "$GRAY============READING: .run$NC"
    local ref="$(dirname "$ROOT")/.run"
    [[ ! -e "$ref" ]] && ! mkdir -p "$ref" && return 1

    while read dir;do
        while read pkg;do
            [[ "$pkg" ]] || continue
            cd "$dir/$pkg" || continue
            export pkg

            if ls "$ref" | grep -q "$pkg";then
                echo -ne "$pkg "
                if [[ ! -e "update.sh" ]];then
                    echo -e "[$GREEN OK $NC]"
                    cd "$ROOT"
                    continue
                fi
                bash "update.sh"\
                    && echo -e "[$GREEN OK $NC]                    "
            else
                echo -ne "${BLUE}installing$NC $pkg..."
                if ! bash "install.sh" || ! mkdir -p "$ref/$pkg";then
                    cd "$ROOT"
                    continue
                fi
                echo -e "[$GREEN OK $NC]"
            fi
            cd "$ROOT"
        done< <(ls "$dir")
    done< <(find . "${EXCLUDES[@]}" -type d -name ".run")
    return 0
}

[[ "$EUID" -eq 0 && "$USER" != "root" ]] && is_sudo="(sudo) "
echo -e "$GRAY============RUNNING AS: $is_sudo$USER$NC"
ROOT+="/resource"
cd "$ROOT" || exit 1

[[ "$NO_APT" ]] || ft_apt
[[ "$NO_PIP" ]] || ft_pip
[[ "$NO_NPM" ]] || ft_npm
[[ "$NO_LOCAL" ]] || ft_local
[[ "$NO_RUN" ]] || ft_run
chown -R "$USER:$USER" "$HOME"
