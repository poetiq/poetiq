/
User story:  As a strategy evaluator, I want to see the equity curve in a time series chart.
Requirement: on-disk quote must have `p#sym and time sorted within sym. This is aj speed requirement.
Resources:
	http://www.accountingformanagement.org/adjusting-marketable-securities-to-market-value/
	http://ibkb.interactivebrokers.com/node/56
\

\l p.q
\l w.q
\e 1
txns: ([] dt: 1 2 3 4; sym: 4#`AAPL; sz: 100 200 -200 -50; px: 50 52 53 53.5)
prices: ([] sym: 4#`AAPL; dt: 1 2 3 4; cl: 50.5 52 53 54)
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