/ q bt.q -cfg src -strat strategy/sma.q -p 5000

\l src/ta.q
\l F:/hdb/equitysim


/ rebalance when new signal arrives to equal weights

sig: select last price by value sym, date from trade / retrieve prices daily, locf regularisation
sig: update ma:mavg[2;price] by sym from sig  / long signal if price > mavg; add crossover indicator
sig: update xo: .ta.xover[price; ma] by sym from sig
sig: update followsxover: 1 < sums 1=xo by sym from sig / counts the crossovers chronologically. exclude initial long signals that precede the first true crossover
dt.signal: select sym, date, signal: xo>0 from sig where xo<>0, followsxover / order management system collects signals. Doesn't necessarily trade them
dt.rebal: select tstamp: "p"$1+date, date from sig where xo=1, followsxover / rebalance events defined. Trigger trading the current signal

/ order management system will calculate target weights based on prevailing signal (alpha, possibly optimisation task).

weight: { long % sum long:x>0} / equal weight longs. Ignore shorts (negative signals)

/ Definition of this will be wrapped under the hood. 
dt.trades: select tstamp:`timestamp$date+1, value sym, price:close from daily where sym in distinct dt.signal.sym
