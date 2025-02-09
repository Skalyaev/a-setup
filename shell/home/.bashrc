# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s "histappend"   # Append to history, don't overwrite it
shopt -s "checkwinsize" # Check window size after each command
shopt -s "globstar"     # ** matches all files, even in subdirectories
shopt -s "cdspell"      # Correct spelling errors during tab-completion
shopt -s "dirspell"     # Correct spelling errors during directory change
shopt -s "autocd"       # Change to directory without cd
shopt -s "cmdhist"      # Save multi-line commands as one command

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"
export PATH="$PATH:$HOME/perl5/bin"
export PATH="$PATH:$HOME/go/bin"

export HISTCONTROL="ignoreboth" # Ignore duplicates and commands starting with space
export HISTSIZE=2000            # Number of commands to remember in history
export HISTFILESIZE=2000        # Number of lines in history file

# Maintain history across sessions
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; ${PROMPT_COMMAND}"

export EDITOR="nvim"    # Use nvim as default editor
export VISUAL="nvim"    # Use nvim as default visual editor
export GRC_ALIASES=true # Colorize output of common commands

PERL_DIR="$HOME/perl5"
export PERL5LIB="$PERL_DIR/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="$PERL_DIR/${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"$PERL_DIR\""
export PERL_MM_OPT="INSTALL_BASE=$PERL_DIR"
unset PERL_DIR

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
    unset BASH_COMPLETION
fi

# SOURCES
SRCS=(
    "/etc/profile.d/grc.sh"
    "/usr/share/doc/pkgfile/command-not-found.bash"
    "/usr/share/nvm/init-nvm.sh"
    "$HOME/.bash_aliases"
    "$HOME/.local/share/pyenv/bin/activate"
)
for src in "${SRCS[@]}"; do [[ -s "$src" ]] && . "$src"; done
unset SRCS

# PROMPT
GRAY="\[\033[38;5;240m\]"
NC="\[\033[00m\]"

P1="\u$GRAY@$NC\h$GRAY"       # User@Host
P2="-[$NC\t$GRAY]"            # Time
P3="-[$NC\w$GRAY]$NC"         # Working directory
P4="$GRAY[$NC\$?$GRAY]\$$NC " # Exit code & Prompt

PS1="$P1$P2$P3\n$P4"
unset GRAY NC P1 P2 P3 P4

# LOGS
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

UPDATE_LOG="$HOME/update.log"
if [[ -e "$UPDATE_LOG" ]]; then

    while read DIR; do

        cd "$DIR" || continue
        [[ -x ".install.sh" ]] || continue
        ./.install.sh

    done <"$UPDATE_LOG"
    unset DIR
    rm "$UPDATE_LOG"
fi
unset UPDATE_LOG
