#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -u

TASKLIST=(
    "0 18 * * * gitsync $HOME/document/github"
)
TASKS="$(crontab -l 2>"/dev/null")"
set -e
for task in "${TASKLIST[@]}"; do

    grep -q "$task" <<<"$TASKS" && continue
    [[ -n "$TASKS" ]] && TASKS+="\n"

    NAME="$(cut -d " " -f "6-" <<<"$task")"
    echo -ne "[$YELLOW * $NC] Setting '$NAME' cronjob..."

    echo -e "$TASKS$task" | crontab - &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$NAME' cronjob set       "

    TASKS="$(crontab -l 2>"/dev/null")"
done
