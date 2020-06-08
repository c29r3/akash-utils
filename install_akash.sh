#!/bin/sh

apt install -y git jq
cd /tmp/ && \
wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz && \
tar -C /usr/local -xzf go*.tar.gz;
echo -e '\nexport PATH=/root/go/bin:$PATH
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> /root/.profile;
. /root/.bashrc

cd ~
git clone https://github.com/ovrclk/akash.git && \
cd akash && \
git checkout v0.6.1 && \
make deps-install && \
make install
