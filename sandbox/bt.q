///////// tickerplant code
\p 5000;
counter:0;
upd:{[t;x] counter+:1};

///////// backtest feeder code

prepare: "data.q"; /process setting: path to script that prepares the data 
chsize: 0; /chunk size setting
h: neg hopen `:localhost:5000; / tickerplant port setting
lasttimestamp: 0N; / global counter

queue: flip `tstamp`tbl`data!"ps*"$\:(); / global variable storing events to be streamed

/ (l)oad (t)ables in (ch)unk(size)s to memory. Moves the counter.
l: {[t;chsize] {.[x;();:; select from x]} each t }; / not implemented at the moment. 

/ Requires tstamp column.
/ Supports tables keyed by tstamp; each group can have multiple records.
/ Returns dictionary of `tstamp, `tbl and `data columns (of types "ps*") where 
/ tstamp is the time of the event, tbl is name of the event and data is a list of columns
events:{[tbls]
	`tstamp xasc (,/) {[tbl]
		{[tbl;x] `tstamp`tbl`data!(x`tstamp;tbl;delete tstamp from x)}[tbl] each 0!select from tbl
	} each tbls
 };

/ Pausing logic not implemented yet
stream:{[h;x]
	{h(`upd;x`tbl;x`data)} each x;
	delete from x
	};

/ prepare your data for streaming by loading custom script that does it

@[{system "l ", prepare};()];
l[src;0];
queue,: events[src];
stream[h;queue];

//// contents of the prepare script:
\l ../hdb/equitysim
\S 104831
bgn:end:syms: 0; / optional global feeder parameters
src: `trade`quote;
update tstamp:date + time from `trade;
update tstamp:date + time from `quote;
//// end of script








fill: update tstamp:date + time from update size * nt?-1 1 from .Q.ind[trade; asc (nt:20)?count trade]
mtm: select time, date, close by tstamp:date+23:59:59.999 from update time: 23:59:59.999 from daily
e: events[`trade`quote]

e.data 0
time | 23:59:59.999 23:59:59.999 23:59:59.999 23:59:59.999 23:59:59.999 23:59..
date | 2016.05.02   2016.05.02   2016.05.02   2016.05.02   2016.05.02   2016...
close| 86.22        29           33.93        12.07        20.44        71.04..

e.data 2
date | 2016.05.04
sym  | `sym$`HPQ
time | 10:20:44.173
price| 35.19
size | -17
stop | 0b
cond | "L"
ex   | "O"

e1: events[enlist `mtm]
(,/)(e;e1)
meta e
$[1b;]
events: flip `timestamp`event`data!"ps*"$\:()
sync: {
	{[t;events] insert[events; {[t;x] `timestamp`event`data!(x`timestamp; t; delete timestamp from x)}[t] each value t]}[;y] each x;
	`timestamp xasc y
	}

stream: {[h;x] 
	{h(`upd;x`event;x`data)} each value x;
	delete from x
	}

//////// run
\l ../hdb/equitysim
\S 104831
fill: update timestamp:date + time from update size * nt?-1 1 from .Q.ind[trade; asc (nt:20)?count trade]
mtm: 0!`timestamp xgroup update timestamp:date + 23:59:59.999 from select from daily
tbls: `fill`mtm
h:neg hopen `:localhost:5001

sync[`fill`mtm; `events]
stream[h;`events]

/ sorted dict with events (`time`table`data) for backtesting
events:{[tbls;bgn;end;syms;mns]
	/.lg.o[`events;"fetching events"];
	`time xasc (,/){[tbl;bgn;end;syms;mns]
		t:?[tbl;enlist(within;(+;`date;`time);(enlist;`bgn;`end));0b;()];
		{[tbl;x]`time`tbl`data!(x[`date]+x`time;tbl;x)}[tbl]each t
	}[;bgn;end;syms;mns]each tbls
 };

/ returns data and a table depicting the order
events2:{[tbls;bgn;end;syms;mns]
	/.lg.o[`events;"fetching events"];
	data:tbls!(?[;enlist(within;(+;`date;`time);(enlist;`bgn;`end));0b;()]@)each tbls;
	order:`time xasc (,/){![?[x;();0b;enlist[`time]!enlist(+;`time;`date)];();0b;`tbl`row!(enlist x;`i)]}each tbls;
	`data`order!(data;order)
 };

\
tbls:`trade`mtm;
bgn:2016.05.01;
end:2016.05.10;
syms:`AAPL`MSFT;
mns:5;
mtm: update time:23:59:59.999 from daily
\ts events[tbls;bgn;end;syms;mns] / 6054 326487424
\ts events2[tbls;bgn;end;syms;mns] / 1322 128845328
e: events[tbls;bgn;end;syms;mns]
e
tt: select from e where tbl=`mtm
tt.data
10#e.data.quote
count
-22!do
do.order
`time xasc do.order
count quote