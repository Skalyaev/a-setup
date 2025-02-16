#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/run/psql.sh
"$DIR"/run/msf.sh
