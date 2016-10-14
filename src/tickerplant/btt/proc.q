/- Example script to launch a tickerplant
/- requires kdb+tick (tick.q and tick directory) to be in the current directory
/- cd to tick directory
system"l ",getenv[`TORQHOME],"/torq.q"
.servers.startup[]
system"cd ",getenv[`MOD],"/tick"
\l backtesttick.q


