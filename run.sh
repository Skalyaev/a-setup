#!/bin/bash
PATH='/bin:/sbin:/usr/bin:/usr/sbin'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "What to do?"
echo "use apt?"
do_apt=false
select x in "Yes" "No"; do
    case $x in
        Yes ) do_apt=true; break;;
        No ) break;;
    esac
done
echo "use sudo?"
do_sudo=false
select x in "Yes" "No"; do
    case $x in
        Yes ) do_sudo=true; break;;
        No ) break;;
    esac
done
echo "setup gnome?"
do_gnome=false
select x in "Yes" "No"; do
    case $x in
        Yes ) do_gnome=true; break;;
        No ) break;;
    esac
done
echo "setup terminal?"
do_terminal=false
select x in "Yes" "No"; do
    case $x in
        Yes ) do_terminal=true; break;;
        No ) break;;
    esac
done
echo "setup vim?"
do_vim=false
select x in "Yes" "No"; do
    case $x in
        Yes ) do_vim=true; break;;
        No ) break;;
    esac
done
echo "setup tools?"
do_tools=false
select x in "Yes" "No"; do
    case $x in
        Yes ) do_tools=true; break;;
        No ) break;;
    esac
done

if [ "$do_apt" = true ]; then
    echo "Updating apt..."
    if [ "$do_sudo" = true ]; then
        sudo apt update -y
    else
        apt update -y
    fi
fi

root=$(dirname $(realpath $0))
backup="$root/backup/$(date +%Y-%m-%d-%H-%M-%S)"
src="$root/src"
if [ $do_gnome = true ]; then
	echo "================ Gnome setup"
	echo -e "================ Gnome setup:$GREEN OK $NC"
fi
if [ $do_terminal = true ]; then
	echo "================ Terminal setup"
	"$src/terminal.sh" "$root" "$backup"
	echo -e "================ Terminal setup:$GREEN OK $NC"
fi
if [ $do_vim = true ]; then
	echo "================ Vim setup"
	"$src/vim.sh" "$root" "$backup" "$do_apt" "$do_sudo"
	echo -e "================ Vim setup:$GREEN OK $NC"
fi
if [ $do_tools = true ]; then
	echo "================ Tools setup"
	echo -e "================ Tools setup:$GREEN OK $NC"
fi

