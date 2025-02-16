#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

process() {

    sudo echo
    local target="$1"

    [[ -e "$target/pacman.list" ]] && do_pacman "$target"
    [[ -e "$target/aur.list" ]] && do_aur "$target"
    [[ -e "$target/pip.list" ]] && do_pip "$target"

    [[ -e "$target/zip" ]] && do_zip "$target"
    [[ -e "$target/tocopy" ]] && do_copy "$target"
    [[ -e "$target/tolink" ]] && do_link "$target"

    [[ -e "$target/_run_.sh" ]] && bash "$target/_run_.sh"
    if [[ -e "$target/script" ]]; then

        local scripts="$(find "$target/script" -name "*.sh")"
        for script in $scripts; do bash "$script"; done
    fi
    echo -e "[$GREEN + $NC] Installation complete"
}

# PACMAN PACKAGES
# ===============
do_pacman() {

    echo -ne "[$YELLOW * $NC] Updating 'pacman' database..."

    sudo pacman -Syu --noconfirm &>"/dev/null"
    echo -e "\r[$GREEN + $NC] 'pacman' database updated    "

    for pkg in $(cat "$1/pacman.list"); do

        pacman -Qi "$pkg" &>"/dev/null" && continue
        echo -ne "[$YELLOW * $NC] Installing '$pkg'..."

        sudo pacman -S --noconfirm --needed "$pkg" &>"/dev/null"
        echo -e "\r[$GREEN + $NC] '$pkg' installed    "
    done
}

# AUR PACKAGES
# ============
do_aur() {

    for pkg in $(cat "$1/aur.list"); do

        cd "/usr/local/src/github"
        if [[ ! -e "$pkg" ]]; then

            echo -ne "[$YELLOW * $NC] Cloning '$pkg'..."

            git clone "https://aur.archlinux.org/$pkg.git" &>"/dev/null"
            echo -e "\r[$GREEN + $NC] '$pkg' cloned    "
        fi
        cd "$pkg"
        if [[ ! -x ".install.sh" ]]; then

            echo 'makepkg -si --noconfirm' >".install.sh"
            chmod +x ".install.sh"
        fi
        echo -e "[$GREEN + $NC] Running makepkg for '$pkg'"
        set +e
        ./.install.sh &>"/dev/null"

        if [[ "$?" -ne 0 ]]; then
            echo -e "[$RED - $NC] '$pkg' makepkg returned non-zero"
        else
            echo -e "[$GREEN + $NC] '$pkg' installed"
        fi
        set -e
    done
}

# PYTHON PACKAGES
# ===============
do_pip() {

    local pyenv="$HOME/.local/share/pyenv"
    if [[ ! -e "$pyenv" ]]; then

        echo -ne "[$YELLOW * $NC] Creating local python environment..."

        python -m venv "$pyenv" &>"/dev/null"
        echo -e "\r[$GREEN + $NC] Local python environment created    "
    fi
    for pkg in $(cat "$1/pip.list"); do

        pip show "$pkg" &>"/dev/null" && continue
        echo -ne "[$YELLOW * $NC] Installing pip '$pkg'..."

        "$pyenv"/bin/pip install --no-cache-dir "$pkg" &>"/dev/null"
        echo -e "\r[$GREEN + $NC] pip '$pkg' installed    "
    done
}

# COPY & LINK & ZIP
# =================
do_copy() {

    local root="$1/tocopy"
    for src in $(find "$root" -type "f"); do

        local dst="$(do_dirname "$src" "$root")"
        local dosudo="$(grep -q "/home/" <<<"$dst" && echo 0 || echo 1)"

        if [[ "$dosudo" -ne 1 ]]; then
            cp -rf "$src" "$dst"
        else
            sudo cp -rf "$src" "$dst"
        fi
    done
}
do_link() {

    local root="$1/tolink"
    for src in $(find "$root" -type "f"); do

        local dst="$(do_dirname "$src" "$root")"
        local dosudo="$(grep -q "/home/" <<<"$dst" && echo 0 || echo 1)"

        if [[ "$dosudo" -ne 1 ]]; then
            ln -sf "$src" "$dst"
        else
            sudo ln -sf "$src" "$dst"
        fi
    done
}
do_zip() {

    local root="$1/zip"
    for src in $(find "$root" -type "f"); do

        local dst="$(do_dirname "$src" "$root")"
        local dosudo="$(grep -q "/home/" <<<"$dst" && echo 0 || echo 1)"

        echo -ne "[$YELLOW * $NC] Unzipping '$(basename "$src")..."
        if [[ "$dosudo" -ne 1 ]]; then

            unzip -o "$src" -d "$dst" &>"/dev/null"
        else
            sudo unzip -o "$src" -d "$dst" &>"/dev/null"
        fi
        echo -e "\r[$GREEN + $NC] '$src' unzipped    "
    done
}
do_dirname() {

    local src="$1"
    local root="$2"

    local dst="$(sed "s=$root=/=" <<<"$src")"
    local dosudo="$(grep -q "/home/" <<<"$dst" && echo 0 || echo 1)"
    dst=$(sed "s=/home/=$HOME/=" <<<"$dst")

    local dirname="$(dirname "$dst")"
    if [[ "$dosudo" -ne 1 ]]; then

        [[ -e "$dirname" ]] || mkdir -p "$dirname"
    else
        [[ -e "$dirname" ]] || sudo mkdir -p "$dirname"
    fi
    echo "$dst"
}
