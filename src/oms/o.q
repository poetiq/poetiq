\l hdb/equitysim

upd: ()!()

upd[`targetsz] :{
	currpos: delete cost,time from hportfolio "positions";
	delta: (select sym, sz from x) pj neg currpos;
	if[count delta; (neg hbtt) (`.u.upd;`order; value first select sym, size:sz from delta)];
	}

pweights: {[w]
	/ Returns an empty weights table of the correct types if current weights table is null.
	$[0=count w;([sym:`$()]sz:`float$());w]
	}

upd[`targetw] :{
	currw:select from pweights[hportfolio "w"] where sym=first exec sym from x;
	targw:select sym, sz:w from x;
	delta:targw pj neg currw;
	price:hfill (`getpx;first exec sym from x);
	order:select sym, size:floor(sz*hportfolio "equity")%price from delta;
	/ break;
	if[count order; (neg hbtt) (`.u.upd;`order;value first order)];
	}
