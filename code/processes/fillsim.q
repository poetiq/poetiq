/ Fill Simulator

/ default parameters
feedtypes:@[value;`feedtypes;`backtester];		/ list of feedtypes to try and make a connection to
subscribeto:@[value;`subscribeto;`quotes];		/ list of tables to subscribe to, (`) means all tables
subscribesyms:@[value;`subscribesyms;`];			/ list of syms to subscribe to, (`) means all syms
schema:@[value;`schema;1b];										/ retrieve the schema from feed
connsleepint:@[value;`connsleepint;10];				/ seconds between attempts to connect to the feed

subscribe:{
	if[count s:.sub.getsubscriptionhandles[feedtypes;();()!()];
		.lg.o[`subscribe;"found available feeds, attempting to subscribe"];
		params:get`params;
		subinfo:.sub.subscribe[subscribeto;subscribesyms;schema;0b;first s];
		/ set a list of tables now subscribed for
		if[count subinfo; @[`.am;`subtables;:;] subinfo`subtables]];
 };

feedconnected:{0<count select from .sub.SUBSCRIPTIONS where proctype in .am.feedtypes,active}

connect:{
	.lg.o[`init;"searching for servers"];
	.servers.startup[];
	subscribe[];
	/ If no feed has connected, block the process until a connection is established
	if[not .am.feedconnected[];.os.sleep[.am.connsleepint];.z.s[]]
 };

init:{.lg.o[`init;"initializing"];connect[]};

upd:{[t;x] .oms.upd[t] . x}

.oms.upd[`quotes]:{upsert[`quotes]}

.oms.upd[`trades]:{-1"on trade"}
