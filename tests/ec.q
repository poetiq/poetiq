/
User story:  As a strategy evaluator, I want to see the equity curve in a time series chart.
Requirement: on-disk quote must have `p#sym and time sorted within sym. This is aj speed requirement.
Resources:
	http://www.accountingformanagement.org/adjusting-marketable-securities-to-market-value/
\

\l acct.q
fills_:([] acct: 6#first -1?0Ng; dt: 1 3 5 7 9 11 ; sym: `AAPL`AAPL`AAPL`AAPL`AAPL`AAPL; side:`BUY`SELL`BUY`SELL`SELL`BUY; sz:6 -5 4 -3 -8 1; px: 10.0 11.0 10.0 11.0 9.0 8.0)
quotes: ([] t: 1 3 5 7 9 11; sym: `AAPL`AAPL`AAPL`AAPL`AAPL`AAPL; bid: 10.0 11.0 10.0 11.0 9.0 8.0; ask: 10.0 12.0 10.0 11.0 9.0 8.0)

f: fills_ 0

.trade.allocate[`FIFO; f]
.inventory.acct[f`acct;`BUY]
.inventory.acct[f`acct] `BUY
.inventory.past
