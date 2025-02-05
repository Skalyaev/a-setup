# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s "histappend"   # Append to history, don't overwrite it
shopt -s "checkwinsize" # Check window size after each command
shopt -s "globstar"     # ** matches all files, even in subdirectories
shopt -s "cdspell"      # Correct spelling errors during tab-completion
shopt -s "dirspell"     # Correct spelling errors during directory change
shopt -s "autocd"       # Change to directory without cd
shopt -s "cmdhist"      # Save multi-line commands as one command

PROMPT_COMMAND="history -n; history -w; history -c; history -r; ${PROMPT_COMMAND}"

PYENV="$HOME/.local/share/pyenv"
[[ -e "$PYENV" ]] && . "$PYENV/bin/activate"

if ! shopt -oq "posix"; then

    BASH_COMPLETION=(
        "/usr/share/bash-completion/bash_completion"
        "/etc/bash_completion"
    )
    for bash_completion in "${BASH_COMPLETION[@]}"; do

        [[ ! -e "$bash_completion" ]] && continue
        . "$bash_completion"
        break
    done
fi
[[ -s "$HOME/.bash_env" ]] && . "$HOME/.bash_env"
[[ -s "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"

[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

PKG_FILE="/usr/share/doc/pkgfile/command-not-found.bash"
[[ -s "$PKG_FILE" ]] && . "$PKG_FILE"
unset PKG_FILE

GRAY="\[\033[38;5;240m\]"
NC="\[\033[00m\]"

P1="\u$GRAY@$NC\h$GRAY"       # User@Host
P2="-[$NC\t$GRAY]"            # Time
P3="-[$NC\w$GRAY]$NC"         # Working directory
P4="$GRAY[$NC\$?$GRAY]\$$NC " # Exit code and prompt

PS1="$P1$P2$P3\n$P4"
unset GRAY NC P1 P2 P3 P4

ERROR_LOG="$HOME/.error"
if [[ -e "$ERROR_LOG" ]]; then

    echo "Error logs:"
    cat "$ERROR_LOG" && rm "$ERROR_LOG"
fi # TODO: Implement GNOME notifications
