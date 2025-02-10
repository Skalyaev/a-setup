# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s "histappend"   # Append to history, don't overwrite it
shopt -s "checkwinsize" # Check window size after each command
shopt -s "globstar"     # ** matches all files, even in subdirectories
shopt -s "cdspell"      # Correct spelling errors during tab-completion
shopt -s "dirspell"     # Correct spelling errors during directory change
shopt -s "autocd"       # Change to directory without cd
shopt -s "cmdhist"      # Save multi-line commands as one command

SRCS=(
    "$HOME/.bash_env"
    "$HOME/.bash_aliases"
    "$HOME/.local/share/pyenv/bin/activate"
    "/usr/share/doc/pkgfile/command-not-found.bash"
    "/usr/share/nvm/init-nvm.sh"
    "/etc/profile.d/grc.sh"
)
for src in "${SRCS[@]}"; do [[ -s "$src" ]] && . "$src"; done
unset SRCS src

# Enable bash completion if not in POSIX mode
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
    unset BASH_COMPLETION bash_completion
fi

# TODO: Welcome message
SYSTEMCTL_RET="$(systemctl --failed)"
JOURNALCTL_RET="$(journalctl -p 3 -xb)"

grep -q "0 loaded" <<<"$SYSTEMCTL_RET" || echo -e "\n$SYSTEMCTL_RET\n"
grep -q "No entries" <<<"$JOURNALCTL_RET" || echo -e "\n$JOURNALCTL_RET\n"
unset SYSTEMCTL_RET JOURNALCTL_RET

ERROR_LOG="$HOME/error.log"
if [[ -e "$ERROR_LOG" ]]; then

    echo -e "\nUSER ERROR LOGS:"
    cat "$ERROR_LOG" && rm "$ERROR_LOG"
fi
unset ERROR_LOG

GRAY="\[\033[38;5;240m\]"
NC="\[\033[00m\]"

P1="\u$GRAY@$NC\h$GRAY"       # User@Host
P2="-[$NC\t$GRAY]"            # Time
P3="-[$NC\w$GRAY]$NC"         # Working directory
P4="$GRAY[$NC\$?$GRAY]\$$NC " # Exit code & Prompt

PS1="$P1$P2$P3\n$P4"
unset GRAY NC P1 P2 P3 P4
