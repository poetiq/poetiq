#!/usr/bin/env bash

source ./setenv.sh

echo "Shutting down backtest ..."
q torq.q -load ${KDBCODE}/processes/kill.q -proctype kill -procname killpoetiq -.servers.CONNECTIONS bttickerplant backtestfeed </dev/null >$KDBLOG/kill.txt 2>&1 &
