/ q bt.q -cfg src -strat strategy/strategy1.q -p 5000
/\l C:/Projects/q/hdb/equitysim
\l F:/hdb/equitysim

dt.trades: select value sym, price, size, tstamp: time + date from trade
dt.fundamental: select date, sym, data:abs (rand each count[daily]#0h)%10000,indicator:`PE, tstamp:"p"$date from daily

dt.targetsz: ungroup select tstamp, sz:signum deltas price by sym from dt.trades


/ live trading version:

\d .alpha
dif: { select signal:last deltas price by sym from `.dt[`trades]}
calc.fun: .alpha.dif

\d .risk

\d .portcon
calc.fun:{[alpha] (`targetsz;select sym, sz:signum signal from alpha) } / (type;data); where type is targetsz or targetw

