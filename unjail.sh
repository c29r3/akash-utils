#!/bin/bash

WALLET_NAME=akash
CHAIN_ID="akash-edgenet-1"
CLI="/usr/local/bin/akash"
RPC="http://localhost:26657"
COIN="uakt"
PSWD=$1
SELF_ADDR=$(echo -e "$PSWD\n" | akash keys list | grep "address:" | awk '{print $2}')

while true; 
do 
    OPERATOR=$($CLI q staking delegations -o json --node $RPC --chain-id $CHAIN_ID $SELF_ADDR | jq -r .delegation_responses[0].delegation.validator_address)
    STATUS=$($CLI query staking validator $OPERATOR --chain-id=$CHAIN_ID --node $RPC -o json | jq -r .jailed)
    echo "Status $STATUS"
    if [[ "$STATUS" == "true" ]]; then
        echo "UNJAIL"
        echo -e "$PSWD\n" | $CLI tx slashing unjail --from $WALLET_NAME --node $RPC --gas-adjustment="1.5" --gas="200000" --fees 5000$COIN --chain-id=$CHAIN_>
    fi
    sleep 300
done
