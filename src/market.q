
\d .market
lastpx:(enlist `)!(enlist 0nf) / last traded price for each symbol
source:`trades;
last.quotes:()!();
orderid: 0;
opensyms:`u#`$() / list of symbols which have at least one open order in the orderbook
sides:(1;-1)!(`buy`sell)
sidescode:(`buy`sell)!(1;-1)
obook: ()!()
obook[`]:()!()
obook[`;`]:()!()


/obook: enlist `buy`sell!(1 2; 3 4)

/update 15#enlist `buy`sell!(1 2; 3 4) from pos
/count pos
genorderid:{:orderid+::1}
genorderids:{ orderid:: last ret:1 + orderid + til x; ret }

.market.upd.trades:{
	/.lg.tic[];
	if[any x[`sym] in opensyms;filled:execute[.bt.e`event;`mkt;x]]; /,execute[t;`lmt][x];
	/.lg.tic[];
	/lastpx[x`sym]:x`price; 
	`pos upsert 1!select sym,lastpx:price from x;
	/.lg.toc[`market.lastpx];
	/.lg.toc[`market.upd.inside];
 }

/ add to book, track number of open orders per symbol
neworders:{
	x:update size: abs size, side: .market.sides[signum size] from x;
	/.lg.l[`i;`market.neworders;x];
	{obook[x`otype;x`sym;x`side],:enlist x} each x;
	if[count x[`sym] except opensyms;
	opensyms::`u#distinct opensyms,x[`sym]
	]; 
 }

sendorder:{[o]
 	send[source;first o`otype][o]; / refactor for multi-type lists of o
 }

cancelorder:{[o]
	break;
 }

send.trades.mkt:{
 	neworders[x];
 }

send.trades.lmt:{
 	:()!()
 }

/ assuming full fills
execute.trades.mkt:{
	/.lg.tic[];
	s: x[`sym] inter opensyms;
	/.lg.tic[];
	o: raze {select id, sym, size:.market.sidescode[side]*size from (,/)value x} each obook[`mkt;s]; / orders to be filled
	/.lg.toc[`execute.o];.lg.tic[];
	f: o lj select last price, last tstamp by sym from x; / filled
 	/.lg.toc[`execute.f];.lg.tic[];
 	{ obook[`mkt;x;`buy]: (); 
 	  obook[`mkt;x;`sell]: (); } each s;
 	/.lg.toc[`execute.s];.lg.tic[];
 	opensyms::`u#opensyms except s;
 	orders.onfilled[f];
 	/.lg.toc[`execute.orders.onfilled];
 	/.lg.toc[`market.execute];
 }

execute.trades.lmt:{
 }

/ send to portfolio
orders.onfilled:{ 
	.oms.upd[`fill;x];
 }

orders.oncanceled:{
 	.oms.upd[`canc;x];
 }

/
edge case: two trades on the same symbol and tick as x in execute.trades.mkt
`event`etstamp`data!(`trades;2016.05.03D15:59:53.986000000;(`ORCL`ORCL;35.23 35.21;39 81;2016.05.03D15:59:53.986000000 2016.05.03D15:59:53.986000000))

/L:(`mkt;`AAPL;`sell)
/.[`obook;L;:;(`side`sym`size)!(`sell;`AAPL;1)]
/obook[`mkt;`AAPL;`buy]
/obook[`mkt;`GOOG;`buy]
/obook[`mkt;`GOOG;`buy]
/obook[`mkt;;`buy]
/obook[`mkt]