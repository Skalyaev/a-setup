#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

root=$(dirname $(realpath $0))
list="$root/list"

echo "Install apt packages?"
do_apt=false
select answ in "Yes" "No"; do
    case $answ in
        Yes ) do_apt=true; break;;
        No ) break;;
    esac
done
echo "Install git repositories?"
do_git=false
select answ in "Yes" "No"; do
    case $answ in
        Yes ) do_git=true; break;;
        No ) break;;
    esac
done
echo "Install other web resources?"
do_wget=false
select answ in "Yes" "No"; do
    case $answ in
        Yes ) do_wget=true; break;;
        No ) break;;
    esac
done
echo "Install oh-my-zsh?"
do_omz=false
select answ in "Yes" "No"; do
    case $answ in
        Yes ) do_omz=true; break;;
        No ) break;;
    esac
done

if [ "$do_apt" = true ]; then
    echo "================ Apt packages..."
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
    echo "================ Git repositories..."
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
    echo "================ Other web resources..."
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

if [ "$do_omz" = true ]; then
    echo "================ Oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    
fi
