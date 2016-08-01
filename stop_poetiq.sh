#!/usr/bin/env bash

source ./setenv.sh

echo "Shutting down Poetiq ..."
q torq.q -load ${KDBCODE}/processes/kill.q -proctype kill -procname killpoetiq -.servers.CONNECTIONS housekeeping hdb p discovery gateway </dev/null >$KDBLOG/kill.txt 2>&1 &