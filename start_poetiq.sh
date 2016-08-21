#!/usr/bin/env bash

source ./setenv.sh

echo "Starting discovery service ..."
q torq.q -load ${KDBCODE}/processes/discovery.q ${KDBSTACKID} -proctype discovery -procname discovery1 -localtime </dev/null >$KDBLOG/discovery.txt 2>&1 &

echo "Starting housekeeping ..."
q torq.q -load ${KDBCODE}/processes/housekeeping.q ${KDBSTACKID} -proctype housekeeping -procname housekeeping1 -localtime </dev/null >$KDBLOG/housekeeping.txt 2>&1 &

echo "Starting hdb equitysim ..."
q torq.q -load ${KDBHDB}/equitysim ${KDBSTACKID} -proctype hdb -procname equitysim -localtime -g 1 -T 60 -w 4000 </dev/null >$KDBLOG/equitysim.txt 2>&1 &

echo "Starting gateway ..."
q torq.q -load ${KDBCODE}/processes/gateway.q ${KDBSTACKID} -proctype gateway -procname gateway1 -.servers.CONNECTIONS hdb rdb -localtime -g 1 -w 4000 </dev/null >$KDBLOG/gateway.txt 2>&1 &
