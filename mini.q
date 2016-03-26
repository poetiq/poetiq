alpha:flip `sym`fcast!"sf"$\:()
alpha,:(`AAPL; .1)
alpha,:(`AMZN; .5)

// PORTFOLIO STATE MACHINE //

/ -- calculate order from optimizer
orders: delete from .schema.orders
.oms.add enlist `sym`qty ! (`AAA; -522 )
delete from .oms.order

`orders insert enlist `sym`dir`qty`prx`id`tif ! (`AAA; `BUY; 10522; 101.5; `007; `DAY)

/ -- marks to market
holdings: delete from .schema.holdings
`holdings upsert (`AAPL; 1; 4.2f)



/ -- sends orders to exchange
h: hopen 5009;
require "qx/oms.q";

h (`upd; `new; orders[0]);

/ -- provides view: equity value
eq:: exec qty wsum prx from holdings



