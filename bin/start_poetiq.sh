#!/usr/bin/env bash

source bin/setenv.sh

echo "Starting discovery service ..."
q torq.q -load ${KDBCODE}/processes/discovery.q ${KDBSTACKID} -proctype discovery -procname discovery1 -localtime -debug -new_console:nc:t:'discovery' #</dev/null >$KDBLOG/discovery.txt 2>&1 &

echo "Starting housekeeping ..."
q torq.q -load ${KDBCODE}/processes/housekeeping.q ${KDBSTACKID} -proctype housekeeping -procname housekeeping1 -localtime -debug -new_console:sVnc:t:'housekeeping' #</dev/null >$KDBLOG/housekeeping.txt 2>&1 &

echo "Starting backtest control ..."
q torq.q -load ${PROC}/btctrl.q ${KDBSTACKID} -trap -proctype btctrl -procname btctrl1 -localtime -debug -new_console:s2THnc:t:'btctrl' -e 1 -.clients.enabled 0 -.usage.enabled 0 #-.zpsignore.enabled 0

echo "Starting tickerplant ..."
q ${PROC}/bttickerplant.q equitysim ${KDBHDB} ${KDBSTACKID} -trap -proctype bttickerplant -procname bttickerplant1 -localtime -debug -new_console:nc:t:'tickerplant' -e 1 -c 25 200