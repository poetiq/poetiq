/ initialize one of `alpha`btctrl`feed`market`oms`hdb`portcon`portfolio`btt
/ configure with strategy
/ start feed


backtest: {[strategy]
 	jobid: reserve[`alpha`btctrl`feed`market`oms`hdb`portcon`portfolio`btt];
 	hbtt: gethandle[jobid; `btt];
 	(neg hbtt) (`u.upd; `strategy; strategy);
 }

reserve:{
newjobid:
 handle: if null x from table then start
 update job:newjobid where h=handle 
 }

 start:{
 	/ 
 	/ config strategy
 	/ .servers.startup[]
 }



 cfg[`alpha]