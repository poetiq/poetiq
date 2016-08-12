/
User story:  As a strategy evaluator, I want to see the equity curve in a time series chart.
Requirement: on-disk quote must have `p#sym and time sorted within sym. This is aj speed requirement.
Resources:
	http://www.accountingformanagement.org/adjusting-marketable-securities-to-market-value/
	http://ibkb.interactivebrokers.com/node/56
\

\l ../hdb/equitysim
\S 104831

txns: update size * nt?-1 1 from .Q.ind[trade; asc (nt:20)?count trade]
prices: select from daily where date=now
events: select distinct date from daily
events: update e:`fill from txns
update e:mtm from prices
select from txns where date < 
exec date from events where i=0
select from daily where sym=`AAPL
trade asof 	`sym`date`time!(`IBM;09:30:00.0)
trade asof (`date`time)!(2016.05.02;09:30:00.434)
clock: 2016.05.01
\ts select aa:{[d;s;p;sz] t:(`date`sym`price`size)!(d;s;p;sz); h (`upd;`fill; t) }'[date;sym;price;size] from trade
\ts 
-22!txns


h:neg hopen `:localhost:5001
h(`upd;`fill; txns 0)
h(`upd;`mtm; prices)
select from trade where sym=`AAPL

select from txns where date=2016.05.02
-11!txns
prices: select from daily where sym=`AAPL
/ performance requirements from http://code.kx.com/wiki/Reference/aj :
`sym`dt xasc `prices
update `g#sym from `prices

{upd[`fill;x]} each txns
upd[`mtm; prices]
equity
/ 100575f
positions
/
sym | sz cost dt
----| ----------
AAPL| 50 54   4 
\
pnl
/
sym  dt pnl
-----------
AAPL 2  200
AAPL 3  300
AAPL 4  50 
AAPL 4  25 
\
/ alternatively, batch calculation:
pnlCalc[txns;prices]
/
dt sym  sz   px   cl   pnl
--------------------------
1  AAPL 100  50   50.5 50 
2  AAPL 200  52   52   150
3  AAPL -200 53   53   300
4  AAPL -50  53.5 54   75 
\
h:neg hopen `:localhost:5001
h(`upd;`fill; txns 2)
h(`upd;`mtm; 2#prices)