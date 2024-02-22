#!/bin/bash
if [ "$do_apt" = true ]; then
    packages=$(
        cat "$list/install/apt.md" \
        | grep -v "^#" \
        | grep -v '^$' \
        | awk -F ': ' '{print $2}' \
        | tr "\n" " " \
        | uniq
    )
    echo "Installing $packages..."
    sudo apt update -y
    sudo apt install -y $packages
fi

if [ "$do_git" = true ]; then
    mkdir -p "$HOME/git"
    packages=$(
        cat "$list/install/git.md" \
        | grep -v "^#" \
        | grep -v '^$' \
        | awk -F ': ' '{print $2}' \
        | tr "\n" " " \
        | uniq
    )
    for package in $packages; do
        echo "Cloning $package..."
        name=$(echo $(basename $package) | cut -d'.' -f1)
        git clone $package "$HOME/git/$name"
    done
fi

if [ "$do_wget" = true ]; then
    mkdir -p "$HOME/wget"
    packages=$(
        cat "$list/install/wget.md" \
        | grep -v "^#" \
        | grep -v '^$' \
        | awk -F ': ' '{print $2}' \
        | tr "\n" " " \
        | uniq
    )
    for package in $packages; do
        echo "Downloading $package..."
        wget -P "$HOME/wget" $package
    done
fi

