#!/bin/bash
name="tree-sitter-linux-x64"
url="https://github.com/tree-sitter/tree-sitter/releases/download/v0.22.6/$name.gz"
cd "/tmp" || exit 1
wget "$url"
gunzip "$name.gz"
mv "$name" "$HOME/.local/bin/$name"
