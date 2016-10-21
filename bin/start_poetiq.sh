#!/usr/bin/env bash

echo "Starting discovery service ..."
q src/torq/startp.q -cfg src/torq/discovery.q

# q backtest.q -cfg src/strategy/random1share.q -test