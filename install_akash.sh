#!/bin/bash

BINARY_VERSION=$(curl -s https://raw.githubusercontent.com/ovrclk/net/master/mainnet/version.txt)
DEB_FILE="https://github.com/ovrclk/akash/releases/download/v$BINARY_VERSION/akash_0.12.1_linux_amd64.deb"
BIN_PATH="/usr/local/bin/akash"
CHAIN_ID=$(curl -s https://raw.githubusercontent.com/ovrclk/net/master/mainnet/chain-id.txt)
SERVICE_FILE="https://raw.githubusercontent.com/c29r3/akash-utils/master/akash.service"
CONFIG_TOML="https://raw.githubusercontent.com/c29r3/akash-utils/master/config.toml"
APP_TOML="https://raw.githubusercontent.com/c29r3/akash-utils/master/app.toml"
GENESIS_URL="https://raw.githubusercontent.com/ovrclk/net/master/mainnet/genesis.json"

# install requirements
sudo apt update
sudo apt-get install -y jq curl wget htop

# install binary
cd /tmp
wget $DEB_FILE &>/dev/null
dpkg -i akash*deb
$BIN_PATH version

# init node
$BIN_PATH init c29r3 --chain-id $CHAIN_ID

# download configs
curl -s $CHAIN_ID > $HOME/.akash/config/genesis.json
curl -s $CONFIG_TOML > $HOME/.akash/config/config.toml
curl -s $APP_TOML > $HOME/.akash/config/app.toml

# install service unit
curl -s $SERVICE_FILE > /etc/systemd/system/akash.service
sudo systemctl daemon-reload
sudo systemctl enable akash.service

# download snapshot
rm -rf ~/.akash/data
mkdir -p ~/.akash/data
cd ~/.akash/data
# random wait
SLEEP_TIME=$(shuf -i 10-300 -n 1)
echo $SLEEP_TIME
sleep $SLEEP_TIME
SNAP_NAME=$(curl -s http://135.181.60.250/akash/ | egrep -o ">$CHAIN_ID.*tar" | tr -d ">"); \
wget -O - http://135.181.60.250/akash/${SNAP_NAME} | tar xf -

# ufw rules
sudo ufw allow 28957,28959,28956,1518,9890/tcp comment "allow akash public nodes"

# start service
sudo systemctl start akash.service

