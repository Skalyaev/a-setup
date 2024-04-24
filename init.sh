#!/bin/bash
mkdir -p ~/.config
mkdir -p ~/.local/src
mkdir -p ~/.local/bin
mkdir -p ~/.local/share
python3 -m venv ~/.local/share/pyenv
source ~/.local/share/pyenv/bin/activate
