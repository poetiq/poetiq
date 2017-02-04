\d .lg
lt:([]ltype:"s"$();llevel:"s"$();syststamp:"p"$();tstamp:"p"$(); etstamp:"p"$(); ecounter: "i"$();message:())

ll:`d`i`w`e`n;
level:`e;
l:{[l;t;m] if[(ll?l)>=ll?level; `.lg.lt insert (t;l; .z.p;.clock.now[]; .bt.e `etstamp ; .bt.ecounter;-3!m)];}
dump:{(`$":log/", ssr[string .z.p; ":"; "."] ,"/lt.xls") 0:.h.tx[`xls;lt];} /dump

tm:([] tspan:"n"$(); fun:"s"$())

tic:{zp::.z.p}
toc:{`.lg.tm insert (.z.p - zp;x)}

/new implementation. Depends on (Psaris) log.q 
\d .log
t: flip `tstamp`data!"p*"$\:()
upd:{if[5<=lvl; `.log.t insert (.z.p;-3!x)];}
dump: {
	/x:ssr[.Q.ty each value flip x;"d";"C"]$/:x; / recast date to string (excel can't import)
	if[count[x] & 5<=lvl; h 0:.h.tx[`xls;update ssr[;".";"-"] each string date, string tstamp from x];-1"Log written."];}

\d .blot

ttypes: "sdsjffffp*"
t: flip `event`date`sym`sz`px`pnl`val`cost`tstamp`misc!ttypes$\:()
tcols: cols[t] except `event`date`misc;

upd:{
	if[not 5<=.log.lvl;:()];
	bcols: cols[y] inter tcols;
	acols: cols[y] except bcols;
	nacols:tcols except bcols;
	c:(); / constraints
	b:(bcols,nacols)!bcols, raze 1#/:(ttypes where cols[t] in nacols)$\:(); /count[nacols]#enlist enlist`; 
	a:enlist[`misc]!enlist $[count[acols]; (!;-3;(flip;(!;enlist acols;(enlist, acols)))); ""];
	`.blot.t insert cols[t] xcols update event:`$x, date:"d"$.bt.e.etstamp from 0!?[y;c;b;a];
 }

add:{} / add table to blotter, resort by date time

`.log.blot set .blot.upd;

\d .
blotter::.blot.t