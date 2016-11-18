\d .market
source:`trades;
last.quotes:()!();
lastpx:()!(); / last traded price for each symbol
orderid: 0;
genorderid:{:orderid+::1}
genorderids:{ orderid:: last ret:1 + orderid + til x; ret }
opensyms:`u#`$() / list of symbols which have at least one open order in the orderbook
sides:(1;-1)!(`buy`sell)
sidescode:(`buy`sell)!(1;-1)
obook: ()!()
obook[`]:()!()
obook[`;`]:()!()

upd:{
	if[.bt.e[`event] in `trades`quotes;
		if[any .bt.data[`sym] in opensyms;filled:execute[.bt.e`event;`mkt][.bt.data]]; /,execute[t;`lmt][x];
 		lastpx[.bt.data`sym]:.bt.data`price;
 		];
 }

/ add to book, track number of open orders per symbol
neworders:{
	x:update size: abs size, side: .market.sides[signum size] from x;
	/.lg.l[`i;`market.neworders;x];
	{obook[x`otype;x`sym;x`side],:enlist x} each x;
	if[count x[`sym] except opensyms;
	opensyms::`u#opensyms,x[`sym]
	]; 
 }

sendorder:{[o]
 	send[source;first o`otype][o]; / refactor for multi-type lists of o
 }

send.trades.mkt:{
 	neworders[x];
 }

send.trades.lmt:{
 	:()!()
 }

/ assuming full fills
execute.trades.mkt:{
	s: x[`sym] inter opensyms;
	o: raze {select id, sym, size:.market.sidescode[side]*size from (,/)value x} each obook[`mkt;s]; / orders to be filled
	f: o lj select last price, tstamp by sym from x; / filled
 	{ obook[`mkt;x;`buy]: (); 
 	  obook[`mkt;x;`sell]: (); } each s;
 	opensyms::`u#opensyms except s;
 	orders.onfilled[f];
 }

execute.trades.lmt:{
 }

/ send to portfolio
orders.onfilled:{ 
	.port.upd[`fill;x];
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