# Run each of these commands in a separate window during debugging

source ./setenv.sh

echo "Starting tickerplant ..."
q code/processes/bttickerplant.q equitysim ${KDBHDB} ${KDBSTACKID} -trap -proctype bttickerplant -procname bttickerplant1 -localtime -debug -new_console:nc:t:'tickerplant'

echo "Starting portfolio ..."
q torq.q -load ${KDBCODE}/processes/portfolio.q ${KDBSTACKID} -trap -proctype portfolio -procname portfolio1 -.servers.CONNECTIONS bttickerplant -localtime -debug -new_console:sVnc:t:'portfolio' #</dev/null >$KDBLOG/gateway.txt 2>&1 &

#sleep 1

echo "Starting feed ..."
q torq.q -load code/tick/backtestfeed.q ${KDBSTACKID} -trap -proctype backtestfeed -procname backtestfeed1 -localtime -tbls mtm fill -bgn 2016.05.02 -end 2016.05.31 -syms AAPL PRU GOOG MSFT -debug -new_console:sH:t:'btfeed' # </dev/null >$KDBLOG/bttickerplant.txt 2>&1 & # -bgn 2016.05.02 -end 2016.05.02 -syms GOOG IBM MSFT

