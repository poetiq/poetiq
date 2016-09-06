\l hdb/equitysim
\S 104831

/ loads the fills and mark-to-market event data
nt:10000 / number of random trades/fills
fill: update size * nt?-1 1 from .Q.ind[trade; asc nt?count trade] / random trades of unit size
mtm: select time: 0D24- 0D00:00:01, date, sym, close from daily
