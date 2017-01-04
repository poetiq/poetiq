market.source:`trades;
market.last.quotes:()!();
market.lastpx:()!(); / last traded price for each symbol
market.orderid: 0;
market.opensyms:`u#`$() / list of symbols which have at least one open order in the orderbook
market.obook: ()!()
market.obook[`]:()!()
market.obook[`;`]:()!()

.market.sides:(1;-1)!(`buy`sell)
.market.sidescode:(`buy`sell)!(1;-1)

.market.genorderid:{:market.orderid+::1}
.market.genorderids:{ market.orderid:: last ret:1 + market.orderid + til x; ret }

.market.upd:{
	if[.bt.e[`event] in `trades`quotes;
		if[any .bt.data[`sym] in market.opensyms;filled:.market.execute[.bt.e`event;`mkt][.bt.data]]; /,execute[t;`lmt][x];
 		market.lastpx[.bt.data`sym]:.bt.data`price;
 		];
 }

/ add to book, track number of open orders per symbol
.market.neworders:{
	x:update size: abs size, side: .market.sides[signum size] from x;
	/.lg.l[`i;`market.neworders;x];
	{market.obook[x`otype;x`sym;x`side],:enlist x} each x;
	if[count x[`sym] except market.opensyms;
	market.opensyms::`u#distinct market.opensyms,x[`sym]
	]; 
 }

.market.sendorder:{[o]
 	.market.send[market.source;first o`otype][o]; / refactor for multi-type lists of o
 }

.market.send.trades.mkt:{
 	.market.neworders[x];
 }

.market.send.trades.lmt:{
 	:()!()
 }

/ assuming full fills
.market.execute.trades.mkt:{
	s: x[`sym] inter market.opensyms;
	o: raze {select id, sym, size:.market.sidescode[side]*size from (,/)value x} each market.obook[`mkt;s]; / orders to be filled
	f: o lj select last price, tstamp by sym from x; / filled
 	{ market.obook[`mkt;x;`buy]: (); 
 	  market.obook[`mkt;x;`sell]: (); } each s;
 	market.opensyms::`u#market.opensyms except s;
 	.market.orders.onfilled[f];
 }

.market.execute.trades.lmt:{
 }

/ send to portfolio
.market.orders.onfilled:{ 
	.port.upd[`fill;x];
 }

.market.orders.oncanceled:{
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