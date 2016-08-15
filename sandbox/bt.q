
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




