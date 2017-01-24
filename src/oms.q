pos: `sym xkey flip `sym`tsz`tw`opsz`val`sz!"sififi"$\:()

.oms.upd.newsym:{`pos upsert update sym:x from 0!0^(count x)#0#pos;}

.oms.upd.targetsz:{
	
	/.lg.tic[];
	 /a:`sym xkey select sym, tsz:sz from x; .lg.toc[`targetsz.xkey.select];
      	/.lg.tic[];  `pos upsert a; .lg.toc[`targetsz.upsertclean];
     /`pos upsert 1!select sym, tsz:sz from x;
     pos,:1!select sym, tsz:sz from x;
    /.lg.toc[`targetsz.upsert]; .lg.tic[];
        o:select from (select sym, size: tsz - opsz + sz from `pos) where 0<abs size;
                /if[`PRU in exec sym from x;break;];
    /.lg.toc[`targetsz.delta]; .lg.tic[];
        if[0<cnt:count o;
            .oms.sendorder[update id:.market.genorderids[cnt], otype:cnt#`mkt from o];
        ];
    /.lg.toc[`targetsz.sendorder];
 }

.oms.sendorder:{
    pos+: 1!select sym, opsz:size from x;
    .market.sendorder[x];
 }

oms.cancelorder:{
	opensz[x`sym]-:x`size;
	.market.cancelorder[x];
 }

.oms.upd.targetw: {
	/currw:$[0=count .port.w;([sym:`$()]sz:`float$());.port.w];
	targetw:: x[`sym]!x`w;
	price: (key[targetw] union key port.w) # .market.lastpx;
	delta: neg[opensz] + .math.round (targetw - port.w) * port.equity.last % price; / TODO: syms where market price is missing to be excluded from delta (orders)
	/ if[0<sum abs opensz;break];
	if[cnt:count delta:(where 0 < abs delta)#delta;
		/ if[(`HLCL.L in key delta) and .clock.etstamp.date=1983.01.27;break];
		oms.sendorder[([] id:.market.genorderids[cnt]; otype:cnt#`mkt; sym:key delta; size: value delta)];
	];
	/if[.clock.etstamp.date>= 1983.03.22;break];
 }

.oms.upd.signal: {
	signal[x`sym]::x`signal;
	/if[.clock.etstamp.date>= 1983.03.22;break];
 }

.oms.upd.rebal: {
	.oms.upd.targetw `sym`w!(key d; value d:weight signal); / TODO: 
 }

.oms.upd.fill: {
	/opensz[x`sym]-:x`size;
	pos[([] sym:x `sym);`opsz]-:x`size;
	.port.upd.fill[x];
 }

/
calc.fun.targetw: {
	currw:$[0=count .port.w;([sym:`$()]sz:`float$());.port.w];
	targw:select sym, sz:w from x;
	delta:select last sz, px:last hfill (`getpx;first sym) by sym from targw pj neg currw;
	orders:select sym, size:floor .port.equity*sz%px from delta;
	if[count orders; (neg hbtt) (`.u.upd;`order;value flip orders)];
 }