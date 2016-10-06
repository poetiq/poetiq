/- Example script to launch a tickerplant
/- requires kdb+tick (tick.q and tick directory) to be in the current directory
/- cd to tick directory
system"l ",getenv[`POETIQ],"/torq.q"
.servers.startup[]
system"cd ",getenv[`KDBCODE],"/tick"
\l backtesttick.q


