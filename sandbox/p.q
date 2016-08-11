/q p.q -p 5001
\l ec.q
positions: update `u#sym from `sym xkey flip `sym`sz`cost`date!"sifd"$\:()
pnl: update `g#sym, `s#date from flip `sym`date`pnl!"sdf"$\:()
cash: 100000
equity:: cash + exec sum pnl from pnl
ec:: select ec: cash + sum pnl by date from pnl

upd: ()!()

upd[`fill] :{
	show x;
	`positions upsert exec sym:x`sym, sum sz, sz wavg cost, last date from (0^positions[x`sym]), select sz:size, cost:price, date from enlist x;
	if[ not positions [ x`sym; `cost ] = x`price; ; upd [`mtm; select sym, date, close:price from enlist x] ];
	}

upd[`mtm]:{
	p: update pnl: sz*close-cost from aj[`sym`date; select from `positions; select sym, date, close from x ];
	`pnl insert select sym, date, pnl from p;
	`positions upsert select sym, sz, cost:close, date from p;
	}

pnlCalc:{[t;q]
	update pnl: (size*close-price) + 0^(prev sums size)*deltas close by sym from aj0 [`sym`date; t; q]
	}
\
neg[.z.w] -8!(enlist `hist)!enlist 0!`dt`val xcol ec]
.z.ts:{ if[`ec in system "B"; 0N!"redrawing"; ec]}
\t 100

sym | sz cost  date       close
----| -------------------------
PRU | 19 60.3  2016.05.02 59.66
GOOG| 61 71.48 2016.05.02 71.04

prices!(0!positions) asof select sym, date from prices
