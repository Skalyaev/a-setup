[[ -e "$HOME/.bashrc" ]] && . "$HOME"/.bashrc

which "gitsync" && gitsync "$HOME/document/github"
