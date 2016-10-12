/ Assumptions: 
/ fill rate: 100% of the order size
/ fill price: at price traded at the time immediately following the order
/ speed of execution: immediately following the order (first after)
/ costs:
/ 	- market impact: none
/   - bid/ask: none
/   - fees: none
/ supported order types:
/   - none explicitly. Implicitly: MARKET(?), MOC, MOO

/ Order bundles are submitted in a table but to be processed one row at a time (TODO)

\l hdb/equitysim / requires trade table; order filled instantaneously at price traded at the time following the order

upd: ()!();
upd[`order]:{
	show raze string hswitch["clock[]"],-3!x;
	now: hswitch["clock[]"];
	if[count x: delete from x where size=0;
		orders:x lj select first price by sym from trade where sym in (exec sym from x), (date+time)>now;
		{(neg hbtt) (`.u.upd;`fill;x)} each value each orders;]
	}

getpx:{
	now: hswitch["clock[]"];
	value first select first price from trade where sym=x, (date+time)>now
	}

/
fixture sample for upcoming TDD
x: ([] sym:`AA`GOOG; size: 100 200) / order (this one is bundled, to be executed at the same time)
x: ([] sym:enlist `AA; price: enlist 100.2) / trade

/ NOT IMPLEMENTED
fill simulator subscribes to (daily) trade events to maintain control table from which to fill orders at last traded price (daily close). Control table is inspired by (more sophisticated) gbkr qx virtual exchange simulator:
http://www.gbkr.com/subjects/q/qx.html
http://code.kx.com/wsvn/code/contrib/gbaker/qx/?rev=1915&peg=1915#a04cc867f5243901d2e2066756a674da3

control: update `u#sym from `sym xkey flip `sym`refprx!"sf"$\:() / gbaker/qx/marketmaker.q has `sym`size`spread`refprx
upd[`trade]:{
	`control upsert select refprx: last price by sym from x;
}


