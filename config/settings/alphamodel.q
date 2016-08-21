\d .eng
mode:$[null m:`$first .proc.params[`mode];`backtest;m];
window:100

\d .proc
loadprocesscode:1b

\d .servers
STARTUP:1b
CONNECTIONS:`backtester`oms

\d .lg
if[`test~.eng.mode;outmap[`INF]:0]
