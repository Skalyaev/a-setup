#!/bin/bash
apt install -y "unzip" &>"/dev/null" || exit 1
cd "$(mktemp -d)" || exit 1

dst="/usr/share/themes"
name="a-linux-theme"
git clone "https://github.com/Skalyaeve/$name" "$dst/$name"
cd "$dst/$name" || exit 1
unzip theme.zip &>"/dev/null" || exit 1
