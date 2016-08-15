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

/ sorted dict with `time`table`data (for backtesting)
events:{[tbls;bgn;end;syms;mns]
	.lg.o[`events;"fetching events"];
	`time xasc (,/){[tbl;bgn;end;syms;mns]
		t:?[tbl;enlist(within;(+;`date;`time);(enlist;`bgn;`end));0b;()];
		{[tbl;x]`time`tbl`data!(x[`date]+x`time;tbl;x)}[tbl]each t
	}[;bgn;end;syms;mns]each tbls
 };


\
tbls:`trade`quote;
bgn:2016.05.01;
end:2016.05.10;
syms:`AAPL`MSFT;
mns:5;

ohlc[bgn;end;syms;minutes]
events[tbls;bgn;end;syms;mns]
