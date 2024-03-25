if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ -z "$DISPLAY" ] && [ $(tty) = '/dev/tty1' ]; then
  /usr/bin/startx
fi

/home/skalya/.local/bin/gitpush '/home/skalya/.local/share/git'
