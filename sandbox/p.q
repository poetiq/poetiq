\l ec.q
positions: update `u#sym from `sym xkey flip `sym`sz`cost`dt!"sifi"$\:()
pnl: update `g#sym, `s#dt from flip `sym`dt`pnl!"sif"$\:()
cash: 100000
equity:: cash + exec sum pnl from pnl
ec:: select ec: cash + sum pnl by dt from pnl

upd: ()!()

upd[`fill] :{
	show x;
	`positions upsert exec sym:x`sym, sum sz, sz wavg cost, last dt from (0^positions[x`sym]), select sz, cost:px, dt from enlist x;
	if[ not positions [ x`sym; `cost ] = x`px; ; upd [`mtm; select sym, dt, cl:px from enlist x] ];
	}

upd[`mtm]:{
	p: update pnl: sz*cl-cost from aj0[`sym`dt; select from `positions; x ];
	`pnl insert select sym, dt, pnl from p;
	`positions upsert select sym, sz, cost:cl, dt from p;
	}

pnlCalc:{[t;q]
	update pnl: (sz*cl-px) + 0^(prev sums sz)*deltas cl by sym from aj0 [`sym`dt; t; q]
	}
/ neg[.z.w] -8!(enlist `hist)!enlist 0!`dt`val xcol ec]
.z.ts:{ if[`ec in system "B"; 0N!"redrawing"; ec]}
\t 100