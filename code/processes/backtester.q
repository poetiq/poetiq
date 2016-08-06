/ Backtest feed

data:([] sym:())

reset:{i::0;}

loaddata:{[bgn;end;syms;delta]
	.lg.o[`backtest;"loading data"];
	h:.servers.gethandlebytype[`gateway;`roundrobin];
	neg[h](`.gw.asyncexec;(`ohlc;bgn;end;syms;delta);`hdb);
	$[98h~type data::h[];.lg.o[`backtest;"data loaded"];.lg.e[`backtest;data]];
	reset[]
 };

init:{[bgn;end;syms;delta]
	.lg.o[`backtest;"initializing backtester"];
	loaddata[bgn;end;syms;delta];
	/ trick to prevent enlisted dict from converting to a table
	scope:(enlist[::]!enlist[::]),exec bgn:min time,end:max time,n:count i from data;
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
bgn:2016.05.01
end:2016.06.01
syms:`AAPL`MSFT
delta:0D00:05

loaddata[bgn;end;syms;delta]
data
