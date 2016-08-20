/ Order Management System

/ default parameters
feedtypes:@[value;`feedtypes;`backtester];				/ list of feedtypes to try and make a connection to
subscribeto:@[value;`subscribeto;`data];			/ list of tables to subscribe to, (`) means all tables
subscribesyms:@[value;`subscribesyms;`];			/ list of syms to subscribe to, (`) means all syms
schema:@[value;`schema;1b];										/ retrieve the schema from feed
connsleepint:@[value;`connsleepint;10];				/ seconds between attempts to connect to the feed

orders:delete from .schema.orders;
executions:delete from .schema.executions;

subscribe:{
	if[count s:.sub.getsubscriptionhandles[feedtypes;();()!()];
		.lg.o[`subscribe;"found available feeds, attempting to subscribe"];
		subinfo:.sub.subscribe[subscribeto;subscribesyms;schema;0b;first s];
		/ set a list of tables now subscribed for
		if[count subinfo; @[`.;`subtables;:;] subinfo`subtables]];
 };

feedconnected:{0<count select from .sub.SUBSCRIPTIONS where proctype in feedtypes,active}

connect:{
	.lg.o[`init;"searching for servers"];
	.servers.startup[];
	subscribe[];
	/ If no feed has connected, block the process until a connection is established
	if[not feedconnected[];.os.sleep[connsleepint];.z.s[]]
 };

init:{.lg.o[`init;"initializing"];connect[]};

.oms.upd:()!()
upd:{[t;x] .oms.upd[t] . x}

.oms.upd[`data]:{[tm;x]
	.lg.o[`quote;"on data"];
 };

.oms.upd[`quote]:{[tm;x]
	.lg.o[`quote;"on quote"];
 };

.oms.upd[`order]:{[x]
	.lg.[`order;"received order"];
	show x;
 };

.oms.upd[`fill]:{
	.lg.[`fill;"order filled"];
	`fills insert x;
 };

\
init[]
subscribe[]
feedconnected[]
.servers.SERVERS
.sub.SUBSCRIPTIONS
