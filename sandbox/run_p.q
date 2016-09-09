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
prices: select from daily
events : {`timestamp`event`data!(x`timestamp;`fill;x)} each update timestamp:date + time from select from txns
events,: {`timestamp`event`data!(x`timestamp;`mtm; flip delete timestamp from x)} each 
0!?[`prices;();enlist[`timestamp]!enlist (+;`date;23:59:59.999);cols[`prices]!cols `prices]
`timestamp xasc `events
h:neg hopen `:localhost:5001
{h(`upd;x`event;x`data)} each events

/
select by timestamp:date + 23:59:59.999 from prices 
`timestamp xasc `events

"p"$2016.05.03
{h(`upd;x`event;x`data)} each 
select data from {`timestamp`event`data!(x`timestamp;`mtm; x,'x`date)} each 0!`date xgroup prices
funcSelect: 

parse "select by timestamp:date + 23:59:59.999 from prices"

update timestamp:date + 23:59:59.999 from prices
/
h(`upd;`fill; txns 0)
h(`upd;`mtm; 2#prices)

select from trade where sym=`AAPL

