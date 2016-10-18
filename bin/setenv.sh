#!/bin/bash

# Set up environment variables

export QBIN=$(find $QHOME -type f \( -name q.exe -or -name q \) | head -n 1)

export POETIQ="$(dirname $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd))"
export KDBCODE=${POETIQ}/src
export KDBBIN=${POETIQ}/bin
export KDBCONFIG=${POETIQ}/config
export KDBLOG=${POETIQ}/logs
export KDBHDB=${POETIQ}/hdb
export KDBLIB=${POETIQ}/lib
export KDBTESTS=${POETIQ}/tests
export TORQ=${POETIQ}/torq.q

export KDBBASEPORT=5000

export KDBSTACKID="-stackid ${KDBBASEPORT}"


# if using the email facility, modify the library path for the email lib depending on OS
# e.g. linux:
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KDBLIB/l[32|64]
# e.g. osx:
# export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$KDBLIB/m[32|64]
