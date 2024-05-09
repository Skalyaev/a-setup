#!/bin/bash
deps=(
    "ninja-build"
    "gettext"
    "cmake"
    "unzip"
    "curl"
    "build-essential"
)
for dep in "${deps[@]}";do
    apt install -y "$dep" &>"/dev/null" || exit 1
done
url="https://github.com/neovim/neovim"
dst="$HOME/.local/src/nvim"
git clone "$url" "$dst"
cd "$dst" || exit 1

git checkout "stable" || exit 1
make CMAKE_BUILD_TYPE="RelWithDebInfo"\
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"\
    >"/dev/null" || exit 1
make install >"/dev/null" || exit 1
make clean >"/dev/null"
ln -s "$HOME/.local/bin/nvim" "/usr/local/bin/vim"

dir="$HOME/.config/nvim/colors"
[[ -e "$dir/neon.lua" ]] && exit 0
[[ -e "$dir" ]] || mkdir -p "$dir" || exit 1

url="https://github.com/Skalyaeve/a-nvim-theme.git"
src="$HOME/.local/src/a-nvim-theme"
[[ -e "$src" ]] || git clone "$url" "$src" || exit 1
ln -s "$src/colors/neon.lua" "$dir/neon.lua"
