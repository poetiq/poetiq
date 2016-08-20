/ Algorithm parameters
params:enlist[::]!enlist[::];
params[`syms]:@[value;`syms;`];								/ list of syms to subscribe for, (`) means all syms
params[`delta]:@[value;`delta;5];							/ the time between each bar, (`) means ticks
params[`tables]:@[value;`tables;`trade`quote];				/ list of table to subscribe to, default (`) means all tables

/ ALPHA MODEL SPECIFIC LOGIC
\d .am

feedtypes:@[value;`feedtypes;`backtester];		/ list of feedtypes to try and make a connection to
schema:@[value;`schema;1b];										/ retrieve the schema from feed
connsleepint:@[value;`connsleepint;10];				/ seconds between attempts to connect to the feed
mode:@[value;`mode;`backtest];								/ value of either backtest, test, live

handles:{exec w from .sub.getsubscriptionhandles[feedtypes;();()!()]}

subscribe:{
	if[count s:.sub.getsubscriptionhandles[feedtypes;();()!()];
		.lg.o[`subscribe;"found available feeds, attempting to subscribe"];
		params:get`params;
		subinfo:.sub.subscribe[params`tables;params`syms;schema;0b;first s];
		/ set a list of tables now subscribed for
		if[count subinfo; @[`.am;`subtables;:;] subinfo`subtables]];
 };

feedconnected:{0<count select from .sub.SUBSCRIPTIONS where proctype in .am.feedtypes,active}

connect:{
	.lg.o[`init;"searching for servers"];
	.servers.startup[];
	if[.am.mode=`backtest;.bt.init . get[`params]`tables`bgn`end`syms];
	subscribe[];
	/ If no feed has connected, block the process until a connection is established
	if[not .am.feedconnected[];.os.sleep[.am.connsleepint];.z.s[]]
 };

init:{
	.lg.o[`init;"initializing"];
	connect[];
 };

upd:()!()

/ On backtester initialized
upd[`init]:{[x]
	.lg.o[`backtest;"backtester loaded. Initializing variables"];
	show scope::x;
	i::0;
	/ .bt.start[];
 };

/ On quote event [timestamp, quotes]
upd[`data]:{[tm;x]
	/ `control upsert t:update time:tm from x;
	/ `quotes insert t;
	/ quotes::delete from quotes where (window-1)<(idesc;.algo.i) fby sym;
	.algo.upd[`quote;tm;x];
	i+::1;
	if[not .bt.debugstep[];.bt.stepnext[]];
 };

/ End of feed
upd[`eof]:{.bt.end[]};


/ ALGORITHM SPECIFIC LOGIC
\d .
.algo.upd:()!()
upd:{[t;x] .am.upd[t] . x}


\
.am.init[]
.bt.stepnext[]
