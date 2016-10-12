\l hdb/equitysim

upd: ()!()

upd[`targetsz] :{
	currpos: delete cost,time from hportfolio "positions";
	delta: (select sym, sz from x) pj neg currpos;
	if[count delta; (neg hbtt) (`.u.upd;`order; value first select sym, size:sz from delta)];
	}

upd[`targetw] :{
	currw:$[0=count w:hportfolio "w";([sym:`$()]sz:`float$());w];
	targw:select sym, sz:w from x;
	delta:select last sz, px:last hfill (`getpx;first sym) by sym from targw pj neg currw;
	orders:select sym, size:floor (hportfolio "equity")*sz%px from delta;
	if[count orders; (neg hbtt) (`.u.upd;`order;value flip orders)];
	}
