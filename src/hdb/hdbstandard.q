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

/ dict with tblname!data
/ all tables must have at least `date`sym columns
events:{[tbls;bgn;end;syms]
	.lg.o[`events;"fetching events"];
	tbls!(?[;((within;`date;(enlist;bgn;end));(in;`sym;enlist syms));0b;()]@)each tbls
 };
