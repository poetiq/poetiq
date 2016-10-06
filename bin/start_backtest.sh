# Run each of these commands in a separate window during debugging

source ./setenv.sh

echo "Starting tickerplant ..."
q ${KDBCODE}/processes/bttickerplant.q equitysim ${KDBHDB} ${KDBSTACKID} -proctype bttickerplant -procname bttickerplant1 -localtime </dev/null >$KDBLOG/bttickerplant.txt 2>&1 &

# echo "Starting portfolio tracker ..."
# q torq.q -load ${KDBCODE}/processes/p.q ${KDBSTACKID} -proctype p -procname p1 -localtime -debug

# echo "Starting test algorithm ..."
# q torq.q -load ${KDBCODE}/algorithms/test.q ${KDBSTACKID} -proctype alphamodel -procname alpha1 -localtime -debug

# echo "Starting Order Management System ..."
# q torq.q -load ${KDBCODE}/processes/oms.q ${KDBSTACKID} -proctype oms -procname oms1 -localtime </dev/null >$KDBLOG/oms.txt 2>&1 &

# echo "Starting example subscriber ..."
# q code/tick/tick/cx.q last 5011
# q code/tick/tick/cx.q last 5014

echo "Starting feed ..."
q torq.q -load ${KDBCODE}/tick/backtestfeed.q ${KDBSTACKID} -proctype backtestfeed -procname backtestfeed1 -localtime -tbls quote trade -bgn 2016.05.02 -end 2016.05.02 -syms GOOG IBM MSFT </dev/null >$KDBLOG/bttickerplant.txt 2>&1 &

# echo "Starting simulated feed ..."
# q torq.q -load code/tick/simfeed.q ${KDBSTACKID} -proctype simfeed -procname simfeed1 -localtime -debug

echo "Starting bundler ..."
q torq.q -load ${KDBCODE}/processes/bundler.q ${KDBSTACKID} -proctype bundler -procname bundler1 -localtime -debug
