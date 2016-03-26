\l common/require.q

require "common/process.q"
require "common/util.q"
require "qx/schema.q"
require "qx/seq.q"


/----------------------------------------------------------------------------------------------------------------------
/ Tables and views
/ 2009.02.18 Added `cancelling to orders to support new cancellation protocol.

control: (
	[sym:		`symbol$	()]
	size:		`int$		();
	spread:		`float$		();
	refprx:		`float$		()
	)

orders: select by id from update cancelling: 0b from delete from .schema.orders;

quotes: delete from .schema.quotes;

bidding:: exec sym from orders where dir = `BUY

asking:: exec sym from orders where dir = `SELL

cancelling:: exec sym from orders where cancelling

/----------------------------------------------------------------------------------------------------------------------
/ .process delegates

/ Trades update the reference price

.process.upd [`trades]: {
	`control upsert select refprx: last prx by sym from x;
	}


/ Keep track of the current quotes. Cancel all orders away from the current best. If any controlled symbols are zero
/ or below the watermark, then add to the quote.
/ 2009.02.18 Correction for feedback on cancels

.process.upd [`quotes]: {
	`quotes upsert x;
	c: select from (`sym xkey select from orders where sym in x [`sym], not cancelling) lj quotes where bidprx > 0, askprx > 0;
	upd [`CANCEL; (select id from c where dir = `BUY, prx < bidprx), select id from c where dir = `SELL, prx > askprx];
	t : (select from control where sym in x `sym) lj quotes;
	upd [`MISSING; select from t where bidprx = 0, askprx = 0, not sym in cancelling];
	upd [`ZEROBID; select from t where bidprx = 0, askprx > 0, not sym in cancelling];
	upd [`ZEROASK; select from t where askprx = 0, bidprx > 0, not sym in cancelling];
	upd [`LOWBID; select from t where bidprx > 0, bidqty < size];
	upd [`LOWASK; select from t where askprx > 0, askqty < size];
	}


/ Account for fills.

.process.upd [`fills]: {
	`orders upsert select id, qty: qty - filled from (select filled: sum qty by id from x) lj orders;
	delete from `orders where qty = 0;
	}


/ 2009.02.18 Cancels from qx

.process.upd [`cancels]: {
	delete from `orders where id in x `id;
	}


/ Correct for missing quote. x is derived from the control table. Positive feedback can occur if new orders
/ are sent but only one side has been actioned so far, and quoted, by qx. This is suppressed by cross-referencing
/ against the orders table through the 'bidding' and 'asking' views.

.process.upd [`MISSING]: {
	t: select sym, dir: `BUY, qty: size, prx: refprx - 0.5 * spread from x where not sym in bidding;
	t,: select sym, dir: `SELL, qty: size, prx: refprx + 0.5 * spread from x where not sym in asking;
	upd [`NEW; t];
	}

.process.upd [`ZEROBID]: {
	upd [`NEW; select sym, dir: `BUY, qty: size, prx: askprx - spread from x where not sym in bidding];
	}

.process.upd [`ZEROASK]: {
	upd [`NEW; select sym, dir: `SELL, qty: size, prx: bidprx + spread from x where not sym in asking];
	}

.process.upd [`LOWBID]: {
	upd [`NEW; select sym, dir: `BUY, qty: size - bidqty, prx: bidprx from x];
	}

.process.upd [`LOWASK]: {
	upd [`NEW; select sym, dir: `SELL, qty: size - askqty, prx: askprx from x];
	}


/ Send new orders constructed from the given prototypes, and cancels.
/ 2009.02.18 New cancellation protocol.

.process.upd [`NEW]: {
	x: update id: .seq.allocate count x, tif: `DAY, cancelling: 0b from x;
	`orders insert x;
	.util.printif @[neg h; (`upd; `new; delete cancelling from x); "failed to send orders"];
	}

.process.upd [`CANCEL]: {
	update cancelling: 1b from `orders where id in x `id;
	.util.printif @[neg h; (`upd; `cancel; x); "failed to send cancellations"];
	}


/----------------------------------------------------------------------------------------------------------------------
/ Other functions

/ Make opening quotes for symbols that are missing, or zero either side, then delegate to normal quoting.

opening: {
	t: 0 < count x;
	if [not t;
		upd [`MISSING; control]
	];
	if [t;
		upd [`MISSING; select from control where not sym in x `sym];
		upd [`quotes; x];
	];
	}


/----------------------------------------------------------------------------------------------------------------------
/ Run

`control upsert ("SIFF"; enlist csv) 0: `:F:/marketmaker.csv;
h: @[hopen; value .util.args `qx; 0]
opening h (`snap; ([] sym:()));
