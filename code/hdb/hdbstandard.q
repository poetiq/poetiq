/ reload function
reload:{
	.lg.o[`reload;"reloading HDB"];
	system"l ."}

/ get the relevant HDB attributes
.proc.getattributes:{`date`tables!(@[value;`date;`date$()];tables[])}

/ OHLC data
ohlc:{[bgn;end;syms;mns]
	.lg.o[`ohlc;"Fetching bars"];
	t:select bidopen:first bid,bidhigh:max bid,bidlow:min bid,bidclose:last bid,askopen:first ask,askhigh:max ask,asklow:min ask,askclose:last ask
	by time:date+mns xbar time.minute,sym from quote where date within(bgn;end),sym in syms;
	0!`time xgroup t
 };

/ row order in which the specified tables should be replayed
replayorder:{[tbls;bgn;end;syms]
	`time xasc (,/){![?[x;();0b;enlist[`time]!enlist(+;`time;`date)];();0b;`tbl`row!(enlist x;`i)]}each tbls
 };

loadchunk:{[order]
	t:first o:(key;value)@\:exec row by tbl from order;
	t!({`row xkey update row:y from .Q.ind[value x;y]} '). o
 };

/ returns data and a table depicting the order
events:{[tbls;bgn;end;syms]
	.lg.o[`events;"fetching events"];
	data:tbls!(?[;enlist(within;(+;`date;`time);(enlist;`bgn;`end));0b;()]@)each tbls;
	order:`time xasc (,/){![?[x;();0b;enlist[`time]!enlist(+;`time;`date)];();0b;`tbl`row!(enlist x;`i)]}each tbls;
	`data`order!(data;order)
 };

/ sorted dict with events (`time`table`data) for backtesting
events2:{[tbls;bgn;end;syms]
	.lg.o[`events;"fetching events"];
	`time xasc (,/){[tbl;bgn;end;syms]
		t:?[tbl;enlist(within;(+;`date;`time);(enlist;`bgn;`end));0b;()];
		{[tbl;x]`time`tbl`data!(x[`date]+x`time;tbl;x)}[tbl]each t
	}[;bgn;end;syms]each tbls
 };


\
tbls:`trade`quote;
bgn:2016.05.10;
end:2016.05.20;
syms:`AAPL`MSFT;
mns:5;

\ts ohlc[bgn;end;syms;mns]
\ts events[tbls;bgn;end;syms] / 6054 326487424
\ts e:events2[tbls;bgn;end;syms] / 1322 128845328

order:1000#replayorder[tbls;bgn;end;syms]
chunk:loadchunk order

count order
chunk`quote

\l .
select from quote
select min date from daily
`date`time xasc update row:i from select from quote

