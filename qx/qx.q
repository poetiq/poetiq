require ("common/process.q"; "common/util.q"; "qx/schema.q")

/----------------------------------------------------------------------------------------------------------------------
/ Tables and global variables
/ 2009.01.13 orders and quotes tables now inherit, and modify, from the common schema.
/ 2009.02.05 added bids and asks views for convenience

orders: update who: 0 from delete tif from delete from .schema.orders;

bids:: `sym xasc `prx xdesc select from orders where dir = `BUY
asks:: `sym xasc `prx xasc select from orders where dir = `SELL

quotes: delete from .schema.quotes;

matched: (
	[]
	sym:			`symbol$	();
	qty:			`int$		();
	prx:			`float$		();
	buyer:			`int$		();
	buyerid:		`symbol$	();
	seller:			`int$		();
	sellerid:		`symbol$	()
	)

members: ()


/----------------------------------------------------------------------------------------------------------------------
/ Core q functions.

/ Keep track of connections.

.z.po: {
	-1 "member ", (string x), " connected";
	members,: x;
	}


/ Cancel all orders once a connection is lost.

.z.pc: {
	-1 "member ", (string x), " disconnected";
	members:: members except x;
	t: select distinct sym from orders where who = x;
	delete from `orders where who = x;
	upd [`QUOTES; t];
	}

/----------------------------------------------------------------------------------------------------------------------
/ Other API functions
/ 2009.01.21 added snap.

/ Snap quotes for symbols in x [`sym]. If table is empty, all current quotes are returned.

snap: {
	t: x [`sym] except exec sym from quotes;
	if [count t;
		`quotes insert update bidqty: 0, bidprx: 0f, askprx: 0f, askqty: 0 from ([] sym: t)
	];
	0 ! $[count x; select from quotes where sym in x `sym; select from quotes]
	}


/----------------------------------------------------------------------------------------------------------------------
/ .process delegates.

/ New orders are submitted in a table but are processed one row at a time.
/ Columns of x must be `sym`dir`qty`prx`tif`id

.process.upd [`new]: {
	{
		.qx.new [x `tif; x; select from orders where sym = x `sym];
		upd [`FILLS; matched];
		upd [`QUOTES; ([] sym: enlist x `sym)];
		upd [`TRADES; matched];
		delete from `matched;
	} each update who: .z.w from x;
	}


/ Cancellations can be processed as a group.
/ Columns of x must be `id
/ 2009.02.18 new order cancellation protocol.

.process.upd [`cancel]: {
	t: select distinct sym from orders where who = .z.w, id in x `id;
	delete from `orders where who = .z.w, id in x `id;
	.util.printif @[neg .z.w; (`upd; `cancels; select id from x); "failed to write cancels to ", string .z.w];
	upd [`QUOTES; t];
	}


/ Quotes are published to all members.
/ 2009.01.13 changed to use upsert and so process all quotes at once. Removed 'side' function dictionary. Enforced policy
/ of only passing flat tables to upd.

.process.upd [`QUOTES]: {
	t: select from orders where sym in x `sym;
	update bidprx: 0f, bidqty: 0, askprx: 0f, askqty: 0 from `quotes where sym in x `sym;
	`quotes upsert select bidprx: first prx, bidqty: sum qty by sym from t where dir = `BUY, prx = max prx;
	`quotes upsert select askprx: first prx, askqty: sum qty by sym from t where dir = `SELL, prx = min prx;
	{[h; x]
		.util.printif @[neg h; (`upd; `quotes; x); "failed to write quotes to ", string h];
	}[; 0 ! select from quotes where sym in x `sym] each members;
	}


/ Fills are published only to the counterparties.

.process.upd [`FILLS]: {
	{
		t: select sym, qty, prx, id: buyerid from matched where buyer = x;
		t,: select sym, qty, prx, id: sellerid from matched where seller = x;
		if [count t;
			.util.printif @[neg x; (`upd; `fills; t); "failed to write fills to ", string x]
		];
	} each members;
	}


/ Anonymous trades are published to all members.

.process.upd [`TRADES]: {
	{[h; x]
		.util.printif @[neg h; (`upd; `trades; x); "failed to write trades to ", string h];
	}[; select sym, qty, prx from x] each members;
	}


/----------------------------------------------------------------------------------------------------------------------
/ Matching
/ 2009.01.13 hid function dictionaries in the .qx context.
/ 2009.01.23 added a zero-fill when IOC's do not match.
/ 2009.02.18 new cancellation protocol for IOCs.

.qx.new: () ! ()

.qx.new [`DAY]: {[x; b]
	if [count b;
		m: .qx.matchable [x `dir; b; x];
		if [count m;
			x [`qty]: match [x; m]
		]
	];
	if [0 < x `qty;
		`orders insert delete tif from x
	];
	}
	
.qx.new [`IOC]: {[x; b]
	if [count b;
		m: .qx.matchable [x `dir; b; x];
		$[count m;
			match [x; m];
			.util.printif
				@[neg x `who; (`upd; `cancels; ([] id: enlist x `id)); "failed to write IOC cancel to ", string x `who]
		];
	];
	}
	

/ How to select and sequence orders that are matchable.

.qx.matchable: () ! ()
.qx.matchable [`BUY]:	{[t; x] `prx xasc select from t where dir = `SELL, x [`prx] >= prx}
.qx.matchable [`SELL]:	{[t; x] `prx xdesc select from t where dir = `BUY, x [`prx] <= prx}


/ How to match an order against a table of matchable orders. First calculate the fill quantities;
/ second, insert these into the matched table; third, delete all fully filled orders; finally handle a
/ possible partially filled order. Return the unmatched quantity.
/ 2009.02.05 fixed bug in handling id's.

match: {[x; m]
	m: update c: sums qty from m;
	m: update d: x [`qty] & c from m;
	m: select from m where d <> prev d;
	m: update fill: qty - c - d from m;
	`matched insert .qx.label [x `dir; select sym, qty: fill, prx, who, id from m; x];
	{delete from `orders where id = x [`id], who = x [`who];} each select id, who from m where qty = fill;
	{update qty: qty - x [`fill] from `orders where id = x [`id], who = x [`who];} each select id, who, fill from m where qty > fill;
	x [`qty] - sum m [`fill]
	}


/ How to label the counterparties.

.qx.label: () ! ()
.qx.label [`BUY]:	{[t; x] delete who, id from update buyer: x [`who], buyerid: x [`id], seller: who, sellerid: id from t}
.qx.label [`SELL]:	{[t; x] delete who, id from update buyer: who, buyerid: id, seller: x [`who], sellerid: x [`id] from t}
