alphas:1!flip`sym`date`signal`time!"sdin"$\:()

upd: ()!()

upd[`signal] :{
	`alphas upsert x;
	targetws:wfun . args;
	break;
	(neg hbtt) (`.u.upd;`targetw; value flip targetws)
	}

wfun:{select sym, date, w:eqw long signal, time from x}
args::alphas