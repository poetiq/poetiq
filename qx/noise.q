\l common/require.q

require "common/util.q"
require "qx/global.q"
require "qx/member.q"
require "qx/seq.q"

quotes: ()

.process.upd [`quotes]: {
	quotes,: x;
	}

actions: (8 # `TAKE), `UP`DOWN

decideqty: {1000 * 1 + rand 10}

.z.ts: {
	t: select last bidqty, last bidprx, last askprx, last askqty by sym from quotes;
	upd [rand actions;  0 ! select from t where bidprx > 0, bidqty > 0, askprx > 0, askqty > 0, (askprx - bidprx) > 0.5];
	}

.process.upd [`MAKE]: {
	upd [`REALLYMAKE; select from x where bidqty < 20000, askqty < 20000];
	}

.process.upd [`REALLYMAKE]: {
	enter select sym, dir, qty: decideqty [], prx: near [dir; bidprx; askprx], tif: `DAY from
		update dir: rand `BUY`SELL from x;
	}

.process.upd [`TAKE]: {
	enter select sym, dir, qty: decideqty [] & `int$ 0.75 * far [dir; bidqty; askqty], prx: far [dir; bidprx; askprx], tif: `IOC from
		update dir: rand `BUY`SELL from x;
	}

ticks: (4 # 0.25), 0.5

.process.upd [`UP]: {
	enter select sym, dir, qty: decideqty [], prx: near [dir; bidprx; askprx] + rand ticks, tif: `DAY from
		update dir: `BUY from x;
	enter select sym, dir, qty: far [dir; bidqty; askqty], prx: far [dir; bidprx; askprx], tif: `IOC from
		update dir: `BUY from x;
	}

.process.upd [`DOWN]: {
	enter select sym, dir, qty: decideqty [], prx: near [dir; bidprx; askprx] - rand ticks, tif: `DAY from
		update dir: `SELL from x;
	enter select sym, dir, qty: far [dir; bidqty; askqty], prx: far [dir; bidprx; askprx], tif: `IOC from
		update dir: `SELL from x;
	}

enter: {
	x: update id: .seq.allocate count x from x;
	.util.printif @[neg h; (`upd; `new; x); "failed to send order"];
	}

cancel: {
	.util.printif @[neg h; (`upd; `cancel; x); "failed to send cancellation"];
	}


h: @[hopen; value .util.args `qx; 0]
quotes,: h (`snap; ([] sym: `AAA`BBB`CCC`DDD`EEE`FFF))
\t 1000
