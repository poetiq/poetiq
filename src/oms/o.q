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
	currw:pweights[hportfolio "w"];
	sig:1!select sym, sz:w from x;
	filterw:pweights[select from currw where sym=first exec sym from x];
	delta:sig pj neg filterw;
	sym:exec sym from x;
	date:exec date from x;
	price:value first select px:avg bid from quote where (date=date) and sym=sym;
	order:select sym, size:floor (sz*hportfolio "equity")%price from delta;
	break;
	if[count order; (neg hbtt) (`.u.upd;`order;value first order)];
	}
