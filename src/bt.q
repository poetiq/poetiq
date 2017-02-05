\d .clock

then:{etstamp + .z.p - now}

now:{.clock.etstamp} /.z.p;

upd:{
	.timer.loop[`timer.job;.bt.e `etstamp];
 	.clock.etstamp:: .bt.e `etstamp;
 }

event.schedule:{
	.timer.add[`timer.job;`mtm; count[ms]#{.clock.etstamp::x; .port.upd.mtm[];::}; ms:events.mtm[]];
	.clock.etstamp::exec last time from `timer.job
 }

/
timer:{
	timer.checks::asc timer.checks,:"t"$y;
}
timer.check:{
	first where .clock.etstamp>=timer.checks
 }
\
\d .bt
/fromto: "p"$2015.05m 2015.06m 
groupbytstamp: {
	if[notstamp: not `tstamp in cols x; x:update tstamp:"p"$1 + date from x]; / if missing, infer tstamp column from date column. TODO: parametrize the delay
	x:select from x where tstamp within .bt.fromto;
	?[x;();(enlist `etstamp)!enlist `tstamp; allc!allc:cols[x] except $[notstamp;`tstamp;`]]  / except `tstamp
 }
transfev:{
	select event:x, etstamp, data:flip value flip value grpd from grpd:groupbytstamp `dt[x]}

queue: {
	/$[`fromto in key `.bt; q::select from queue[] where etstamp within "p"$get `.bt.fromto; q::queue[]]
	q:`etstamp xasc (,/){transfev[x]} each 1_key `dt;
	.calendar.trading.days:: exec distinct "d"$tstamp from `dt.trades;
	.clock.event.schedule[];
 	q};

ecounter:0;

doEvent:{[event]
 	e::event;
 	ecounter+::1;
 	f:cols .schema[event`event];
 	x:event`data;
 	data::$[0>type first x;enlist f!x;flip f!x];
 	/.lg.tic[];.port.upd.mtm[]; .lg.toc[`port.upd];
 	/.lg.tic[];.market.upd[event`event; .bt.data]; .lg.toc[`market.upd];
 	.log.blot["**pos**";get `pos];
 	/.market.upd[event`event; .bt.data];
	    / port
	    / mtm
	/.strategy.upd[];
	/.lg.tic[];.oms.upd[event`event; .bt.data];.lg.toc[` sv `oms.upd, event`event];
	/.lg.tic[];
	.oms.upd[event`event; .bt.data];
	/.lg.toc[`oms];  .lg.tic[];
	.market.upd[event`event; .bt.data];
	/.lg.toc[`market];  .lg.tic[];
	.clock.upd[];
	/.lg.toc[`clock]; 
	/ risk
	/ port constr
		/ oms
			/ market (if quotes driven)
			/ port
 }

run:{[]
 	.dt.prepschema[];
 	/.oms.upd.newsym asc exec distinct sym from `dt.trades; / O(n) scaling by number of symbols. (15000?`4), +1000 syms cost ~+4 seconds 
 	{doEvent[x]} each queue[];
 }

/ ************************************************************************
/todo

/ market process each select by priority from orders.op 
/ rename all size to sz
/ LOW PRIORITY: market order partial fills assuming some measure of overall liquidity
/ .clock.upd queue remove (adds 3 seconds)