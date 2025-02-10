#!/bin/bash
set -e
set -u

systemctl enable "NetworkManager" &>"/dev/null"
systemctl enable "systemd-timesyncd" &>"/dev/null"
systemctl enable "paccache.timer" &>"/dev/null"
systemctl enable "cronie" &>"/dev/null"
