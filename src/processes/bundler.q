
tbls:`trade`quote
syms:`
schema:1b
replaylog:0b
stdcols:`date`sym`time 	/ standard columns not to be

upd:{[t;x]event[t] . x}

bar:()!()
bar[`quote]:{
	select bidopen:first bid,bidhigh:max bid,bidlow:min bid,bidclose:last bid,askopen:first ask,askhigh:max ask,asklow:min ask,askclose:last ask by sym from quote
 };
bar[`trade]:{}

ts:{
	show t!{bar[x][]}each t:`quote`trade;
	{delete from x}each t;
	};

tabcount:()!()

event:()!()
event[`quote]:insert[`quote;]
event[`trade]:insert[`trade;]

subscribe:{
	if[count s:.sub.getsubscriptionhandles[`bttickerplant;();()!()];
		.lg.o[`subscribe;"found available tickerplant, attempting to subscribe"];
		subinfo:.sub.subscribe[tbls;syms;schema;replaylog;first s];
		@[`.;;:;].'flip(key;value)@\:subinfo; / set schemas
	 ];
 };

/ .z.ts:ts

if[not system"t";system"t 1000"];

.servers.startup[]
subscribe[]

\
quote
trade
event

ts[]
{bar[x][]} each t:`quote`trade
ts[]
