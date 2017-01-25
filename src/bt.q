\d .clock

then:{etstamp + .z.p - now}

upd:{
 	.clock.etstamp:: .bt.e `etstamp;
	.clock.now:: .z.p;
 }

\d .bt

groupbytstamp: {
	if[notstamp: not `tstamp in cols x; x:update tstamp:"p"$1 + date from x]; / if missing, infer tstamp column from date column. TODO: parametrize the delay
	?[x;();(enlist `etstamp)!enlist `tstamp; allc!allc:cols[x] except $[notstamp;`tstamp;`]]  / except `tstamp
 }
transfev:{select event:x, etstamp, data:flip value flip value grpd from grpd:groupbytstamp `dt[x]}
queue: {`etstamp xasc (,/){transfev[x]} each 1_key `dt}

ecounter:0;

doEvent:{[event]
 	e::event;
 	ecounter+::1;
 	f:cols .schema[event`event];
 	x:event`data;
 	data::$[0>type first x;enlist f!x;flip f!x];
 	/.lg.tic[];.port.upd.mtm[]; .lg.toc[`port.upd];
 	/.lg.tic[];.market.upd[event`event; .bt.data]; .lg.toc[`market.upd];
 	.port.upd.mtm[];
 	.market.upd[event`event; .bt.data];
 	.clock.upd[];
	    / port
	    / mtm
	/.strategy.upd[];
	/.lg.tic[];.oms.upd[event`event; .bt.data];.lg.toc[` sv `oms.upd, event`event];
	.oms.upd[event`event; .bt.data];
	/ risk
	/ port constr
		/ oms
			/ market (if quotes driven)
			/ port
 }

run:{[]
 	.dt.prepschema[];
 	.oms.upd.newsym asc exec distinct sym from `dt.trades; / O(n) scaling by number of symbols. (15000?`4), +1000 syms cost ~+4 seconds 
 	update `u#sym from `pos;
 	{doEvent[x]} each select from queue[];
 }

/ ************************************************************************
/todo

/ market process each select by priority from orders.op 
/ rename all size to sz
/ LOW PRIORITY: market order partial fills assuming some measure of overall liquidity