#!/usr/bin/env bash

source bin/setenv.sh

echo "Starting discovery service ..."
q torq.q -load ${KDBCODE}/processes/discovery.q ${KDBSTACKID} -proctype discovery -procname discovery1 -localtime -debug -new_console:nc:t:'discovery' #</dev/null >$KDBLOG/discovery.txt 2>&1 &

echo "Starting housekeeping ..."
q torq.q -load ${KDBCODE}/processes/housekeeping.q ${KDBSTACKID} -proctype housekeeping -procname housekeeping1 -localtime -debug -new_console:sVnc:t:'housekeeping' #</dev/null >$KDBLOG/housekeeping.txt 2>&1 &

echo "Starting backtest control ..."
q torq.q -load ${PROC}/btctrl.q ${KDBSTACKID} -trap -proctype btctrl -procname btctrl1 -localtime -debug -new_console:s2THnc:t:'btctrl' -e 1 -.clients.enabled 0 -.usage.enabled 0 #-.zpsignore.enabled 0

echo "Starting tickerplant ..."


# Proposed new setup

# source bin/control.sh

# startp discovery discovery1					--debug --args -new_console:nc:t:'discovery'
# startp housekeeping housekeeping1		--debug --args -new_console:sVnc:t:'housekeeping'
# startp btctrl btctrl1 							--debug	--args -new_console:s2THnc:t:'btctrl'
# startp bttickerplant bttickerplant1	--debug --args -new_console:nc:t:'tickerplant'
