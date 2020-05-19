#!/bin/sh

apt install -y git jq
cd /tmp/ && \
wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz && \
tar -C /usr/local -xzf go*.tar.gz;
echo  'export PATH=/root/go/bin:$PATH
export GOROOT=/usr/local/go
export GOPATH=/root/go
export GO111MODULE=on 
export PATH=/root/go/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/go/bin:/usr/local/go/bin:/usr/local/go/bin:/root
export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"' >> /root/.profile;
. /root/.profile

cd ~
git clone https://github.com/ovrclk/akash.git && \
cd akash && \
git checkout v0.6.1 && \
make deps-install && \
make install
