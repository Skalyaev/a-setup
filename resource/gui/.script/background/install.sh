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
    for file in "${files[@]}";do
        [[ -e "$FROM/$file" ]] || continue
        if ! diff "$FROM/$file" "$target";then
            local dontstop=1
            break
        fi
    done
    [[ "$dontstop" ]] || return -1

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

NAME="background.jpg"
FILES=(
    "default"
    "desktop-background"
    "desktop-grub.png"
    "login-background.svg"
)
P1="https://github.com/Skalyaeve"
P2="/images/blob/main/background/$NAME"
URL="$P1$P2"
nodiff=0
curl -kL "$URL" -o "$NAME" || exit 1
doit "$NAME" "${FILES[@]}"
[[ "$?" -eq 255 ]] && ((nodiff++))
#======================= GRUB BACKGROUND
NAME="black.png"
P1="https://raw.githubusercontent.com/Skalyaeve"
P2="/images/main/background/$NAME"
URL="$P1$P2"
curl -kL "$URL" -o "$NAME"
DST="/boot/grub"
if [[ -e "$DST/$NAME" ]];then
    if diff "$NAME" "$DST/$NAME";then
        [[ "$nodiff" -eq 1 ]] && exit -1
        exit 0
    fi
    mv "$DST/$NAME" "$DST/$NAME.ft.bak" || exit 1
fi
mv "$NAME" "$DST/$NAME" || exit 1

SRC="$HOME/.local/share/setup/resource/gui/grub/grub"
DST="/etc/default/grub"
if [[ -e "$DST" ]];then
    diff "$SRC" "$DST" && exit 0
    mv "$DST" "$DST.ft.bak" || exit 1
fi
cp "$SRC" "$DST" || exit 1
update-grub &>"/dev/null"
exit 0
