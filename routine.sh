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

    [[ -e "$target/zip.list" ]] && do_zip "$target"
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

    local pkgs="$1/pacman.list"
    while read pkg; do

        pacman -Qi "$pkg" &>"/dev/null" && continue
        echo -ne "[$YELLOW * $NC] Installing '$pkg'..."

        sudo pacman -S --noconfirm --needed "$pkg" &>"/dev/null"
        echo -e "\r[$GREEN + $NC] '$pkg' installed    "

    done <"$pkgs"
}

# AUR PACKAGES
# ============
do_aur() {

    local pkgs="$1/aur.list"
    while read pkg; do

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

        [[ "$?" -ne 0 ]] && echo -e "[$RED - $NC] '$pkg' makepkg returned non-zero"
        set -e
        echo -e "[$GREEN + $NC] '$pkg' installed"

    done <"$pkgs"
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
    local pkgs="$1/pip.list"
    while read pkg; do

        pip show "$pkg" &>"/dev/null" && continue
        echo -ne "[$YELLOW * $NC] Installing pip '$pkg'..."

        "$pyenv"/bin/pip install --no-cache-dir "$pkg" &>"/dev/null"
        echo -e "\r[$GREEN + $NC] pip '$pkg' installed    "

    done <"$pkgs"
}

# ZIP FILES
# =========
do_zip() {

    local pkgs="$1/zip.list"
    while read file; do

        IFS=" " read name dst <<<"$file"

        local src="$1/zip/$name.zip"
        dst="$HOME/$dst"

        mkdir -p "$dst"
        echo -ne "[$YELLOW * $NC] Unzipping '$name'..."

        unzip -o "$src" -d "$dst" &>"/dev/null"
        echo -e "\r[$GREEN + $NC] '$name' unzipped    "

    done <"$pkgs"
}

# COPY & LINK
# ===========
do_copy() {

    local root="$1/tocopy"
    while read src; do

        local dst="$(do_dirname "$src")"
        cp -rf "$src" "$dst"

    done < <(find "$root" -type "f")
}
do_link() {

    local root="$1/tolink"
    while read src; do

        local dst="$(do_dirname "$src")"
        ln -sf "$src" "$dst"

    done < <(find "$root" -type "f")
}
do_dirname() {

    local src="$1"

    local dst="$(sed "s=$root=/=" <<<"$src")"
    dst=$(sed "s=/home/=$HOME/=" <<<"$dst")

    local dirname="$(dirname "$dst")"
    [[ -e "$dirname" ]] || mkdir -p "$dirname"

    echo "$dst"
}
