#!/usr/bin/env bash

source ./setenv.sh

echo "Shutting down Poetiq ..."
q kill.q $((${POETIQBASEPORT}+1)) </dev/null >$KDBLOGS/kill.txt 2>&1 &
