#!/bin/bash

VERSION=$1
if [ "$VERSION" == "" ]; then
    VERSION="0.14.0"
fi
echo $GO_VERSION

URL=https://github.com/ovrclk/akash/releases/download/v${VERSION}/akash_${VERSION}_linux_amd64.zip
BIN_PATH=$HOME/go/bin/
BIN_NAME=akash

sudo systemctl stop ${BIN_NAME}

sudo apt-get update && sudo apt-get install -y unzip

cd ${BIN_PATH}

rm ${BIN_NAME}

wget ${URL}

unzip *zip

mv ${BIN_NAME}_*/akash .

chmod 700 akash

rm -rf ${BIN_NAME}_*

sudo systemctl start ${BIN_NAME}

sudo systemctl status ${BIN_NAME}