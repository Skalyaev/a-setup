#!/bin/bash
#======================= LIGHTDM BACKGROUNDS
FROM='/usr/share/images/desktop-base'
TO="/usr/share/images/backgrounds"
if [[ ! -e "$TO" ]]; then
    mkdir "$TO" || exit 1
    [[ "$NO_BACKUP" ]] || DIFF+=("add:$TO")
fi

TMP="$(mktemp -d)" || exit 1
cd "$TMP" || exit 1

doit() {
    local target="$1"
    local files=("${@:2}")
    if [[ ! -w "$FROM" ]]; then
        echo "Permission denied: $FROM" 1>&2
        return 1
    fi
    [[ -e "$TO/$target" ]]\
        && ! mv "$TO/$target" "$TO/$target.ft.bak"\
        && return 1

    if ! mv "$target" "$TO/$target";then
        mv "$TO/$target.ft.bak" "$TO/$target"
        return 1
    fi
    for file in "${files[@]}";do
        if [[ -e "$FROM/$file" ]]\
            && ! mv "$FROM/$file" "$FROM/$file.ft.bak"
        then
            for old in "${files[@]}";do
                [[ "$file" == "$old" ]] && break
                mv "$FROM/$old.ft.bak" "$FROM/$old"
            done
            mv "$TO/$target.ft.bak" "$TO/$target"
            return 1
        fi
        if ! ln -s "$TO/$target" "$FROM/$file";then
            for old in "${files[@]}";do
                mv "$FROM/$old.ft.bak" "$FROM/$old"
                [[ "$file" == "$old" ]] && break
            done
            mv "$TO/$target.ft.bak" "$TO/$target"
            return 1
        fi
    done
    return 0
}

NAME="ft_background.jpg"
nodiff=0
if [[ ! -e "$TO/$NAME" ]];then
    FILES=(
        "default"
        "desktop-background"
        "desktop-grub.png"
        "login-background.svg"
    )
    P1="https://github.com/Skalyaeve"
    P2="/images/blob/main/background/background.jpg"
    URL="$P1$P2"
    curl -kL "$URL" -o "$NAME" || exit 1
    doit "$NAME" "${FILES[@]}"
else
    ((nodiff++))
fi

NAME="ft_background.xml"
if [[ ! -e "$TO/$NAME" ]];then
    FILES=(
        "desktop-background.xml"
        "desktop-lockscreen.xml"
    )
    P1="https://github.com/Skalyaeve"
    P2="/images/blob/main/background/background.xml"
    URL="$P1$P2"
    curl -kL "$URL" -o "$NAME" || exit 1
    doit "$NAME" "${FILES[@]}"
else
    ((nodiff++))
fi
#======================= GRUB BACKGROUND
NAME="ft_black.png"
DST="/boot/grub"
if [[ ! -e "$DST/$NAME" ]];then
    P1="https://raw.githubusercontent.com/Skalyaeve"
    P2="/images/main/background/$NAME"
    URL="$P1$P2"
    curl -kL "$URL" -o "$NAME" || exit 1
    mv "$NAME" "$DST/$NAME" || exit 1
else
    ((nodiff++))
fi

SRC="$HOME/.local/share/setup/resource/gui/grub/grub"
DST="/etc/default/grub"
if [[ -e "$DST" ]];then
    if diff "$SRC" "$DST"; then
        [[ "$nodiff" -eq 3 ]] && exit -1
    fi
    mv "$DST" "$DST.ft.bak" || exit 1
fi
cp "$SRC" "$DST" || exit 1
sudo update-grub &>"/dev/null"
exit 0
