\d .hdb

dbname:equitysim

\d .alpha

mtm:: select time: 0D24- 0D00:00:01, date, sym, close from daily
signal:: update time: 0D24- 0D00:00:01 from ungroup select date, signal: signum deltas close by sym from daily

\d .portcon

upd[`signal] :{
	x: select sym, date, sz: units[1] signal, time from x;
	(neg hbtt) (`.u.upd;`targetsz; value first x);
	}

units: {[n;x]
	n * `long$signum x
	}

wfun: `units

\d. oms

upd[`targetsz] :{
	currpos: delete cost,time from hportfolio "positions";
	delta: (select sym, sz from x) pj neg currpos;
	if[count delta; (neg hbtt) (`.u.upd;`order; value first select sym, size:sz from delta)];
	}

\d. market

upd[`order]:{
	show raze string hswitch["clock[]"],-3!x;
	now: hswitch["clock[]"];
	if[count x: delete from x where size=0;
		x:x lj select first price by sym from trade where sym in (exec sym from x), (date+time)>now;
		(neg hbtt) (`.u.upd;`fill; value first x);]
	}


\d. bt

bgn: 2016.05.02 
end: 2016.05.31 
syms: `AAPL`PRU`GOOG`MSFT