upd: ()!()

twevent:{[s;d;w;t]
	/ Generates a targetw event.
	([]sym:enlist s;date:enlist d;w:enlist w;time:enlist t)
	}

signals:1!flip`sym`signal!"sj"$\:()

upd[`signal] :{
	`signals upsert (sym:first exec sym from x;signal:first exec signal from x);
	tw:exec 1%count sym from signals where signal>0;
	tws:select sym, tw:`float$tw*signal from update signal:0 from signals where signal<1;
	d::first exec date from x; t::first exec time from x;
	events:{twevent[first x;d;last x;t]} each value each tws;
	{(neg hbtt) (`.u.upd;`targetw; value first x)} each events;
	}

/ upd[`signal] :{
/ 	x: select sym, date, sz: units[1] signal, time from x;
/ 	(neg hbtt) (`.u.upd;`targetsz; value first x);
/ 	}
