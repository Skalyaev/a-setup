#!/bin/bash
RAM_USAGE="$(free | grep Mem | awk '{print $3/$2 * 100.0}')"

if [ -z "$RAM_USAGE" ]; then
    echo "N/A"
    echo "N/A"
    echo "#FF0000"
else
    RAM_USAGE="$(printf "%.0f" "$RAM_USAGE")"
    echo "$RAM_USAGE%"
    echo "$RAM_USAGE%"

    if [ "$RAM_USAGE" -lt 50 ]; then
        echo "#00FF00"
    elif [ "$RAM_USAGE" -ge 50 -a "$RAM_USAGE" -lt 75 ]; then
        echo "#FFFF00"
    else
        echo "#FF0000"
    fi
fi
