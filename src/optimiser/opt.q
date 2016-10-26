upd: ()!()

upd[`signal] :{.cfg.r[x]; break; (neg hbtt) (`.u.upd; .cfg.e; value flip .cfg.wfun . value 1_.arg)}

\d .cfg
r:{`.arg.alpha upsert x} / What to do on receipt of event
eqw:{x*1%sum x}; long:{x*x>0}; / Helper functions for wfun
wfun:{select sym, date, w:.cfg.eqw .cfg.long signal, time from x}; / Weighting function
e:`targetw / What event type to produce

\d .arg / All arguments are upserted here.

/ permutem:{[p;m] {flip x[;y]}[;p]/[count m;m]}
/ permutev:{[p;v] v p}