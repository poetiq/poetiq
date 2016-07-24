# Set up environment variables

export POETIC=$(pwd)
export KDBCODE=${POETIQ}/code
export KDBCONFIG=${POETIQ}/config
export KDBLOG=${POETIQ}/logs
export KDBHDB=${POETIC}/hdb
export KDBLIB=${POETIQ}/lib
export KDBTESTS=${POETIC}/tests
export KDBHTML=${POETIQ}/html

export POETICBASEPORT=5000

# if using the email facility, modify the library path for the email lib depending on OS
# e.g. linux:
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KDBLIB/l[32|64]
# e.g. osx:
# export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$KDBLIB/m[32|64]
