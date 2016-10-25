#!/usr/bin/env bash

echo "Starting discovery service ..."
q src/torq/process/start.q -cfg src/torq/discovery/cfg.q

# q backtest.q -cfg src/strategy/random1share.q -test