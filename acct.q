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


\d .inventory
/ nested data structure to hold current inventory. Keyed by trade (gu)id and by side.
book: flip `dt`sz`px!"iif"$\:()
acct: ()!()
acct[first 1#`guid$()]: `BUY`SELL!(book;book)
past: "to be defined"

\d .trade
/ allocate: try to match with opposite side. add nonmatched.
allocate: ()!()
allocate[`FIFO]:{[f]
	opposide: $[`BUY=f`side;`SELL;`BUY];
	$[count i:.inventory.acct[f`acct;opposide];
	0N!"some matching";
	inventory[f`acct;f`side],::`dt`sz`px!(1;1;1.)]}
