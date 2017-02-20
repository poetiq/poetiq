/ launches backtest from command line
\l init.q

.log.h: `:f:/log.xls
.log.lvl:2

/.bt.fromto: 2014.07 2014.08m
/.bt.fromto: -0W 1984.01.01

.lg.tic[];
if[not (::)~`.[`dt]; .bt.run[];];
.lg.toc[`bt];

-1 raze "Elapsed: ", string exec sum `time$tspan from .lg.tm where fun in `bt`strat;
-1 raze "Last equity: ", string last port.equity.curve[`ec];

\l F:/qecvis/ec.q

.log.dump[blotter];