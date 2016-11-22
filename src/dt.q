/\l C:/Projects/q/hdb/equitysim
\l F:/poetiq/hdb/equitysim

.dt.trades: select value sym, price, size, tstamp: time + date from trade
.dt.fundamental: select date, sym, data:abs (rand each count[daily]#0h)%10000,indicator:`PE, tstamp:"p"$date from daily

/system "cd C:/Projects/q/poetiq"
system "cd F:/gdrive/poetiq"