#
#
#================================== DO_WEB
ft_web() {
    if [ ! -z "$NO_WEB" ]; then
        return
    fi
    ft_echo "${GRAY}================ READING: web.list$NC\n"
    local script="$(find . "${EXCLUDES[@]}" \
        -type f -name 'web.list' |
        xargs cat)"
    local webdir="$(dirname "$ROOT")/.web"
    if [ ! -e "$webdir" ]; then
        if ! mkdir "$webdir"; then
            ft_echo "[$YELLOW WARNING $NC] Can not create $webdir\n"
            ft_echo "Aborting web install.\n"
            return
        fi
        chown "$USER:$USER" "$webdir"
    fi
    while read -r line; do
        if [ -z "$line" ]; then
            continue
        fi
        if [ -z "$to_run" -a -z "$to_skip" -a -z "$to_backup" ]; then
            if [ "$line" = '@@@@' ]; then
                if [ -z "$src" -o -z "$dst" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "Unmatched $line.\n"
                    ft_echo "Aborting web install.\n"
                    break
                fi
                unset target src dst installed runned
            elif [[ "$line" == *'@'* ]]; then
                local target="$(echo "$line" | cut -d'@' -f1 | xargs)"
                local src="$(echo "$line" | cut -d'@' -f2 | cut -d':' -f1 | xargs)"
                local dst="$webdir/$target"
                if [ -e "$dst" ]; then
                    local installed=1
                else
                    mkdir "$dst"
                    chown "$USER:$USER" "$dst"
                fi
            elif [ "$line" = '$- INSTALL' ]; then
                if [ -z "$src" -o -z "$dst" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "src and/or dst missing for an INSTALL.\n"
                    ft_echo "Aborting web install.\n"
                    break
                else
                    if [ -z "$installed" ]; then
                        cd "$dst"
                        local to_run=1
                        local runned=1
                        ft_echo "${BLUE}Installing${NC} $target..."
                    else
                        local to_skip=1
                    fi
                fi
            elif [ "$line" = '$- UPDATE' ]; then
                if [ -z "$src" -o -z "$dst" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "src and/or dst missing for an UPDATE.\n"
                    ft_echo "Aborting web install.\n"
                    break
                else
                    if [ -z "$installed" ]; then
                        local to_skip=1
                    elif [ ! -n $(find "$dst" -maxdepth 1 -type f -name '.update') ]; then
                        cd "$dst"
                        rm -f '.update'
                        local to_run=1
                        local runned=1
                        ft_echo "${BLUE}Updating${NC} $target..."
                    else
                        local to_skip=1
                        ft_echo "$target [$GREEN OK $NC]\n"
                    fi
                fi
            elif [ "$line" = '$- REMOVE' ]; then
                if [ -z "$src" -o -z "$dst" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "src and/or dst missing for a REMOVE.\n"
                    ft_echo "Aborting web install.\n"
                    break
                else
                    if [ ! -z "$runned" ]; then
                        local to_backup=1
                        DIFF=("${DIFF[@]}" "web:$dst")
                    else
                        local to_skip=1
                    fi
                fi
            fi

        elif [ "$line" = '$---' ]; then
            if [ ! -z "$to_backup" ]; then
                DIFF=("${DIFF[@]}" '$---')
            elif [ ! -z "$to_run" ]; then
                cd "$ROOT"
                ft_echo "[$GREEN OK $NC]\n"
            fi
            unset to_run to_skip to_backup

        elif [ ! -z "$to_backup" ]; then
            DIFF=("${DIFF[@]}" "$line")

        elif [ ! -z "$to_run" ]; then
            if ! eval "$line" &>/dev/null; then
                unset to_run
                local to_skip=1
                rm -rf "$dst"
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Non-zero returned from: $line\n"
                ft_echo "$target will not be installed/updated.\n"
            fi
        fi
    done <<< "$script"
    cd "$ROOT"
}
