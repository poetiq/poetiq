pos: `sym xkey update `s#sym from flip `sym`tsz`tw`sig`val`sz`px`cost!"sjfffjff"$\:()
ob:  `sym xkey update `s#sym, `u#id from flip `sym`id`sz!"sjj"$\:()

.oms.side:(1 -1)!(`b`s)

.oms.upd.newsym:{`pos upsert update sym:x from 0!0^(count x)#0#pos;}

.oms.order.cancel:{.market.order.cancel[x];}
.oms.order.modify:{.market.order.modify[x];}
.oms.order.new:{
	x:update id:.market.genorderids[count x] from x;
	.market.order.new[x];
 }

.strategy.oms.delta.mktall:{
	/(update d0:0=tsz-sz, osz0:0=opsz from pos) lj dcsn
	update delta:tsz - sz from `pos; / 900
	if[count d0:select from pos where delta=0;
		if[count cancel:exec id from ob ij d0; 
			.oms.order.cancel[cancel]]];
	if[count d: 1!select sym, sz:delta from pos where 0<abs delta;
		if[count modify:d ij ob;
			.oms.order.modify[modify]];
		if[count new: key[ob]_d;
			.oms.order.new[new]]];
/	if[count modify:select sym, sz:delta from nm where not osz0;
/		.oms.order.modify[modify]];
/	if[count new: select sym, sz:delta from nm where osz0;
/		.oms.order.new[new]];

	/
	/`ob set 1!select from (select sym, tsz, opsz, sz from `pos where 0<abs tsz-opsz+sz);
	/if[count delta;
	/	.oms.cancelorder[update sz: tsz opsz from `ob]; / cancel
	/	.oms.amendorder[];
	/	update id:.market.genorderids[count x], sym, otype:`mkt, from `delta;
	/	.oms.neworder[update sz: from o];
	/];
 }

.oms.upd.obook: .strategy.oms.delta.mktall

.oms.upd.targetw: {
	.log.blot["tw";x];
	pos,:1!select sym, tw from x;
	`pos set pos lj .market.getlastpx[select sym, tstamp:.bt.e.etstamp from pos];
	/break;
	update 0^sz from `pos; / for symbols not yet in portfolio that were just added
	update tsz: "j"$tw * equity % px from `pos;
	/if[.bt.e.etstamp.month=2014.08m; break];
	/d: select sym, sz: ("j"$tw * port.equity.last % lastpx) - opsz + sz from pos;
	/o: select sym, size: ("j"$(tw-port.w) * port.equity.last % lastpx) - opsz from pos;
	/d: update delta: tsz - opsz + sz from pos;
	/d: update delta: tsz - opsz + sz from pos where 0<abs  tsz - opsz + sz; / TODO: syms where market price is missing to be excluded from delta (orders)
	/if[count d;
		/break;
		/ if[(`HLCL.L in key delta) and .clock.etstamp.date=1983.01.27;break];
	.oms.upd.obook[];
 }

.oms.upd.targetsz:{
     pos,:1!select sym, tsz:sz from x;
     `pos set pos lj .market.lastpx;
     update 0^sz from `pos; / for symbols not yet in portfolio that were just added
     .oms.upd.obook[];
     /o:select from (select sym, size: tsz - opsz + sz from `pos) where 0<abs size;
 }

.oms.upd.signal: {
	/if[1986.01.09<="d"$.clock.etstamp;break;];
	pos,:1!select sym, sig:"f"$signal from x; / TODO: casting to float should be preprocessed at the input table level. faster.
 }

.oms.upd.rebal: {
	.oms.upd.targetw select sym, tw:weight[sig] from pos; / `sym`w!(key d; value d:weight signal); / TODO: 
 }

.oms.upd.fill: {
	ob[([] sym:x `sym);`sz]-:x`sz;
	delete from `ob where sz=0;
	.port.upd.fill[x];
 }

.oms.upd.accepted: {
 	ob,: select sym, id, sz from x;
 }

.oms.upd.cancelled: {
	delete from `ob where id in x;
 }

/
calc.fun.targetw: {
	currw:$[0=count .port.w;([sym:`$()]sz:`float$());.port.w];
	targw:select sym, sz:w from x;
	delta:select last sz, px:last hfill (`getpx;first sym) by sym from targw pj neg currw;
	orders:select sym, size:floor .port.equity*sz%px from delta;
	if[count orders; (neg hbtt) (`.u.upd;`order;value flip orders)];
 }