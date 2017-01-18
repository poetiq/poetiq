/ q bt.q -cfg src -strat strategy/strategy1.q -p 5000
/\l C:/Projects/q/hdb/equitysim
\l F:/hdb/equitysim

sig: select last price by sym, date from trade / retrieve prices daily, locf regularisation
sig: update ma:mavg[2;price] by sym from sig  / long signal if price > mavg; add crossover indicator
sig: update xo: .ta.xover[price; ma] by sym from sig
sig: update mustfollowxover: 1 < sums 1=xo by sym from sig / counts the crossovers chronologically. exclude initial long signals that precede the first true crossover
sig: update rebalance: xo and mustfollowxover by sym from sig 
sig: select date, sym, rebalance from sig where price>ma, mustfollowxover 
sig: select date, sym, signal:1 from sig where rebalance=1 


sig: aj[`sym`date; (select distinct sym from sig) cross (`date xasc select distinct date from sig) ;sig]

ungroup select sym, w: w signal by date from sig

cross
w: {x%sum x}
w 0N 1 1




select date by sym from sig where 1=rebalance 

/ rebalance when new signal arrives to equal weights
rebalance: 

dt.fundamental: select date, sym, data:abs (rand each count[daily]#0h)%10000,indicator:`PE, tstamp:"p"$date from daily

dt.targetsz: ungroup select tstamp, sz:signum deltas price by sym from dt.trades


/ live trading version:

\d .alpha
dif: { select signal:last deltas price by sym from `.dt[`trades]}
calc.fun: .alpha.dif

\d .risk

\d .portcon
calc.fun:{[alpha] (`targetsz;select sym, sz:signum signal from alpha) } / (type;data); where type is targetsz or targetw

