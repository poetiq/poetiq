/ Backtest feed

reset:{i::0;}

chunksize:"j"$1e4;	/ chunk size
curchunk:(0;chunksize);	/ current chunk

nextchunk:{:curchunk::curchunk[1]+/:(1;chunksize)};

/ sets and returns `order (replay order)
getorder:{[tbls;bgn;end;syms]
	.lg.o[`backtest;"getting order in which tables should be replayed"];
	h:.servers.gethandlebytype[`gateway;`roundrobin];
	neg[h](`.gw.asyncexec;(`replayorder;tbls;bgn;end;syms);`hdb);
	 / deferred async (block current process)
	$[98h~type r:h[];[.lg.o[`getorder;"order retrieved"];:order::r;];.lg.e[`getorder;r]];
 };

loadchunk:{[order]
	.lg.o[`loadchunk;"loading rows "," - "sv string curchunk];
	h:.servers.gethandlebytype[`gateway;`roundrobin];
	neg[h](`.gw.asyncexec;(`loadchunk;order);`hdb);
	$[99h~type r:h[]; / deferred sync
		/ update local tables with current chunks
		[(@[`.;;:;]').(key;value)@\:r; .lg.o[`getorder;"chunk retrieved"];];
		.lg.e[`getorder;r]];
 };

loaddata:{[tbls;bgn;end;syms]
	.lg.o[`backtest;"loading data"];
	h:.servers.gethandlebytype[`gateway;`roundrobin];
	neg[h](`.gw.asyncexec;(`events;tbls;bgn;end;syms);`hdb);
	$[99h~type r::h[]; / send sync chaser
		/ set data and order variables
		[(@[`.;;:;]'). flip(flip(key;value)@\:r`data),enlist(`order;r`order);.lg.o[`backtest;"data loaded"]];
		.lg.e[`backtest;data]];
	reset[];
	loaded::1b;
 };

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
bgn:2016.05.01;
end:2016.06.01;
syms:`AAPL`MSFT;

init[bgn;end;syms;delta]

getorder[tbls;bgn;end;syms]
tables[]
loadchunk select from order where i within curchunk
nextchunk[]
trade
quote
order
