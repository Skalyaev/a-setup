#!/bin/bash
PATH='/bin:/sbin:/usr/bin:/usr/sbin'
root="$1"
backup="$2"
do_apt="$3"
do_sudo="$4"
list="$root/list"
shells=$(cat "$list/terminal/shell.md" | grep -v "^#" | grep -v "^$")

if [ $# -lt 4 ]; then
    echo "Not yet"
fi
if [ "$do_sudo" = true ]; then
    
    if [ "$do_apt" = true ]; then
        sudo apt install vim
    else
        apt install vim
    fi
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
        --output-dir "$root"
    sudo rm -rf /opt/nvim 
    sudo tar -C /opt -xzf "$root/nvim-linux64.tar.gz"
    sudo mv /opt/nvim-linux64 /opt/nvim
    nvim_path="/opt/nvim/bin"
else
    if [ "$do_apt" = true ]; then
        apt install vim
    fi
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
        --output-dir "$root"
    nvim_path="$HOME/tools/bin"
    mkdir -p "$nvim_path"
    mv "$root/nvim.appimage" "$nvim_path/nvim"
    chmod u+x "$nvim_path/nvim"
fi

pattern="#================ exports"
while IFS= read -r shell; do
    if ! grep -q "$pattern" "$HOME/$shell"; then
        echo -e "$pattern" >> "$HOME/$shell"
    fi
    if ! grep -q "$nvim_path" "$HOME/$shell"; then
        x='export PATH=$PATH'
        sed -i "s;$pattern;$pattern\n$x:$nvim_path;" "$HOME/$shell"
    fi
done <<< "$shells"

mkdir -p "$backup"
if [ -e "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$backup"
fi
cp -r "$root/resources/.config/nvim" "$HOME/.config/nvim"
cat "$list/vim/config.md" | grep -v "^#" | grep -v "^$" \
    >> "$HOME/.config/nvim/init.lua"

plugins=$(ls "$list/vim/plugins")
while IFS= read -r file; do
    plugin=$(cat "$list/vim/plugins/$file")
    awk -v insert="$plugin" '
        /local plugins = {/ {
            print $0;
            print insert;
            next;
        }
        { print $0 }
        ' "$HOME/.config/nvim/init.lua" > "$root/init.lua" \
        && mv "$root/init.lua" "$HOME/.config/nvim/init.lua"
done <<< "$plugins"

opts=$(ls "$list/vim/opts")
while IFS= read -r file; do
    if [ -z "$file" ]; then
        continue
    fi
    opt=$(cat "$list/vim/opts/$file")
    awk -v insert="$opt" '
        /local opts = {/ {
            print $0;
            print insert;
            next;
        }
        { print $0 }
        ' "$HOME/.config/nvim/init.lua" > "$root/init.lua" \
        && mv "$root/init.lua" "$HOME/.config/nvim/init.lua"
done <<< "$opts"
