positions: update `u#sym from `sym xkey flip `sym`sz`cost`time!"sifp"$\:()
pnl: update `g#sym, `s#time from flip `sym`time`pnl!"spf"$\:()
cash: 100000
equity:: cash + exec sum pnl from pnl
ec:: select ec: cash + sum pnl by time from pnl

upd: ()!()

upd[`fill] :{
	x: update time: date + time from x;
	`positions upsert exec sym:first x`sym, sum sz, sz wavg cost, last time from (0^positions[x`sym]), select sz:size, cost:price, time from x;
	if[ not positions [ x`sym; `cost ] = first x`price; upd [`mtm; select time: `timespan$time, date:`date$time, sym, close:price from x] ];
	}

upd[`mtm]:{
	x:update time: date + time from x;
	p: update pnl: sz*close-cost from x lj delete time from positions;
	`pnl insert select sym, time, pnl from p;
	`positions upsert select sym, sz, cost:close, time from p;
	}

pnlCalc:{[t;q]
	update pnl: (size*close-price) + 0^(prev sums size)*deltas close by sym from aj0 [`sym`date; t; q]
	}
