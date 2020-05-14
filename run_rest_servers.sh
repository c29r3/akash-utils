#!/bin/bash

tmux new-session -d -s 1317 'akashctl rest-server --laddr --max-open 30000'

tmux new-session -d -s 1318 'akashctl rest-server --laddr tcp://localhost:1318 --node tcp://139.178.89.117:26657 --trust-node --max-open 30000'

tmux new-session -d -s 1319 'akashctl rest-server --laddr tcp://localhost:1319 --node tcp://157.245.119.72:26657 --trust-node --max-open 30000'
