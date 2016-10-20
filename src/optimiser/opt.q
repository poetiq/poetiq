upd: ()!()

upd[`signal] :{.cfg.r[x];(neg hbtt) (`.u.upd; .cfg.e; value flip .cfg.wfun . value 1_.arg)}

\d .cfg
r:{`.arg.a upsert x} / What to do on receipt of event
eqw:{x*1%sum x}; long:{x*x>0}; / Helper functions for wfun
wfun:{select sym, date, w:.cfg.eqw .cfg.long signal, time from x}; / Weighting function
e:`targetw / What event type to produce

\d .arg / Specify/define all arguments in here.  To add one, just add it to the namespace - nothing else.
a:1!flip`sym`date`signal`time!"sdin"$\:()