#!/bin/bash

BINARY_VERSION=$(curl -s https://raw.githubusercontent.com/ovrclk/net/master/mainnet/version.txt)
DEB_FILE="https://github.com/ovrclk/akash/releases/download/v$BINARY_VERSION/akash_${BINARY_VERSION}_linux_amd64.deb"
BIN_PATH="/usr/local/bin/akash"
CHAIN_ID=$(curl -s https://raw.githubusercontent.com/ovrclk/net/master/mainnet/chain-id.txt)
SERVICE_FILE="https://raw.githubusercontent.com/c29r3/akash-utils/master/akash.service"
CONFIG_TOML="https://raw.githubusercontent.com/c29r3/akash-utils/master/config.toml"
APP_TOML="https://raw.githubusercontent.com/c29r3/akash-utils/master/app.toml"
GENESIS_URL="https://raw.githubusercontent.com/ovrclk/net/master/mainnet/genesis.json"

# install requirements
sudo apt-get update
sudo apt-get install -y jq curl wget htop pv bc

# install binary
cd /tmp
rm akash*deb
wget $DEB_FILE &>/dev/null
dpkg -i akash*deb
$BIN_PATH version

echo "init node"
$BIN_PATH init c29r3 --chain-id $CHAIN_ID

echo "download configs"
curl -s $GENESIS_URL > $HOME/.akash/config/genesis.json
curl -s $CONFIG_TOML > $HOME/.akash/config/config.toml
curl -s $APP_TOML > $HOME/.akash/config/app.toml

echo "install service unit"
curl -s $SERVICE_FILE > /etc/systemd/system/akash.service
sudo systemctl daemon-reload
sudo systemctl enable akash.service

echo "download snapshot"
rm -rf ~/.akash/data
mkdir -p ~/.akash/data
cd ~/.akash/data

RANDOM_IP=$(curl -s https://gist.githubusercontent.com/c29r3/1a8a951008b19aaa424d63d15cf528d8/raw/910b3ab34bcceb2b3e9bca0765a92461bafc53f8/akash-snapshot-mirrors | shuf | head -n1); \
SNAP_NAME=$(curl -s $RANDOM_IP/akash/ | egrep -o ">akashnet-2.*tar" | tr -d ">"); \
wget -O - $RANDOM_IP/akash/${SNAP_NAME} | tar xf -

#echo "ufw rules"
#sudo ufw allow 28957,28959,28956,1518,9890/tcp comment "allow akash public nodes"

echo "start service"
sudo systemctl start akash.service
