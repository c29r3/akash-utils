#!/bin/bash

SELF_ADDR="WALLET_ADDRESS"
OPERATOR="OPERATOR_ADDRESS"
WALLET_NAME="akash"
CHAIN_ID="akashnet-2"
WALLET_PWD="PASSWORD"
BIN_FILE="/usr/local/bin/akash"
TOKEN="uakt"


while true; do
    # withdraw reward
    echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx distribution withdraw-rewards $OPERATOR --commission --fees 1000$TOKEN --chain-id $CHAIN_ID --from $WALLET_NAME -y

    sleep 10

    # check current balance
    BALANCE=$($BIN_FILE q bank balances $SELF_ADDR -o json | jq -r .balances[0].amount)
    echo CURRENT BALANCE IS: $BALANCE

    RESTAKE_AMOUNT=$(( $BALANCE - 5000000 ))

    if (( $RESTAKE_AMOUNT >=  25000000 ));then
        echo "Let's delegate $RESTAKE_AMOUNT of REWARD tokens to $SELF_ADDR"
        # delegate balance
        echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx staking delegate $OPERATOR "$RESTAKE_AMOUNT"$TOKEN --fees 3000$TOKEN --chain-id $CHAIN_ID --from $WALLET_NAME -y

    else
        echo "Reward is $RESTAKE_AMOUNT"
    fi
    echo "DONE"
    sleep 10800
done
