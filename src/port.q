port.equity.last:: port.cash + exec sum pnl from port.pnl
port.equity.curve:: select ec: port.cash + sum pnl by tstamp from port.pnl
port.w::port.pos.val % port.cash + sum port.pos.val

port.cash: 100000
port.pnl: update `s#tstamp,`g#sym from flip `tstamp`sym`pnl!"psf"$\:()

port.pos.val: ()!() / sym -> total position (liquidation) value dictionary.
port.pos.sz: ()!() / sym -> total number of units/shares dictionary

port.lastt:0N

if[`fill in key `port; delete fill from `port] / because fill,::x is faster than fill::fill,x;
/positions: update `u#sym from `sym xkey flip `sym`sz`val!"sif"$\:()

/ average cost method
.port.upd.fill: {
	fill,::x;
	lastfillprice: exec last price, last tstamp by sym from x; / assuming fills sorted by tstamp (!), take last observed transacted price per symbol to use it for (m)arking-to-market
	fillval: exec sum price * size by sym from x;
	fillsz: exec sum size by sym from x;
	port.pos.sz[key fillsz]+:: value fillsz;
	port.pos.val[key fillsz]+:: value fillval;
 }

.port.upd.mtm:{
		if[ port.lastt=n:"d"$.bt.e[`etstamp] ; :()];
		if[null port.lastt; port.lastt::n; :()];
		d:(s: key port.pos.sz)#.market.lastpx;
		`port.pnl insert (((count s)#"p"$port.lastt); s; value (newval: d * port.pos.sz) - port.pos.val); / record pnl (change in value)
		port.pos.val[key newval]:: value newval; / reprice positions
		port.lastt::n;
 }

/
pnlCalc:{[t;q]
	update pnl: (size*close-price) + 0^(prev sums size)*deltas close by sym from aj0 [`sym`date; t; q]
	}
/ lastfillprice: select last price, last tstamp by sym from x
/
upd[`fill] :{
	if[not all x[`sym] in exec sym from positions;
	subinfo:.sub.subscribe[`mtm; x[`sym], exec sym from positions;1b;0b; first btt]]; / subscribe new instruments for updates
	`positions upsert exec sym:first x`sym, sum sz, sz wavg cost from (0^positions[x`sym]), select sz:size, cost:price from x;
	}

upd[`mtm]:{
	x: delete date from update time: date + time from x;
	p: update pnl: sz*close-cost from x lj positions;
	`pnl insert select sym, time, pnl from p;
	`positions upsert select sym, cost:close from p;
	}