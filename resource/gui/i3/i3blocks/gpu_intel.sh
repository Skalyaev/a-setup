#!/bin/bash
# Required: $USER ALL=(ALL:ALL) NOPASSWD: /usr/bin/intel_gpu_top -J
GPU_USAGE="$(timeout 2 sudo /usr/bin/intel_gpu_top -J\
    | jq '.engines."Render/3D/0".busy')"

if [[ ! "$GPU_USAGE" ]];then
    echo "N/A"
    echo "N/A"
    echo "#FF0000"
else
    GPU_USAGE="$(printf "%.0f" "$GPU_USAGE")"
    echo "$GPU_USAGE%"
    echo "$GPU_USAGE%"

    if [[ "$GPU_USAGE" -lt 50 ]];then
        echo "#00FF00"
    elif [[ "$GPU_USAGE" -ge 50 && "$GPU_USAGE" -lt 75 ]];then
        echo "#FFFF00"
    else
        echo "#FF0000"
    fi
fi
