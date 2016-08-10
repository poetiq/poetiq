/q p.q -p 5001
\l ec.q
positions: update `u#sym from `sym xkey flip `sym`size`cost`date!"sifd"$\:()
pnl: update `g#sym, `s#date from flip `sym`date`pnl!"sdf"$\:()
cash: 100000
equity:: cash + exec sum pnl from pnl
ec:: select ec: cash + sum pnl by date from pnl

upd: ()!()

upd[`fill] :{
	show x;
	`positions upsert exec sym:x`sym, sum size, size wavg cost, last date from (0^positions[x`sym]), select size, cost:price, date from enlist x;
	if[ not positions [ x`sym; `cost ] = x`price; ; upd [`mtm; select sym, dt, close:price from enlist x] ];
	}

upd[`mtm]:{
	p: update pnl: size*close-cost from aj0[`sym`date; select from `positions; x ];
	`pnl insert select sym, date, pnl from p;
	`positions upsert select sym, size, cost:close, date from p;
	}

pnlCalc:{[t;q]
	update pnl: (size*close-price) + 0^(prev sums size)*deltas close by sym from aj0 [`sym`date; t; q]
	}
\
neg[.z.w] -8!(enlist `hist)!enlist 0!`dt`val xcol ec]
.z.ts:{ if[`ec in system "B"; 0N!"redrawing"; ec]}
\t 100

