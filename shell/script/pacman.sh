#!/bin/bash
set -e
set -u

sudo sed -i 's/#Color/Color/g' "/etc/pacman.conf"
