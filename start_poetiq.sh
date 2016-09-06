#!/usr/bin/env bash

source ./setenv.sh

echo "Starting discovery service ..."
q torq.q -load ${KDBCODE}/processes/discovery.q ${KDBSTACKID} -proctype discovery -procname discovery1 -localtime -debug -new_console:nc:t:'discovery' #</dev/null >$KDBLOG/discovery.txt 2>&1 &

echo "Starting housekeeping ..."
q torq.q -load ${KDBCODE}/processes/housekeeping.q ${KDBSTACKID} -proctype housekeeping -procname housekeeping1 -localtime -debug -new_console:sVnc:t:'housekeeping' #</dev/null >$KDBLOG/housekeeping.txt 2>&1 &

echo "Starting hdb equitysim ..."
q torq.q -load ${KDBHDB}/equitysim ${KDBSTACKID} -proctype hdb -procname equitysim -localtime -g 1 -T 60 -w 4000 -debug -new_console:s2THnc:t:'equitysim' #</dev/null >$KDBLOG/equitysim.txt 2>&1 &

echo "Starting gateway ..."
q torq.q -load ${KDBCODE}/processes/gateway.q ${KDBSTACKID} -proctype gateway -procname gateway1 -.servers.CONNECTIONS hdb rdb -localtime -g 1 -w 4000 -debug -new_console:s3THnc:t:'gateway' #</dev/null >$KDBLOG/gateway.txt 2>&1 &
