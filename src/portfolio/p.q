positions: update `u#sym from `sym xkey flip `sym`sz`cost!"sif"$\:()
pnl: update `g#sym, `s#time from flip `sym`time`pnl!"spf"$\:()
cash: 100000
equity:: cash + exec sum pnl from pnl
ec:: select ec: cash + sum pnl by time from pnl
w::select sz*cost%equity by sym from positions / portfolio weights

upd: ()!()

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

pnlCalc:{[t;q]
	update pnl: (size*close-price) + 0^(prev sums size)*deltas close by sym from aj0 [`sym`date; t; q]
	}
/
	positions

	x: enlist (`time`sym`close)!(2016.05.03D23:59:59.000000000;`AAPL;88.03)
	select sym, sz, cost:cost^close from p

x
positions
x lj positions
p: update pnl: sz*close-cost from x lj positions
positions upsert select sym, cost:close from p