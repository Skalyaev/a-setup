#
#
#=============================== FONCTIONS
ft_echo() {
    if [ -z "$SILENT" ]; then
        echo -e "$@"
    fi
}

is_inside() {
    local tab=("${@:1:$#-1}")
    local item="${@: -1}"
    for x in "${tab[@]}"; do
        if [ "$x" = "$item" ]; then
            return 0
        fi
    done
    return 1
}

ft_apt() {
    local package="$1"
    if [ -z "$NO_APT" ]; then
        if ! dpkg -s "$package" >/dev/null; then
            ft_echo "installing $package..."
            apt install -y "$package" >/dev/null
            if [ "$?" -eq 0 ]; then
                ft_echo "$package ${GREEN}installed${NC}"
                DIFF=("${DIFF[@]}" "apt:$package")
            else
                ft_echo "[$RED ERROR $NC] Non-zero returned from apt."
                ft_echo "You may need to run this command with sudo."
                exit 1
            fi
        else
            ft_echo "$package ${GREEN}up to date${NC}"
        fi
    fi
}

ft_git() {
    local src="$1"
    local dst="$2"
    if [ -z "$NO_GIT" ]; then
        if [ ! -e "$dst" ]; then
            ft_echo "cloning $src..."
            git clone "$src" "$dst" >/dev/null
            if [ "$?" -eq 0 ]; then
                ft_echo "$dirname ${GREEN}cloned${NC}"
            else
                ft_echo "[$RED ERROR $NC] Non-zero returned from git."
                exit 1
            fi
        else
            ft_echo "updating $src..."
            cd "$dst" && git pull >/dev/null
            if [ "$?" -eq 0 ]; then
                ft_echo "$dirname ${GREEN}updated${NC}"
            else
                ft_echo "[$RED ERROR $NC] Non-zero returned from git."
                exit 1
            fi
        fi
    fi
}

ft_curl() {
    local src="$1"
    local dst="$ROOT/resources/curl/$repo"
    if [ -z "$NO_CURL" ]; then
        if [ ! -e "$dst" ]; then
            ft_echo "downloading $src..."
            curl -sL "$src" -o "$dst" >/dev/null
            if [ "$?" -eq 0 ]; then
                ft_echo "$src ${GREEN}downloaded${NC}"
            else
                ft_echo "[$RED ERROR $NC] Non-zero returned from curl."
                exit 1
            fi
        fi
    fi
}

ft_swap() {
    local src=$ROOT/resources/$1
    local dst=$HOME/$2
    ft_echo "Replacing $dst..." | tr -d '\n'
    if [ -e "$dst" -a -z "$NO_BACKUP" ]; then
        if ! mv "$dst" "$BACKUP_DIR"; then
            ft_echo "[$RED ERROR $NC] Aborting, could not backup $dst."
            exit 1
        fi
    fi
    if [ -f "$src" ]; then
        if ! cp "$src" "$dst"; then
            ft_echo "[$RED ERROR $NC] Aborting, could not copy $src to $dst."
            exit 1
        fi
        chown "$USER":"$USER" "$dst"
    elif [ -d "$src" ]; then
        if ! cp -r "$src" "$dst"; then
            ft_echo "[$RED ERROR $NC] Aborting, could not copy $src to $dst."
            exit 1
        fi
        chown -R "$USER":"$USER" "$dst"
    fi
    DIFF=("${DIFF[@]}" "swap:$dst")
    ft_echo "[$GREEN OK $NC]"
}
