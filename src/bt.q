\d .clock

then:{etstamp + .z.p - now}

upd:{
 	.clock.etstamp:: .bt.e `etstamp;
	.clock.now:: .z.p;
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
 	.mtm.upd[];
 	.market.upd[];
 	.clock.upd[];
 	.sdt.upd[];
	    / port
	    / mtm
	.strategy.upd[];
	/ risk
	/ port constr
		/ oms
			/ market (if quotes driven)
			/ port
 }

run:{[]
	.sdt.prepschema[];
 	/ doEvent over p,d
 	{doEvent[x]} each select from .ext.queue[] where etstamp>2016.05.30;
 }

/ ************************************************************************
/todo

/ market flip procevent get rid of mthfcka
/ market process each select by priority from orders.op 
/ rename all size to sz
/ LOW PRIORITY: market order partial fills assuming some measure of overall liquidity
/ consider src/market/market.q -> src/market.q