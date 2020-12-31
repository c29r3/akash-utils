#!/bin/bash

SELF_ADDR="akash..."
OPERATOR="akashvaloper..."
WALLET_NAME="akash"
CHAIN_ID="akashnet-1"
WALLET_PWD="PASSWD"
BIN_FILE="/usr/local/bin/akashctl"
TOKEN="uakt"


while true; do
    # withdraw reward
    echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx distribution withdraw-rewards $OPERATOR --commission --fees 1000$TOKEN --chain-id $CHAIN_ID --from $WALLET_NAME -y

    sleep 10

    # check current balance
    BALANCE=$($BIN_FILE query account $SELF_ADDR -o json | jq -r .value.coins[0].amount)
    echo CURRENT BALANCE IS: $BALANCE

    RESTAKE_AMOUNT=$(( $BALANCE - 50000000 ))

    if (( $RESTAKE_AMOUNT >=  25000000 ));then
        echo "Let's delegate $RESTAKE_AMOUNT of REWARD tokens to $SELF_ADDR"
        # delegate balance
        echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx staking delegate $OPERATOR "$RESTAKE_AMOUNT"$TOKEN --fees 1000$TOKEN --chain-id $CHAIN_ID --from $WALLET_NAME -y

    else
        echo "Reward is $RESTAKE_AMOUNT"
    fi
    echo "DONE"
    sleep 86400
done
