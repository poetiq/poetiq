alphas:1!flip`sym`date`signal`time!"sdin"$\:()

upd: ()!()

upd[`signal] :{
	`alphas upsert x;
	target:wfun . enlist alphas; / For equal weight strategy.
	/ target:wfun[x]; / For single unit strategy.
	(neg hbtt) (`.u.upd; eventtype; value flip target)
	}