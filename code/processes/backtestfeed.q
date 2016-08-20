/ Backtest feed

reset:{i::0;}

/ chunksize:"j"$1e4;	/ chunk size
/ curchunk:(0;chunksize);	/ current chunk

/ nextchunk:{:curchunk::curchunk[1]+/:(1;chunksize)};

/ / sets and returns `order (replay order)
/ getorder:{[tbls;bgn;end;syms]
/ 	.lg.o[`backtest;"getting order in which tables should be replayed"];
/ 	h:.servers.gethandlebytype[`gateway;`roundrobin];
/ 	neg[h](`.gw.asyncexec;(`replayorder;tbls;bgn;end;syms);`hdb);
/ 	 / deferred async (block current process)
/ 	$[98h~type r:h[];[.lg.o[`getorder;"order retrieved"];:order::r;];.lg.e[`getorder;r]];
/  };

/ loadchunk:{[order]
/ 	.lg.o[`loadchunk;"loading rows "," - "sv string curchunk];
/ 	h:.servers.gethandlebytype[`gateway;`roundrobin];
/ 	neg[h](`.gw.asyncexec;(`loadchunk;order);`hdb);
/ 	$[99h~type r:h[]; / deferred sync
/ 		/ update local tables with current chunks
/ 		[(@[`.;;:;]').(key;value)@\:r; .lg.o[`getorder;"chunk retrieved"];];
/ 		.lg.e[`getorder;r]];
/  };

getorder:{[tbls]`time xasc (,/){![?[x;();0b;enlist[`time]!enlist(+;`time;`date)];();0b;`tbl`row!(enlist x;`i)]}each tbls}

loaddata:{[tbls;bgn;end;syms]
	.lg.o[`backtest;"loading data"];
	h:.servers.gethandlebytype[`gateway;`roundrobin];
	neg[h](`.gw.asyncexec;(`events;tbls;bgn;end;syms);`hdb); r:h[]; / deferred async
	$[99h~type r;(@[`.;;:;]').(key;value)@\:r;.lg.e[`backtest;r]]; / set data and order variables
	order::getorder tbls; loaded::1b;
	reset[];
	.lg.o[`backtest;"data loaded"];
 };

/ get the ith event
event:{{(x;enlist?[x;enlist(=;`i;y);();()])}. value first each exec tbl,row from order where i=x};

curtime::exec first time from order where i=get`i;

init:{[tbls;bgn;end;syms]
	.lg.o[`backtest;"initializing backtester"];
	if[not loaded;loaddata[tbls;bgn;end;syms]];
	/ trick to prevent enlisted dict from converting to a table
	scope:(enlist[]!enlist[]),exec bgn:min time,end:max time,n:count i from order;
	.lg.o[`init;"sending init signal to subscribers"];
	(neg first first .u.w`data)(`upd;`init;enlist scope);
 };

/ Overwrite selector (get ith bar)
.u.sel:{[x;y](first over key@;ungroup value@)@\:1!select from data where i=get`i}

/ Overwrite publisher (increase current bar number)
.u.pub:{
	$[not i<n and n:count data;
		eof[];
		[x .(y;z);i+::1;]]
 }@[value;`.u.pub;{{[t;x]}}]

/ End of feed
eof:{
	.lg.o[`backtest;"backtest complete"];
	{[w](neg first w)(`upd;`eof;enlist`)}each .u.w`data;
 };

.servers.startup[]

\
tbls:`trade`quote;
bgn:2016.05.05;
end:2016.05.10;
syms:`AAPL`MSFT;

init[bgn;end;syms;delta]

getorder[tbls;bgn;end;syms]
tables[]
loadchunk select from order where i within curchunk
nextchunk[]
trade
quote
order
loaddata[tbls;bgn;end;syms]

event 4
