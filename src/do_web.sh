#
#
#================================== DO_WEB
ft_web() {
    if [ ! -z "$NO_WEB" ]; then
        return
    fi
    ft_echo "${GRAY}================ READING: web.list$NC\n"
    local script=$(find "$ROOT" "${EXCLUDES[@]}" \
        -type f -name 'web.list' |
        xargs cat)
    while read -r line; do
        if [ -z "$line" ]; then
            continue
        fi

        if [ -z "$to_run" -a -z "$to_skip" -a -z "$to_backup" ]; then
            if [[ "$line" == '@@@@' ]]; then
                if [ -z "$src" -o -z "$dst" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "Unmatched $line.\n"
                    ft_echo "Aborting web install.\n"
                    break
                fi
                unset target src dst installed
            elif [[ "$line" == *'@'* ]]; then
                local target=$(echo "$line" | cut -d'@' -f1 | xargs)
                local src=$(echo "$line" | cut -d'@' -f2 | cut -d'~' -f1 | xargs)
            elif [[ "$line" == '#### '* ]]; then
                if [ -z "$src" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "Unmatched $line.\n"
                    ft_echo "Aborting web install.\n"
                    break
                fi
                local dst=$(echo "$line" | cut -d' ' -f2 | xargs)
                if [ -e "$dst" ]; then
                    local installed=1
                elif [ ! -e "$(dirname "$dst")" ]; then
                    mkdir -p "$(dirname "$dst")" >/dev/null 2>&1
                fi
            elif [[ "$line" == '$- INSTALL' ]]; then
                if [ -z "$src" -o -z "$dst" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "src and/or dst missing for an INSTALL.\n"
                    ft_echo "Aborting web install.\n"
                    break
                else
                    if [ -z "$installed" ]; then
                        local to_run=1
                        ft_echo "Installing $target..."
                    else
                        local to_skip=1
                    fi
                fi
            elif [[ "$line" == '$- UPDATE' ]]; then
                if [ -z "$src" -o -z "$dst" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "src and/or dst missing for an UPDATE.\n"
                    ft_echo "Aborting web install.\n"
                    break
                else
                    if [ -z "$installed" ]; then
                        local to_skip=1
                    else
                        local to_run=1
                        ft_echo "Updating $target..."
                    fi
                fi
            elif [[ "$line" == '$- REMOVE' ]]; then
                if [ -z "$src" -o -z "$dst" ]; then
                    ft_echo "[$YELLOW WARNING $NC] A web.list file is invalid.\n"
                    ft_echo "src and/or dst missing for a REMOVE.\n"
                    ft_echo "Aborting web install.\n"
                    break
                else
                    local to_backup=1
                    DIFF=("${DIFF[@]}" "web:$dst")
                fi
            fi

        elif [[ "$line" == '$---' ]]; then
            if [ ! -z "$to_backup" ]; then
                DIFF=("${DIFF[@]}" '$---')
            elif [ ! -z "$to_run" ]; then
                ft_echo "[$GREEN OK $NC]\n"
                chown -R "$USER:$USER" "$dst" >/dev/null 2>&1
            fi
            unset to_run to_skip to_backup

        elif [ ! -z "$to_backup" ]; then
            DIFF=("${DIFF[@]}" "$line")

        elif [ ! -z "$to_run" ]; then
            if ! eval "$line" >/dev/null 2>&1; then
                unset to_run
                local to_skip=1
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Non-zero returned from: $line\n"
                ft_echo "$dst will not be installed/updated.\n"
                ft_echo "You may need to clear that install/update manually.\n"
            fi
        fi
    done <<<"$script"
}
