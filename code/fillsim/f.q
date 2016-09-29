control: update `u#sym from `sym xkey flip `sym`refprx!"sf"$\:() / gbaker/qx/marketmaker.q has `sym`size`spread`refprx

/ assumptions: 
/ fill 100% of the order size at last trade price (e.g. daily open or close)
/ Order bundles are submitted in a table but are processed one row at a time
upd: ()!();
upd[`order]:{
	x: select sym, price: 100.5, size:size from x;
	show hswitch "clock";
	(neg hbtt) (`.u.upd;`fill; value first x);
	}

upd[`trade]:{
	`control upsert select refprx: last price by sym from x;
	}

/
fixture sample for upcoming TDD
x: ([] sym:`AA`GOOG; size: 100 200) / order (this one is bundled, to be executed at the same time)
x: ([] sym:enlist `AA; price: enlist 100.2) / trade
