\d .clock

then:{etstamp + .z.p - now}

upd:{
 	.clock.etstamp:: .bt.e `etstamp;
	.clock.now:: .z.p;
 }

\d .strategy
upd:{
	.oms.calc.fun . .portcon.calc.fun .alpha.calc.fun[];
 }

\d .bt

init:{[]
 ;
 .ps.init[tables `.dt];
 }

ecounter:0;

doEvent:{[event]
 	e::event;
 	ecounter+::1;
 	f:cols .eschema[event`event];
 	x:event`data;
 	data::$[0>type first x;enlist f!x;flip f!x];
 	/.lg.toc[`doEvent.data];
 	/.lg.tic::.z.p;.mtm.upd[]; .lg.toc[`mtm.upd];
 	/.lg.tic::.z.p;.market.upd[]; .lg.toc[`market.upd];
 	/.lg.tic::.z.p;.sdt.upd[];.lg.toc[`sdt.upd];
 	.mtm.upd[];
 	.market.upd[];
 	.clock.upd[];
 	.sdt.upd[];
	    / port
	    / mtm
	/.strategy.upd[];
	.oms.upd[];
	/ risk
	/ port constr
		/ oms
			/ market (if quotes driven)
			/ port
 }

run:{[]
	.sdt.prepschema[];
 	{.dt[x]:y} . .strategy.precalc.fun[];
 	{doEvent[x]} each select from .ext.queue[] where etstamp>2016.05.25;
 }

/ ************************************************************************
/todo

/ market flip procevent get rid of
/ market process each select by priority from orders.op 
/ rename all size to sz
/ LOW PRIORITY: market order partial fills assuming some measure of overall liquidity
/ consider src/market/market.q -> src/market.q