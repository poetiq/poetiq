upd: ()!()

\d .portcon

alphas:1!flip`sym`date`signal`time!"sdin"$\:()

upd[`signal]:{}

/`alphas upsert x;
 /target:wfun . enlist alphas;
 /(neg hbtt) (`.u.upd; eventtype; value flip target)

eqw:{x*1%sum x}

wfun:{select sym, date, w:eqw long signal, time from x}; eventtype:`targetw 

\d .oms

upd[`targetw] :{
	currw:$[0=count w:hportfolio "w";([sym:`$()]sz:`float$());w];
	targw:select sym, sz:w from x;
	delta:select last sz, px:last hfill (`getpx;first sym) by sym from targw pj neg currw;
	orders:select sym, size:floor (hportfolio "equity")*sz%px from delta;
	/ break;
	if[count orders; (neg hbtt) (`.u.upd;`order;value flip orders)];
	}