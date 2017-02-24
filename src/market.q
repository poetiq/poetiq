/ assuming full fills
.market.ex.mktfill100:{
	/f: o lj select last price, last tstamp by sym from x; / filled
	f: 0!update sz:1*sz from ob ij 1!select sym, px, tstamp from x;
	/f: 0!ob ij .market.getlastpx[select sym, tstamp:.clock.now[] from ob];
	if[count f;
		.market.orders.onfilled[f];];
 }

.market.getlastpx:{
  (select sym from x)!dt.px asof select sym, tstamp from x
 }


\d .market
lastpx: `sym xkey update `s#sym from flip `sym`px!"sf"$\:()
/lastpx:(enlist `)!(enlist 0nf) / last traded price for each symbol
source:`trades;
last.quotes:()!();
orderid: 0;
opensyms:`u#`$() / list of symbols which have at least one open order in the orderbook
sides:(1;-1)!(`buy`sell)
sidescode:(`buy`sell)!(1;-1)
obook: ()!()
obook[`]:()!()
obook[`;`]:()!() / obook[`mkt;;] not to be used (`each` is too slow)


/obook: enlist `buy`sell!(1 2; 3 4)

/update 15#enlist `buy`sell!(1 2; 3 4) from pos
/count pos
genorderid:{:orderid+::1}
genorderids:{ orderid:: last ret:1 + orderid + til x; ret }

.market.upd.trades:{
	/.lg.tic[];
	/if[not all (a:distinct x`sym) in exec sym from `pos; 
	/	.oms.upd.newsym a ];
	lastpx,:1!select sym, px from x;

	.log.blot["price";lastpx];
	/if[any x[`sym] in opensyms;
	execute.trades[`mkt;x];
		/]; /,execute[t;`lmt][x];
	/.lg.tic[];
	/lastpx[x`sym]:x`price; 

	/.lg.toc[`market.lastpx];
	/.lg.toc[`market.upd.inside];
 }

sendorder:{[o]
 	send[source;first o`otype][o]; / refactor for multi-type lists of o
 }

order.new:{
	.oms.upd[`accepted;x];
 }

order.modify:{
	.oms.upd[`accepted;x];
 }

order.cancel:{
	.oms.upd[`cancelled;x];
 }

cancelorder:{[o]
	.oms.upd[`cancelled;x];
 }

send.trades.mkt:{
	.oms.upd[`accepted;x];
 }

send.trades.lmt:{
 	:()!()
 }

execute.trades.mkt:ex.mktfill100

execute.trades.lmt:{
 }

/ send to the counterparties (our oms)
orders.onfilled:{
	.oms.upd[`fill;x];
 }

orders.oncanceled:{
 	.oms.upd[`ordercancel;x];
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
 	.lg.toc[`market.execute];
 }

