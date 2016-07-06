/
User story:  As a strategy evaluator, I want to see the equity curve in a time series chart.
Feature: Generate equity curve from list of trades
Feature: Calculate PnL from trades (and quotes?)
Requirement: perpetual vs periodic inventory system
Requirement: symbols separately in keyed dictionaries of trades. Avoids using "by sym" syntax everywhere. Or at least parted when in table.
Requirement?: store sells with negative quantity
Requirement?: trades table needs unique increasing identifier (i?) when matching buys vs sells

http://stackoverflow.com/questions/25490783/kdb-pnl-in-fifo-manner

Definitions:
order - instruction to buy or sell instruments. Ultimately sent to exchange.
fill (a.k.a. execution) - sent by exchange. An order can have multiple partial fills.
allocation - how fill gets assigned to one or multiple accounts.
trade - set of allocations comprise a trade. 
   Trade starts with first allocation, moving the position in instrument away from zero.
   Trade ends with allocation that closes the position back to zero.
position - total size of units/shares of an instrument held in a portfolio
\

/ First-in first-out allocation of bid/buy and ask/sell fills
/ Returns allocation matrix: a connectivity matrix of (b)id fills in rows and (a)sk fills in columns
fifo: {deltas each deltas sums[x] &\: sums[y]}

/ Connectivity list from connectivity matrix
lm: {raze(til count x),''where each x}

acct::{.inventory.acct[x]}
xside:{$[`BUY=x;`SELL;`BUY]}

/ nested data structure to hold current inventory. Keyed by trade (gu)id and by side.
.inventory.acct: ()!()
.inventory.acct[first 1#`guid$()]: `BUY`SELL!(flip `dt`sz`px!"iif"$\:();flip `dt`sz`px!"iif"$\:())
.inventory.past: "to be defined"

/ First-in first-out allocation of bid/buy and ask/sell fills
/ Returns allocation matrix: a connectivity matrix of (b)id fills in rows and (a)sk fills in columns
fifo: {deltas each deltas sums[x] &\: sums[y]}

/ Connectivity list from connectivity matrix
lm: {raze(til count x),''where each x}

/ allocate: try to match with opposite side. add nonmatched.
/ f(ill): a dictionary Must be a single record.  
.trade.allocate: ()!()
.trade.allocate[`FIFO]:{[f]
	ao:acct[f`acct] xside f`side;
	$[count ao;.trade.match[`FIFO][ao;f];
	.inventory.acct[f`acct;f`side],::`dt`sz`px!(f`dt;f`sz;f`px)];}

.trade.match: ()!()
.trade.match[`FIFO]:{[a;f]
	f: enlist update abs sz,px: px*signum sz from f
	l:lm 0<r:fifo[a`sz;f`sz]
	delete from (update sz - raze r from a) where sz=0
	dt: a[l[;0];`dt]|f`dt
	pnl: a[l[;0];`px] + (raze r) * f`px
	rpnl:([] sym:f`sym;acct:f`acct;dt;pnl)
