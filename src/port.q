margin: 0f
port.cash: 100000f
equity::max 0, port.cash + margin /port.cash + margin / max 0 port.cash + margin /  + exec sum cost from pos (;port.cash+margin)
weights::1!select sym, w:sz * px % equity from pos
/port.equity.last:: port.cash + exec sum pnl from port.pnl
port.pos.h::`tstamp xasc update val:pos*px from ungroup select tstamp, pos:sums sz, px, pch:pch[px] by sym from fill / position history
port.equity.curve:: select tstamp, ec:100000+sums pnl from select sum pnl by tstamp from port.pnl


port.pnl: update `s#tstamp,`g#sym from flip `tstamp`sym`pnl!"psf"$\:()

/port.pos.val: ()!() / sym -> total position (liquidation) value dictionary.
/port.pos.sz: ()!() / sym -> total number of units/shares dictionary

if[`fill in key `port; delete fill from `port] / because fill,::x is faster than fill::fill,x;
/positions: update `u#sym from `sym xkey flip `sym`sz`val!"sif"$\:()

/ average cost method
.port.upd.fill: {
	/.lg.tic[];
	fill,::0!x;
	.log.blot["fill";x];
	/lastfillprice: exec last price, last tstamp by sym from x; / assuming fills sorted by tstamp (!), take last observed transacted price per symbol to use it for (m)arking-to-market
	/f: exec sz: sum size, val:sum price * size by sym from x;
	pos+:f:select sym, sz, cost:px * sz from x;
	/port.cash-:exec sum cost from f;
	/.lg.toc[`updfill];
 }

.port.upd.mtm:{
	`pos set pos lj .market.lastpx;
	update val:px * sz from `pos;
	update pnl:val - cost, cost:val from `pos;
	.log.blot["mtm";pos];
	if[count i:select tstamp:"p"$.clock.now[], sym, pnl from `pos where 0<abs pnl;
		.port.upd.pnl[i]; / record pnl (change in value)
		];
 }

/ record pnl (change in value)
.port.upd.pnl:{
 	margin+: sum x`pnl;
 	`port.pnl insert x;
 	.log.blot["pnl";x];
 };

.clock.events.mtm:{"p"$1+.calendar.trading.days}
/.clock.timer[.port.upd.mtm;.calendar.trading.days]