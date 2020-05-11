#!/bin/bash
# require jq and bc
# apt install -y jq bc

PWD="YOUR_PASS"
VALIDATOR_ADDR="akashvaloper..."
TEAM_NAME="team"

# last time when stake fee was edited
LST_EDIT=$(akashctl query staking validator $VALIDATOR_ADDR --chain-id centauri --trust-node -o json | jq -r '.commission.update_time' | date -f - +"%s")
# last + 24 hours
NEXT_EDIT=$(($LST_EDIT+86400))
CURRENT_TIME=$(date +"%s")

echo -e "Last edit time: $(date -d @$LST_EDIT) --> Fee change time: $(date -d @$NEXT_EDIT)"

if ((CURRENT_TIME > NEXT_EDIT)); then
    CUR_FEE=$(akashctl query staking validator $VALIDATOR_ADDR --chain-id centauri --trust-node -o json | jq -r '.commission.commission_rates.rate')
    NEW_FEE=$(echo -e "0$(echo "$CUR_FEE+0.01" | bc -l)")

    echo -e "\e[92mCURRENT_FEE=$CUR_FEE --> NEW_FEE=$NEW_FEE\e[0m"
    echo -e "$PWD\n$PWD\n" | akashctl tx staking edit-validator --from $TEAM_NAME --commission-rate $NEW_FEE --chain-id centauri -y

else
    echo "It is too early"
    fi
