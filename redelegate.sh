#!/bin/bash

SELF_ADDR="akash..."
OPERATOR="akashvaloper..."
WALLET_NAME="teamname"
WALLET_PWD="pwd"
BIN_FILE="/root/go/bin/akashctl"

# withdraw reward
echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx distribution withdraw-rewards $OPERATOR --commission --chain-id centauri --from $WALLET_NAME -y
sleep 5

# check current balance
BALANCE=$($BIN_FILE query account $SELF_ADDR -o json | jq .value.coins[0].amount | tr -d '"')
echo CURRENT BALANCE IS: $BALANCE

if (( $BALANCE >=  2 ));then
    echo "Let's delegate $REWARD of REWARD tokens to $SELF_ADDR"
    # delegate balance
    echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BIN_FILE tx staking delegate $OPERATOR "$REWARD"uakt --chain-id centauri --from $WALLET_NAME -y

else
    echo "Reward is $REWARD"
fi
echo "DONE"
