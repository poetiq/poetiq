alphas: 1!flip`sym`date`signal`time!"sdin"$\:()

upd: ()!()

upd[`signal] :{
	`alphas upsert x;
	tw:exec 1%count sym from alphas where signal>0;
	tws:select sym, date, w:"f"$tw*signal, time from update signal:0 from alphas where signal<1;
	(neg hbtt) (`.u.upd;`targetw; value flip tws)
	}

/ upd[`signal] :{
/ 	x: select sym, date, sz: units[1] signal, time from x;
/ 	(neg hbtt) (`.u.upd;`targetsz; value first x);
/ 	}
