#!/bin/bash

WALLET_NAME=akash
CHAIN_ID="akashnet-1"
CLI="/usr/local/bin/akashctl"
RPC="http://localhost:26657"
COIN="uakt"
TG_TOKEN=""
CHAT_ID="11111111"
PASSWD="PSWD"
SUBJECT="AKASH"

SELF_ADDR=$(echo -e "$PASSWD\n" | akashctl keys list -o json | jq -r .[0].address)

while true; 
do 
    OPERATOR=$($CLI q staking delegations -o json --node $RPC --chain-id $CHAIN_ID $SELF_ADDR | jq -r .[0].validator_address)
    STATUS=$($CLI query staking validator $OPERATOR --chain-id=$CHAIN_ID --node $RPC -o json --trust-node | jq -r .jailed)
    echo "Status $STATUS"
    if [[ "$STATUS" == "true" ]]; then
        echo "UNJAIL"
        if [[ $TG_TOKEN != "" ]]
        then
            MSG="Validator status = $STATUS"
            $(which curl) -s -H 'Content-Type: application/json' --request 'POST' -d "{\"chat_id\":\"${CHAT_ID}\",\"text\":\"${SUBJECT}\n${MSG}\"}" "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
        fi
        echo -e "$PASSWD\n$PASSWD\n" | $CLI tx slashing unjail --from $WALLET_NAME --node $RPC --gas-adjustment="1.5" --gas="200000" --fees 5000$COIN --chain-id=$CHAIN_ID -y
    fi
    sleep 300
done
