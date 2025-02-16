#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

if [[ ! -e "$HOME/.rvm" ]]; then

    echo -ne "[$YELLOW * $NC] Installing 'rvm'..."
    curl -L "get.rvm.io" >"/tmp/rvm-installer" 2>"/dev/null"

    bash "/tmp/rvm-installer" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] 'rvm' installed    "
fi
set +u
source "$HOME/.rvm/scripts/rvm"
set -u

RUBY_VERSION=$(cat "/opt/metasploit/.ruby-version")
if [[ -z "$RUBY_VERSION" ]];then

    echo -ne "[$RED - $NC] /opt/metasploit/.ruby-version not found"
    exit 1
fi
if [[ "$(ruby --version)" != *"$RUBY_VERSION"* ]]; then

    echo -ne "[$YELLOW * $NC] Installing Ruby $RUBY_VERSION..."
    rvm install "$RUBY_VERSION" &>"/dev/null"

    rvm use "$RUBY_VERSION" --default &>"/dev/null"
    echo -e "\r[$GREEN + $NC] Ruby $RUBY_VERSION installed    "
fi
echo -e "[$GREEN + $NC] Installing MSF bundler"
set +u
cd "/opt/metasploit" && gem install "bundler"
set -u

sudo -u "$USER" bundle install
echo -e "[$GREEN + $NC] MSF bundler installed"

echo -ne "[$YELLOW * $NC] Initializing Metasploit database..."
CONNECTION_STRING="postgresql://postgres@localhost:5432/postgres"

sudo -u "$USER" msfdb init --connection-string="$CONNECTION_STRING" &>"/dev/null"
echo -e "\r[$GREEN + $NC] Metasploit database initialized    "

ADAPTER="  adapter: postgresql"
DATABASE="  database: postgres"
USERNAME="  username: postgres"
PASSWORD="  password:"
HOST="  host: localhost"
PORT="  port: 5432"
cat <<EOF >"$HOME/.msf4/database.yml"
production:
$ADAPTER
$DATABASE
$USERNAME
$PASSWORD
$HOST
$PORT
EOF
