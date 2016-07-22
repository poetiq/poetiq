#!/usr/bin/env bash

source ./setenv.sh

echo "Shutting down Poetic ..."
q kill.q $((${POETICBASEPORT}+1)) </dev/null >$KDBLOGS/kill.txt 2>&1 &
