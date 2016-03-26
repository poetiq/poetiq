alpha:flip `sym`fcast!"sf"$\:()
alpha,:(`AAPL; .1)
alpha,:(`AMZN; .5)

// PORTFOLIO STATE MACHINE //
require "qx/member.q"

/ -- marks to market
holdings: delete from .schema.holdings
`holdings upsert (`AAPL; 1; 4.2f)

/ -- sends orders to exchange
h: hopen 5009;
h (`upd; `new; enlist `sym`dir`qty`prx`id`tif ! (`AAA; `BUY; 10522; 101.5; `007; `DAY));

/ -- provides view: equity value
eq:: exec qty wsum prx from holdings



