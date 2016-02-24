/ Are prices at or within limit prices?
/ x direction
/ y price
/ z limit or reference price
/ arguments may be columns or lists of equal length

withinlimit: {?[x = `BUY; not y > z; not y < z]}


/ Access quantities and prices on the side of the order book appropriate to the order direction.
/ x direction
/ y bid side value
/ z ask side value
/ arguments may be columns or lists

near:	{?[x = `BUY; y; z]}
far:	{?[x = `BUY; z; y]}


/ VWAP after the given quantity and price have been included.
/ qty cumulative volume
/ prx previous VWAP
/ q additional quantity
/ p price of additional quantity

vwapafter: {[qty; prx; q; p] ((qty * prx) + q * p) % qty + q}


/ Gross up the given quantity.
/ x quantity
/ y participation rate

gross: {`int$ x % 1 - y}


/ Price difference relative to the given benchmark, so that over is positive and under is negative.
/ x direction
/ y price
/ z reference

relative: {?[x = `BUY; y - z; z - y]}
