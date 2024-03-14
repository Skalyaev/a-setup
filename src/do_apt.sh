#
#
#================================== DO_APT
ft_apt() {
    if [ ! -z "$NO_APT" ]; then
        return
    fi
    ft_echo "Updating apt..."
    if ! apt update -y >/dev/null 2>&1; then
        ft_echo "[$RED KO $NC]\n"
        ft_echo "[$YELLOW WARNING $NC] Non-zero returned from apt.\n"
        ft_echo "You may need to run this command with sudo.\n"
        ft_echo "No apt packages will be installed/updated.\n"
    else
        ft_echo "[$GREEN OK $NC]\n"
        ft_echo "${GRAY}================ READING: apt.list$NC\n"
        local pkgs="$(find "$ROOT" "${EXCLUDES[@]}" \
            -type f -name 'apt.list' |
            xargs cat |
            cut -d':' -f1)"
        while read -r pkg; do
            if ! dpkg -s "$pkg" >/dev/null 2>&1; then
                ft_echo "Installing $pkg..."
                if ! apt install -y "$pkg" >/dev/null 2>&1; then
                    ft_echo "[$RED K0 $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Non-zero returned from apt.\n"
                    ft_echo "$pkg will not be installed.\n"
                else
                    if [ -z "$NO_BACKUP" ]; then
                        DIFF=("${DIFF[@]}" "apt:$pkg")
                    fi
                    ft_echo "[$GREEN OK $NC]\n"
                fi
            else
                ft_echo "$pkg [$GREEN OK $NC]\n"
            fi
        done <<<"$(echo "$pkgs" | uniq)"
    fi
}