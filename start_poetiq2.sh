#!/usr/bin/env bash

source ./setenv.sh

echo "Starting discovery service ..."
q torq.q -load ${KDBCODE}/processes/discovery.q ${KDBSTACKID} -proctype discovery -procname discovery1 -localtime -w 4000 -debug -new_console:nc:t:'discovery'

echo "Starting housekeeping ..."
q torq.q -load ${KDBCODE}/processes/housekeeping.q ${KDBSTACKID} -proctype housekeeping -procname housekeeping1 -localtime -w 4000 -debug -new_console:sVnc:t:'housekeeping'

echo "Starting hdb equitysim ..."
q torq.q -load ${KDBHDB}/equitysim ${KDBSTACKID} -proctype hdb -procname equitysim -localtime -g 1 -T 100 -w 4000 -debug -new_console:s2THnc:t:'equitysim'

echo "Starting gateway ..."
q torq.q -load ${KDBCODE}/processes/gateway.q ${KDBSTACKID} -proctype gateway -procname gateway1 -.servers.CONNECTIONS hdb rdb -localtime -g 1 -w 4000 -debug -new_console:s3Tnc:t:'gateway'
 