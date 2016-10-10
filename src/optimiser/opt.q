upd: ()!()

twevent:{[s;d;w;t] 
	([]sym:enlist s;date:enlist d;w:enlist w;time:enlist t)
	}

upd[`signal] :{
	currw:pweights[hportfolio "w"];
	date::first exec date from x;
	time::first exec time from x;
	sig:$[0>s:first exec signal from x;0;s];
	sym:first exec sym from x;
	syms:$[sym in s:exec sym from currw;s;s,sym];
	tw:`float$sig*1%count syms;
	w:currw upsert (sym:sym;sz:tw);
	balw:`float$(1-tw)%(-1+count syms);
	balance:update sz:balw from w where not sym=sym;
	/ delta:balance pj neg currw;
	events:{twevent[first x;date;last x;time]} each value each 0!balance;
	{(neg hbtt) (`.u.upd;`targetw; value first x)} each events;
	}

/ upd[`signal] :{
/ 	x: select sym, date, sz: units[1] signal, time from x;
/ 	(neg hbtt) (`.u.upd;`targetsz; value first x);
/ 	}
