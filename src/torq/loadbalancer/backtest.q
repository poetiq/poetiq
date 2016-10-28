/ initialize one of `alpha`btctrl`feed`market`oms`hdb`portcon`portfolio`btt
/ configure with strategy
/ start feed


backtest: {[strategy]
	jobid: 1
 	reserve[`alpha`btctrl`feed`market`oms`hdb`portcon`portfolio`btt; jobid];
 	/advertise strategy change event
 	hbtt: gethandle[jobid; `btt];
 	(neg hbtt) (`u.upd; `strategy; strategy);
 }

reserve:{[proctype;jobid]

	/$[null exec first w from .servers.SERVERS where proctype=proctype
	new[proctype]
newjobid:
 handle: if null x from table then start
 update job:newjobid where h=handle 
 }

 start:{
 	/ 
 	/ config strategy
 	/ .servers.startup[]
 }

new:{
	system "bin\\startp.bat", 
}


 cfg[`alpha]