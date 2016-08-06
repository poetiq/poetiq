// reload function
reload:{
	.lg.o[`reload;"reloading HDB"];
	system"l ."}

// Get the relevant HDB attributes
.proc.getattributes:{`date`tables!(@[value;`date;`date$()];tables[])}

/ OHLC data
ohlc:{[bgn;end;syms;mns]
	.lg.o[`ohlc;"Fetching bars"];
	t:select bidopen:first bid,bidhigh:max bid,bidlow:min bid,bidclose:last bid,askopen:first ask,askhigh:max ask,asklow:min ask,askclose:last ask
	by time:date+mns xbar time.minute,sym from quote where date within(bgn;end),sym in syms;
	0!`time xgroup t
 };

\
bgn:2016.05.01
end:2016.06.01
syms:`AAPL`MSFT
minutes:5

ohlc[bgn;end;syms;minutes]
0!`time xgroup t