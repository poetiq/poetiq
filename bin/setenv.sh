#!/bin/bash

# Set up environment variables

export QBIN=$(find $QHOME -name q -type f)

export POETIQ="$(dirname $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd))"

export TORQHOME=../TorQ
export KDBCONFIG=${TORQHOME}/config
export KDBCODE=${TORQHOME}/code
export KDBLOG=${TORQHOME}/logs
export KDBHTML=${TORQHOME}/html
export KDBLIB=${TORQHOME}/lib

export KDBAPPCONFIG=${POETIQ}/config
export KDBHDB=${POETIQ}/hdb
export MOD=${POETIQ}/src
export PROC=${POETIQ}/src/processes

export KDBTESTS=${POETIQ}/tests

export KDBBASEPORT=5000

export KDBSTACKID="-stackid ${KDBBASEPORT}"

cd ${TORQHOME}


# if using the email facility, modify the library path for the email lib depending on OS
# e.g. linux:
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KDBLIB/l[32|64]
# e.g. osx:
# export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$KDBLIB/m[32|64]
